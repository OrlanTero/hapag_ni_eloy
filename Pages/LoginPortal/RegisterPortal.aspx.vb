Imports System.Data
Imports HapagDB
Public Class Pages_Customer_RegisterPortal
    Inherits System.Web.UI.Page

    Dim Connect As New Connection()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Set focus to the first field
            displayNameTxt.Focus()
        End If
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        Try
            ' Get form values
            Dim username As String = usernameTxt.Text.Trim()
            Dim password As String = passwordTxt.Text
            Dim confirmPassword As String = confirmPasswordTxt.Text
            Dim displayName As String = displayNameTxt.Text.Trim()
            Dim email As String = emailTxt.Text.Trim()

            ' Validate required fields
            If String.IsNullOrEmpty(username) OrElse String.IsNullOrEmpty(password) OrElse 
               String.IsNullOrEmpty(confirmPassword) OrElse String.IsNullOrEmpty(displayName) OrElse 
               String.IsNullOrEmpty(email) Then
                ShowAlert("All fields are required.", False)
                Return
            End If

            ' Validate password match
            If password <> confirmPassword Then
                ShowAlert("Passwords do not match.", False)
                Return
            End If

            ' Validate email format
            If Not IsValidEmail(email) Then
                ShowAlert("Please enter a valid email address.", False)
                Return
            End If

            ' Validate username doesn't exist
            Dim checkUsernameQuery As String = "SELECT COUNT(*) FROM users WHERE username = @username"
            Connect.AddParam("@username", username)
            Connect.Query(checkUsernameQuery)

            If Connect.Data.Tables(0).Rows(0)(0) > 0 Then
                ShowAlert("Username already exists. Please choose a different username.", False)
                Return
            End If

            ' Create new connection for email check
            Connect = New Connection()

            ' Validate email doesn't exist
            Dim checkEmailQuery As String = "SELECT COUNT(*) FROM users WHERE email = @email"
            Connect.AddParam("@email", email)
            Connect.Query(checkEmailQuery)

            If Connect.Data.Tables(0).Rows(0)(0) > 0 Then
                ShowAlert("Email address already registered. Please use a different email or try to recover your password.", False)
                Return
            End If

            ' Create new connection for insert
            Connect = New Connection()

            ' Insert new user (always as customer with user_type = 3)
            Dim insertQuery As String = "INSERT INTO users (username, password, display_name, email, user_type) VALUES (@username, @password, @display_name, @email, @user_type)"
            
            With Connect
                .AddParam("@username", username)
                .AddParam("@password", password)
                .AddParam("@display_name", displayName)
                .AddParam("@email", email)
                .AddParam("@user_type", 3) ' 3 = customer
                .Query(insertQuery)
            End With

            ' Show success message and redirect
            ShowAlert("Registration successful! Please log in.", True)
            Response.Redirect("CustomerLoginPortal.aspx")

        Catch ex As Exception
            ShowAlert("Registration failed: " & ex.Message, False)
        End Try
    End Sub

    Private Function IsValidEmail(ByVal email As String) As Boolean
        Try
            Dim addr As New System.Net.Mail.MailAddress(email)
            Return addr.Address = email
        Catch
            Return False
        End Try
    End Function

    Private Sub ShowAlert(ByVal message As String, ByVal isSuccess As Boolean)
        Dim script As String = String.Format("alert('{0}');", message.Replace("'", "\'"))
        If isSuccess Then
            script &= String.Format("window.location = '{0}';", ResolveUrl("CustomerLoginPortal.aspx"))
        End If
        ClientScript.RegisterStartupScript(Me.GetType(), "ShowAlert", script, True)
    End Sub
End Class
