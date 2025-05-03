Imports System.Data.SqlClient
Imports HapagDB

Partial Class Pages_LoginPortal_ResetPassword
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Get token from query string
            Dim token As String = Request.QueryString("token")
            
            ' Check if token exists
            If String.IsNullOrEmpty(token) Then
                ShowError()
                Return
            End If
            
            ' Store token in hidden field
            tokenValue.Value = token
            
            ' Verify token validity
            If Not IsValidToken(token) Then
                ShowError()
                Return
            End If
        End If
    End Sub
    
    Protected Sub resetPasswordBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles resetPasswordBtn.Click
        ' Get token from hidden field
        Dim token As String = tokenValue.Value
        
        ' Validate token again
        If String.IsNullOrEmpty(token) OrElse Not IsValidToken(token) Then
            ShowError()
            Return
        End If
        
        ' Get the new password from form fields
        Dim newPass As String = newPassword.Text.Trim()
        Dim confirmPass As String = confirmPassword.Text.Trim()
        
        ' Validate passwords
        If Not ValidatePasswords(newPass, confirmPass) Then
            Return
        End If
        
        ' Get user email associated with the token
        Dim userEmail As String = GetEmailFromToken(token)
        If String.IsNullOrEmpty(userEmail) Then
            ShowError()
            Return
        End If
        
        ' Update user password in the database
        If UpdateUserPassword(userEmail, newPass) Then
            ' Invalidate the token
            InvalidateToken(token)
            
            ' Show success message
            resetForm.Visible = False
            successMessage.Visible = True
            successMessage.Style("display") = "block"
        Else
            ' Show generic error
            ClientScript.RegisterStartupScript(Me.GetType(), "errorMsg", 
                "alert('An error occurred while resetting your password. Please try again.');", True)
        End If
    End Sub
    
    Private Function ValidatePasswords(ByVal newPass As String, ByVal confirmPass As String) As Boolean
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
    
    ' Helper function to check if token is valid and not expired
    Private Function IsValidToken(ByVal token As String) As Boolean
        Try
            Dim conn As New Connection()
            Dim query As String = "SELECT COUNT(*) FROM password_resets WHERE token = @Token AND expiration_date > @CurrentDate AND is_used = 0"
            conn.AddParam("@Token", token)
            conn.AddParamWithNull("@CurrentDate", DateTime.Now)
            conn.Query(query)
            
            Return conn.DataCount > 0
        Catch ex As Exception
            ' Log error
            System.Diagnostics.Debug.WriteLine("Error validating token: " & ex.Message)
            Return False
        End Try
    End Function
    
    ' Helper function to get the email associated with the token
    Private Function GetEmailFromToken(ByVal token As String) As String
        Try
            Dim conn As New Connection()
            Dim query As String = "SELECT email FROM password_resets WHERE token = @Token AND expiration_date > @CurrentDate AND is_used = 0"
            conn.AddParam("@Token", token)
            conn.AddParamWithNull("@CurrentDate", DateTime.Now)
            conn.Query(query)
            
            If conn.DataCount > 0 Then
                Return conn.Data.Tables(0).Rows(0)("email").ToString()
            End If
            
            Return String.Empty
        Catch ex As Exception
            ' Log error
            System.Diagnostics.Debug.WriteLine("Error getting email from token: " & ex.Message)
            Return String.Empty
        End Try
    End Function
    
    ' Helper function to update the user's password
    Private Function UpdateUserPassword(ByVal email As String, ByVal newPassword As String) As Boolean
        Try
            Dim conn As New Connection()
            Dim query As String = "UPDATE users SET password = @Password WHERE email = @Email"
            
            ' Hash the password before storing (in a real system)
            Dim hashedPassword As String = newPassword ' In a real system, hash this
            
            conn.AddParam("@Password", hashedPassword)
            conn.AddParam("@Email", email)
            Return conn.Query(query)
        Catch ex As Exception
            ' Log error
            System.Diagnostics.Debug.WriteLine("Error updating password: " & ex.Message)
            Return False
        End Try
    End Function
    
    ' Helper function to invalidate the token after it has been used
    Private Sub InvalidateToken(ByVal token As String)
        Try
            Dim conn As New Connection()
            Dim query As String = "UPDATE password_resets SET is_used = 1 WHERE token = @Token"
            conn.AddParam("@Token", token)
            conn.Query(query)
        Catch ex As Exception
            ' Log error
            System.Diagnostics.Debug.WriteLine("Error invalidating token: " & ex.Message)
        End Try
    End Sub
    
    ' Helper function to hash the password
    Private Function HashPassword(ByVal password As String) As String
        ' TODO: Replace with proper password hashing
        ' For example using BCrypt.Net:
        ' Return BCrypt.Net.BCrypt.HashPassword(password)
        
        ' Placeholder implementation
        Return password
    End Function
End Class 