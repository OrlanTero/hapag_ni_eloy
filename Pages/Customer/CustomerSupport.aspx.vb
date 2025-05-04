Imports System.Data
Imports HapagDB
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls

Partial Class Pages_Customer_CustomerSupport
    Inherits System.Web.UI.Page
    Private supportTicketController As SupportTicketController
    Private supportMessageController As SupportMessageController
    Private Connect As Connection

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Initialize controllers
        If supportTicketController Is Nothing Then
            supportTicketController = New SupportTicketController()
        End If
        
        If supportMessageController Is Nothing Then
            supportMessageController = New SupportMessageController()
        End If
        
        If Connect Is Nothing Then
            Connect = New Connection()
        End If

        If Not IsPostBack Then
            ' Check if user is logged in
            If Session("CURRENT_SESSION") Is Nothing Then
                Response.Redirect("~/Pages/LoginPortal/CustomerLoginPortal.aspx")
                Return
            End If

            ' Check if customer 
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
       
            
            ' Convert user_type (string) to integer for comparison
            Dim userTypeValue As Integer = -1
            Try
                ' Always treat it as a string and try to parse it to integer
                If Integer.TryParse(currentUser.user_type, userTypeValue) Then
                    ' Successfully parsed to integer
                    If userTypeValue <> 0 Then ' 0 is customer type
                        ShowAlert("This page is only accessible to customers. Your user type is: " & userTypeValue, False)
                        Response.Redirect("~/Pages/Customer/CustomerDashboard.aspx")
                        Return
                    End If
                Else
                    ' Could not parse to integer - probably some unexpected format
                    ShowAlert("Invalid user type format: " & currentUser.user_type, False)
                    Response.Redirect("~/Pages/Customer/CustomerDashboard.aspx")
                    Return
                End If
            Catch ex As Exception
              
            End Try

            LoadTickets()
            
            ' Check if a specific ticket is requested
            If Not String.IsNullOrEmpty(Request.QueryString("id")) Then
                Dim ticketId As Integer
                If Integer.TryParse(Request.QueryString("id"), ticketId) Then
                    LoadTicketDetails(ticketId)
                End If
            End If
        End If
    End Sub
    
    Private Sub LoadTickets()
        Try
            ' Get the current logged in user
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            If supportTicketController Is Nothing Then
                supportTicketController = New SupportTicketController()
                ShowAlert("Support ticket controller was null. Created a new instance.", False)
            End If
            
            ' Get tickets for this user
            Dim tickets As List(Of SupportTicket) = supportTicketController.GetTicketsByUserId(currentUser.user_id)
            
            If tickets Is Nothing Then
                tickets = New List(Of SupportTicket)()
                ShowAlert("No tickets were found or an error occurred.", False)
            End If
            
            ' Bind tickets to repeater
            If TicketRepeater IsNot Nothing Then
                TicketRepeater.DataSource = tickets
                TicketRepeater.DataBind()
            End If
            
            ' Show empty state if no tickets
            If NoTicketsPanel IsNot Nothing Then
                NoTicketsPanel.Visible = (tickets.Count = 0)
            End If
        Catch ex As Exception
            ShowAlert("Error loading tickets: " & ex.Message, False)
        End Try
    End Sub
    
    Protected Sub TicketRepeater_ItemCommand(source As Object, e As RepeaterCommandEventArgs)
        If e.CommandName = "SelectTicket" Then
            Dim ticketId As Integer = Convert.ToInt32(e.CommandArgument)
            Response.Redirect("~/Pages/Customer/CustomerSupport.aspx?id=" & ticketId)
        End If
    End Sub
    
    Protected Sub NewTicketBtn_Click(sender As Object, e As EventArgs)
        ' Show the new ticket form
        If TicketListPanel IsNot Nothing Then
            TicketListPanel.Visible = False
        End If
        
        If NewTicketPanel IsNot Nothing Then
            NewTicketPanel.Visible = True
        End If
        
        If EmptyDetailsPanel IsNot Nothing Then
            EmptyDetailsPanel.Visible = True
        End If
        
        If TicketDetailsPanel IsNot Nothing Then
            TicketDetailsPanel.Visible = False
        End If
    End Sub
    
    Protected Sub CancelBtn_Click(sender As Object, e As EventArgs)
        ' Go back to ticket list
        If TicketListPanel IsNot Nothing Then
            TicketListPanel.Visible = True
        End If
        
        If NewTicketPanel IsNot Nothing Then
            NewTicketPanel.Visible = False
        End If
        
        If EmptyDetailsPanel IsNot Nothing Then
            EmptyDetailsPanel.Visible = True
        End If
        
        If TicketDetailsPanel IsNot Nothing Then
            TicketDetailsPanel.Visible = False
        End If
    End Sub
    
    Protected Sub SubmitTicketBtn_Click(sender As Object, e As EventArgs)
        If Not IsValid Then
            Return
        End If
        
        Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
        
        Try
            ' Create new ticket
            Dim ticket As New SupportTicket()
            ticket.user_id = currentUser.user_id
            
            If SubjectTxt IsNot Nothing Then
                ticket.subject = SubjectTxt.Text.Trim()
            Else
                ticket.subject = "Support Request"
            End If
            
            ticket.status = "Open"
            
            If PriorityDdl IsNot Nothing Then
                ticket.priority = PriorityDdl.SelectedValue
            Else
                ticket.priority = "Medium"
            End If
            
            ' Save ticket
            If supportTicketController.CreateTicket(ticket) Then
                ' Create first message
                Dim message As New SupportMessage()
                message.ticket_id = ticket.ticket_id
                message.sender_id = currentUser.user_id
                
                If MessageTxt IsNot Nothing Then
                    message.message_text = MessageTxt.Text.Trim()
                Else
                    message.message_text = "Support request submitted."
                End If
                
                If supportMessageController.CreateMessage(message) Then
                    ShowAlert("Your support ticket has been created successfully.", True)
                    
                    ' Go back to ticket list and load the new ticket
                    If TicketListPanel IsNot Nothing Then
                        TicketListPanel.Visible = True
                    End If
                    
                    If NewTicketPanel IsNot Nothing Then
                        NewTicketPanel.Visible = False
                    End If
                    
                    LoadTickets()
                    LoadTicketDetails(ticket.ticket_id)
                Else
                    ShowAlert("Your ticket was created, but there was an issue adding your message.", False)
                End If
            Else
                ShowAlert("Failed to create support ticket. Please try again.", False)
            End If
        Catch ex As Exception
            ShowAlert("Error creating ticket: " & ex.Message, False)
        End Try
    End Sub
    
    Private Sub LoadTicketDetails(ticketId As Integer)
        Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
        
        ' Load ticket details
        Dim ticket As SupportTicket = supportTicketController.GetTicketById(ticketId)
        
        ' Verify ticket belongs to this user
        If ticket IsNot Nothing AndAlso ticket.user_id = currentUser.user_id Then
            ' Show ticket details panel
            If EmptyDetailsPanel IsNot Nothing Then
                EmptyDetailsPanel.Visible = False
            End If
            
            If TicketDetailsPanel IsNot Nothing Then
                TicketDetailsPanel.Visible = True
            End If
            
            ' Set ticket info
            If TicketSubjectLiteral IsNot Nothing Then
                TicketSubjectLiteral.Text = ticket.subject
            End If
            
            If TicketStatusLiteral IsNot Nothing Then
                TicketStatusLiteral.Text = FormatStatus(ticket.status)
            End If
            
            If TicketDateLiteral IsNot Nothing Then
                TicketDateLiteral.Text = ticket.created_at.ToString("MMM d, yyyy h:mm tt")
            End If
            
            If TicketAssignedLiteral IsNot Nothing Then
                If ticket.assigned_staff_id.HasValue AndAlso Not String.IsNullOrEmpty(ticket.staff_name) Then
                    TicketAssignedLiteral.Text = " | Assigned to: " & ticket.staff_name
                Else
                    TicketAssignedLiteral.Text = ""
                End If
            End If
            
            ' Get messages for this ticket
            Dim messages As List(Of SupportMessage) = supportMessageController.GetMessagesByTicketId(ticketId)
            
            ' Bind messages to repeater
            If MessageRepeater IsNot Nothing Then
                MessageRepeater.DataSource = messages
                MessageRepeater.DataBind()
            End If
            
            ' Mark messages as read
            supportMessageController.MarkMessagesAsRead(ticketId, currentUser.user_id)
        Else
            ' Ticket not found or doesn't belong to this user
            ShowAlert("The requested ticket was not found or you do not have permission to view it.", False)
            Response.Redirect("~/Pages/Customer/CustomerSupport.aspx")
        End If
    End Sub
    
    Protected Sub SendBtn_Click(sender As Object, e As EventArgs)
        Try
            ' Check if message text control exists
            If ReplyMessageTxt Is Nothing OrElse String.IsNullOrEmpty(ReplyMessageTxt.Text.Trim()) Then
                Return
            End If
            
            ' Check if ticket ID is in query string
            If String.IsNullOrEmpty(Request.QueryString("id")) Then
                ShowAlert("Please select a ticket first.", False)
                Return
            End If
            
            ' Try to parse ticket ID
            Dim ticketId As Integer
            If Not Integer.TryParse(Request.QueryString("id"), ticketId) Then
                ShowAlert("Invalid ticket selection.", False)
                Return
            End If
            
            ' Get current user
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            If currentUser Is Nothing Then
                Response.Redirect("~/Pages/LoginPortal/CustomerLoginPortal.aspx")
                Return
            End If
            
            ' Create new message
            Dim message As New SupportMessage()
            message.ticket_id = ticketId
            message.sender_id = currentUser.user_id
            message.message_text = ReplyMessageTxt.Text.Trim()
            
            ' Try a direct insert first
            Connect.ClearParams()
            Connect.AddParam("@ticket_id", message.ticket_id)
            Connect.AddParam("@sender_id", message.sender_id)
            Connect.AddParam("@message_text", message.message_text)
            Connect.AddParamWithNull("@attachment_url", Nothing)
            
            Dim directInsertQuery As String = "INSERT INTO support_messages (ticket_id, sender_id, message_text, attachment_url, is_read, created_at) " & _
                                           "VALUES (@ticket_id, @sender_id, @message_text, @attachment_url, 0, GETDATE()); " & _
                                           "UPDATE support_tickets SET last_updated = GETDATE() WHERE ticket_id = @ticket_id"
            
            Dim directInsertSuccess As Boolean = Connect.Query(directInsertQuery)
            
            If directInsertSuccess Then
                ' Clear message box
                ReplyMessageTxt.Text = String.Empty
                ' Reload ticket details
                LoadTicketDetails(ticketId)
                Return
            End If
            
            ' If direct insert failed, try the controller method
            If supportMessageController.CreateMessage(message) Then
                ' Update ticket status if closed
                Dim ticket = supportTicketController.GetTicketById(ticketId)
                If ticket IsNot Nothing AndAlso ticket.status = "Closed" Then
                    ticket.status = "In Progress"
                    supportTicketController.UpdateTicket(ticket)
                End If
                
                ' Clear message box
                ReplyMessageTxt.Text = String.Empty
                
                ' Reload ticket details to refresh messages
                LoadTicketDetails(ticketId)
            Else
                ShowAlert("Failed to send message. Please try again.", False)
            End If
        Catch ex As Exception
            ShowAlert("Error: " & ex.Message, False)
        End Try
    End Sub
    
    ' Helper method to format status for display
    Private Function FormatStatus(status As String) As String
        Select Case status.ToLower()
            Case "open"
                Return "<span class='status open'>Open</span>"
            Case "in progress"
                Return "<span class='status in-progress'>In Progress</span>"
            Case "closed"
                Return "<span class='status closed'>Closed</span>"
            Case Else
                Return status
        End Select
    End Function
    
    ' Helper method to format date for display
    Protected Function FormatDate(dateValue As Object) As String
        If dateValue Is Nothing OrElse IsDBNull(dateValue) Then
            Return String.Empty
        End If
        
        Dim dateTime As DateTime = Convert.ToDateTime(dateValue)
        
        ' If today, show time only
        If dateTime.Date = DateTime.Today Then
            Return dateTime.ToString("h:mm tt")
        ' If this year, show month and day
        ElseIf dateTime.Year = DateTime.Today.Year Then
            Return dateTime.ToString("MMM d")
        ' Otherwise show full date
        Else
            Return dateTime.ToString("MMM d, yyyy")
        End If
    End Function
    
    ' Helper method to format date for message
    Protected Function FormatMessageDate(dateValue As Object) As String
        If dateValue Is Nothing OrElse IsDBNull(dateValue) Then
            Return String.Empty
        End If
        
        Dim dateTime As DateTime = Convert.ToDateTime(dateValue)
        
        ' If today, show time only
        If dateTime.Date = DateTime.Today Then
            Return dateTime.ToString("h:mm tt")
        ' If this year, show month, day and time
        ElseIf dateTime.Year = DateTime.Today.Year Then
            Return dateTime.ToString("MMM d, h:mm tt")
        ' Otherwise show full date and time
        Else
            Return dateTime.ToString("MMM d, yyyy h:mm tt")
        End If
    End Function
    
    ' Helper method to get CSS class for status
    Protected Function GetStatusClass(status As String) As String
        Select Case status.ToLower()
            Case "open"
                Return "open"
            Case "in progress"
                Return "in-progress"
            Case "closed"
                Return "closed"
            Case Else
                Return String.Empty
        End Select
    End Function
    
    Private Sub ShowAlert(ByVal message As String, ByVal isSuccess As Boolean)
        If alertMessage IsNot Nothing Then
            alertMessage.Visible = True
            If isSuccess Then
                alertMessage.Attributes("class") = "alert-message alert-success"
            Else
                alertMessage.Attributes("class") = "alert-message alert-danger"
            End If
            
            If AlertLiteral IsNot Nothing Then
                AlertLiteral.Text = message
            End If
        End If
    End Sub
End Class 