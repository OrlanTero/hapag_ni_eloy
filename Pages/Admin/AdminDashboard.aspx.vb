Imports System.Web.Script.Serialization
Imports System.Collections.Generic
Imports HapagDB

Partial Class Pages_Admin_AdminDashboard
    Inherits AdminBasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check for access denied message
            If Session("ACCESS_DENIED_MESSAGE") IsNot Nothing Then
                ' Use the master page's alert method
                Try
                    Dim masterPage As Pages_Admin_AdminTemplate = DirectCast(Me.Master, Pages_Admin_AdminTemplate)
                    If masterPage IsNot Nothing Then
                        masterPage.ShowAlert(Session("ACCESS_DENIED_MESSAGE").ToString(), False)
                    End If
                Catch ex As Exception
                    ' Fallback if master page alert fails
                End Try
                
                ' Clear the message
                Session("ACCESS_DENIED_MESSAGE") = Nothing
            End If
            
            ' Load dashboard data
            LoadDashboardData()
        End If
    End Sub

    Private Function GetInitials(ByVal name As String) As String
        If String.IsNullOrEmpty(name) Then
            Return "U"
        End If

        Dim parts = name.Split(" "c)
        If parts.Length > 1 Then
            ' If there are multiple parts, take first letter of first and last parts
            Return (parts(0)(0) & parts(parts.Length - 1)(0)).ToUpper()
        Else
            ' If single word, take first two letters or just first letter if single character
            Return If(name.Length > 1, name.Substring(0, 2), name.Substring(0, 1)).ToUpper()
        End If
    End Function

    ' LogoutButton_Click handler is now in the master page

    Private Sub LoadDashboardData()
        Try
            ' Load actual data from database
            Dim totalOrders As Integer = GetTotalOrders()
            Dim totalRevenue As Decimal = GetTotalRevenue()
            Dim activeUsers As Integer = GetActiveUsers()
            Dim menuItems As Integer = GetTotalMenuItems()
            
            ' Calculate percentage changes
            Dim orderChange As Decimal = GetOrdersPercentChange()
            Dim revenueChange As Decimal = GetRevenuePercentChange()
            Dim userChange As Decimal = GetUsersPercentChange()
            Dim menuChange As Decimal = GetMenuItemsPercentChange()
            
            ' Update UI with data and percentage changes
            TotalOrdersLiteral.Text = totalOrders.ToString()
            TotalRevenueLiteral.Text = totalRevenue.ToString("N2")
            ActiveUsersLiteral.Text = activeUsers.ToString()
            MenuItemsLiteral.Text = menuItems.ToString()
            
            ' Update percentage change indicators
            OrdersChangeLiteral.Text = FormatPercentChange(orderChange)
            RevenueChangeLiteral.Text = FormatPercentChange(revenueChange)
            UsersChangeLiteral.Text = FormatPercentChange(userChange)
            MenuChangeLiteral.Text = FormatPercentChange(menuChange)
            
            ' Set CSS classes based on change direction
            OrdersChangeContainer.Attributes("class") = "stat-card-change " & If(orderChange >= 0, "positive", "negative")
            RevenueChangeContainer.Attributes("class") = "stat-card-change " & If(revenueChange >= 0, "positive", "negative")
            UsersChangeContainer.Attributes("class") = "stat-card-change " & If(userChange >= 0, "positive", "negative")
            MenuChangeContainer.Attributes("class") = "stat-card-change " & If(menuChange >= 0, "positive", "negative")
            
            ' Load chart data
            Dim salesData As Dictionary(Of String, Object) = GetSalesData()
            Dim categoryData As Dictionary(Of String, Object) = GetCategoryData()
            
            ' Convert data to JSON for JavaScript charts
            Dim serializer As New JavaScriptSerializer()
            Dim salesJson As String = serializer.Serialize(salesData)
            Dim categoryJson As String = serializer.Serialize(categoryData)
            
            ' Register the chart data as JavaScript variables
            Dim script As String = "var salesChartData = " & salesJson & ";" & _
                                 "var categoryChartData = " & categoryJson & ";"
            
            ' Register the script before the chart initialization
            ClientScript.RegisterStartupScript(Me.GetType(), "ChartData", script, True)
            
            ' Load recent activity
            LoadRecentActivity()

        Catch ex As Exception
            ' Handle any errors - use the master page's alert message if possible
            Try
                Dim masterPage As Pages_Admin_AdminTemplate = DirectCast(Me.Master, Pages_Admin_AdminTemplate)
                If masterPage IsNot Nothing Then
                    masterPage.ShowAlert("Error loading dashboard data: " & ex.Message, False)
                End If
            Catch masterEx As Exception
                ' Fallback to client-side alert if master page method fails
                Dim script As String = "alert('Error loading dashboard data: " & _
                                      ex.Message.Replace("'", "\\'") & "');"
                ClientScript.RegisterStartupScript(Me.GetType(), "ErrorAlert", script, True)
            End Try
        End Try
    End Sub

    ' Get the total number of orders from the database
    Private Function GetTotalOrders() As Integer
        Dim orderController As New OrderController()
        Dim orders = orderController.GetAllOrders()
        Return orders.Count
    End Function

    ' Get the total revenue from the database
    Private Function GetTotalRevenue() As Decimal
        Dim transactionController As New TransactionController()
        Dim transactions = transactionController.GetAllTransactions()
        
        Dim totalRevenue As Decimal = 0
        For Each transaction In transactions
            totalRevenue += transaction.total_amount
        Next
        
        Return totalRevenue
    End Function

    ' Get the number of active users from the database
    Private Function GetActiveUsers() As Integer
        Dim userController As New UserController()
        ' Only count customer accounts
        Dim users = userController.GetUsersByType("customer")
        Return users.Count
    End Function

    ' Get the total number of menu items from the database
    Private Function GetTotalMenuItems() As Integer
        Dim menuController As New MenuController()
        Dim menuItems = menuController.GetAllMenuItems()
        Return menuItems.Count
    End Function
    
    ' Get monthly sales data for the chart
    Private Function GetSalesData() As Dictionary(Of String, Object)
        Dim result As New Dictionary(Of String, Object)()
        Dim transactionController As New TransactionController()
        Dim transactions = transactionController.GetAllTransactions()
        
        ' Group transactions by month
        Dim monthlySales As New Dictionary(Of String, Decimal)()
        Dim monthNames As New List(Of String)()
        Dim salesData As New List(Of Decimal)()
        
        ' Get last 7 months
        Dim startDate As Date = Date.Today.AddMonths(-6)
        Dim endDate As Date = Date.Today
        
        ' Initialize months
        For i As Integer = 0 To 6
            Dim currentDate As Date = startDate.AddMonths(i)
            Dim monthKey As String = currentDate.ToString("MMM")
            monthNames.Add(monthKey)
            monthlySales(monthKey) = 0
        Next
        
        ' Calculate sales for each month
        For Each transaction In transactions
            Try
                ' Explicitly convert to Date type
                Dim transactionDateValue As Date = CDate(transaction.transaction_date)
                
                ' Compare dates
                If transactionDateValue >= startDate AndAlso transactionDateValue <= endDate Then
                    Dim monthKey As String = transactionDateValue.ToString("MMM")
                    If monthlySales.ContainsKey(monthKey) Then
                        monthlySales(monthKey) += transaction.total_amount
                    End If
                End If
            Catch ex As Exception
                ' Skip this transaction if there's an issue with the date
                Continue For
            End Try
        Next
        
        ' Convert to lists for JavaScript
        For Each monthKey In monthNames
            salesData.Add(monthlySales(monthKey))
        Next
        
        result("labels") = monthNames
        result("data") = salesData
        
        Return result
    End Function
    
    ' Get category sales data for the pie chart
    Private Function GetCategoryData() As Dictionary(Of String, Object)
        Dim result As New Dictionary(Of String, Object)()
        Dim menuController As New MenuController()
        Dim orderController As New OrderController()
        
        ' Get all categories
        Dim categories = menuController.GetAllCategories()
        Dim categoryNames As New List(Of String)()
        Dim categorySales As New Dictionary(Of String, Integer)()
        
        ' Initialize category sales
        For Each category In categories
            If category.is_active Then
                categoryNames.Add(category.category_name)
                categorySales(category.category_name) = 0
            End If
        Next
        
        ' Get all orders
        Dim orders = orderController.GetAllOrders()
        
        ' Calculate sales for each category
        For Each order In orders
            For Each item In order.OrderItems
                ' Get the category for this item
                Dim menuItem = menuController.GetMenuItemById(item.item_id)
                If menuItem IsNot Nothing AndAlso menuItem.category IsNot Nothing Then
                    If categorySales.ContainsKey(menuItem.category) Then
                        categorySales(menuItem.category) += item.quantity
                    End If
                End If
            Next
        Next
        
        ' Convert to lists for JavaScript
        Dim categoryData As New List(Of Integer)()
        For Each categoryName In categoryNames
            categoryData.Add(categorySales(categoryName))
        Next
        
        result("labels") = categoryNames
        result("data") = categoryData
        
        Return result
    End Function
    
    ' Load recent activity data
    Private Sub LoadRecentActivity()
        Try
            Dim orderController As New OrderController()
            Dim userController As New UserController()
            Dim menuController As New MenuController()
            
            ' Get latest 5 orders
            Dim orders = orderController.GetAllOrders()
            If orders.Count > 5 Then
                orders = orders.GetRange(0, 5)
            End If
            
            ' Get latest 5 users
            Dim users = userController.GetAllUsers()
            users.Sort(Function(a, b) b.user_id.CompareTo(a.user_id))
            If users.Count > 5 Then
                users = users.GetRange(0, 5)
            End If
            
            ' Generate recent activity HTML
            Dim activityHtml As New System.Text.StringBuilder()
            
            ' Add recent orders
            For Each order In orders
                ' Handle order date safely
                Dim orderDate As String = ""
                Try
                    ' Explicitly convert to Date type
                    Dim orderDateValue As Date = CDate(order.order_date)
                    orderDate = GetRelativeTime(orderDateValue)
                Catch ex As Exception
                    ' Fallback for when there's an issue with the date
                    orderDate = "Unknown date"
                End Try
                
                Dim user = userController.GetUserById(order.user_id)
                Dim userName = If(user IsNot Nothing, user.display_name, "Unknown")
                
                activityHtml.AppendLine("<li class=""activity-item"">")
                activityHtml.AppendLine("    <div class=""activity-icon order"">📦</div>")
                activityHtml.AppendLine("    <div class=""activity-content"">")
                activityHtml.AppendLine("        <div class=""activity-title"">New order #" & order.order_id & " from " & userName & "</div>")
                activityHtml.AppendLine("        <div class=""activity-time"">" & orderDate & "</div>")
                activityHtml.AppendLine("    </div>")
                activityHtml.AppendLine("</li>")
            Next
            
            ' Register the activity HTML
            Dim script As String = "document.addEventListener('DOMContentLoaded', function() { " & _
                                 "  document.querySelector('.activity-list').innerHTML = '" & activityHtml.ToString().Replace("'", "\\'").Replace(Environment.NewLine, "") & "'; " & _
                                 "});"
            
            ClientScript.RegisterStartupScript(Me.GetType(), "ActivityData", script, True)
            
        Catch ex As Exception
            ' Log error but don't display - non-critical
            System.Diagnostics.Debug.WriteLine("Error loading activity: " & ex.Message)
        End Try
    End Sub
    
    ' Helper method to convert a date to a relative time string
    Private Function GetRelativeTime(ByVal dateValue As Date) As String
        Dim ts As TimeSpan = DateTime.Now - dateValue
        
        If ts.TotalMinutes < 1 Then
            Return "just now"
        ElseIf ts.TotalMinutes < 60 Then
            Return Math.Round(ts.TotalMinutes) & " minutes ago"
        ElseIf ts.TotalHours < 24 Then
            Return Math.Round(ts.TotalHours) & " hours ago"
        ElseIf ts.TotalDays < 7 Then
            Return Math.Round(ts.TotalDays) & " days ago"
        Else
            Return dateValue.ToString("MMM dd, yyyy")
        End If
    End Function
    
    ' Helper function to format percentage changes
    Private Function FormatPercentChange(ByVal change As Decimal) As String
        Dim arrow As String = If(change >= 0, "↑", "↓")
        Return arrow & " " & Math.Abs(change).ToString("0.0") & "%"
    End Function
    
    ' Calculate percentage change in orders compared to previous month
    Private Function GetOrdersPercentChange() As Decimal
        Dim orderController As New OrderController()
        Dim orders = orderController.GetAllOrders()
        
        ' Get current month orders
        Dim currentMonthStart As Date = New Date(Date.Today.Year, Date.Today.Month, 1)
        Dim currentMonthEnd As Date = currentMonthStart.AddMonths(1).AddDays(-1)
        
        Dim currentMonthOrders As Integer = 0
        Dim previousMonthOrders As Integer = 0
        
        ' Get previous month dates
        Dim previousMonthStart As Date = currentMonthStart.AddMonths(-1)
        Dim previousMonthEnd As Date = currentMonthStart.AddDays(-1)
        
        ' Count orders in each month with safe date handling
        For Each order In orders
            Try
                ' Explicitly convert to Date type
                Dim orderDateValue As Date = CDate(order.order_date)
                
                ' Check current month
                If orderDateValue >= currentMonthStart AndAlso orderDateValue <= currentMonthEnd Then
                    currentMonthOrders += 1
                End If
                
                ' Check previous month
                If orderDateValue >= previousMonthStart AndAlso orderDateValue <= previousMonthEnd Then
                    previousMonthOrders += 1
                End If
            Catch ex As Exception
                ' Skip this order if there's an issue with the date
                Continue For
            End Try
        Next
        
        ' Calculate percentage change
        If previousMonthOrders > 0 Then
            Return Math.Round(((currentMonthOrders - previousMonthOrders) / previousMonthOrders) * 100, 1)
        ElseIf currentMonthOrders > 0 Then
            Return 100.0 ' If previous month had zero orders but current month has orders, we show 100% increase
        Else
            Return 0.0 ' No change if both months have zero orders
        End If
    End Function
    
    ' Calculate percentage change in revenue compared to previous month
    Private Function GetRevenuePercentChange() As Decimal
        Dim transactionController As New TransactionController()
        Dim transactions = transactionController.GetAllTransactions()
        
        ' Get current month revenue
        Dim currentMonthStart As Date = New Date(Date.Today.Year, Date.Today.Month, 1)
        Dim currentMonthEnd As Date = currentMonthStart.AddMonths(1).AddDays(-1)
        
        Dim currentMonthRevenue As Decimal = 0
        Dim previousMonthRevenue As Decimal = 0
        
        ' Get previous month dates
        Dim previousMonthStart As Date = currentMonthStart.AddMonths(-1)
        Dim previousMonthEnd As Date = currentMonthStart.AddDays(-1)
        
        ' Calculate revenue for each month with safe date handling
        For Each transaction In transactions
            Try
                ' Explicitly convert to Date type
                Dim transactionDateValue As Date = CDate(transaction.transaction_date)
                
                ' Check current month
                If transactionDateValue >= currentMonthStart AndAlso transactionDateValue <= currentMonthEnd Then
                    currentMonthRevenue += transaction.total_amount
                End If
                
                ' Check previous month
                If transactionDateValue >= previousMonthStart AndAlso transactionDateValue <= previousMonthEnd Then
                    previousMonthRevenue += transaction.total_amount
                End If
            Catch ex As Exception
                ' Skip this transaction if there's an issue with the date
                Continue For
            End Try
        Next
        
        ' Calculate percentage change
        If previousMonthRevenue > 0 Then
            Return Math.Round(((currentMonthRevenue - previousMonthRevenue) / previousMonthRevenue) * 100, 1)
        ElseIf currentMonthRevenue > 0 Then
            Return 100.0 ' If previous month had zero revenue but current month has revenue, we show 100% increase
        Else
            Return 0.0 ' No change if both months have zero revenue
        End If
    End Function
    
    ' Calculate percentage change in users compared to previous month
    Private Function GetUsersPercentChange() As Decimal
        ' Since we don't have a "created_date" field for users, we'll just use a fixed number for demo
        ' In a real application, you would calculate this based on user registration dates
        Return 5.2
    End Function
    
    ' Calculate percentage change in menu items compared to previous month
    Private Function GetMenuItemsPercentChange() As Decimal
        ' Since menu items don't have a "created_date" field, we'll just use a fixed number for demo
        ' In a real application, you would calculate this based on when items were added
        Return 3.7
    End Function
End Class
