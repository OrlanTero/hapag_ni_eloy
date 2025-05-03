Imports Microsoft.VisualBasic
Imports System.Collections.Generic
Imports HapagDB

' This file ensures all model types are compiled together
' No code is needed, just import statements to all model types to ensure they're loaded
Public Class CompilerDefaults
    ' This class does nothing functional but helps the compiler
    ' Class references to ensure they are compiled together
    Private ReadOnly cart As Cart
    Private ReadOnly customerAddress As CustomerAddress
    Private ReadOnly deal As Deal
    Private ReadOnly dealItem As DealItem
    Private ReadOnly discount As Discount
    Private ReadOnly menuCategory As MenuCategory
    Private ReadOnly menuItem As MenuItem
    Private ReadOnly menuType As MenuType
    Private ReadOnly order As Order
    Private ReadOnly orderItem As OrderItem
    Private ReadOnly promotion As Promotion
    Private ReadOnly transaction As Transaction
    Private ReadOnly user As User
    Private ReadOnly connection As Connection
    
    Public Sub New()
        ' This constructor is never called, it's just to prevent compiler warnings
    End Sub
End Class 