Imports System.Collections.Generic

Partial Class Pages_OTPVerification
    Inherits System.Web.UI.Page

    Protected Sub Page_PreInit(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreInit
        ' Skip master page for verification page to avoid login redirects
        System.Diagnostics.Debug.WriteLine("OTP Verification page PreInit - Setting up page options")
        
        ' Store authentication bypass flag in session
        Session("SkipLoginRedirect") = "true"
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Set the skip login redirect flag to prevent automatic redirections
            Session("SkipLoginRedirect") = "true"
            
            System.Diagnostics.Debug.WriteLine("OTP Verification page load")
            
            ' Check if there's an OTP session
            Dim email As String = OTPManager.GetOTPEmail()
            System.Diagnostics.Debug.WriteLine("OTP Email from session: " & If(String.IsNullOrEmpty(email), "Not found", email))
            
            If String.IsNullOrEmpty(email) Then
                ' No active OTP session, redirect back to sign up page
                System.Diagnostics.Debug.WriteLine("No OTP email found, redirecting to registration page")
                Session("SkipLoginRedirect") = Nothing ' Clear the flag before redirect
                Response.Redirect("~/Pages/LoginPortal/RegisterPortal.aspx", True)
                Return
            End If
            
            ' Display masked email
            EmailLiteral.Text = MaskEmail(email)
            
            ' Set the remaining seconds in the hidden field
            RemainingSecondsField.Value = OTPManager.GetRemainingTimeInSeconds().ToString()
            System.Diagnostics.Debug.WriteLine("OTP Remaining seconds: " & RemainingSecondsField.Value)
            
            ' Check if OTP is expired
            If OTPManager.IsOTPExpired() Then
                System.Diagnostics.Debug.WriteLine("OTP is expired")
                ShowError("Your verification code has expired. Please request a new one.")
                ResendButton.Enabled = True
            End If
        End If
    End Sub
    
    Protected Sub VerifyButton_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Try
            ' Collect OTP from input fields
            Dim enteredOTP As String = Digit1.Text + Digit2.Text + Digit3.Text + Digit4.Text + Digit5.Text + Digit6.Text
            
            ' Validate OTP
            If String.IsNullOrEmpty(enteredOTP) OrElse enteredOTP.Length < 6 Then
                ShowError("Please enter the complete 6-digit verification code.")
                Return
            End If
            
            If OTPManager.IsOTPExpired() Then
                ShowError("Your verification code has expired. Please request a new one.")
                Return
            End If
            
            ' Verify OTP
            If OTPManager.VerifyOTP(enteredOTP) Then
                ' OTP is valid, complete the registration process
                Dim userData As Dictionary(Of String, String) = OTPManager.GetUserData()
                
                If userData Is Nothing Then
                    ShowError("Registration data not found. Please try signing up again.")
                    Return
                End If
                
                ' Show success message
                ShowSuccess("Email verified successfully! Completing your registration...")
                
                ' Clear OTP data but keep user data
                OTPManager.ClearOTPData()
                
                ' Set skip login redirect for the registration complete page
                Session("SkipLoginRedirect") = "true"
                
                ' Redirect to complete registration after a short delay
                ClientScript.RegisterStartupScript(Me.GetType(), "RedirectAfterSuccess", 
                    "setTimeout(function() { window.location.href = 'RegistrationComplete.aspx'; }, 2000);", True)
            Else
                ' Invalid OTP
                Dim remainingAttempts As Integer = OTPManager.GetRemainingAttempts()
                If remainingAttempts > 0 Then
                    ShowError(String.Format("Invalid verification code. You have {0} attempts remaining.", remainingAttempts))
                Else
                    ShowError("Too many failed attempts. Please request a new verification code.")
                    ClearOTPInputs()
                End If
            End If
            
        Catch ex As Exception
            ' Log exception
            System.Diagnostics.Debug.WriteLine("OTP verification error: " & ex.Message)
            ShowError("An error occurred during verification. Please try again.")
        End Try
    End Sub
    
    Protected Sub ResendButton_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Try
            ' Get the email from session
            Dim email As String = OTPManager.GetOTPEmail()
            
            If String.IsNullOrEmpty(email) Then
                ' No email in session, redirect back to signup page
                Response.Redirect("~/Pages/LoginPortal/RegisterPortal.aspx", True)
                Return
            End If
            
            ' Generate and send new OTP
            If OTPManager.GenerateAndSendOTP(email) Then
                ShowSuccess("A new verification code has been sent to your email.")
                
                ' Reset inputs
                ClearOTPInputs()
                
                ' Update the remaining seconds in the hidden field
                RemainingSecondsField.Value = OTPManager.GetRemainingTimeInSeconds().ToString()
                
                ' Refresh page to update timer
                ClientScript.RegisterStartupScript(Me.GetType(), "RefreshAfterResend", 
                    "setTimeout(function() { window.location.reload(); }, 1500);", True)
            Else
                ShowError("Failed to send verification code. Please try again later.")
            End If
            
        Catch ex As Exception
            ' Log exception
            System.Diagnostics.Debug.WriteLine("Resend OTP error: " & ex.Message)
            ShowError("An error occurred. Please try again.")
        End Try
    End Sub
    
    Private Sub ShowError(ByVal message As String)
        ErrorPanel.Visible = True
        ErrorMessage.Text = message
        SuccessPanel.Visible = False
    End Sub
    
    Private Sub ShowSuccess(ByVal message As String)
        SuccessPanel.Visible = True
        SuccessMessage.Text = message
        ErrorPanel.Visible = False
    End Sub
    
    Private Sub ClearOTPInputs()
        Digit1.Text = String.Empty
        Digit2.Text = String.Empty
        Digit3.Text = String.Empty
        Digit4.Text = String.Empty
        Digit5.Text = String.Empty
        Digit6.Text = String.Empty
    End Sub
    
    ' Helper function to mask email for privacy
    Private Function MaskEmail(ByVal email As String) As String
        Try
            If String.IsNullOrEmpty(email) Then
                Return String.Empty
            End If
            
            Dim parts As String() = email.Split("@"c)
            If parts.Length < 2 Then
                Return email ' Invalid email format
            End If
            
            Dim username As String = parts(0)
            Dim domain As String = parts(1)
            
            ' Show first 2 characters and last character of username, mask the rest
            Dim maskedUsername As String
            If username.Length <= 3 Then
                maskedUsername = username.Substring(0, 1) & "***"
            Else
                maskedUsername = username.Substring(0, 2) & "***" & username.Substring(username.Length - 1)
            End If
            
            Return maskedUsername & "@" & domain
        Catch ex As Exception
            Return email ' Return original email if masking fails
        End Try
    End Function
End Class 