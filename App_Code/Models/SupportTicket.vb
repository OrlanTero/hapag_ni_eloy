Imports Microsoft.VisualBasic

Namespace HapagDB
    Public Class SupportTicket
        Public Property ticket_id As Integer
        Public Property user_id As Integer
        Public Property subject As String
        Public Property status As String
        Public Property priority As String
        Public Property created_at As DateTime
        Public Property last_updated As DateTime
        Public Property assigned_staff_id As Integer?
        
        ' Navigation properties for related entities
        Public Property user_name As String        ' Customer name (not stored in DB)
        Public Property staff_name As String       ' Assigned staff name (not stored in DB)
        Public Property message_count As Integer   ' Number of messages (not stored in DB)
        Public Property unread_count As Integer    ' Number of unread messages (not stored in DB)
        
        Public Sub New()
            created_at = DateTime.Now
            last_updated = DateTime.Now
            status = "Open"
            priority = "Medium"
        End Sub
    End Class
End Namespace 