Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Collections.Generic
Imports HapagDB

Public Class PromotionController
    Private conn As New Connection()
    
    Public Function GetPromotionById(ByVal promotionId As Integer) As Promotion
        Dim query As String = "SELECT * FROM promotions WHERE promotion_id = @promotion_id"
        conn.AddParam("@promotion_id", promotionId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            Return MapDataRowToPromotion(conn.Data.Tables(0).Rows(0))
        End If
        
        Return Nothing
    End Function
    
    Public Function GetAllPromotions() As List(Of Promotion)
        Dim promotions As New List(Of Promotion)()
        Dim query As String = "SELECT * FROM promotions ORDER BY date_created DESC"
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                promotions.Add(MapDataRowToPromotion(row))
            Next
        End If
        
        Return promotions
    End Function
    
    Public Function GetActivePromotions() As List(Of Promotion)
        Dim promotions As New List(Of Promotion)()
        Dim query As String = "SELECT * FROM promotions WHERE start_date <= GETDATE() AND valid_until >= GETDATE() ORDER BY date_created DESC"
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                promotions.Add(MapDataRowToPromotion(row))
            Next
        End If
        
        Return promotions
    End Function
    
    Public Function CreatePromotion(ByVal promotion As Promotion) As Boolean
        Dim query As String = "INSERT INTO promotions (name, code, value, value_type, start_date, valid_until, date_created, description, image, min_purchase, is_active) " & _
                             "VALUES (@name, @code, @value, @value_type, @start_date, @valid_until, @date_created, @description, @image, @min_purchase, @is_active)"
        
        conn.AddParamWithNull("@name", promotion.name)
        conn.AddParamWithNull("@code", promotion.code)
        conn.AddParamWithNull("@value", promotion.value)
        conn.AddParamWithNull("@value_type", promotion.value_type)
        conn.AddParamWithNull("@start_date", promotion.start_date)
        conn.AddParamWithNull("@valid_until", promotion.valid_until)
        conn.AddParam("@date_created", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
        conn.AddParamWithNull("@description", promotion.description)
        conn.AddParamWithNull("@image", promotion.image)
        conn.AddParamWithNull("@min_purchase", promotion.min_purchase.ToString())
        conn.AddParam("@is_active", promotion.is_active)
        
        Return conn.Query(query)
    End Function
    
    Public Function UpdatePromotion(ByVal promotion As Promotion) As Boolean
        Dim query As String = "UPDATE promotions " & _
                             "SET name = @name, " & _
                             "    code = @code, " & _
                             "    value = @value, " & _
                             "    value_type = @value_type, " & _
                             "    start_date = @start_date, " & _
                             "    valid_until = @valid_until, " & _
                             "    description = @description, " & _
                             "    image = @image, " & _
                             "    min_purchase = @min_purchase, " & _
                             "    is_active = @is_active " & _
                             "WHERE promotion_id = @promotion_id"
        
        conn.AddParam("@promotion_id", promotion.promotion_id)
        conn.AddParamWithNull("@name", promotion.name)
        conn.AddParamWithNull("@code", promotion.code)
        conn.AddParamWithNull("@value", promotion.value)
        conn.AddParamWithNull("@value_type", promotion.value_type)
        conn.AddParamWithNull("@start_date", promotion.start_date)
        conn.AddParamWithNull("@valid_until", promotion.valid_until)
        conn.AddParamWithNull("@description", promotion.description)
        conn.AddParamWithNull("@image", promotion.image)
        conn.AddParamWithNull("@min_purchase", promotion.min_purchase.ToString())
        conn.AddParam("@is_active", promotion.is_active)
        
        Return conn.Query(query)
    End Function
    
    Public Function DeletePromotion(ByVal promotionId As Integer) As Boolean
        Dim query As String = "DELETE FROM promotions WHERE promotion_id = @promotion_id"
        
        conn.AddParam("@promotion_id", promotionId)
        
        Return conn.Query(query)
    End Function
    
    Private Function MapDataRowToPromotion(ByVal row As DataRow) As Promotion
        Dim promotion As New Promotion()
        
        promotion.promotion_id = Convert.ToInt32(row("promotion_id"))
        promotion.code = If(row("code") IsNot DBNull.Value, row("code").ToString(), Nothing)
        promotion.name = If(row("name") IsNot DBNull.Value, row("name").ToString(), Nothing)
        promotion.value = If(row("value") IsNot DBNull.Value, row("value").ToString(), Nothing)
        promotion.value_type = If(row("value_type") IsNot DBNull.Value, row("value_type").ToString(), Nothing)
        promotion.start_date = If(row("start_date") IsNot DBNull.Value, row("start_date").ToString(), Nothing)
        promotion.valid_until = If(row("valid_until") IsNot DBNull.Value, row("valid_until").ToString(), Nothing)
        promotion.date_created = If(row("date_created") IsNot DBNull.Value, row("date_created").ToString(), Nothing)
        promotion.description = If(row("description") IsNot DBNull.Value, row("description").ToString(), Nothing)
        promotion.image = If(row("image") IsNot DBNull.Value, row("image").ToString(), Nothing)
        
        ' Fix for Double conversion - properly handle DBNull and invalid format values
        If row("min_purchase") IsNot DBNull.Value Then
            Dim minPurchaseValue As String = row("min_purchase").ToString()
            Dim minPurchaseResult As Double = 0
            If Not String.IsNullOrEmpty(minPurchaseValue) AndAlso Double.TryParse(minPurchaseValue, minPurchaseResult) Then
                promotion.min_purchase = minPurchaseResult
            Else
                promotion.min_purchase = 0
            End If
        Else
            promotion.min_purchase = 0
        End If
        
        ' Fix for Boolean conversion - properly handle DBNull and empty string values
        If row("is_active") IsNot DBNull.Value Then
            Dim isActiveValue As String = row("is_active").ToString()
            If String.IsNullOrEmpty(isActiveValue) Then
                promotion.is_active = False
            Else
                Boolean.TryParse(isActiveValue, promotion.is_active)
            End If
        Else
            promotion.is_active = False
        End If
        
        Return promotion
    End Function
End Class 