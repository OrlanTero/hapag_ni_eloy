Imports System.Data
Imports HapagDB
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls

Partial Class Pages_Admin_CustomerSupport
    Inherits AdminBasePage
    Private supportTicketController As New SupportTicketController()
    Private supportMessageController As New SupportMessageController()
    Private Connect As New Connection()

    ' ASP.NET Web Forms automatically declares controls with runat="server" as Protected WithEvents fields
    ' So we don't need to declare them explicitly again

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in
            If Session("CURRENT_SESSION") Is Nothing Then
                Response.Redirect("~/Pages/LoginPortal/AdminStaffLoginPortal.aspx")
            End If

            ' Verify user has staff or admin role
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            If currentUser.role.ToLower() <> "staff" AndAlso currentUser.role.ToLower() <> "admin" Then
                System.Diagnostics.Debug.WriteLine("CustomerSupport: Access denied for user")
                ShowAlert("This page is only accessible to staff and admin members.", False)
                Response.Redirect("~/Pages/Admin/AdminDashboard.aspx")
            Else
                System.Diagnostics.Debug.WriteLine("CustomerSupport: Access granted to " & currentUser.role)
                LoadTickets()
                
                ' Check if a specific ticket is requested
                If Not String.IsNullOrEmpty(Request.QueryString("id")) Then
                    Dim ticketId As Integer
                    If Integer.TryParse(Request.QueryString("id"), ticketId) Then
                        LoadTicketDetails(ticketId)
                    End If
                End If
            End If
        End If
    End Sub
    
    Private Sub LoadTickets()
        ' Get the current logged in user
        Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
        Dim tickets As List(Of SupportTicket)
        
        ' Get tickets based on filter
        Dim statusFilter As String = ""

        ' Check if StatusFilter control exists and get its value
        Try
            Dim statusFilterControl As DropDownList = TryCast(FindControl("StatusFilter"), DropDownList)
            If statusFilterControl IsNot Nothing Then
                statusFilter = statusFilterControl.SelectedValue
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error accessing StatusFilter: " & ex.Message)
        End Try
        
        Dim searchText As String = ""
        If SearchBox IsNot Nothing Then
            searchText = SearchBox.Text.Trim()
        End If
        
        ' Get all open tickets 
        tickets = supportTicketController.GetAllOpenTickets()
        
        ' Apply status filter if selected
        If Not String.IsNullOrEmpty(statusFilter) Then
            Dim filteredTickets As New List(Of SupportTicket)
            For Each t As SupportTicket In tickets
                If t.status = statusFilter Then
                    filteredTickets.Add(t)
                End If
            Next
            tickets = filteredTickets
        End If
        
        ' Apply search filter if provided
        If Not String.IsNullOrEmpty(searchText) Then
            Dim searchedTickets As New List(Of SupportTicket)
            For Each t As SupportTicket In tickets
                If t.subject.IndexOf(searchText, StringComparison.OrdinalIgnoreCase) >= 0 OrElse _
                   t.user_name.IndexOf(searchText, StringComparison.OrdinalIgnoreCase) >= 0 Then
                    searchedTickets.Add(t)
                End If
            Next
            tickets = searchedTickets
        End If
        
        ' Bind tickets to repeater
        If TicketRepeater IsNot Nothing Then
            TicketRepeater.DataSource = tickets
            TicketRepeater.DataBind()
        End If
        
        ' Show message if no tickets
        If tickets.Count = 0 AndAlso ticketItems IsNot Nothing Then
            Dim noTicketsDiv As New HtmlGenericControl("div")
            noTicketsDiv.Attributes.Add("class", "empty-state")
            noTicketsDiv.InnerHtml = "<i class='fas fa-ticket-alt fa-3x'></i>" & _
                                    "<h3>No Tickets Found</h3>" & _
                                    "<p>There are no support tickets matching your criteria.</p>"
            ticketItems.Controls.Add(noTicketsDiv)
        End If
    End Sub
    
    Protected Sub TicketRepeater_ItemCommand(source As Object, e As RepeaterCommandEventArgs)
        If e.CommandName = "SelectTicket" Then
            Dim ticketId As Integer = Convert.ToInt32(e.CommandArgument)
            Response.Redirect("~/Pages/Admin/CustomerSupport.aspx?id=" & ticketId)
        End If
    End Sub
    
    Protected Sub SearchBox_TextChanged(sender As Object, e As EventArgs)
        LoadTickets()
    End Sub
    
    Protected Sub StatusFilter_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadTickets()
    End Sub
    
    Private Sub LoadTicketDetails(ticketId As Integer)
        ' Load ticket details
        Dim ticket As SupportTicket = supportTicketController.GetTicketById(ticketId)
        
        If ticket IsNot Nothing Then
            ' Show chat panel
            If EmptyChatPanel IsNot Nothing Then
                EmptyChatPanel.Visible = False
            End If
            
            If ChatPanel IsNot Nothing Then
                ChatPanel.Visible = True
            End If
            
            ' Set ticket info
            If TicketSubjectLiteral IsNot Nothing Then
                TicketSubjectLiteral.Text = ticket.subject
            End If
            
            If CustomerNameLiteral IsNot Nothing Then
                CustomerNameLiteral.Text = ticket.user_name
            End If
            
            If TicketStatusLiteral IsNot Nothing Then
                TicketStatusLiteral.Text = FormatStatus(ticket.status)
            End If
            
            If TicketPriorityLiteral IsNot Nothing Then
                TicketPriorityLiteral.Text = FormatPriority(ticket.priority)
            End If
            
            ' Set dropdown selections
            If StatusDropDown IsNot Nothing Then
                StatusDropDown.SelectedValue = ticket.status
            End If
            
            If PriorityDropDown IsNot Nothing Then
                PriorityDropDown.SelectedValue = ticket.priority
            End If
            
            ' Get current user
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            ' Assign ticket to current staff if not assigned
            If Not ticket.assigned_staff_id.HasValue Then
                supportTicketController.AssignTicket(ticketId, currentUser.user_id)
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
            ' Ticket not found
            ShowAlert("The requested ticket was not found.", False)
            Response.Redirect("~/Pages/Admin/CustomerSupport.aspx")
        End If
    End Sub
    
    Protected Sub SendMessageBtn_Click(sender As Object, e As EventArgs)
        If MessageTextBox Is Nothing OrElse String.IsNullOrEmpty(MessageTextBox.Text.Trim()) Then
            ' Don't send empty messages
            Return
        End If
        
        Try
            ' Check if ticket ID is valid
            If String.IsNullOrEmpty(Request.QueryString("id")) Then
                Return
            End If
            
            Dim ticketId As Integer
            If Not Integer.TryParse(Request.QueryString("id"), ticketId) Then
                Return
            End If
            
            ' Check if user is logged in
            If Session("CURRENT_SESSION") Is Nothing Then
                Response.Redirect("~/Pages/LoginPortal/AdminStaffLoginPortal.aspx")
                Return
            End If
            
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            ' Create new message
            Dim message As New SupportMessage()
            message.ticket_id = ticketId
            message.sender_id = currentUser.user_id
            message.message_text = MessageTextBox.Text.Trim()
            
            ' Try direct insert first to bypass controller
            Dim directInsertSuccess As Boolean = False
            Try
                Connect.ClearParams()
                Connect.AddParam("@ticket_id", message.ticket_id)
                Connect.AddParam("@sender_id", message.sender_id)
                Connect.AddParam("@message_text", message.message_text)
                Connect.AddParamWithNull("@attachment_url", Nothing)
                
                Dim query As String = "INSERT INTO support_messages (ticket_id, sender_id, message_text, attachment_url, is_read, created_at) " & _
                                    "VALUES (@ticket_id, @sender_id, @message_text, @attachment_url, 0, GETDATE()); " & _
                                    "SELECT SCOPE_IDENTITY(); " & _
                                    "UPDATE support_tickets SET last_updated = GETDATE() WHERE ticket_id = @ticket_id"
                                    
                Connect.Query(query)
                
                ' Get the newly created message ID
                If Connect.DataCount > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                    message.message_id = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0))
                    directInsertSuccess = True
                End If
            Catch ex As Exception
                directInsertSuccess = False
            End Try
            
            ' If direct insert failed, try through controller
            If Not directInsertSuccess Then
                ' Save message using controller
                Dim controllerSuccess As Boolean = supportMessageController.CreateMessage(message)
                
                If controllerSuccess Then
                    ' Clear message box
                    MessageTextBox.Text = String.Empty
                    
                    ' Reload ticket details to refresh messages
                    LoadTicketDetails(ticketId)
                Else
                    ShowAlert("Failed to send message. Please try again.", False)
                End If
            Else
                ' Direct insert worked
                MessageTextBox.Text = String.Empty
                LoadTicketDetails(ticketId)
            End If
            
        Catch ex As Exception
            ShowAlert("Error sending message: " & ex.Message, False)
        End Try
    End Sub
    
    Protected Sub UpdateTicketBtn_Click(sender As Object, e As EventArgs)
        Try
            Dim ticketId As Integer = Convert.ToInt32(Request.QueryString("id"))
            Dim ticket As SupportTicket = supportTicketController.GetTicketById(ticketId)
            
            If ticket IsNot Nothing Then
                ' Update ticket properties
                If StatusDropDown IsNot Nothing Then
                    ticket.status = StatusDropDown.SelectedValue
                End If
                
                If PriorityDropDown IsNot Nothing Then
                    ticket.priority = PriorityDropDown.SelectedValue
                End If
                
                ' Save changes
                If supportTicketController.UpdateTicket(ticket) Then
                    ShowAlert("Ticket updated successfully.", True)
                    
                    ' Add a system message about status change if it changed
                    If TicketStatusLiteral IsNot Nothing Then
                        Dim statusText As String = TicketStatusLiteral.Text.Replace("<span class='status open'>", "").Replace("<span class='status in-progress'>", "").Replace("<span class='status closed'>", "").Replace("</span>", "")
                        
                        If ticket.status <> statusText Then
                            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
                            Dim systemMessage As New SupportMessage()
                            systemMessage.ticket_id = ticketId
                            systemMessage.sender_id = currentUser.user_id
                            systemMessage.message_text = "Status updated to '" & ticket.status & "'"
                            supportMessageController.CreateMessage(systemMessage)
                        End If
                    End If
                    
                    ' Reload ticket details
                    LoadTicketDetails(ticketId)
                Else
                    ShowAlert("Failed to update ticket.", False)
                End If
            Else
                ShowAlert("Ticket not found.", False)
            End If
        Catch ex As Exception
            ShowAlert("Error updating ticket: " & ex.Message, False)
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
    
    ' Helper method to format priority for display
    Private Function FormatPriority(priority As String) As String
        Select Case priority.ToLower()
            Case "high"
                Return "<span class='priority high'>High</span>"
            Case "medium"
                Return "<span class='priority medium'>Medium</span>"
            Case "low"
                Return "<span class='priority low'>Low</span>"
            Case Else
                Return priority
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
    
    ' Helper method to get CSS class for priority
    Protected Function GetPriorityClass(priority As String) As String
        Select Case priority.ToLower()
            Case "high"
                Return "high"
            Case "medium"
                Return "medium"
            Case "low"
                Return "low"
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