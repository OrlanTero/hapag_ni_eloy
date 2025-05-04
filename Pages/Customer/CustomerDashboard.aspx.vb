Imports System.Data
Imports HapagDB

Partial Class Pages_Customer_CustomerDashboard
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in
            If Session("CURRENT_SESSION") Is Nothing Then
                Response.Redirect("~/Pages/LoginPortal/CustomerLoginPortal.aspx")
                Return
            End If

            ' The following code is commented out as these controls no longer exist
            ' Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            ' UserDisplayNameLiteral.Text = currentUser.display_name
            ' UserInitialsLiteral.Text = GetInitials(currentUser.display_name)
            ' UserTypeLiteral.Text = If(currentUser.user_type = 1, "Admin", If(currentUser.user_type = 2, "Staff", "Customer"))

            ' Load dashboard data
            LoadDashboardData()
            
            ' Load special offers
            LoadSpecialOffers()
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

    Private Sub LoadDashboardData()
        Try
            ' Load recent orders
            LoadRecentOrders()

            ' Load available deals
            LoadAvailableDeals()

            ' Load reward points
            LoadRewardPoints()

        Catch ex As Exception
            ShowAlert("Error loading dashboard data: " & ex.Message, False)
        End Try
    End Sub

    Private Sub LoadRecentOrders()
        ' TODO: Implement loading recent orders
    End Sub

    Private Sub LoadAvailableDeals()
        ' TODO: Implement loading available deals
    End Sub

    Private Sub LoadRewardPoints()
        ' TODO: Implement loading reward points
    End Sub

    Private Sub LoadSpecialOffers()
        Try
            ' Get active promotions
            Dim query As String = "SELECT TOP 4 * FROM promotions WHERE "
            query &= "(CONVERT(datetime, start_date, 101) <= GETDATE() AND CONVERT(datetime, valid_until, 101) >= GETDATE()) OR "
            query &= "(start_date IS NULL OR valid_until IS NULL) "
            query &= "ORDER BY name ASC"

            Connect.ClearParams()
            Connect.Query(query)

            If Connect.DataCount > 0 Then
                PromotionsRepeater.DataSource = Connect.Data
                PromotionsRepeater.DataBind()
                PromotionsContainer.Visible = True
                NoPromotionsContainer.Visible = False
            Else
                PromotionsContainer.Visible = False
                NoPromotionsContainer.Visible = True
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error loading special offers: " & ex.Message)
            PromotionsContainer.Visible = False
            NoPromotionsContainer.Visible = True
            
            Dim masterPage As Pages_Customer_CustomerTemplate = DirectCast(Me.Master, Pages_Customer_CustomerTemplate)
            masterPage.ShowAlert("Error loading special offers: " & ex.Message, False)
        End Try
    End Sub

    Protected Function GetImageUrl(ByVal imagePath As Object) As String
        If imagePath Is Nothing OrElse String.IsNullOrEmpty(imagePath.ToString()) Then
            Return ResolveUrl("~/Assets/Images/default-food.jpg")
        End If

        Dim path As String = imagePath.ToString()

        ' Check if the path already contains the full URL
        If path.StartsWith("http") Then
            Return path
        End If

        ' Check if the path starts with ~/ or /
        If Not path.StartsWith("~/") AndAlso Not path.StartsWith("/") Then
            path = "~/Assets/Images/Menu/" & path
        End If

        Return ResolveUrl(path)
    End Function

    Protected Function GetValueDisplay(ByVal value As Object, ByVal valueType As Object) As String
        If value Is Nothing OrElse valueType Is Nothing Then
            Return ""
        End If

        Dim val As String = value.ToString()
        Dim type As String = valueType.ToString()

        If String.IsNullOrEmpty(val) Then
            Return ""
        End If

        If type = "1" Then
            ' Percentage
            Return val & "% OFF"
        ElseIf type = "2" Then
            ' Fixed amount
            Return "PHP " & val & " OFF"
        Else
            Return val
        End If
    End Function

    Protected Function FormatDate(ByVal dateValue As Object) As String
        If dateValue Is Nothing OrElse String.IsNullOrEmpty(dateValue.ToString()) Then
            Return "N/A"
        End If

        Try
            Dim date1 As DateTime = DateTime.Parse(dateValue.ToString())
            Return date1.ToString("MMM dd, yyyy")
        Catch ex As Exception
            Return dateValue.ToString()
        End Try
    End Function

    Protected Sub AddToCart_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim btn As LinkButton = DirectCast(sender, LinkButton)
            Dim itemId As Integer = Convert.ToInt32(btn.CommandArgument)
            Dim currentUser As Object = Session("CURRENT_SESSION")
            
            If currentUser Is Nothing Then
                Response.Redirect("~/Pages/LoginPortal/CustomerLoginPortal.aspx")
                Return
            End If
            
            ' Check if item already exists in cart
            Dim checkConnect As New Connection()
            Dim checkQuery As String = "SELECT cart_id, quantity FROM cart " & _
                                     "WHERE user_id = @user_id AND item_id = @item_id"

            checkConnect.AddParam("@user_id", CInt(currentUser.user_id))
            checkConnect.AddParam("@item_id", itemId)
            checkConnect.Query(checkQuery)

            If checkConnect.DataCount > 0 Then
                ' Update quantity if item exists
                Dim currentQuantity As Integer = CInt(checkConnect.Data.Tables(0).Rows(0)("quantity"))
                Dim newQuantity As Integer = currentQuantity + 1
                newQuantity = Math.Min(newQuantity, 99) ' Limit quantity to 99
                
                Dim updateConnect As New Connection()
                Dim updateQuery As String = "UPDATE cart " & _
                                          "SET quantity = @quantity " & _
                                          "WHERE user_id = @user_id AND item_id = @item_id"

                updateConnect.AddParam("@user_id", CInt(currentUser.user_id))
                updateConnect.AddParam("@item_id", itemId)
                updateConnect.AddParam("@quantity", newQuantity)
                updateConnect.Query(updateQuery)
            Else
                ' Insert new item if it doesn't exist
                Dim insertConnect As New Connection()
                Dim insertQuery As String = "INSERT INTO cart (user_id, item_id, quantity) " & _
                                          "VALUES (@user_id, @item_id, @quantity)"

                insertConnect.AddParam("@user_id", CInt(currentUser.user_id))
                insertConnect.AddParam("@item_id", itemId)
                insertConnect.AddParam("@quantity", 1)
                insertConnect.Query(insertQuery)
            End If
            
            ' Show success message and refresh cart count in master page
            Dim masterPage As Pages_Customer_CustomerTemplate = DirectCast(Me.Master, Pages_Customer_CustomerTemplate)
            masterPage.ShowAlert("Item added to cart successfully!", True)
            
            ' Refresh the page to update cart count
            Response.Redirect(Request.RawUrl)
        Catch ex As Exception
            Dim masterPage As Pages_Customer_CustomerTemplate = DirectCast(Me.Master, Pages_Customer_CustomerTemplate)
            masterPage.ShowAlert("Error adding item to cart: " & ex.Message, False)
        End Try
    End Sub

    ' Helper method to show alert messages
    Protected Sub ShowAlert(ByVal message As String, Optional ByVal isSuccess As Boolean = True)
        Dim masterPage As Pages_Customer_CustomerTemplate = DirectCast(Me.Master, Pages_Customer_CustomerTemplate)
        masterPage.ShowAlert(message, isSuccess)
    End Sub
    
    ' Helper method to show warning messages
    Protected Sub ShowWarning(ByVal message As String)
        Dim masterPage As Pages_Customer_CustomerTemplate = DirectCast(Me.Master, Pages_Customer_CustomerTemplate)
        masterPage.ShowAlert(message, False)
    End Sub
    
    ' Helper method to show info messages
    Protected Sub ShowInfo(ByVal message As String)
        Dim masterPage As Pages_Customer_CustomerTemplate = DirectCast(Me.Master, Pages_Customer_CustomerTemplate)
        masterPage.ShowAlert(message, True)
    End Sub
End Class
