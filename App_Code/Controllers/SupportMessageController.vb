Imports System.Data
Imports Microsoft.VisualBasic

Namespace HapagDB
    Public Class SupportMessageController
        Private Connect As New Connection()
        
        ' Create a new message
        Public Function CreateMessage(message As SupportMessage) As Boolean
            Try
                Connect.ClearParams()
                Connect.AddParam("@ticket_id", message.ticket_id)
                Connect.AddParam("@sender_id", message.sender_id)
                Connect.AddParam("@message_text", message.message_text)
                Connect.AddParam("@attachment_url", If(String.IsNullOrEmpty(message.attachment_url), DBNull.Value, message.attachment_url))
                
                Dim query As String = "INSERT INTO support_messages (ticket_id, sender_id, message_text, attachment_url, is_read, created_at) " & _
                                    "VALUES (@ticket_id, @sender_id, @message_text, @attachment_url, 0, GETDATE()); " & _
                                    "SELECT SCOPE_IDENTITY(); " & _
                                    "UPDATE support_tickets SET last_updated = GETDATE() WHERE ticket_id = @ticket_id"
                                    
                Connect.Query(query)
                
                ' Get the newly created message ID
                If Connect.DataCount > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                    message.message_id = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0))
                    Return True
                End If
                
                Return False
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error creating message: " & ex.Message)
                Return False
            End Try
        End Function
        
        ' Get all messages for a specific ticket
        Public Function GetMessagesByTicketId(ticketId As Integer) As List(Of SupportMessage)
            Try
                Connect.ClearParams()
                Connect.AddParam("@ticket_id", ticketId)
                
                Dim query As String = "SELECT m.*, u.display_name AS sender_name, " & _
                                    "u.user_type, " & _
                                    "CASE WHEN u.user_type = 1 OR u.user_type = 2 THEN 1 ELSE 0 END AS is_staff_type " & _
                                    "FROM support_messages m " & _
                                    "JOIN users u ON m.sender_id = u.user_id " & _
                                    "WHERE m.ticket_id = @ticket_id " & _
                                    "ORDER BY m.created_at ASC"
                
                Connect.Query(query)
                
                Dim messages As New List(Of SupportMessage)()
                
                If Connect.DataCount > 0 Then
                    System.Diagnostics.Debug.WriteLine("Message count for ticket " & ticketId & ": " & Connect.Data.Tables(0).Rows.Count)
                    
                    For Each row As DataRow In Connect.Data.Tables(0).Rows
                        Dim message = MapRowToMessage(row)
                        
                        ' Debug info for each message
                        System.Diagnostics.Debug.WriteLine("Message ID: " & message.message_id & 
                                                         ", Sender: " & message.sender_name & 
                                                         ", is_staff: " & message.is_staff & 
                                                         ", user_type: " & (If(row("user_type") IsNot DBNull.Value, row("user_type").ToString(), "NULL")))
                        
                        messages.Add(message)
                    Next
                End If
                
                Return messages
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error getting messages: " & ex.Message)
                Return New List(Of SupportMessage)()
            End Try
        End Function
        
        ' Mark all messages in a ticket as read for a specific user
        Public Function MarkMessagesAsRead(ticketId As Integer, userId As Integer) As Boolean
            Try
                Connect.ClearParams()
                Connect.AddParam("@ticket_id", ticketId)
                Connect.AddParam("@user_id", userId)
                
                ' Mark messages as read if they were sent by someone else
                Dim query As String = "UPDATE support_messages SET is_read = 1 " & _
                                    "WHERE ticket_id = @ticket_id AND sender_id <> @user_id"
                
                Connect.Query(query)
                
                Return True
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error marking messages as read: " & ex.Message)
                Return False
            End Try
        End Function
        
        ' Get the count of unread messages for a user
        Public Function GetUnreadMessageCount(userId As Integer) As Integer
            Try
                Connect.ClearParams()
                Connect.AddParam("@user_id", userId)
                
                ' Get tickets where the user is either the customer or the assigned staff
                Dim query As String = "SELECT COUNT(*) FROM support_messages m " & _
                                    "JOIN support_tickets t ON m.ticket_id = t.ticket_id " & _
                                    "WHERE m.is_read = 0 AND m.sender_id <> @user_id AND " & _
                                    "(t.user_id = @user_id OR t.assigned_staff_id = @user_id)"
                
                Connect.Query(query)
                
                If Connect.DataCount > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                    Return Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0))
                End If
                
                Return 0
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error getting unread message count: " & ex.Message)
                Return 0
            End Try
        End Function
        
        ' Add file attachment to a message
        Public Function AddAttachment(messageId As Integer, attachmentUrl As String) As Boolean
            Try
                Connect.ClearParams()
                Connect.AddParam("@message_id", messageId)
                Connect.AddParam("@attachment_url", attachmentUrl)
                
                Dim query As String = "UPDATE support_messages SET attachment_url = @attachment_url " & _
                                    "WHERE message_id = @message_id"
                
                Connect.Query(query)
                
                Return True
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error adding attachment: " & ex.Message)
                Return False
            End Try
        End Function
        
        ' Helper method to map a data row to a SupportMessage object
        Private Function MapRowToMessage(row As DataRow) As SupportMessage
            Dim message As New SupportMessage()
            
            message.message_id = Convert.ToInt32(row("message_id"))
            message.ticket_id = Convert.ToInt32(row("ticket_id"))
            message.sender_id = Convert.ToInt32(row("sender_id"))
            message.message_text = Convert.ToString(row("message_text"))
            message.is_read = Convert.ToBoolean(row("is_read"))
            message.created_at = Convert.ToDateTime(row("created_at"))
            
            ' Handle nullable attachment_url
            If Not IsDBNull(row("attachment_url")) Then
                message.attachment_url = Convert.ToString(row("attachment_url"))
            End If
            
            ' Set navigation properties if available
            If row.Table.Columns.Contains("sender_name") Then
                message.sender_name = Convert.ToString(row("sender_name"))
            End If
            
            ' Use the pre-computed is_staff_type column if available
            If row.Table.Columns.Contains("is_staff_type") Then
                Try
                    message.is_staff = Convert.ToBoolean(row("is_staff_type"))
                    ' Debug log
                    System.Diagnostics.Debug.WriteLine("Using is_staff_type column: " & message.is_staff)
                    Return message
                Catch ex As Exception
                    System.Diagnostics.Debug.WriteLine("Error using is_staff_type: " & ex.Message)
                    ' Continue to fallback
                End Try
            End If
            
            ' Determine if the sender is staff based on user_type (fallback)
            If row.Table.Columns.Contains("user_type") Then
                Try
                    ' Handle user_type whether it's stored as string or integer
                    Dim userTypeValue = row("user_type")
                    If userTypeValue IsNot Nothing AndAlso Not IsDBNull(userTypeValue) Then
                        ' Handle numeric user_type (1 = admin, 2 = staff)
                        If TypeOf userTypeValue Is Integer OrElse IsNumeric(userTypeValue) Then
                            Dim userTypeInt As Integer = Convert.ToInt32(userTypeValue)
                            message.is_staff = (userTypeInt = 1 OrElse userTypeInt = 2) ' Admin or Staff
                        Else
                            ' Handle string user_type
                            Dim userTypeStr As String = userTypeValue.ToString().ToLower()
                            message.is_staff = (userTypeStr = "1" OrElse userTypeStr = "2" OrElse 
                                               userTypeStr = "admin" OrElse userTypeStr = "staff")
                        End If
                    End If
                Catch ex As Exception
                    ' Default to not staff if conversion fails
                    System.Diagnostics.Debug.WriteLine("Error determining is_staff: " & ex.Message)
                    message.is_staff = False
                End Try
            End If
            
            Return message
        End Function
        
        ' Get the latest message for each ticket
        Public Function GetLatestMessagesForTickets(tickets As List(Of SupportTicket)) As Dictionary(Of Integer, SupportMessage)
            Try
                If tickets Is Nothing OrElse tickets.Count = 0 Then
                    Return New Dictionary(Of Integer, SupportMessage)()
                End If
                
                ' Build a list of ticket IDs
                Dim ticketIds As New List(Of String)()
                For Each ticket In tickets
                    ticketIds.Add(ticket.ticket_id.ToString())
                Next
                
                ' Query to get the latest message for each ticket
                Connect.ClearParams()
                
                Dim query As String = "WITH LatestMessages AS (" & _
                                    "    SELECT m.*, ROW_NUMBER() OVER (PARTITION BY m.ticket_id ORDER BY m.created_at DESC) AS RowNum, " & _
                                    "    u.display_name AS sender_name, u.user_type " & _
                                    "    FROM support_messages m " & _
                                    "    JOIN users u ON m.sender_id = u.user_id " & _
                                    "    WHERE m.ticket_id IN (" & String.Join(",", ticketIds) & ") " & _
                                    ") " & _
                                    "SELECT * FROM LatestMessages WHERE RowNum = 1"
                
                Connect.Query(query)
                
                Dim latestMessages As New Dictionary(Of Integer, SupportMessage)()
                
                If Connect.DataCount > 0 Then
                    For Each row As DataRow In Connect.Data.Tables(0).Rows
                        Dim ticketId As Integer = Convert.ToInt32(row("ticket_id"))
                        latestMessages(ticketId) = MapRowToMessage(row)
                    Next
                End If
                
                Return latestMessages
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error getting latest messages: " & ex.Message)
                Return New Dictionary(Of Integer, SupportMessage)()
            End Try
        End Function
    End Class
End Namespace 