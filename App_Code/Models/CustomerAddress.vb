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
End Class 