Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports System.Web.UI.WebControls
Imports System.Configuration
Imports HapagDB
' Remove the User class definition as it's likely conflicting with an existing User class
' Public Class User
'     Public Property user_id As Integer
'     Public Property username As String
'     Public Property role As String
'     ' Add other properties as needed
' End Class

Partial Class Pages_Customer_CustomerTransactionHistory
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in
            If Session("CURRENT_SESSION") Is Nothing Then
                Response.Redirect("~/Pages/Login.aspx")
                Return
            End If
            
            ' Get current user ID safely - simplified approach
            Dim userID As Integer = 0
            
            Try
                ' Try to get user_id directly from the session object
                Dim currentSession As Object = Session("CURRENT_SESSION")
                If currentSession IsNot Nothing Then
                    ' Try to access the user_id directly
                    userID = Convert.ToInt32(currentSession.user_id)
                End If
                
                If userID <= 0 Then
                    ' Invalid user ID
                    Response.Redirect("~/Pages/Login.aspx")
                    Return
                End If
            Catch ex As Exception
                ' Can't get user ID - redirect to login
                Response.Redirect("~/Pages/Login.aspx")
                Return
            End Try
            
            ' Debug: Check the table structure
            Try
                Dim connect As New Connection()
                Dim query As String = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders'"
                connect.Query(query)
                
                If connect.DataCount > 0 Then
                    Dim columns As String = ""
                    For Each row As DataRow In connect.Data.Tables(0).Rows
                        columns += row("COLUMN_NAME").ToString() & ", "
                    Next
                    
                    ' Show the column names in an alert
                    Dim masterPage As Pages_Customer_CustomerTemplate = CType(Me.Master, Pages_Customer_CustomerTemplate)
                    If masterPage IsNot Nothing Then
                        masterPage.ShowAlert("Debug: Orders table columns: " & columns, True)
                    End If
                End If
            Catch ex As Exception
                ' Error checking schema
                Dim masterPage As Pages_Customer_CustomerTemplate = CType(Me.Master, Pages_Customer_CustomerTemplate)
                If masterPage IsNot Nothing Then
                    masterPage.ShowAlert("Debug: Error checking schema: " & ex.Message, False)
                End If
            End Try
            
            ' Set default date range (last 30 days) in MM/DD/YYYY format
            StartDatePicker.Text = DateTime.Now.AddDays(-30).ToString("MM/dd/yyyy")
            EndDatePicker.Text = DateTime.Now.ToString("MM/dd/yyyy")
            
            ' Load transactions with the retrieved user ID
            LoadTransactions(userID)
        End If
    End Sub
    
    Protected Sub FilterButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        ' Validate date inputs
        If String.IsNullOrEmpty(StartDatePicker.Text) OrElse String.IsNullOrEmpty(EndDatePicker.Text) Then
            Dim masterPage As Pages_Customer_CustomerTemplate = CType(Me.Master, Pages_Customer_CustomerTemplate)
            If masterPage IsNot Nothing Then
                masterPage.ShowAlert("Please select both start and end dates for filtering", False)
            End If
            Return
        End If
        
        ' Validate date range
        Dim startDate As DateTime = Convert.ToDateTime(StartDatePicker.Text)
        Dim endDate As DateTime = Convert.ToDateTime(EndDatePicker.Text)
        
        If startDate > endDate Then
            Dim masterPage As Pages_Customer_CustomerTemplate = CType(Me.Master, Pages_Customer_CustomerTemplate)
            If masterPage IsNot Nothing Then
                masterPage.ShowAlert("Start date cannot be later than end date", False)
            End If
            Return
        End If
        
        ' Load filtered transactions
        LoadTransactions()
    End Sub
    
    Protected Sub ResetButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        ' Reset date inputs to default (last 30 days)
        StartDatePicker.Text = DateTime.Now.AddDays(-30).ToString("MM/dd/yyyy")
        EndDatePicker.Text = DateTime.Now.ToString("MM/dd/yyyy")
        
        ' Reload transactions
        LoadTransactions()
    End Sub
    
    Protected Sub LoadTransactions()
        Try
            ' Get current user ID - simplified approach
            Dim userID As Integer = 0
            
            Try
                ' Try to get user_id directly from the session object
                Dim currentSession As Object = Session("CURRENT_SESSION")
                If currentSession IsNot Nothing Then
                    ' Try to access the user_id directly
                    userID = Convert.ToInt32(currentSession.user_id)
                End If
                
                If userID <= 0 Then
                    ' Invalid user ID
                    Dim masterPage As Pages_Customer_CustomerTemplate = CType(Me.Master, Pages_Customer_CustomerTemplate)
                    If masterPage IsNot Nothing Then
                        masterPage.ShowAlert("Error: Unable to identify user. Please log in again.", False)
                    End If
                    Return
                End If
            Catch ex As Exception
                ' Can't get user ID - show error
                Dim masterPage As Pages_Customer_CustomerTemplate = CType(Me.Master, Pages_Customer_CustomerTemplate)
                If masterPage IsNot Nothing Then
                    masterPage.ShowAlert("Error: Session expired. Please log in again.", False)
                End If
                Return
            End Try
            
            ' Load transactions with the retrieved user ID
            LoadTransactions(userID)
        Catch ex As Exception
            ' Show error
            Dim masterPage As Pages_Customer_CustomerTemplate = CType(Me.Master, Pages_Customer_CustomerTemplate)
            If masterPage IsNot Nothing Then
                masterPage.ShowAlert("Error loading transactions: " & ex.Message, False)
            End If
        End Try
    End Sub
    
    Protected Sub LoadTransactions(ByVal userID As Integer)
        Try
            ' Show loading using jQuery
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowLoading", 
                "$('.loading-overlay').show();", True)
            
            ' Get date range
            Dim startDate As DateTime
            Dim endDate As DateTime
            
            If Not String.IsNullOrEmpty(StartDatePicker.Text) Then
                startDate = Convert.ToDateTime(StartDatePicker.Text)
            Else
                startDate = DateTime.Now.AddDays(-30)
            End If
            
            If Not String.IsNullOrEmpty(EndDatePicker.Text) Then
                endDate = Convert.ToDateTime(EndDatePicker.Text).AddDays(1).AddSeconds(-1) ' End of the selected day
            Else
                endDate = DateTime.Now
            End If
            
            ' Get transactions
            Dim transactions As DataTable = GetTransactions(userID, startDate, endDate)
            
            ' Check if we have any transactions
            If transactions.Rows.Count > 0 Then
                TransactionsRepeater.DataSource = transactions
                TransactionsRepeater.DataBind()
                
                TransactionsPanel.Visible = True
                EmptyTransactionsPanel.Visible = False
            Else
                TransactionsPanel.Visible = False
                EmptyTransactionsPanel.Visible = True
            End If
            
            ' Hide loading using jQuery
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "HideLoading", 
                "$('.loading-overlay').hide();", True)
            
        Catch ex As Exception
            ' Show error
            Dim masterPage As Pages_Customer_CustomerTemplate = CType(Me.Master, Pages_Customer_CustomerTemplate)
            If masterPage IsNot Nothing Then
                masterPage.ShowAlert("Error loading transactions: " & ex.Message, False)
            End If
            
            ' Hide loading using jQuery
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "HideLoading", 
                "$('.loading-overlay').hide();", True)
        End Try
    End Sub
    
    Private Function GetTransactions(ByVal userID As Integer, ByVal startDate As DateTime, ByVal endDate As DateTime) As DataTable
        Dim dt As New DataTable()
        
        Try
            ' Use the Connection class instead of direct SQL connection to maintain consistency
            Dim connect As New Connection()
            
            ' Build the query with parameters - use only columns that exist in the table
            Dim query As String = "SELECT " & _
                           "o.order_id, " & _
                           "o.order_date, " & _
                           "o.status, " & _
                           "o.total_amount, " & _
                           "o.transaction_id, " & _
                           "o.subtotal, " & _
                           "o.shipping_fee, " & _
                           "o.tax " & _
                           "FROM orders o " & _
                           "WHERE o.user_id = @UserID " & _
                           "AND o.order_date BETWEEN @StartDate AND @EndDate " & _
                           "ORDER BY o.order_date DESC"
            
            ' Add parameters
            connect.AddParam("@UserID", userID)
            connect.AddParam("@StartDate", startDate)
            connect.AddParam("@EndDate", endDate)
            
            ' Execute query
            connect.Query(query)
            
            ' Get the result
            If connect.DataCount > 0 Then
                dt = connect.Data.Tables(0)
            End If
            
        Catch ex As Exception
            ' Handle database error
            Dim masterPage As Pages_Customer_CustomerTemplate = CType(Me.Master, Pages_Customer_CustomerTemplate)
            If masterPage IsNot Nothing Then
                masterPage.ShowAlert("Error loading transactions: " & ex.Message, False)
            End If
        End Try
        
        Return dt
    End Function
    
    Protected Sub TransactionsRepeater_ItemDataBound(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim orderRow As DataRowView = DirectCast(e.Item.DataItem, DataRowView)
            
            ' Get order ID
            Dim orderID As Integer = Convert.ToInt32(orderRow("order_id"))
            
            ' Get order items
            Dim orderItems As DataTable = GetOrderItems(orderID)
            
            ' Set the number of items
            Dim totalItemsLiteral As Literal = DirectCast(e.Item.FindControl("TotalItemsLiteral"), Literal)
            If totalItemsLiteral IsNot Nothing Then
                totalItemsLiteral.Text = orderItems.Rows.Count.ToString()
            End If
            
            ' Set order items in repeater
            Dim orderItemsRepeater As Repeater = DirectCast(e.Item.FindControl("OrderItemsRepeater"), Repeater)
            If orderItemsRepeater IsNot Nothing Then
                orderItemsRepeater.DataSource = orderItems
                orderItemsRepeater.DataBind()
            End If
            
            ' Set transaction ID (instead of reference number)
            Dim referenceNumberLiteral As Literal = DirectCast(e.Item.FindControl("ReferenceNumberLiteral"), Literal)
            If referenceNumberLiteral IsNot Nothing Then
                referenceNumberLiteral.Text = If(orderRow("transaction_id") IsNot DBNull.Value, orderRow("transaction_id").ToString(), "N/A")
            End If
            
            ' Set sender name (not available in DB)
            Dim senderNameLiteral As Literal = DirectCast(e.Item.FindControl("SenderNameLiteral"), Literal)
            If senderNameLiteral IsNot Nothing Then
                senderNameLiteral.Text = "N/A"
            End If
            
            ' Note: The delivery-related fields have been removed from the ASPX file, 
            ' so we don't need to set them here anymore
        End If
    End Sub
    
    Private Function GetOrderItems(ByVal orderID As Integer) As DataTable
        Dim dt As New DataTable()
        
        Try
            ' Use the Connection class instead of direct SQL connection
            Dim connect As New Connection()
            
            ' Build the query with parameters
            Dim query As String = "SELECT " & _
                           "oi.quantity, " & _
                           "m.* " & _
                           "FROM order_items oi " & _
                           "INNER JOIN menu m ON oi.item_id = m.item_id " & _
                           "WHERE oi.order_id = @OrderID"
            
            ' Add parameters
            connect.AddParam("@OrderID", orderID)
            
            ' Execute query
            connect.Query(query)
            
            ' Get the result
            If connect.DataCount > 0 Then
                dt = connect.Data.Tables(0)
            End If
            
        Catch ex As Exception
            ' Handle database error
            Dim masterPage As Pages_Customer_CustomerTemplate = CType(Me.Master, Pages_Customer_CustomerTemplate)
            If masterPage IsNot Nothing Then
                masterPage.ShowAlert("Error loading order items: " & ex.Message, False)
            End If
        End Try
        
        Return dt
    End Function
    
    Protected Function GetImageUrl(ByVal imagePath As String) As String
        If String.IsNullOrEmpty(imagePath) Then
            Return "~/Assets/Images/default-food.jpg"
        End If
        
        Try
            If imagePath.StartsWith("http://") OrElse imagePath.StartsWith("https://") Then
                Return imagePath
            Else
                Return "~/Assets/Images/Menu/" & imagePath
            End If
        Catch ex As Exception
            ' If there's any error processing the image path, return the default
            Return "~/Assets/Images/default-food.jpg"
        End Try
    End Function
End Class
