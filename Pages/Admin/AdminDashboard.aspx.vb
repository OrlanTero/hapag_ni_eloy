Partial Class Pages_Admin_AdminDashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in
            If Session("CURRENT_SESSION") Is Nothing Then
                Response.Redirect("~/Pages/LoginPortal/AdminStaffLoginPortal.aspx")
            End If

            ' Display user name and initials
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            UserDisplayNameLiteral.Text = currentUser.display_name
            UserInitialsLiteral.Text = GetInitials(currentUser.display_name)
            
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

    Protected Sub LogoutButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        ' Clear session
        Session.Clear()
        Session.Abandon()

        ' Redirect to login page
        Response.Redirect("~/Pages/LoginPortal/AdminStaffLoginPortal.aspx")
    End Sub

    Private Sub LoadDashboardData()
        ' Here you would load the actual data for the dashboard
        ' For now, we're using sample data in the front-end
        Try
            Dim dbUtils As New DBUtils()
            
            ' You can uncomment and implement these once the database queries are ready
            ' TotalOrdersLiteral.Text = GetTotalOrders()
            ' TotalRevenueLiteral.Text = GetTotalRevenue()
            ' ActiveUsersLiteral.Text = GetActiveUsers()
            ' MenuItemsLiteral.Text = GetTotalMenuItems()

        Catch ex As Exception
            ' Handle any errors
            AlertLiteral.Text = "Error loading dashboard data: " & ex.Message
            alertMessage.Visible = True
        End Try
    End Sub

    ' Helper methods for loading dashboard data
    Private Function GetTotalOrders() As Integer
        ' Implement the actual database query
        Return 0
    End Function

    Private Function GetTotalRevenue() As Decimal
        ' Implement the actual database query
        Return 0
    End Function

    Private Function GetActiveUsers() As Integer
        ' Implement the actual database query
        Return 0
    End Function

    Private Function GetTotalMenuItems() As Integer
        ' Implement the actual database query
        Return 0
    End Function
End Class
