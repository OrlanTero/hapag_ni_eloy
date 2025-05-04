Imports System.Data
Imports Microsoft.VisualBasic

Namespace HapagDB
    Public Class SupportTicketController
        Private Connect As New Connection()
        
        ' Create a new support ticket
        Public Function CreateTicket(ticket As SupportTicket) As Boolean
            Try
                Connect.ClearParams()
                Connect.AddParam("@user_id", ticket.user_id)
                Connect.AddParam("@subject", ticket.subject)
                Connect.AddParam("@status", ticket.status)
                Connect.AddParam("@priority", ticket.priority)
                
                Dim query As String = "INSERT INTO support_tickets (user_id, subject, status, priority, created_at, last_updated) " & _
                                    "VALUES (@user_id, @subject, @status, @priority, GETDATE(), GETDATE()); " & _
                                    "SELECT SCOPE_IDENTITY();"
                                    
                Connect.Query(query)
                
                ' Get the newly created ticket ID
                If Connect.DataCount > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                    ticket.ticket_id = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0))
                    Return True
                End If
                
                Return False
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error creating ticket: " & ex.Message)
                Return False
            End Try
        End Function
        
        ' Get a specific ticket by ID
        Public Function GetTicketById(ticketId As Integer) As SupportTicket
            Try
                Connect.ClearParams()
                Connect.AddParam("@ticket_id", ticketId)
                
                Dim query As String = "SELECT t.*, u.display_name AS user_name, " & _
                                    "s.display_name AS staff_name, " & _
                                    "(SELECT COUNT(*) FROM support_messages WHERE ticket_id = t.ticket_id) AS message_count, " & _
                                    "(SELECT COUNT(*) FROM support_messages WHERE ticket_id = t.ticket_id AND is_read = 0) AS unread_count " & _
                                    "FROM support_tickets t " & _
                                    "JOIN users u ON t.user_id = u.user_id " & _
                                    "LEFT JOIN users s ON t.assigned_staff_id = s.user_id " & _
                                    "WHERE t.ticket_id = @ticket_id"
                
                Connect.Query(query)
                
                If Connect.DataCount > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                    Return MapRowToTicket(Connect.Data.Tables(0).Rows(0))
                End If
                
                Return Nothing
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error getting ticket: " & ex.Message)
                Return Nothing
            End Try
        End Function
        
        ' Get all tickets for a specific user
        Public Function GetTicketsByUserId(userId As Integer) As List(Of SupportTicket)
            Try
                Connect.ClearParams()
                Connect.AddParam("@user_id", userId)
                
                Dim query As String = "SELECT t.*, u.display_name AS user_name, " & _
                                    "s.display_name AS staff_name, " & _
                                    "(SELECT COUNT(*) FROM support_messages WHERE ticket_id = t.ticket_id) AS message_count, " & _
                                    "(SELECT COUNT(*) FROM support_messages WHERE ticket_id = t.ticket_id AND is_read = 0) AS unread_count " & _
                                    "FROM support_tickets t " & _
                                    "JOIN users u ON t.user_id = u.user_id " & _
                                    "LEFT JOIN users s ON t.assigned_staff_id = s.user_id " & _
                                    "WHERE t.user_id = @user_id " & _
                                    "ORDER BY t.last_updated DESC"
                
                Connect.Query(query)
                
                Dim tickets As New List(Of SupportTicket)()
                
                If Connect.DataCount > 0 Then
                    For Each row As DataRow In Connect.Data.Tables(0).Rows
                        tickets.Add(MapRowToTicket(row))
                    Next
                End If
                
                Return tickets
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error getting user tickets: " & ex.Message)
                Return New List(Of SupportTicket)()
            End Try
        End Function
        
        ' Get all tickets assigned to a specific staff member
        Public Function GetTicketsByStaffId(staffId As Integer) As List(Of SupportTicket)
            Try
                Connect.ClearParams()
                Connect.AddParam("@staff_id", staffId)
                
                Dim query As String = "SELECT t.*, u.display_name AS user_name, " & _
                                    "s.display_name AS staff_name, " & _
                                    "(SELECT COUNT(*) FROM support_messages WHERE ticket_id = t.ticket_id) AS message_count, " & _
                                    "(SELECT COUNT(*) FROM support_messages WHERE ticket_id = t.ticket_id AND is_read = 0) AS unread_count " & _
                                    "FROM support_tickets t " & _
                                    "JOIN users u ON t.user_id = u.user_id " & _
                                    "LEFT JOIN users s ON t.assigned_staff_id = s.user_id " & _
                                    "WHERE t.assigned_staff_id = @staff_id " & _
                                    "ORDER BY t.last_updated DESC"
                
                Connect.Query(query)
                
                Dim tickets As New List(Of SupportTicket)()
                
                If Connect.DataCount > 0 Then
                    For Each row As DataRow In Connect.Data.Tables(0).Rows
                        tickets.Add(MapRowToTicket(row))
                    Next
                End If
                
                Return tickets
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error getting staff tickets: " & ex.Message)
                Return New List(Of SupportTicket)()
            End Try
        End Function
        
        ' Get all open tickets (for staff portal)
        Public Function GetAllOpenTickets() As List(Of SupportTicket)
            Try
                Connect.ClearParams()
                
                Dim query As String = "SELECT t.*, u.display_name AS user_name, " & _
                                    "s.display_name AS staff_name, " & _
                                    "(SELECT COUNT(*) FROM support_messages WHERE ticket_id = t.ticket_id) AS message_count, " & _
                                    "(SELECT COUNT(*) FROM support_messages WHERE ticket_id = t.ticket_id AND is_read = 0) AS unread_count " & _
                                    "FROM support_tickets t " & _
                                    "JOIN users u ON t.user_id = u.user_id " & _
                                    "LEFT JOIN users s ON t.assigned_staff_id = s.user_id " & _
                                    "WHERE t.status <> 'Closed' " & _
                                    "ORDER BY " & _
                                    "CASE WHEN t.priority = 'High' THEN 1 " & _
                                    "     WHEN t.priority = 'Medium' THEN 2 " & _
                                    "     WHEN t.priority = 'Low' THEN 3 END, " & _
                                    "t.last_updated DESC"
                
                Connect.Query(query)
                
                Dim tickets As New List(Of SupportTicket)()
                
                If Connect.DataCount > 0 Then
                    For Each row As DataRow In Connect.Data.Tables(0).Rows
                        tickets.Add(MapRowToTicket(row))
                    Next
                End If
                
                Return tickets
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error getting open tickets: " & ex.Message)
                Return New List(Of SupportTicket)()
            End Try
        End Function
        
        ' Update a ticket
        Public Function UpdateTicket(ticket As SupportTicket) As Boolean
            Try
                Connect.ClearParams()
                Connect.AddParam("@ticket_id", ticket.ticket_id)
                Connect.AddParam("@subject", ticket.subject)
                Connect.AddParam("@status", ticket.status)
                Connect.AddParam("@priority", ticket.priority)
                Connect.AddParam("@assigned_staff_id", If(ticket.assigned_staff_id.HasValue, ticket.assigned_staff_id, DBNull.Value))
                
                Dim query As String = "UPDATE support_tickets SET " & _
                                    "subject = @subject, " & _
                                    "status = @status, " & _
                                    "priority = @priority, " & _
                                    "assigned_staff_id = @assigned_staff_id, " & _
                                    "last_updated = GETDATE() " & _
                                    "WHERE ticket_id = @ticket_id"
                
                Connect.Query(query)
                
                Return True
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error updating ticket: " & ex.Message)
                Return False
            End Try
        End Function
        
        ' Assign a ticket to a staff member
        Public Function AssignTicket(ticketId As Integer, staffId As Integer) As Boolean
            Try
                Connect.ClearParams()
                Connect.AddParam("@ticket_id", ticketId)
                Connect.AddParam("@staff_id", staffId)
                
                Dim query As String = "UPDATE support_tickets SET " & _
                                    "assigned_staff_id = @staff_id, " & _
                                    "status = CASE WHEN status = 'Open' THEN 'In Progress' ELSE status END, " & _
                                    "last_updated = GETDATE() " & _
                                    "WHERE ticket_id = @ticket_id"
                
                Connect.Query(query)
                
                Return True
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error assigning ticket: " & ex.Message)
                Return False
            End Try
        End Function
        
        ' Close a ticket
        Public Function CloseTicket(ticketId As Integer) As Boolean
            Try
                Connect.ClearParams()
                Connect.AddParam("@ticket_id", ticketId)
                
                Dim query As String = "UPDATE support_tickets SET " & _
                                    "status = 'Closed', " & _
                                    "last_updated = GETDATE() " & _
                                    "WHERE ticket_id = @ticket_id"
                
                Connect.Query(query)
                
                Return True
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error closing ticket: " & ex.Message)
                Return False
            End Try
        End Function
        
        ' Reopen a closed ticket
        Public Function ReopenTicket(ticketId As Integer) As Boolean
            Try
                Connect.ClearParams()
                Connect.AddParam("@ticket_id", ticketId)
                
                Dim query As String = "UPDATE support_tickets SET " & _
                                    "status = 'In Progress', " & _
                                    "last_updated = GETDATE() " & _
                                    "WHERE ticket_id = @ticket_id"
                
                Connect.Query(query)
                
                Return True
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error reopening ticket: " & ex.Message)
                Return False
            End Try
        End Function
        
        ' Helper method to map a data row to a SupportTicket object
        Private Function MapRowToTicket(row As DataRow) As SupportTicket
            Dim ticket As New SupportTicket()
            
            ticket.ticket_id = Convert.ToInt32(row("ticket_id"))
            ticket.user_id = Convert.ToInt32(row("user_id"))
            ticket.subject = Convert.ToString(row("subject"))
            ticket.status = Convert.ToString(row("status"))
            ticket.priority = Convert.ToString(row("priority"))
            ticket.created_at = Convert.ToDateTime(row("created_at"))
            ticket.last_updated = Convert.ToDateTime(row("last_updated"))
            
            ' Handle nullable assigned_staff_id
            If Not IsDBNull(row("assigned_staff_id")) Then
                ticket.assigned_staff_id = Convert.ToInt32(row("assigned_staff_id"))
            End If
            
            ' Set navigation properties if available
            If row.Table.Columns.Contains("user_name") Then
                ticket.user_name = Convert.ToString(row("user_name"))
            End If
            
            If row.Table.Columns.Contains("staff_name") AndAlso Not IsDBNull(row("staff_name")) Then
                ticket.staff_name = Convert.ToString(row("staff_name"))
            End If
            
            If row.Table.Columns.Contains("message_count") Then
                ticket.message_count = Convert.ToInt32(row("message_count"))
            End If
            
            If row.Table.Columns.Contains("unread_count") Then
                ticket.unread_count = Convert.ToInt32(row("unread_count"))
            End If
            
            Return ticket
        End Function
    End Class
End Namespace 