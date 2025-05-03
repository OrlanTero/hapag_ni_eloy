Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Collections.Generic
Imports HapagDB

Public Class CartController
    Private conn As New Connection()
    
    Public Function GetCartByUserId(ByVal userId As Integer) As List(Of Cart)
        Dim cartItems As New List(Of Cart)()
        Dim query As String = "SELECT c.*, m.name AS item_name, m.price, m.image FROM cart c " & _
                             "INNER JOIN menu m ON c.item_id = m.item_id " & _
                             "WHERE c.user_id = @user_id"
        
        conn.AddParam("@user_id", userId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                Dim cart As Cart = MapDataRowToCart(row)
                
                ' Set menu item properties
                cart.MenuItem = New MenuItem()
                cart.MenuItem.item_id = cart.item_id
                cart.MenuItem.name = If(row("item_name") IsNot DBNull.Value, row("item_name").ToString(), Nothing)
                cart.MenuItem.price = If(row("price") IsNot DBNull.Value, row("price").ToString(), Nothing)
                cart.MenuItem.image = If(row("image") IsNot DBNull.Value, row("image").ToString(), Nothing)
                
                cartItems.Add(cart)
            Next
        End If
        
        Return cartItems
    End Function
    
    Public Function GetCartItemById(ByVal cartId As Integer) As Cart
        Dim query As String = "SELECT * FROM cart WHERE cart_id = @cart_id"
        conn.AddParam("@cart_id", cartId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            Return MapDataRowToCart(conn.Data.Tables(0).Rows(0))
        End If
        
        Return Nothing
    End Function
    
    Public Function AddToCart(ByVal userId As Integer, ByVal itemId As Integer, ByVal quantity As Integer) As Boolean
        ' Check if item already exists in cart
        Dim existingQuery As String = "SELECT * FROM cart WHERE user_id = @user_id AND item_id = @item_id"
        conn.AddParam("@user_id", userId)
        conn.AddParam("@item_id", itemId)
        
        If conn.Query(existingQuery) AndAlso conn.DataCount > 0 Then
            ' Item exists, update quantity
            Dim existingCart As Cart = MapDataRowToCart(conn.Data.Tables(0).Rows(0))
            Dim cartId As Integer = existingCart.cart_id
            Dim newQuantity As Integer = existingCart.quantity + quantity
            
            Return UpdateCartItemQuantity(cartId, newQuantity)
        Else
            ' Item doesn't exist, add new cart item
            Dim query As String = "INSERT INTO cart (user_id, item_id, quantity) VALUES (@user_id, @item_id, @quantity)"
            
            conn.AddParam("@user_id", userId)
            conn.AddParam("@item_id", itemId)
            conn.AddParam("@quantity", quantity)
            
            Return conn.Query(query)
        End If
    End Function
    
    Public Function UpdateCartItemQuantity(ByVal cartId As Integer, ByVal quantity As Integer) As Boolean
        Dim query As String = "UPDATE cart SET quantity = @quantity WHERE cart_id = @cart_id"
        
        conn.AddParam("@cart_id", cartId)
        conn.AddParam("@quantity", quantity)
        
        Return conn.Query(query)
    End Function
    
    Public Function RemoveFromCart(ByVal cartId As Integer) As Boolean
        Dim query As String = "DELETE FROM cart WHERE cart_id = @cart_id"
        
        conn.AddParam("@cart_id", cartId)
        
        Return conn.Query(query)
    End Function
    
    Public Function ClearCart(ByVal userId As Integer) As Boolean
        Dim query As String = "DELETE FROM cart WHERE user_id = @user_id"
        
        conn.AddParam("@user_id", userId)
        
        Return conn.Query(query)
    End Function
    
    Public Function GetCartTotal(ByVal userId As Integer) As Decimal
        Dim total As Decimal = 0
        Dim query As String = "SELECT SUM(m.price * c.quantity) AS total " & _
                             "FROM cart c " & _
                             "INNER JOIN menu m ON c.item_id = m.item_id " & _
                             "WHERE c.user_id = @user_id"
        
        conn.AddParam("@user_id", userId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 AndAlso conn.Data.Tables(0).Rows(0)("total") IsNot DBNull.Value Then
            total = Convert.ToDecimal(conn.Data.Tables(0).Rows(0)("total"))
        End If
        
        Return total
    End Function
    
    Private Function MapDataRowToCart(ByVal row As DataRow) As Cart
        Dim cart As New Cart()
        
        cart.cart_id = Convert.ToInt32(row("cart_id"))
        cart.user_id = Convert.ToInt32(row("user_id"))
        cart.item_id = Convert.ToInt32(row("item_id"))
        cart.quantity = Convert.ToInt32(row("quantity"))
        
        Return cart
    End Function
End Class 