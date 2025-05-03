Imports System.Net.Mail
Imports System.Net
Imports System.Web.UI
Imports System.Web.UI.WebControls

Partial Class Pages_LandingPage_Contact
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Initialize form
        End If
    End Sub

    Protected Sub submitButton_Click(ByVal sender As Object, ByVal e As EventArgs) Handles submitButton.Click
        Try
            ' Get form values
            Dim senderName As String = name.Text.Trim()
            Dim senderEmail As String = email.Text.Trim()
            Dim messageText As String = message.Text.Trim()

            ' Validate inputs
            If String.IsNullOrEmpty(senderName) OrElse String.IsNullOrEmpty(senderEmail) OrElse String.IsNullOrEmpty(messageText) Then
                ShowMessage("Please fill in all fields.", False)
                Return
            End If

            ' Create mail message
            Dim mailMessage As New MailMessage()
            mailMessage.From = New MailAddress(senderEmail, senderName)
            mailMessage.To.Add("hapagfilipinorestaurant@gmail.com")
            mailMessage.Subject = "New Contact Form Message from " & senderName
            mailMessage.Body = String.Format("Name: {0}<br/>Email: {1}<br/><br/>Message:<br/>{2}", 
                                           senderName, senderEmail, messageText)
            mailMessage.IsBodyHtml = True

            ' Configure SMTP client
            Dim smtpClient As New SmtpClient()
            smtpClient.Host = "smtp.gmail.com"
            smtpClient.Port = 587
            smtpClient.EnableSsl = True
            smtpClient.Credentials = New NetworkCredential("hapagfilipinorestaurant@gmail.com", "your-app-specific-password")

            ' Send email
            smtpClient.Send(mailMessage)

            ' Clear form and show success message
            name.Text = ""
            email.Text = ""
            message.Text = ""
            ShowMessage("Your message has been sent successfully! We'll get back to you soon.", True)

        Catch ex As Exception
            ' Log the error (you might want to implement proper error logging)
            ShowMessage("Sorry, there was an error sending your message. Please try again later.", False)
        End Try
    End Sub

    Private Sub ShowMessage(ByVal message As String, ByVal isSuccess As Boolean)
        ' Create a literal control for the message
        Dim messageLiteral As New Literal()
        messageLiteral.Text = String.Format("<script type='text/javascript'>alert('{0}');</script>", message)
        Page.Controls.Add(messageLiteral)
    End Sub
End Class
