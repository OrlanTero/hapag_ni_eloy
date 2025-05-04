Imports Microsoft.VisualBasic
Imports System

Public Class CustomerAddress
    Public Property address_id As Integer
    Public Property user_id As Integer
    Public Property address_name As String
    Public Property recipient_name As String
    Public Property contact_number As String
    Public Property address_line As String
    Public Property city As String
    Public Property postal_code As String
    Public Property is_default As Long
    Public Property date_added As DateTime
    
    ' Navigation properties
    Public Property User As User
    
    ' Helper property to handle Boolean conversion
    Public ReadOnly Property IsDefaultBoolean As Boolean
        Get
            Return is_default > 0
        End Get
    End Property
    
    ' Helper method to set is_default properly
    Public Sub SetDefault(value As Boolean)
        is_default = If(value, 1, 0)
    End Sub
End Class 