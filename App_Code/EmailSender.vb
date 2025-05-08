Imports System.Net
Imports System.Net.Mail
Imports System.Text

''' <summary>
''' Utility class for sending emails using Gmail SMTP server
''' </summary>
Public Class EmailSender
    ' Gmail SMTP settings
    Private Const SmtpServer As String = "smtp.gmail.com"
    Private Const SmtpPort As Integer = 587
    Private Const SmtpUsername As String = "hapagfilipinorestaurant@gmail.com"
    Private Const SmtpPassword As String = "ettzojlnfraoakup" ' App password
    Private Const SenderName As String = "Hapag Filipino Restaurant"
    
    ''' <summary>
    ''' Sends an email using Gmail SMTP server
    ''' </summary>
    ''' <param name="toEmail">Recipient email address</param>
    ''' <param name="subject">Email subject</param>
    ''' <param name="body">Email body (HTML supported)</param>
    ''' <returns>Boolean indicating success or failure</returns>
    Public Shared Function SendEmail(ByVal toEmail As String, ByVal subject As String, ByVal body As String) As Boolean
        Try
            ' Create mail message
            Dim mail As New MailMessage()
            mail.From = New MailAddress(SmtpUsername, SenderName)
            mail.To.Add(toEmail)
            mail.Subject = subject
            mail.Body = body
            mail.IsBodyHtml = True
            
            ' Create SMTP client
            Dim smtp As New SmtpClient(SmtpServer)
            smtp.Port = SmtpPort
            smtp.EnableSsl = True
            smtp.DeliveryMethod = SmtpDeliveryMethod.Network
            smtp.UseDefaultCredentials = False
            smtp.Credentials = New NetworkCredential(SmtpUsername, SmtpPassword)
            
            ' Send email
            smtp.Send(mail)
            Return True
        Catch ex As Exception
            ' Log error
            System.Diagnostics.Debug.WriteLine("Email sending error: " & ex.Message)
            Return False
        End Try
    End Function
    
    ''' <summary>
    ''' Generates a random 6-character OTP
    ''' </summary>
    ''' <returns>6-character OTP string</returns>
    Public Shared Function GenerateOTP() As String
        Dim random As New Random()
        Dim otp As New StringBuilder()
        
        ' Generate 6 random digits
        For i As Integer = 0 To 5
            otp.Append(random.Next(0, 10))
        Next
        
        Return otp.ToString()
    End Function
    
    ''' <summary>
    ''' Sends OTP verification email
    ''' </summary>
    ''' <param name="toEmail">Recipient email address</param>
    ''' <param name="otp">The OTP code to send</param>
    ''' <returns>Boolean indicating success or failure</returns>
    Public Shared Function SendOTPEmail(ByVal toEmail As String, ByVal otp As String) As Boolean
        ' Check if this is for password reset or registration
        ' If UserData exists and contains registration info, it's for registration
        ' Otherwise, it's for password reset
        Dim userData As Dictionary(Of String, String) = OTPManager.GetUserData()
        Dim isPasswordReset As Boolean = (userData Is Nothing OrElse Not userData.ContainsKey("Username"))
        
        System.Diagnostics.Debug.WriteLine("Sending OTP email for: " & If(isPasswordReset, "Password Reset", "Registration"))
        
        Dim subject As String
        Dim emailTemplate As String
        
        If isPasswordReset Then
            subject = "Password Reset Verification - Hapag Filipino Restaurant"
            emailTemplate = GetPasswordResetOTPEmailTemplate(otp)
        Else
            subject = "Verify Your Email - Hapag Filipino Restaurant"
            emailTemplate = GetRegistrationOTPEmailTemplate(otp)
        End If
        
        Return SendEmail(toEmail, subject, emailTemplate)
    End Function
    
    ''' <summary>
    ''' Gets the email template for registration OTP verification
    ''' </summary>
    ''' <param name="otp">The OTP code to include in the email</param>
    ''' <returns>HTML email template</returns>
    Private Shared Function GetRegistrationOTPEmailTemplate(ByVal otp As String) As String
        Return "<html><body style='font-family: Arial, sans-serif; line-height: 1.6;'>" & _
            "<div style='max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px;'>" & _
            "<div style='text-align: center; margin-bottom: 20px;'>" & _
            "<h2 style='color: #4a4a4a;'>Email Verification</h2>" & _
            "</div>" & _
            "<p>Dear Customer,</p>" & _
            "<p>Thank you for registering with Hapag Filipino Restaurant. Please use the following One-Time Password (OTP) to complete your registration:</p>" & _
            "<div style='background-color: #f7f7f7; padding: 15px; text-align: center; margin: 20px 0;'>" & _
            "<h1 style='font-size: 30px; letter-spacing: 5px; margin: 0; color: #333;'>" & otp & "</h1>" & _
            "</div>" & _
            "<p>This code will expire in 15 minutes. If you didn't request this code, please ignore this email.</p>" & _
            "<p>Best Regards,<br/>Hapag Filipino Restaurant Team</p>" & _
            "</div></body></html>"
    End Function
    
    ''' <summary>
    ''' Gets the email template for password reset OTP verification
    ''' </summary>
    ''' <param name="otp">The OTP code to include in the email</param>
    ''' <returns>HTML email template</returns>
    Private Shared Function GetPasswordResetOTPEmailTemplate(ByVal otp As String) As String
        Return "<html><body style='font-family: Arial, sans-serif; line-height: 1.6;'>" & _
            "<div style='max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px;'>" & _
            "<div style='text-align: center; margin-bottom: 20px;'>" & _
            "<h2 style='color: #4a4a4a;'>Password Reset Verification</h2>" & _
            "</div>" & _
            "<p>Dear Customer,</p>" & _
            "<p>We received a request to reset your password for your Hapag Filipino Restaurant account. Please use the following One-Time Password (OTP) to verify your identity:</p>" & _
            "<div style='background-color: #f7f7f7; padding: 15px; text-align: center; margin: 20px 0;'>" & _
            "<h1 style='font-size: 30px; letter-spacing: 5px; margin: 0; color: #333;'>" & otp & "</h1>" & _
            "</div>" & _
            "<p>This code will expire in 15 minutes. If you didn't request this password reset, please ignore this email and ensure your account is secure.</p>" & _
            "<p>Best Regards,<br/>Hapag Filipino Restaurant Team</p>" & _
            "</div></body></html>"
    End Function
End Class 