Imports Microsoft.VisualBasic
Imports System
Imports System.Collections.Generic

Public Class Deal
    Public Property deals_id As Integer
    Public Property name As String
    Public Property value As String
    Public Property value_type As String
    Public Property start_date As String
    Public Property valid_until As String
    Public Property date_created As String
    Public Property description As String
    Public Property image As String
    
    ' Navigation properties
    Public Property DealItems As List(Of DealItem)
End Class 