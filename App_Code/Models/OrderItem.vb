Imports Microsoft.VisualBasic
Imports System.Collections.Generic


Public Class OrderItem
    Public Property order_item_id As Integer
    Public Property transaction_id As Integer
    Public Property item_id As Integer
    Public Property quantity As Integer
    Public Property price As Decimal
    Public Property order_id As Integer
    
    ' Navigation properties
    Public Property Order As Order
    Public Property Transaction As Transaction
    Public Property MenuItem As MenuItem
End Class