Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports HapagDB

Partial Class Pages_LoginPortal_ResetPassword
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Try
                ' Get token from query string
                Dim token As String = Request.QueryString("token")
                
                System.Diagnostics.Debug.WriteLine("Reset Password Page - Token from query string: " & If(token, "null"))
                
                ' Check if token exists
                If String.IsNullOrEmpty(token) Then
                    System.Diagnostics.Debug.WriteLine("Reset Password Error - No token provided")
                    ShowError()
                    Return
                End If
                
                ' Store token in hidden field
                tokenValue.Value = token
                
                ' Check user data from OTP verification
                Dim userData As Dictionary(Of String, String) = OTPManager.GetUserData()
                
                System.Diagnostics.Debug.WriteLine("Reset Password - User data from session: " & 
                    If(userData Is Nothing, "null", "found"))
                
                If userData Is Nothing OrElse Not userData.ContainsKey("Email") OrElse Not userData.ContainsKey("ResetToken") Then
                    ' No user data or missing required fields
                    System.Diagnostics.Debug.WriteLine("Reset Password Error - Missing user data or required fields")
                    ShowError()
                    Return
                End If
                
                ' Verify token matches
                If userData("ResetToken") <> token Then
                    System.Diagnostics.Debug.WriteLine("Reset Password Error - Token mismatch: " & 
                        userData("ResetToken") & " vs " & token)
                    ShowError()
                    Return
                End If
                
                ' Data is valid, allow password reset
                System.Diagnostics.Debug.WriteLine("Password reset session is valid for email: " & userData("Email"))
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Reset Password Error in Page_Load: " & ex.Message)
                ShowError()
            End Try
        End If
    End Sub
    
    Protected Sub resetPasswordBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles resetPasswordBtn.Click
        Try
            ' Get token from hidden field
            Dim token As String = tokenValue.Value
            
            System.Diagnostics.Debug.WriteLine("Reset Password Button Click - Token: " & If(token, "null"))
            
            ' Get user data from session
            Dim userData As Dictionary(Of String, String) = OTPManager.GetUserData()
            
            System.Diagnostics.Debug.WriteLine("Reset Password - User data from session: " & 
                If(userData Is Nothing, "null", "found"))
            
            ' Validate token and user data again
            If String.IsNullOrEmpty(token) OrElse 
               userData Is Nothing OrElse 
               Not userData.ContainsKey("Email") OrElse 
               Not userData.ContainsKey("ResetToken") OrElse 
               userData("ResetToken") <> token Then
                System.Diagnostics.Debug.WriteLine("Reset Password Error - Token validation failed")
                ShowError()
                Return
            End If
            
            ' Get the new password from form fields
            Dim newPass As String = newPassword.Text.Trim()
            Dim confirmPass As String = confirmPassword.Text.Trim()
            
            System.Diagnostics.Debug.WriteLine("Reset Password - Validating new password")
            
            ' Validate passwords
            If Not ValidatePasswords(newPass, confirmPass) Then
                System.Diagnostics.Debug.WriteLine("Reset Password Error - Password validation failed")
                Return
            End If
            
            ' Get user email from session
            Dim userEmail As String = userData("Email")
            
            System.Diagnostics.Debug.WriteLine("Reset Password - Updating password for email: " & userEmail)
            
            ' Update user password in the database
            If UpdateUserPassword(userEmail, newPass) Then
                System.Diagnostics.Debug.WriteLine("Reset Password - Password updated successfully")
                
                ' Clear user data from session
                OTPManager.ClearUserData()
                
                ' Show success message
                resetForm.Visible = False
                successMessage.Visible = True
                successMessage.Style("display") = "block"
            Else
                ' Show generic error
                System.Diagnostics.Debug.WriteLine("Reset Password Error - Failed to update password in database")
                ClientScript.RegisterStartupScript(Me.GetType(), "errorMsg", 
                    "alert('An error occurred while resetting your password. Please try again.');", True)
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Reset Password Error in resetPasswordBtn_Click: " & ex.Message)
            ClientScript.RegisterStartupScript(Me.GetType(), "errorMsg", 
                "alert('An unexpected error occurred. Please try again later.');", True)
        End Try
    End Sub
    
    Private Function ValidatePasswords(ByVal newPass As String, ByVal confirmPass As String) As Boolean
        ' Check if passwords are empty
        If String.IsNullOrEmpty(newPass) OrElse String.IsNullOrEmpty(confirmPass) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "emptyPassword", 
                "alert('Password fields cannot be empty.');", True)
            Return False
        End If
        
        ' Check if passwords match
        If newPass <> confirmPass Then
            ClientScript.RegisterStartupScript(Me.GetType(), "passwordMismatch", 
                "alert('Passwords do not match. Please try again.');", True)
            Return False
        End If
        
        ' Check password complexity
        If Not IsStrongPassword(newPass) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "weakPassword", 
                "alert('Password does not meet the requirements. Please review the password guidelines.');", True)
            Return False
        End If
        
        Return True
    End Function
    
    Private Function IsStrongPassword(ByVal password As String) As Boolean
        ' Check if password meets requirements
        ' 1. At least 8 characters long
        If password.Length < 8 Then
            Return False
        End If
        
        ' 2. Contains at least one uppercase letter
        If Not password.Any(Function(c) Char.IsUpper(c)) Then
            Return False
        End If
        
        ' 3. Contains at least one lowercase letter
        If Not password.Any(Function(c) Char.IsLower(c)) Then
            Return False
        End If
        
        ' 4. Contains at least one digit
        If Not password.Any(Function(c) Char.IsDigit(c)) Then
            Return False
        End If
        
        ' 5. Contains at least one special character
        Dim specialChars As String = "!@#$%^&*()-_=+[]{}|;:,.<>?/~`"
        If Not password.Any(Function(c) specialChars.Contains(c)) Then
            Return False
        End If
        
        Return True
    End Function
    
    Private Sub ShowError()
        ' Hide the reset form and show error message
        resetForm.Visible = False
        errorMessage.Visible = True
        errorMessage.Style("display") = "block"
    End Sub
    
    ' Helper function to update the user's password
    Private Function UpdateUserPassword(ByVal email As String, ByVal newPassword As String) As Boolean
        Try
            Dim conn As New Connection()
            Dim query As String = "UPDATE users SET password = @Password WHERE email = @Email"
            
            ' Hash the password before storing (in a real system)
            Dim hashedPassword As String = HashPassword(newPassword)
            
            conn.AddParam("@Password", hashedPassword)
            conn.AddParam("@Email", email)
            
            System.Diagnostics.Debug.WriteLine("Executing query to update password for email: " & email)
            
            Dim result As Boolean = conn.Query(query)
            
            System.Diagnostics.Debug.WriteLine("Password update query result: " & result)
            
            Return result
        Catch ex As Exception
            ' Log error
            System.Diagnostics.Debug.WriteLine("Error updating password: " & ex.Message)
            Return False
        End Try
    End Function
    
    ' Helper function to hash the password
    Private Function HashPassword(ByVal password As String) As String
        ' TODO: Replace with proper password hashing
        ' For example using BCrypt.Net:
        ' Return BCrypt.Net.BCrypt.HashPassword(password)
        
        ' For demonstration only - in a real application, use a secure hashing algorithm
        System.Diagnostics.Debug.WriteLine("Note: Using insecure password storage for demonstration")
        Return password
    End Function
End Class 