Imports System.Data
Imports System.Web.Security
Imports HapagDB

Partial Class Pages_LoginPortal_AdminStaffLoginPortal
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Check if user is already logged in
        If Not IsNothing(Session("CURRENT_SESSION")) Then
            RedirectBasedOnRole()
        End If

        ' Check if there's a remember me cookie
        If Not IsPostBack Then
            Dim authCookie As HttpCookie = Request.Cookies("UserAuth")
            If authCookie IsNot Nothing Then
                UsernameTxt.Text = authCookie("Username")
                RememberMeChk.Checked = True
            End If
        End If
    End Sub

    Protected Sub LoginBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim username As String = UsernameTxt.Text.Trim()
        Dim password As String = PasswordTxt.Text.Trim()
        Dim isAdmin As Boolean = AdminRadio.Checked

        If String.IsNullOrEmpty(username) OrElse String.IsNullOrEmpty(password) Then
            ShowAlert("Please enter both username and password.", "danger")
            Return
        End If

        Try
            ' Query the users table and check user_type
            Dim userType As Integer = If(isAdmin, 1, 2) ' 1 for admin, 2 for staff
            Dim query As String = "SELECT * FROM users WHERE username = @username AND password = @password AND user_type = @user_type"

            Connect.AddParam("@username", username)
            Connect.AddParam("@password", password)
            Connect.AddParam("@user_type", userType)

            If Connect.Query(query) AndAlso Connect.DataCount > 0 Then
                ' Create user session
                Dim userData As DataRow = Connect.Data.Tables(0).Rows(0)
                Dim user As New User()
                user.user_id = userData("user_id")
                user.username = userData("username")
                user.display_name = userData("display_name")
                user.role = If(userType = 1, "admin", "staff")

                Session("CURRENT_SESSION") = user

                ' Handle remember me
                If RememberMeChk.Checked Then
                    Dim authCookie As New HttpCookie("UserAuth")
                    authCookie("Username") = username
                    authCookie.Expires = DateTime.Now.AddDays(30)
                    Response.Cookies.Add(authCookie)
                Else
                    ' Remove cookie if exists
                    If Request.Cookies("UserAuth") IsNot Nothing Then
                        Dim authCookie As New HttpCookie("UserAuth")
                        authCookie.Expires = DateTime.Now.AddDays(-1)
                        Response.Cookies.Add(authCookie)
                    End If
                End If

                ' Log the login activity
                LogLoginActivity(user.user_id, user.role)

                ' Redirect based on role
                RedirectBasedOnRole()
            Else
                ShowAlert("Invalid username or password.", "danger")
            End If
        Catch ex As Exception
            ShowAlert("Error during login: " & ex.Message, "danger")
        End Try
    End Sub

    Private Sub LogLoginActivity(ByVal userId As Integer, ByVal role As String)
        Try
            Dim query As String = "INSERT INTO login_history (user_id, role, login_time, ip_address) VALUES (@user_id, @role, @login_time, @ip_address)"

            Connect.AddParam("@user_id", userId)
            Connect.AddParam("@role", role)
            Connect.AddParam("@login_time", DateTime.Now)
            Connect.AddParam("@ip_address", Request.UserHostAddress)

            Connect.Query(query)
        Catch ex As Exception
            ' Log the error but don't stop the login process
            System.Diagnostics.Debug.WriteLine("Error logging login activity: " & ex.Message)
        End Try
    End Sub

    Private Sub RedirectBasedOnRole()
        Dim user As User = DirectCast(Session("CURRENT_SESSION"), User)
        If user IsNot Nothing Then
            Select Case user.role.ToLower()
                Case "admin"
                    Response.Redirect("~/Pages/Admin/AdminDashboard.aspx")
                Case "staff"
                    Response.Redirect("~/Pages/Staff/StaffDashboard.aspx")
                Case Else
                    Response.Redirect("~/Default.aspx")
            End Select
        End If
    End Sub

    Private Sub ShowAlert(ByVal message As String, ByVal type As String)
        alertMessage.Visible = True
        alertMessage.Attributes("class") = "alert-message alert-" & type & " show"
        AlertLiteral.Text = message
    End Sub
End Class
