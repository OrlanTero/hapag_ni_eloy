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
        Dim email As String = recoveryEmail.Text.Trim()
        
        ' Validate email
        If String.IsNullOrEmpty(email) OrElse Not IsValidEmail(email) Then
            ' Email validation failed
            ClientScript.RegisterStartupScript(Me.GetType(), "invalidEmail", 
                "alert('Please enter a valid email address.');", True)
            Return
        End If
        
        ' Verify email exists in the database
        If VerifyEmailExists(email) Then
            ' Generate a unique token for password reset
            Dim resetToken As String = GenerateResetToken()
            
            ' Store the token in the database with the user's email and expiration date
            StoreResetToken(email, resetToken)
            
            ' Send recovery email with the reset link
            SendPasswordResetEmail(email, resetToken)
            
            ' Show success message
            ClientScript.RegisterStartupScript(Me.GetType(), "successMessage", 
                "document.getElementById('successMessage').classList.add('active');", True)
        Else
            ' Email not found in the database
            ' For security reasons, still show success message
            ' This prevents user enumeration attacks
            ClientScript.RegisterStartupScript(Me.GetType(), "successMessage", 
                "document.getElementById('successMessage').classList.add('active');", True)
            
            ' For development/testing, add a note about the email not being found
            System.Diagnostics.Debug.WriteLine("Email not found in database: " & email)
        End If
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
            Return False
        End Try
    End Function
    
    ' Helper function to generate a unique token for password reset
    Private Function GenerateResetToken() As String
        ' Generate a random token
        Dim tokenBytes As Byte() = New Byte(31) {}
        Dim rng As New System.Security.Cryptography.RNGCryptoServiceProvider()
        rng.GetBytes(tokenBytes)
        Return Convert.ToBase64String(tokenBytes).Replace("+", "").Replace("/", "").Replace("=", "").Substring(0, 20)
    End Function
    
    ' Helper function to store the reset token in the database
    Private Sub StoreResetToken(ByVal email As String, ByVal token As String)
        Try
            Dim conn As New Connection()
            ' First, remove any existing tokens for this email
            Dim deleteQuery As String = "DELETE FROM password_resets WHERE email = @Email"
            conn.AddParam("@Email", email)
            conn.Query(deleteQuery)
            
            ' Create new connection for insert
            conn = New Connection()
            
            ' Insert new token with 24-hour expiration
            Dim insertQuery As String = "INSERT INTO password_resets (email, token, expiration_date, is_used) VALUES (@Email, @Token, @Expiration, 0)"
            conn.AddParam("@Email", email)
            conn.AddParam("@Token", token)
            conn.AddParam("@Expiration", DateTime.Now.AddHours(24))
            conn.Query(insertQuery)
        Catch ex As Exception
            ' Log error
            System.Diagnostics.Debug.WriteLine("Error storing reset token: " & ex.Message)
        End Try
    End Sub
    
    ' Helper function to send the password reset email
    Private Sub SendPasswordResetEmail(ByVal email As String, ByVal token As String)
        Try
            ' Generate reset link
            Dim resetLink As String = "http://" & Request.Url.Host & ":" & Request.Url.Port & "/Pages/LoginPortal/ResetPassword.aspx?token=" & token
            
            ' For now, just show the reset link as an alert for testing purposes
            ' In a production environment, this would actually send an email
            ClientScript.RegisterStartupScript(Me.GetType(), "resetLink", 
                "console.log('Reset link: " & resetLink & "');", True)
            
            ' In a production environment, we would use code like this:
            ' Using message As New System.Net.Mail.MailMessage()
            '     message.From = New System.Net.Mail.MailAddress("noreply@hapagrestaurant.com", "Hapag Filipino Restaurant")
            '     message.To.Add(New System.Net.Mail.MailAddress(email))
            '     message.Subject = "Password Reset Request"
            '     message.Body = "Dear Customer," & vbCrLf & vbCrLf & 
            '                   "We received a request to reset your password. Please click the link below to reset your password:" & vbCrLf & vbCrLf & 
            '                   resetLink & vbCrLf & vbCrLf & 
            '                   "This link will expire in 24 hours. If you did not request a password reset, please ignore this email." & vbCrLf & vbCrLf & 
            '                   "Regards," & vbCrLf & "Hapag Filipino Restaurant Team"
            '     message.IsBodyHtml = False
            '     
            '     Using client As New System.Net.Mail.SmtpClient("smtp.example.com")
            '         client.Port = 587
            '         client.Credentials = New System.Net.NetworkCredential("username", "password")
            '         client.EnableSsl = True
            '         client.Send(message)
            '     End Using
            ' End Using
            
            ' For development/testing: show the reset link to the user
            ClientScript.RegisterStartupScript(Me.GetType(), "showResetLink", 
                "alert('For testing: Password reset link has been generated. In a real environment, this would be sent to your email. Link: " & resetLink & "');", True)
        Catch ex As Exception
            ' Log error
            System.Diagnostics.Debug.WriteLine("Error sending password reset email: " & ex.Message)
        End Try
    End Sub
End Class
