Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Collections.Generic
Imports HapagDB

Public Class DealController
    Private conn As New Connection()
    
    Public Function GetDealById(ByVal dealId As Integer) As Deal
        Dim query As String = "SELECT * FROM deals WHERE deals_id = @deals_id"
        conn.AddParam("@deals_id", dealId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            Dim deal As Deal = MapDataRowToDeal(conn.Data.Tables(0).Rows(0))
            
            ' Get deal items
            deal.DealItems = GetDealItemsByDealId(dealId)
            
            Return deal
        End If
        
        Return Nothing
    End Function
    
    Public Function GetAllDeals() As List(Of Deal)
        Dim deals As New List(Of Deal)()
        Dim query As String = "SELECT * FROM deals ORDER BY date_created DESC"
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                Dim deal As Deal = MapDataRowToDeal(row)
                
                ' Get deal items
                deal.DealItems = GetDealItemsByDealId(deal.deals_id)
                
                deals.Add(deal)
            Next
        End If
        
        Return deals
    End Function
    
    Public Function GetActiveDeals() As List(Of Deal)
        Dim deals As New List(Of Deal)()
        Dim query As String = "SELECT * FROM deals WHERE start_date <= GETDATE() AND valid_until >= GETDATE() ORDER BY date_created DESC"
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                Dim deal As Deal = MapDataRowToDeal(row)
                
                ' Get deal items
                deal.DealItems = GetDealItemsByDealId(deal.deals_id)
                
                deals.Add(deal)
            Next
        End If
        
        Return deals
    End Function
    
    Public Function CreateDeal(ByVal deal As Deal) As Integer
        Dim query As String = "INSERT INTO deals (name, value, value_type, start_date, valid_until, date_created, description, image) " & _
                             "VALUES (@name, @value, @value_type, @start_date, @valid_until, @date_created, @description, @image); " & _
                             "SELECT SCOPE_IDENTITY();"
        
        conn.AddParamWithNull("@name", deal.name)
        conn.AddParamWithNull("@value", deal.value)
        conn.AddParamWithNull("@value_type", deal.value_type)
        conn.AddParamWithNull("@start_date", deal.start_date)
        conn.AddParamWithNull("@valid_until", deal.valid_until)
        conn.AddParam("@date_created", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
        conn.AddParamWithNull("@description", deal.description)
        conn.AddParamWithNull("@image", deal.image)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            Dim dealId As Integer = Convert.ToInt32(conn.Data.Tables(0).Rows(0)(0))
            
            ' Add deal items
            If deal.DealItems IsNot Nothing Then
                For Each item As DealItem In deal.DealItems
                    AddDealItem(dealId, item.item_id, item.ref)
                Next
            End If
            
            Return dealId
        End If
        
        Return 0
    End Function
    
    Public Function UpdateDeal(ByVal deal As Deal) As Boolean
        Dim query As String = "UPDATE deals " & _
                             "SET name = @name, " & _
                             "    value = @value, " & _
                             "    value_type = @value_type, " & _
                             "    start_date = @start_date, " & _
                             "    valid_until = @valid_until, " & _
                             "    description = @description, " & _
                             "    image = @image " & _
                             "WHERE deals_id = @deals_id"
        
        conn.AddParam("@deals_id", deal.deals_id)
        conn.AddParamWithNull("@name", deal.name)
        conn.AddParamWithNull("@value", deal.value)
        conn.AddParamWithNull("@value_type", deal.value_type)
        conn.AddParamWithNull("@start_date", deal.start_date)
        conn.AddParamWithNull("@valid_until", deal.valid_until)
        conn.AddParamWithNull("@description", deal.description)
        conn.AddParamWithNull("@image", deal.image)
        
        Return conn.Query(query)
    End Function
    
    Public Function DeleteDeal(ByVal dealId As Integer) As Boolean
        ' First delete deal items
        Dim deleteItemsQuery As String = "DELETE FROM deals_item WHERE ref = @deal_id"
        conn.AddParam("@deal_id", dealId.ToString())
        conn.Query(deleteItemsQuery)
        
        ' Then delete the deal
        Dim query As String = "DELETE FROM deals WHERE deals_id = @deals_id"
        conn.AddParam("@deals_id", dealId)
        
        Return conn.Query(query)
    End Function
    
    Public Function GetDealItemsByDealId(ByVal dealId As Integer) As List(Of DealItem)
        Dim dealItems As New List(Of DealItem)()
        Dim query As String = "SELECT di.*, m.name as item_name FROM deals_item di " & _
                             "LEFT JOIN menu m ON di.item_id = m.item_id " & _
                             "WHERE di.ref = @deal_id"
        
        conn.AddParam("@deal_id", dealId.ToString())
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                Dim dealItem As DealItem = MapDataRowToDealItem(row)
                
                ' Set menu item properties if available
                If row("item_name") IsNot DBNull.Value Then
                    dealItem.MenuItem = New MenuItem()
                    dealItem.MenuItem.name = row("item_name").ToString()
                End If
                
                dealItems.Add(dealItem)
            Next
        End If
        
        Return dealItems
    End Function
    
    Public Function AddDealItem(ByVal dealId As Integer, ByVal itemId As String, ByVal ref As String) As Boolean
        Dim query As String = "INSERT INTO deals_item (item_id, ref, date_created) VALUES (@item_id, @ref, @date_created)"
        
        conn.AddParamWithNull("@item_id", itemId)
        conn.AddParam("@ref", dealId.ToString())
        conn.AddParam("@date_created", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
        
        Return conn.Query(query)
    End Function
    
    Public Function RemoveDealItem(ByVal dealItemId As Integer) As Boolean
        Dim query As String = "DELETE FROM deals_item WHERE deal_item_id = @deal_item_id"
        
        conn.AddParam("@deal_item_id", dealItemId)
        
        Return conn.Query(query)
    End Function
    
    Private Function MapDataRowToDeal(ByVal row As DataRow) As Deal
        Dim deal As New Deal()
        
        deal.deals_id = Convert.ToInt32(row("deals_id"))
        deal.name = If(row("name") IsNot DBNull.Value, row("name").ToString(), Nothing)
        deal.value = If(row("value") IsNot DBNull.Value, row("value").ToString(), Nothing)
        deal.value_type = If(row("value_type") IsNot DBNull.Value, row("value_type").ToString(), Nothing)
        deal.start_date = If(row("start_date") IsNot DBNull.Value, row("start_date").ToString(), Nothing)
        deal.valid_until = If(row("valid_until") IsNot DBNull.Value, row("valid_until").ToString(), Nothing)
        deal.date_created = If(row("date_created") IsNot DBNull.Value, row("date_created").ToString(), Nothing)
        deal.description = If(row("description") IsNot DBNull.Value, row("description").ToString(), Nothing)
        deal.image = If(row("image") IsNot DBNull.Value, row("image").ToString(), Nothing)
        
        Return deal
    End Function
    
    Private Function MapDataRowToDealItem(ByVal row As DataRow) As DealItem
        Dim dealItem As New DealItem()
        
        dealItem.deal_item_id = Convert.ToInt32(row("deal_item_id"))
        dealItem.item_id = If(row("item_id") IsNot DBNull.Value, row("item_id").ToString(), Nothing)
        dealItem.ref = If(row("ref") IsNot DBNull.Value, row("ref").ToString(), Nothing)
        dealItem.date_created = If(row("date_created") IsNot DBNull.Value, row("date_created").ToString(), Nothing)
        
        Return dealItem
    End Function
End Class 