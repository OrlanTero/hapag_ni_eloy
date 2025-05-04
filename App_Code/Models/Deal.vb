Imports Microsoft.VisualBasic
Imports System
Imports System.Collections.Generic

Public Class Deal
    Public Property deals_id As Integer
    Public Property name As String
    Public Property value As Decimal
    Public Property value_type As Integer
    Public Property start_date As DateTime
    Public Property valid_until As DateTime
    Public Property date_created As DateTime?
    Public Property description As String
    Public Property image As String
    
    ' Navigation properties
    Public Property DealItems As List(Of DealItem)
End Class 