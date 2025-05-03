Imports Microsoft.VisualBasic

Public Class DealItem
    Public Property deal_item_id As Integer
    Public Property item_id As String
    Public Property ref As String
    Public Property date_created As String
    
    ' Navigation properties
    Public Property Deal As Deal
    Public Property MenuItem As MenuItem
End Class 