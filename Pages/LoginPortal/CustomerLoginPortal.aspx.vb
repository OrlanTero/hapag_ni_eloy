Imports HapagDB

Partial Class CustomerLoginPortal
    Inherits System.Web.UI.Page

    Dim Util As New DBUtils()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Page load code
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        Dim username As String = usernameTxt.Text
        Dim password As String = passwordTxt.Text

        Dim login = Util.LoginUser(username, password)

        If login IsNot Nothing Then
            ' Create User object and store in session
            Dim currentUser As New User()
            currentUser.user_id = Convert.ToInt32(login("user_id"))
            currentUser.username = login("username").ToString() 
            currentUser.display_name = login("display_name").ToString()
            
            ' Handle user_type conversion properly
            Try
                ' Try to convert user_type to integer
                currentUser.user_type = Convert.ToInt32(login("user_type"))
            Catch ex As Exception
                currentUser.user_type = 3 ' Default to customer
            End Try

            Session("CURRENT_SESSION") = currentUser

            Dim message As String = "Successfully Login!"
            Dim script As String = "alert('" & message.Replace("'", "\'") & "'); location.replace('../Customer/CustomerDashboard.aspx');"
            ClientScript.RegisterStartupScript(Me.GetType(), "ShowAlert", script, True)
        Else
            Dim message As String = "Failed to Login"
            Dim script As String = "alert('" & message.Replace("'", "\'") & "');"
            ClientScript.RegisterStartupScript(Me.GetType(), "ShowAlert", script, True)
        End If
    End Sub

    Protected Sub btnSendLink_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSendLink.Click
        Try
            Dim email As String = recoveryEmail.Text.Trim()
            
            ' Client-side validation may be bypassed, so validate server-side as well
            If String.IsNullOrEmpty(email) Then
                ShowAlert("Please enter your email address.")
                Return
            End If
            
            ' Validate email format
            If Not IsValidEmail(email) Then
                ShowAlert("Please enter a valid email address.")
                Return
            End If
            
            ' Verify email exists in the database
            If VerifyEmailExists(email) Then
                ' Generate and send OTP for password reset
                If OTPManager.GenerateAndSendOTP(email) Then
                    ' Show success message
                    ClientScript.RegisterStartupScript(Me.GetType(), "successMessage", 
                        "document.getElementById('successMessage').classList.add('active');", True)
                    
                    ' Redirect to OTP verification page with slight delay
                    ClientScript.RegisterStartupScript(Me.GetType(), "redirectToOTP", 
                        "setTimeout(function() { window.location.href = 'ForgotPasswordOTP.aspx'; }, 2000);", True)
                Else
                    ' Failed to send OTP
                    ShowAlert("Failed to send verification code. Please try again later.")
                End If
            Else
                ' Email not found in the database
                ' For security reasons, still show success message to prevent user enumeration
                ' Log a message for debugging purposes
                System.Diagnostics.Debug.WriteLine("Email not found in database: " & email)
                
                ' Show the same success message and redirection as if the email was found
                ClientScript.RegisterStartupScript(Me.GetType(), "successMessage", 
                    "document.getElementById('successMessage').classList.add('active');", True)
                
                ' We'll still redirect but the OTP page will handle the invalid email
                ClientScript.RegisterStartupScript(Me.GetType(), "redirectToOTP", 
                    "setTimeout(function() { window.location.href = 'ForgotPasswordOTP.aspx'; }, 2000);", True)
            End If
        Catch ex As Exception
            ' Log the exception
            System.Diagnostics.Debug.WriteLine("Password reset error: " & ex.Message)
            
            ' Show generic error message
            ShowAlert("An error occurred while processing your request. Please try again later.")
        End Try
    End Sub
    
    ' Helper function to validate email format
    Private Function IsValidEmail(ByVal email As String) As Boolean
        Try
            Dim addr As New System.Net.Mail.MailAddress(email)
            Return addr.Address = email
        Catch
            Return False
        End Try
    End Function
    
    ' Helper function to verify if email exists in the database
    Private Function VerifyEmailExists(ByVal email As String) As Boolean
        Try
            Dim conn As New Connection()
            Dim query As String = "SELECT COUNT(*) FROM users WHERE email = @Email"
            conn.AddParam("@Email", email)
            conn.Query(query)
            
            Return conn.DataCount > 0
        Catch ex As Exception
            ' Log error
            System.Diagnostics.Debug.WriteLine("Database error in VerifyEmailExists: " & ex.Message)
            Return False
        End Try
    End Function
    
    ' Helper function to show alert messages
    Private Sub ShowAlert(ByVal message As String)
        ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", 
            "alert('" & message.Replace("'", "\'") & "');", True)
    End Sub
End Class
