Imports Microsoft.VisualBasic
Imports System.Collections.Generic
Imports System

Public Class User
    Public Property user_id As Integer
    Public Property username As String
    Public Property password As String 
    Public Property display_name As String
    Public Property contact As String
    Public Property email As String
    Public Property address As String
    Public Property user_type As String
    Public Property role As String
    
    ' Navigation properties
    Public Property Orders As List(Of Order)
    Public Property Transactions As List(Of Transaction)
    Public Property CartItems As List(Of Cart)
    Public Property CustomerAddresses As List(Of CustomerAddress)
End Class
    