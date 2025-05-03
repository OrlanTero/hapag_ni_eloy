Imports Microsoft.VisualBasic
Imports System

Public Class Cart
    Public Property cart_id As Integer
    Public Property user_id As Integer
    Public Property item_id As Integer
    Public Property quantity As Integer
    
    ' Navigation properties
    Public Property User As User
    Public Property MenuItem As MenuItem
End Class 