Imports Microsoft.VisualBasic

Namespace HapagDB
    Public Class SupportMessage
        Public Property message_id As Integer
        Public Property ticket_id As Integer
        Public Property sender_id As Integer
        Public Property message_text As String
        Public Property attachment_url As String
        Public Property is_read As Boolean
        Public Property created_at As DateTime
        
        ' Navigation properties for related entities
        Public Property sender_name As String      ' Name of the message sender (not stored in DB)
        Public Property is_staff As Boolean        ' Whether the sender is staff (not stored in DB)
        
        Public Sub New()
            created_at = DateTime.Now
            is_read = False
        End Sub
    End Class
End Namespace 