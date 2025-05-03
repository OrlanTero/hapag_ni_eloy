Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Collections.Generic
Imports HapagDB

Public Class MenuController
    Private conn As New Connection()
    
    Public Function GetMenuItemById(ByVal itemId As Integer) As MenuItem
        Dim query As String = "SELECT * FROM menu WHERE item_id = @item_id"
        conn.AddParam("@item_id", itemId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            Return MapDataRowToMenuItem(conn.Data.Tables(0).Rows(0))
        End If
        
        Return Nothing
    End Function
    
    Public Function GetAllMenuItems() As List(Of MenuItem)
        Dim menuItems As New List(Of MenuItem)()
        Dim query As String = "SELECT * FROM menu"
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                menuItems.Add(MapDataRowToMenuItem(row))
            Next
        End If
        
        Return menuItems
    End Function
    
    Public Function GetMenuItemsByCategory(ByVal categoryId As Integer) As List(Of MenuItem)
        Dim menuItems As New List(Of MenuItem)()
        Dim query As String = "SELECT * FROM menu WHERE category_id = @category_id"
        conn.AddParam("@category_id", categoryId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                menuItems.Add(MapDataRowToMenuItem(row))
            Next
        End If
        
        Return menuItems
    End Function
    
    Public Function GetMenuItemsByType(ByVal typeId As Integer) As List(Of MenuItem)
        Dim menuItems As New List(Of MenuItem)()
        Dim query As String = "SELECT * FROM menu WHERE type_id = @type_id"
        conn.AddParam("@type_id", typeId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                menuItems.Add(MapDataRowToMenuItem(row))
            Next
        End If
        
        Return menuItems
    End Function
    
    Public Function SearchMenuItems(ByVal searchTerm As String) As List(Of MenuItem)
        Dim menuItems As New List(Of MenuItem)()
        Dim query As String = "SELECT * FROM menu WHERE name LIKE @search OR description LIKE @search"
        conn.AddParam("@search", "%" & searchTerm & "%")
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                menuItems.Add(MapDataRowToMenuItem(row))
            Next
        End If
        
        Return menuItems
    End Function
    
    Public Function CreateMenuItem(ByVal menuItem As MenuItem) As Boolean
        Dim query As String = "INSERT INTO menu (name, price, category, type, availability, image, category_id, type_id, description, no_of_serving) " & _
                             "VALUES (@name, @price, @category, @type, @availability, @image, @category_id, @type_id, @description, @no_of_serving)"
        
        conn.AddParamWithNull("@name", menuItem.name)
        conn.AddParamWithNull("@price", menuItem.price)
        conn.AddParamWithNull("@category", menuItem.category)
        conn.AddParamWithNull("@type", menuItem.type)
        conn.AddParamWithNull("@availability", menuItem.availability)
        conn.AddParamWithNull("@image", menuItem.image)
        conn.AddParamWithNull("@category_id", menuItem.category_id)
        conn.AddParamWithNull("@type_id", menuItem.type_id)
        conn.AddParamWithNull("@description", menuItem.description)
        conn.AddParamWithNull("@no_of_serving", menuItem.no_of_serving)
        
        Return conn.Query(query)
    End Function
    
    Public Function UpdateMenuItem(ByVal menuItem As MenuItem) As Boolean
        Dim query As String = "UPDATE menu " & _
                             "SET name = @name, " & _
                             "    price = @price, " & _
                             "    category = @category, " & _
                             "    type = @type, " & _
                             "    availability = @availability, " & _
                             "    image = @image, " & _
                             "    category_id = @category_id, " & _
                             "    type_id = @type_id, " & _
                             "    description = @description, " & _
                             "    no_of_serving = @no_of_serving " & _
                             "WHERE item_id = @item_id"
        
        conn.AddParam("@item_id", menuItem.item_id)
        conn.AddParamWithNull("@name", menuItem.name)
        conn.AddParamWithNull("@price", menuItem.price)
        conn.AddParamWithNull("@category", menuItem.category)
        conn.AddParamWithNull("@type", menuItem.type)
        conn.AddParamWithNull("@availability", menuItem.availability)
        conn.AddParamWithNull("@image", menuItem.image)
        conn.AddParamWithNull("@category_id", menuItem.category_id)
        conn.AddParamWithNull("@type_id", menuItem.type_id)
        conn.AddParamWithNull("@description", menuItem.description)
        conn.AddParamWithNull("@no_of_serving", menuItem.no_of_serving)
        
        Return conn.Query(query)
    End Function
    
    Public Function DeleteMenuItem(ByVal itemId As Integer) As Boolean
        Dim query As String = "DELETE FROM menu WHERE item_id = @item_id"
        
        conn.AddParam("@item_id", itemId)
        
        Return conn.Query(query)
    End Function
    
    ' Menu Categories Functions
    
    Public Function GetAllCategories() As List(Of MenuCategory)
        Dim categories As New List(Of MenuCategory)()
        Dim query As String = "SELECT * FROM menu_categories"
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                categories.Add(MapDataRowToMenuCategory(row))
            Next
        End If
        
        Return categories
    End Function
    
    Public Function GetCategoryById(ByVal categoryId As Integer) As MenuCategory
        Dim query As String = "SELECT * FROM menu_categories WHERE category_id = @category_id"
        conn.AddParam("@category_id", categoryId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            Return MapDataRowToMenuCategory(conn.Data.Tables(0).Rows(0))
        End If
        
        Return Nothing
    End Function
    
    Public Function CreateCategory(ByVal category As MenuCategory) As Boolean
        Dim query As String = "INSERT INTO menu_categories (category_name, description, is_active) " & _
                             "VALUES (@category_name, @description, @is_active)"
        
        conn.AddParamWithNull("@category_name", category.category_name)
        conn.AddParamWithNull("@description", category.description)
        conn.AddParam("@is_active", If(category.is_active, 1, 0))
        
        Return conn.Query(query)
    End Function
    
    Public Function UpdateCategory(ByVal category As MenuCategory) As Boolean
        Dim query As String = "UPDATE menu_categories " & _
                             "SET category_name = @category_name, " & _
                             "    description = @description, " & _
                             "    is_active = @is_active " & _
                             "WHERE category_id = @category_id"
        
        conn.AddParam("@category_id", category.category_id)
        conn.AddParamWithNull("@category_name", category.category_name)
        conn.AddParamWithNull("@description", category.description)
        conn.AddParam("@is_active", If(category.is_active, 1, 0))
        
        Return conn.Query(query)
    End Function
    
    Public Function DeleteCategory(ByVal categoryId As Integer) As Boolean
        Dim query As String = "DELETE FROM menu_categories WHERE category_id = @category_id"
        
        conn.AddParam("@category_id", categoryId)
        
        Return conn.Query(query)
    End Function
    
    ' Menu Types Functions
    
    Public Function GetAllTypes() As List(Of MenuType)
        Dim types As New List(Of MenuType)()
        Dim query As String = "SELECT * FROM menu_types"
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                types.Add(MapDataRowToMenuType(row))
            Next
        End If
        
        Return types
    End Function
    
    Public Function GetTypeById(ByVal typeId As Integer) As MenuType
        Dim query As String = "SELECT * FROM menu_types WHERE type_id = @type_id"
        conn.AddParam("@type_id", typeId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            Return MapDataRowToMenuType(conn.Data.Tables(0).Rows(0))
        End If
        
        Return Nothing
    End Function
    
    Public Function CreateType(ByVal type As MenuType) As Boolean
        Dim query As String = "INSERT INTO menu_types (type_name, description, is_active) " & _
                             "VALUES (@type_name, @description, @is_active)"
        
        conn.AddParamWithNull("@type_name", type.type_name)
        conn.AddParamWithNull("@description", type.description)
        conn.AddParam("@is_active", If(type.is_active, 1, 0))
        
        Return conn.Query(query)
    End Function
    
    Public Function UpdateType(ByVal type As MenuType) As Boolean
        Dim query As String = "UPDATE menu_types " & _
                             "SET type_name = @type_name, " & _
                             "    description = @description, " & _
                             "    is_active = @is_active " & _
                             "WHERE type_id = @type_id"
        
        conn.AddParam("@type_id", type.type_id)
        conn.AddParamWithNull("@type_name", type.type_name)
        conn.AddParamWithNull("@description", type.description)
        conn.AddParam("@is_active", If(type.is_active, 1, 0))
        
        Return conn.Query(query)
    End Function
    
    Public Function DeleteType(ByVal typeId As Integer) As Boolean
        Dim query As String = "DELETE FROM menu_types WHERE type_id = @type_id"
        
        conn.AddParam("@type_id", typeId)
        
        Return conn.Query(query)
    End Function
    
    ' Mapping Functions
    
    Private Function MapDataRowToMenuItem(ByVal row As DataRow) As MenuItem
        Dim menuItem As New MenuItem()
        
        menuItem.item_id = Convert.ToInt32(row("item_id"))
        menuItem.name = If(row("name") IsNot DBNull.Value, row("name").ToString(), Nothing)
        menuItem.price = If(row("price") IsNot DBNull.Value, row("price").ToString(), Nothing)
        menuItem.category = If(row("category") IsNot DBNull.Value, row("category").ToString(), Nothing)
        menuItem.type = If(row("type") IsNot DBNull.Value, row("type").ToString(), Nothing)
        menuItem.availability = If(row("availability") IsNot DBNull.Value, row("availability").ToString(), Nothing)
        menuItem.image = If(row("image") IsNot DBNull.Value, row("image").ToString(), Nothing)
        
        If row("category_id") IsNot DBNull.Value Then
            menuItem.category_id = Convert.ToInt32(row("category_id"))
        End If
        
        If row("type_id") IsNot DBNull.Value Then
            menuItem.type_id = Convert.ToInt32(row("type_id"))
        End If
        
        menuItem.description = If(row("description") IsNot DBNull.Value, row("description").ToString(), Nothing)
        menuItem.no_of_serving = If(row("no_of_serving") IsNot DBNull.Value, row("no_of_serving").ToString(), Nothing)
        
        Return menuItem
    End Function
    
    Private Function MapDataRowToMenuCategory(ByVal row As DataRow) As MenuCategory
        Dim category As New MenuCategory()
        
        category.category_id = Convert.ToInt32(row("category_id"))
        category.category_name = If(row("category_name") IsNot DBNull.Value, row("category_name").ToString(), Nothing)
        category.description = If(row("description") IsNot DBNull.Value, row("description").ToString(), Nothing)
        category.is_active = If(row("is_active") IsNot DBNull.Value, Convert.ToBoolean(row("is_active")), False)
        
        Return category
    End Function
    
    Private Function MapDataRowToMenuType(ByVal row As DataRow) As MenuType
        Dim type As New MenuType()
        
        type.type_id = Convert.ToInt32(row("type_id"))
        type.type_name = If(row("type_name") IsNot DBNull.Value, row("type_name").ToString(), Nothing)
        type.description = If(row("description") IsNot DBNull.Value, row("description").ToString(), Nothing)
        type.is_active = If(row("is_active") IsNot DBNull.Value, Convert.ToBoolean(row("is_active")), False)
        
        Return type
    End Function
End Class 