Imports Microsoft.VisualBasic
Imports System
Imports System.Collections.Generic

Public Class Transaction
    Public Property transaction_id As Integer
    Public Property payment_method As String
    Public Property subtotal As String
    Public Property total As String
    Public Property discount As String
    Public Property driver As String
    Public Property user_id As Integer
    Public Property total_amount As Decimal
    Public Property status As String
    Public Property reference_number As String
    Public Property sender_name As String
    Public Property sender_number As String
    Public Property transaction_date As DateTime
    Public Property delivery_fee As Decimal
    Public Property discount_id As Integer?
    Public Property promotion_id As Integer?
    Public Property deal_id As Integer?
    Public Property app_name As String
    Public Property tracking_url As String
    Public Property estimated_time As String
    Public Property driver_name As String
    Public Property verification_date As DateTime?
    
    ' Navigation properties
    Public Property User As User
    Public Property Orders As List(Of Order)
    Public Property OrderItems As List(Of OrderItem)
End Class 