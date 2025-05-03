Imports Microsoft.VisualBasic
Imports System.Collections.Generic

Public Class MenuCategory
    Public Property category_id As Integer
    Public Property category_name As String
    Public Property description As String
    Public Property is_active As Boolean
    
    ' Navigation properties
    Public Property MenuItems As List(Of MenuItem)
End Class 