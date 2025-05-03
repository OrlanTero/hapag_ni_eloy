Imports System.Data

Partial Class Pages_Customer_CustomerMenu
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in
            If Session("CURRENT_SESSION") Is Nothing Then
                Response.Redirect("~/Pages/LoginPortal/CustomerLoginPortal.aspx")
            End If

            ' Load categories, types, and menu items
            LoadCategories()
            LoadTypes()
            LoadMenuItems()
        End If
    End Sub

    Private Sub LoadCategories()
        Try
            Dim query As String = "SELECT DISTINCT category_id, category FROM menu ORDER BY category"
            Connect.Query(query)
            CategoryRepeater.DataSource = Connect.Data
            CategoryRepeater.DataBind()
        Catch ex As Exception
            ShowAlert("Error loading categories: " & ex.Message, False)
        End Try
    End Sub

    Private Sub LoadTypes()
        Try
            Dim query As String = "SELECT DISTINCT type_id, type FROM menu ORDER BY type"
            Connect.Query(query)
            TypeRepeater.DataSource = Connect.Data
            TypeRepeater.DataBind()
        Catch ex As Exception
            ShowAlert("Error loading types: " & ex.Message, False)
        End Try
    End Sub

    Private Sub LoadMenuItems()
        Try
            Dim query As String = "SELECT item_id, name, description, category, type, " & _
                                "category_id, type_id, image, CAST(price AS DECIMAL(10,2)) AS price, " & _
                                "availability " & _
                                "FROM menu ORDER BY name"
            Connect.Query(query)
            MenuRepeater.DataSource = Connect.Data
            MenuRepeater.DataBind()
        Catch ex As Exception
            ShowAlert("Error loading menu items: " & ex.Message, False)
        End Try
    End Sub

    Private Shared Function VerifyCartTable() As Boolean
        Try
            Dim Connect As New Connection()
            
            ' Check if cart table exists
            Try
                Dim checkTableQuery As String = "SHOW TABLES LIKE 'cart'"
                Connect.Query(checkTableQuery)
                
                If Connect.DataCount = 0 Then
                    ' Create cart table
                    Connect = New Connection()
                    Dim createTableQuery As String = "CREATE TABLE cart (" & _
                        "cart_id INT PRIMARY KEY AUTO_INCREMENT, " & _
                        "user_id INT NOT NULL, " & _
                        "item_id INT NOT NULL, " & _
                        "quantity INT NOT NULL DEFAULT 1, " & _
                        "FOREIGN KEY (user_id) REFERENCES users(user_id), " & _
                        "FOREIGN KEY (item_id) REFERENCES menu(item_id)" & _
                        ")"
                    Connect.Query(createTableQuery)
                End If
                
                Return True
            Catch ex As Exception
                Return False
            End Try
        Catch ex As Exception
            Return False
        End Try
    End Function

    <System.Web.Services.WebMethod()> _
    Public Shared Function AddToCart(ByVal itemId As Integer, ByVal quantity As Integer) As String
        Try
            ' Check if user is logged in
            If HttpContext.Current.Session("CURRENT_SESSION") Is Nothing Then
                Return "Error: Please log in to add items to cart"
            End If

            Dim currentUser As User = DirectCast(HttpContext.Current.Session("CURRENT_SESSION"), User)
            
            ' Create connection
            Dim Connect As New Connection()

            ' Check if item exists and is available
            Dim checkItemQuery As String = "SELECT availability FROM menu WHERE item_id = @item_id"
            Connect.AddParam("@item_id", itemId)
            Connect.Query(checkItemQuery)

            If Connect.DataCount = 0 Then
                Return "Error: Item not found"
            End If

            Dim availabilityValue = Connect.Data.Tables(0).Rows(0)("availability")
            Dim isAvailable As Boolean = True ' Default to True

            If availabilityValue IsNot Nothing Then
                If TypeOf availabilityValue Is Boolean Then
                    isAvailable = DirectCast(availabilityValue, Boolean)
                ElseIf TypeOf availabilityValue Is String Then
                    Dim availabilityStr As String = availabilityValue.ToString().Trim().ToLower()
                    isAvailable = (availabilityStr = "true" Or availabilityStr = "1" Or availabilityStr = "yes")
                ElseIf TypeOf availabilityValue Is Integer Then
                    isAvailable = (Convert.ToInt32(availabilityValue) = 1)
                End If
            End If

            If Not isAvailable Then
                Return "Error: Item is not available"
            End If

            ' Check if item exists in cart
            Connect = New Connection()
            Dim cartQuery As String = "SELECT cart_id FROM cart WHERE user_id = @user_id AND item_id = @item_id"
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.AddParam("@item_id", itemId)
            Connect.Query(cartQuery)

            If Connect.DataCount > 0 Then
                ' Update existing cart item
                Connect = New Connection()
                Dim cartId As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)("cart_id"))
                Dim updateQuery As String = "UPDATE cart SET quantity = quantity + @quantity WHERE cart_id = @cart_id"
                Connect.AddParam("@cart_id", cartId)
                Connect.AddParam("@quantity", quantity)
                Connect.Query(updateQuery)
            Else
                ' Insert new cart item
                Connect = New Connection()
                Dim insertQuery As String = "INSERT INTO cart (user_id, item_id, quantity) VALUES (@user_id, @item_id, @quantity)"
                Connect.AddParam("@user_id", currentUser.user_id)
                Connect.AddParam("@item_id", itemId)
                Connect.AddParam("@quantity", quantity)
                Connect.Query(insertQuery)
            End If

            Return "Success: Item added to cart successfully!"
        Catch ex As Exception
            Return "Error: " & ex.Message
        End Try
    End Function

    ' Helper method to show alert messages
    Protected Sub ShowAlert(ByVal message As String, Optional ByVal isSuccess As Boolean = True)
        Dim masterPage As Pages_Customer_CustomerTemplate = DirectCast(Me.Master, Pages_Customer_CustomerTemplate)
        masterPage.ShowAlert(message, isSuccess)
    End Sub

    Protected Function GetImageUrl(ByVal imagePath As String) As String
        If String.IsNullOrEmpty(imagePath) Then
            Return ResolveUrl("~/Assets/Images/default-food.jpg")
        End If

        ' Check if the path already contains the full URL
        If imagePath.StartsWith("http") Then
            Return imagePath
        End If

        ' Check if the path starts with ~/ or /
        If Not imagePath.StartsWith("~/") AndAlso Not imagePath.StartsWith("/") Then
            imagePath = "~/Assets/Images/Menu/" & imagePath
        End If

        Return ResolveUrl(imagePath)
    End Function

    Protected Function GetAvailabilityAttribute(ByVal availability As Object) As String
        Dim isAvailable As Boolean = CheckAvailability(availability)
        Return If(isAvailable, "", "disabled")
    End Function

    Protected Function GetAvailabilityText(ByVal availability As Object) As String
        Dim isAvailable As Boolean = CheckAvailability(availability)
        Return If(isAvailable, "Add to Cart", "Not Available")
    End Function

    Private Function CheckAvailability(ByVal availability As Object) As Boolean
        If availability Is Nothing Then Return True

        If TypeOf availability Is Boolean Then
            Return DirectCast(availability, Boolean)
        ElseIf TypeOf availability Is String Then
            Dim availStr As String = availability.ToString().Trim().ToLower()
            Return (availStr = "true" Or availStr = "1" Or availStr = "yes")
        ElseIf TypeOf availability Is Integer Then
            Return (Convert.ToInt32(availability) = 1)
        End If

        Return True ' Default to available if type is unknown
    End Function
End Class
