Imports System.Data
Imports HapagDB
Imports System.Collections.Generic

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
            ' Validate form
            If Not ValidateForm() Then
                Return
            End If
            
            ' Get values from form
            Dim displayName As String = displayNameTxt.Text.Trim()
            Dim username As String = usernameTxt.Text.Trim()
            Dim email As String = emailTxt.Text.Trim()
            Dim password As String = passwordTxt.Text.Trim()
            
            ' Check if email or username already exists in database
            If IsEmailOrUsernameExists(email, username) Then
                ShowErrorMessage("Email address or username already exists. Please try a different one.")
                Return
            End If
            
            ' Store the registration data in session
            Dim userData As New Dictionary(Of String, String)()
            userData.Add("DisplayName", displayName)
            userData.Add("Username", username)
            userData.Add("Email", email)
            userData.Add("Password", password) ' In production, you would hash this password
            userData.Add("UserType", "3") ' 3 = customer
            
            ' Store the user data in session for later use after verification
            OTPManager.StoreUserData(userData)
            
            System.Diagnostics.Debug.WriteLine("Starting OTP process for email: " & email)
            
            ' Generate and send OTP to user's email
            Dim otpResult As Boolean = OTPManager.GenerateAndSendOTP(email)
            System.Diagnostics.Debug.WriteLine("OTP generation result: " & otpResult.ToString())
            
            If otpResult Then
                ' Email sent successfully, redirect to OTP verification page
                System.Diagnostics.Debug.WriteLine("OTP sent successfully, redirecting to verification page")
                
                ' Set the flag to bypass login redirect in the master page
                Session("SkipLoginRedirect") = "true"
                Session("OTPGenerated") = "true"
                
                ' Direct redirect to OTP verification page
                Response.Redirect("~/Pages/OTPVerification.aspx", False)
                Context.ApplicationInstance.CompleteRequest()
            Else
                ' Failed to send OTP
                System.Diagnostics.Debug.WriteLine("Failed to send OTP")
                ShowErrorMessage("Failed to send verification code. Please try again.")
                OTPManager.ClearUserData() ' Clean up session data
            End If
            
        Catch ex As Exception
            ' Log error
            System.Diagnostics.Debug.WriteLine("Registration error: " & ex.Message)
            System.Diagnostics.Debug.WriteLine("Stack trace: " & ex.StackTrace)
            ShowErrorMessage("An error occurred during registration. Please try again.")
        End Try
    End Sub

    Private Function ValidateForm() As Boolean
        ' Clear previous error messages
        ClearErrorMessages()
        
        ' Check for empty fields
        If String.IsNullOrEmpty(displayNameTxt.Text.Trim()) Then
            ShowErrorMessage("Display Name is required")
            return False
        End If
        
        If String.IsNullOrEmpty(usernameTxt.Text.Trim()) Then
            ShowErrorMessage("Username is required")
            return False
        End If
        
        If String.IsNullOrEmpty(emailTxt.Text.Trim()) Then
            ShowErrorMessage("Email Address is required")
            return False
        End If
        
        If String.IsNullOrEmpty(passwordTxt.Text) Then
            ShowErrorMessage("Password is required")
            return False
        End If
        
        If String.IsNullOrEmpty(confirmPasswordTxt.Text) Then
            ShowErrorMessage("Please confirm your password")
            return False
        End If
        
        ' Check for valid email format
        If Not System.Text.RegularExpressions.Regex.IsMatch(emailTxt.Text.Trim(), "^[^@\s]+@[^@\s]+\.[^@\s]+$") Then
            ShowErrorMessage("Please enter a valid email address")
            return False
        End If
        
        ' Check password length
        If passwordTxt.Text.Length < 6 Then
            ShowErrorMessage("Password must be at least 6 characters long")
            return False
        End If
        
        ' Check if passwords match
        If passwordTxt.Text <> confirmPasswordTxt.Text Then
            ShowErrorMessage("Passwords do not match")
            return False
        End If
        
        Return True
    End Function
    
    Private Function IsEmailOrUsernameExists(ByVal email As String, ByVal username As String) As Boolean
        Dim Connect As New Connection()
        
        Try
            ' Check username
            Dim checkUsernameQuery As String = "SELECT COUNT(*) FROM users WHERE username = @username"
            Connect.ClearParams()
            Connect.AddParam("@username", username)
            Connect.Query(checkUsernameQuery)
            
            If Connect.DataCount > 0 AndAlso Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0)) > 0 Then
                Return True ' Username exists
            End If
            
            ' Check email
            Dim checkEmailQuery As String = "SELECT COUNT(*) FROM users WHERE email = @email"
            Connect.ClearParams()
            Connect.AddParam("@email", email)
            Connect.Query(checkEmailQuery)
            
            If Connect.DataCount > 0 AndAlso Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0)) > 0 Then
                Return True ' Email exists
            End If
            
            Return False ' Neither username nor email exists
        Catch ex As Exception
            ' Log error
            System.Diagnostics.Debug.WriteLine("Database check error: " & ex.Message)
            Return False ' Return false on error to let registration proceed
        End Try
    End Function
    
    Private Sub ShowErrorMessage(ByVal message As String)
        ErrorSummary.Visible = True
        ErrorMessage.Text = message
    End Sub
    
    Private Sub ClearErrorMessages()
        ErrorSummary.Visible = False
        ErrorMessage.Text = String.Empty
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
        ClientScript.RegisterStartupScript(Me.GetType(), "ShowAlert", script, True)
    End Sub
End Class
