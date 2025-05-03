Imports Microsoft.VisualBasic
Imports System.Collections.Generic

Public Class MenuItem
    Public Property item_id As Integer
    Public Property name As String
    Public Property price As String
    Public Property category As String
    Public Property type As String
    Public Property availability As String
    Public Property image As String
    Public Property category_id As Integer
    Public Property type_id As Integer
    Public Property description As String
    Public Property no_of_serving As String
    
    ' Navigation properties
    Public Property MenuCategory As MenuCategory
    Public Property MenuType As MenuType
    Public Property OrderItems As List(Of OrderItem)
    Public Property CartItems As List(Of Cart)
End Class