Imports Microsoft.VisualBasic
Imports System
Imports System.Collections.Generic

Public Class Order
    Public Property order_id As Integer
    Public Property user_id As Integer
    Public Property order_date As DateTime
    Public Property transaction_id As Integer
    Public Property subtotal As String
    Public Property shipping_fee As String
    Public Property tax As String
    Public Property total_amount As Decimal
    Public Property status As String
    Public Property driver_name As String
    Public Property delivery_service As String
    Public Property tracking_link As String
    Public Property delivery_notes As String
    
    ' Navigation properties
    Public Property User As User
    Public Property OrderItems As List(Of OrderItem)
    Public Property Transaction As Transaction
End Class 