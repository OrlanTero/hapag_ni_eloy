Imports System.Collections.Generic

Partial Class Pages_LoginPortal_ForgotPasswordOTP
    Inherits System.Web.UI.Page
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if there's an OTP in the session
            Dim email As String = OTPManager.GetOTPEmail()
            
            If String.IsNullOrEmpty(email) Then
                ' No OTP email in session, redirect back to login page
                System.Diagnostics.Debug.WriteLine("No OTP email found in session, redirecting to login page")
                Response.Redirect("CustomerLoginPortal.aspx")
                Return
            End If
            
            System.Diagnostics.Debug.WriteLine("Loading OTP verification page for email: " & email)
            
            ' Display masked email for privacy
            EmailLabel.Text = MaskEmail(email)
            
            ' Set remaining time for timer
            Dim remainingSeconds As Integer = OTPManager.GetRemainingTimeInSeconds()
            System.Diagnostics.Debug.WriteLine("Remaining OTP time: " & remainingSeconds & " seconds")
            RemainingTimeHidden.Value = remainingSeconds.ToString()
            
            ' Set remaining attempts
            AttemptsLabel.Text = OTPManager.GetRemainingAttempts().ToString()
            System.Diagnostics.Debug.WriteLine("Remaining OTP attempts: " & OTPManager.GetRemainingAttempts())
            
            ' Hide error message by default
            errorMessage.Style("display") = "none"
        End If
    End Sub
    
    Protected Sub VerifyButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles VerifyButton.Click
        Try
            ' Collect OTP from input fields
            Dim otpInput As String = OtpDigit1.Text & OtpDigit2.Text & OtpDigit3.Text & 
                                    OtpDigit4.Text & OtpDigit5.Text & OtpDigit6.Text
            
            System.Diagnostics.Debug.WriteLine("Verifying OTP: " & otpInput)
            
            ' Check if OTP is complete (6 digits)
            If otpInput.Length < 6 Then
                ShowError("Please enter all 6 digits of the verification code")
                System.Diagnostics.Debug.WriteLine("Incomplete OTP entered")
                Return
            End If
            
            ' Check if OTP is expired
            If OTPManager.IsOTPExpired() Then
                ShowError("Verification code has expired. Please request a new code")
                System.Diagnostics.Debug.WriteLine("OTP has expired")
                Return
            End If
            
            ' Verify OTP
            If OTPManager.VerifyOTP(otpInput) Then
                ' OTP verified successfully
                System.Diagnostics.Debug.WriteLine("OTP verified successfully")
                
                ' Get the user data from session
                Dim email As String = OTPManager.GetOTPEmail()
                System.Diagnostics.Debug.WriteLine("Email from OTP session: " & email)
                
                ' Reset token to verify email in the password reset process
                Dim resetToken As String = GenerateResetToken()
                System.Diagnostics.Debug.WriteLine("Generated reset token: " & resetToken)
                
                ' Store the email and token in session for the ResetPassword page
                Dim userData As New Dictionary(Of String, String)()
                userData.Add("Email", email)
                userData.Add("ResetToken", resetToken)
                OTPManager.StoreUserData(userData)
                System.Diagnostics.Debug.WriteLine("Stored user data in session for password reset")
                
                ' Clear OTP data but keep user data
                OTPManager.ClearOTPData()
                
                ' Redirect to reset password page
                System.Diagnostics.Debug.WriteLine("Redirecting to reset password page")
                Response.Redirect("ResetPassword.aspx?token=" & resetToken)
            Else
                ' Invalid OTP, update attempts
                System.Diagnostics.Debug.WriteLine("Invalid OTP entered")
                ShowError("Invalid verification code. Please try again")
                AttemptsLabel.Text = OTPManager.GetRemainingAttempts().ToString()
                
                ' If no more attempts left, show different message
                If OTPManager.GetRemainingAttempts() <= 0 Then
                    System.Diagnostics.Debug.WriteLine("No more OTP attempts remaining")
                    ShowError("Too many failed attempts. Please request a new code")
                End If
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error in OTP verification: " & ex.Message)
            ShowError("An error occurred. Please try again later.")
        End Try
    End Sub
    
    Protected Sub ResendButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ResendButton.Click
        Try
            ' Get current email from session
            Dim email As String = OTPManager.GetOTPEmail()
            
            If String.IsNullOrEmpty(email) Then
                ' No email in session, redirect back to login page
                System.Diagnostics.Debug.WriteLine("No email found when trying to resend OTP")
                Response.Redirect("CustomerLoginPortal.aspx")
                Return
            End If
            
            System.Diagnostics.Debug.WriteLine("Resending OTP to: " & email)
            
            ' Generate and send a new OTP
            If OTPManager.GenerateAndSendOTP(email) Then
                System.Diagnostics.Debug.WriteLine("New OTP sent successfully")
                
                ' Reset timer and attempts
                RemainingTimeHidden.Value = "900" ' 15 minutes in seconds
                AttemptsLabel.Text = "3"
                
                ' Clear input fields
                ClearOTPInputs()
                
                ' Hide error message
                errorMessage.Style("display") = "none"
                
                ' Show success message
                ClientScript.RegisterStartupScript(Me.GetType(), "resendSuccess", 
                    "alert('A new verification code has been sent to your email');", True)
            Else
                ' Failed to send OTP
                System.Diagnostics.Debug.WriteLine("Failed to send new OTP")
                ShowError("Failed to send verification code. Please try again later")
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error resending OTP: " & ex.Message)
            ShowError("An error occurred. Please try again later.")
        End Try
    End Sub
    
    Private Sub ShowError(ByVal message As String)
        errorMessage.InnerHtml = message
        errorMessage.Style("display") = "block"
    End Sub
    
    Private Sub ClearOTPInputs()
        OtpDigit1.Text = ""
        OtpDigit2.Text = ""
        OtpDigit3.Text = ""
        OtpDigit4.Text = ""
        OtpDigit5.Text = ""
        OtpDigit6.Text = ""
    End Sub
    
    Private Function MaskEmail(ByVal email As String) As String
        Try
            Dim atIndex As Integer = email.IndexOf("@")
            If atIndex <= 1 Then
                Return email ' Can't mask effectively
            End If
            
            Dim name As String = email.Substring(0, atIndex)
            Dim domain As String = email.Substring(atIndex)
            
            ' Show first character, mask the rest with asterisks
            Dim maskedName As String = name.Substring(0, 1) & "".PadLeft(name.Length - 1, "*"c)
            
            Return maskedName & domain
        Catch ex As Exception
            ' In case of any error, return the original email
            Return email
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
End Class 