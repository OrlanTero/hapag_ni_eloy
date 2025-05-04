Imports System.Data
Imports HapagDB

Partial Class Pages_Customer_CustomerTemplate
    Inherits System.Web.UI.MasterPage
    Dim Connect As New Connection()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in
            If Session("CURRENT_SESSION") Is Nothing Then
                Response.Redirect("~/Pages/LoginPortal/CustomerLoginPortal.aspx")
                Return
            End If

            ' Set active navigation item based on current page
            SetActiveNavItem()
            
            ' Load cart count
            LoadCartCount()
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

    Protected Sub LogoutButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        ' Clear session
        Session.Clear()
        Session.Abandon()

        ' Redirect to login page
        Response.Redirect("~/Pages/LoginPortal/CustomerLoginPortal.aspx")
    End Sub

    Private Sub SetActiveNavItem()
        Try
            ' Get the current page filename
            Dim currentPage As String = System.IO.Path.GetFileName(Request.Path).ToLower()
            
            ' Reset all navigation items
            navHome.Attributes.Remove("class")
            navMenu.Attributes.Remove("class")
            navOffers.Attributes.Remove("class")
            navOrders.Attributes.Remove("class")
            navProfile.Attributes.Remove("class")
            navTransaction.Attributes.Remove("class")
            navSupport.Attributes.Remove("class")
            navCart.Attributes.Remove("class")
            
            ' Set active class based on current page
            Select Case currentPage
                Case "customerdashboard.aspx"
                    navHome.Attributes.Add("class", "active")
                Case "customermenu.aspx"
                    navMenu.Attributes.Add("class", "active")
                Case "customerspecialoffers.aspx"
                    navOffers.Attributes.Add("class", "active")
                Case "customerorders.aspx"
                    navOrders.Attributes.Add("class", "active")
                Case "customerprofile.aspx"
                    navProfile.Attributes.Add("class", "active")
                Case "customertransactionhistory.aspx"
                    navTransaction.Attributes.Add("class", "active")
                Case "customersupport.aspx"
                    navSupport.Attributes.Add("class", "active")
                Case "customercart.aspx"
                    navCart.Attributes.Add("class", "active")
            End Select
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error setting active navigation: " & ex.Message)
        End Try
    End Sub

    Private Sub LoadCartCount()
        Try
            If Session("CURRENT_SESSION") IsNot Nothing Then
                Dim currentUser As Object = Session("CURRENT_SESSION")

                ' Get total items count (sum of quantities) from the cart
                Dim query As String = "SELECT SUM(quantity) AS total_items FROM cart WHERE user_id = @user_id"
                Connect.ClearParams()
                Connect.AddParam("@user_id", CInt(currentUser.user_id))
                Connect.Query(query)

                If Connect.DataCount > 0 AndAlso Not IsDBNull(Connect.Data.Tables(0).Rows(0)("total_items")) Then
                    Dim totalItems As Integer = CInt(Connect.Data.Tables(0).Rows(0)("total_items"))
                    CartCountLiteral.Text = totalItems.ToString()
                Else
                    CartCountLiteral.Text = "0"
                End If
            Else
                CartCountLiteral.Text = "0"
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error loading cart count: " & ex.Message)
            CartCountLiteral.Text = "0"
        End Try
    End Sub

    Public Sub ShowAlert(ByVal message As String, Optional ByVal isSuccess As Boolean = True)
        alertMessage.Visible = True
        
        If isSuccess Then
            alertMessage.Attributes("class") = "alert-message alert-success"
        Else
            alertMessage.Attributes("class") = "alert-message alert-danger"
        End If
        
        AlertLiteral.Text = message
    End Sub
End Class 