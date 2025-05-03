Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Collections.Generic
Imports HapagDB

Public Class DiscountController
    Private conn As New Connection()
    
    Public Function GetDiscountById(ByVal discountId As Integer) As Discount
        Dim query As String = "SELECT * FROM discounts WHERE discount_id = @discount_id"
        conn.AddParam("@discount_id", discountId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            Return MapDataRowToDiscount(conn.Data.Tables(0).Rows(0))
        End If
        
        Return Nothing
    End Function
    
    Public Function GetAllDiscounts() As List(Of Discount)
        Dim discounts As New List(Of Discount)()
        Dim query As String = "SELECT * FROM discounts ORDER BY start_date DESC"
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                discounts.Add(MapDataRowToDiscount(row))
            Next
        End If
        
        Return discounts
    End Function
    
    Public Function GetActiveDiscounts() As List(Of Discount)
        Dim discounts As New List(Of Discount)()
        Dim query As String = "SELECT * FROM discounts WHERE status = 1 AND start_date <= GETDATE() AND end_date >= GETDATE() ORDER BY created_at DESC"
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                discounts.Add(MapDataRowToDiscount(row))
            Next
        End If
        
        Return discounts
    End Function
    
    Public Function GetDiscountsByType(ByVal discountType As Integer) As List(Of Discount)
        Dim discounts As New List(Of Discount)()
        Dim query As String = "SELECT * FROM discounts WHERE discount_type = @discount_type AND status = 1 ORDER BY created_at DESC"
        
        conn.AddParam("@discount_type", discountType)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                discounts.Add(MapDataRowToDiscount(row))
            Next
        End If
        
        Return discounts
    End Function
    
    Public Function CreateDiscount(ByVal discount As Discount) As Boolean
        Dim query As String = "INSERT INTO discounts (name, value, value_type, date_created, description, discount_type, applicable_to, start_date, end_date, min_order_amount, status, created_at) " & _
                             "VALUES (@name, @value, @value_type, @date_created, @description, @discount_type, @applicable_to, @start_date, @end_date, @min_order_amount, @status, @created_at)"
        
        conn.AddParamWithNull("@name", discount.name)
        conn.AddParamWithNull("@value", discount.value)
        conn.AddParamWithNull("@value_type", discount.value_type)
        conn.AddParamWithNull("@date_created", discount.date_created)
        conn.AddParamWithNull("@description", discount.description)
        conn.AddParam("@discount_type", discount.discount_type)
        conn.AddParam("@applicable_to", discount.applicable_to)
        conn.AddParam("@start_date", discount.start_date)
        conn.AddParam("@end_date", discount.end_date)
        conn.AddParam("@min_order_amount", discount.min_order_amount)
        conn.AddParam("@status", discount.status)
        conn.AddParam("@created_at", DateTime.Now)
        
        Return conn.Query(query)
    End Function
    
    Public Function UpdateDiscount(ByVal discount As Discount) As Boolean
        Dim query As String = "UPDATE discounts " & _
                             "SET name = @name, " & _
                             "    value = @value, " & _
                             "    value_type = @value_type, " & _
                             "    description = @description, " & _
                             "    discount_type = @discount_type, " & _
                             "    applicable_to = @applicable_to, " & _
                             "    start_date = @start_date, " & _
                             "    end_date = @end_date, " & _
                             "    min_order_amount = @min_order_amount, " & _
                             "    status = @status " & _
                             "WHERE discount_id = @discount_id"
        
        conn.AddParam("@discount_id", discount.discount_id)
        conn.AddParamWithNull("@name", discount.name)
        conn.AddParamWithNull("@value", discount.value)
        conn.AddParamWithNull("@value_type", discount.value_type)
        conn.AddParamWithNull("@description", discount.description)
        conn.AddParam("@discount_type", discount.discount_type)
        conn.AddParam("@applicable_to", discount.applicable_to)
        conn.AddParam("@start_date", discount.start_date)
        conn.AddParam("@end_date", discount.end_date)
        conn.AddParam("@min_order_amount", discount.min_order_amount)
        conn.AddParam("@status", discount.status)
        
        Return conn.Query(query)
    End Function
    
    Public Function DeleteDiscount(ByVal discountId As Integer) As Boolean
        Dim query As String = "DELETE FROM discounts WHERE discount_id = @discount_id"
        
        conn.AddParam("@discount_id", discountId)
        
        Return conn.Query(query)
    End Function
    
    Public Function ActivateDiscount(ByVal discountId As Integer) As Boolean
        Dim query As String = "UPDATE discounts SET status = 1 WHERE discount_id = @discount_id"
        
        conn.AddParam("@discount_id", discountId)
        
        Return conn.Query(query)
    End Function
    
    Public Function DeactivateDiscount(ByVal discountId As Integer) As Boolean
        Dim query As String = "UPDATE discounts SET status = 0 WHERE discount_id = @discount_id"
        
        conn.AddParam("@discount_id", discountId)
        
        Return conn.Query(query)
    End Function
    
    Private Function MapDataRowToDiscount(ByVal row As DataRow) As Discount
        Dim discount As New Discount()
        
        discount.discount_id = Convert.ToInt32(row("discount_id"))
        discount.name = If(row("name") IsNot DBNull.Value, row("name").ToString(), Nothing)
        discount.value = If(row("value") IsNot DBNull.Value, row("value").ToString(), Nothing)
        discount.value_type = If(row("value_type") IsNot DBNull.Value, row("value_type").ToString(), Nothing)
        discount.date_created = If(row("date_created") IsNot DBNull.Value, row("date_created").ToString(), Nothing)
        discount.description = If(row("description") IsNot DBNull.Value, row("description").ToString(), Nothing)
        discount.discount_type = Convert.ToInt32(row("discount_type"))
        discount.applicable_to = Convert.ToInt32(row("applicable_to"))
        discount.start_date = Convert.ToDateTime(row("start_date"))
        discount.end_date = Convert.ToDateTime(row("end_date"))
        
        If row("min_order_amount") IsNot DBNull.Value Then
            discount.min_order_amount = Convert.ToDecimal(row("min_order_amount"))
        End If
        
        discount.status = Convert.ToInt32(row("status"))
        discount.created_at = Convert.ToDateTime(row("created_at"))
        
        Return discount
    End Function
End Class 