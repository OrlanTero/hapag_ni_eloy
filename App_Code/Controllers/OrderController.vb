Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Collections.Generic
Imports HapagDB

Public Class OrderController
    Private conn As New Connection()
    
    Public Function GetOrderById(ByVal orderId As Integer) As Order
        Dim query As String = "SELECT * FROM orders WHERE order_id = @order_id"
        conn.AddParam("@order_id", orderId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            Dim order As Order = MapDataRowToOrder(conn.Data.Tables(0).Rows(0))
            
            ' Get order items
            order.OrderItems = GetOrderItemsByOrderId(orderId)
            
            Return order
        End If
        
        Return Nothing
    End Function
    
    Public Function GetAllOrders() As List(Of Order)
        Dim orders As New List(Of Order)()
        Dim query As String = "SELECT * FROM orders ORDER BY order_date DESC"
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                Dim order As Order = MapDataRowToOrder(row)
                
                ' Get order items
                order.OrderItems = GetOrderItemsByOrderId(order.order_id)
                
                orders.Add(order)
            Next
        End If
        
        Return orders
    End Function
    
    Public Function GetOrdersByUserId(ByVal userId As Integer) As List(Of Order)
        Dim orders As New List(Of Order)()
        Dim query As String = "SELECT * FROM orders WHERE user_id = @user_id ORDER BY order_date DESC"
        
        conn.AddParam("@user_id", userId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                Dim order As Order = MapDataRowToOrder(row)
                
                ' Get order items
                order.OrderItems = GetOrderItemsByOrderId(order.order_id)
                
                orders.Add(order)
            Next
        End If
        
        Return orders
    End Function
    
    Public Function GetOrdersByStatus(ByVal status As String) As List(Of Order)
        Dim orders As New List(Of Order)()
        Dim query As String = "SELECT * FROM orders WHERE status = @status ORDER BY order_date DESC"
        
        conn.AddParam("@status", status)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                Dim order As Order = MapDataRowToOrder(row)
                
                ' Get order items
                order.OrderItems = GetOrderItemsByOrderId(order.order_id)
                
                orders.Add(order)
            Next
        End If
        
        Return orders
    End Function
    
    Public Function CreateOrder(ByVal order As Order) As Integer
        ' Begin transaction
        Dim transactionQuery As String = "INSERT INTO transactions (payment_method, subtotal, total, user_id, total_amount, status, reference_number, sender_name, sender_number, transaction_date) " & _
                                         "VALUES (@payment_method, @subtotal, @total, @user_id, @total_amount, @status, @reference_number, @sender_name, @sender_number, @transaction_date); " & _
                                         "SELECT SCOPE_IDENTITY();"
        
        conn.AddParamWithNull("@payment_method", order.Transaction.payment_method)
        conn.AddParamWithNull("@subtotal", order.Transaction.subtotal)
        conn.AddParamWithNull("@total", order.Transaction.total)
        conn.AddParam("@user_id", order.user_id)
        conn.AddParam("@total_amount", order.total_amount)
        conn.AddParam("@status", "Pending")
        conn.AddParamWithNull("@reference_number", order.Transaction.reference_number)
        conn.AddParamWithNull("@sender_name", order.Transaction.sender_name)
        conn.AddParamWithNull("@sender_number", order.Transaction.sender_number)
        conn.AddParam("@transaction_date", DateTime.Now)
        
        If conn.Query(transactionQuery) AndAlso conn.DataCount > 0 Then
            Dim transactionId As Integer = Convert.ToInt32(conn.Data.Tables(0).Rows(0)(0))
            
            ' Create order
            Dim orderQuery As String = "INSERT INTO orders (user_id, transaction_id, subtotal, shipping_fee, tax, total_amount, status, order_date) " & _
                                       "VALUES (@user_id, @transaction_id, @subtotal, @shipping_fee, @tax, @total_amount, @status, @order_date); " & _
                                       "SELECT SCOPE_IDENTITY();"
            
            conn.AddParam("@user_id", order.user_id)
            conn.AddParam("@transaction_id", transactionId)
            conn.AddParamWithNull("@subtotal", order.subtotal)
            conn.AddParamWithNull("@shipping_fee", order.shipping_fee)
            conn.AddParamWithNull("@tax", order.tax)
            conn.AddParam("@total_amount", order.total_amount)
            conn.AddParam("@status", "Pending")
            conn.AddParam("@order_date", DateTime.Now)
            
            If conn.Query(orderQuery) AndAlso conn.DataCount > 0 Then
                Dim orderId As Integer = Convert.ToInt32(conn.Data.Tables(0).Rows(0)(0))
                
                ' Add order items
                If order.OrderItems IsNot Nothing Then
                    For Each item As OrderItem In order.OrderItems
                        Dim itemQuery As String = "INSERT INTO order_items (transaction_id, order_id, item_id, quantity, price) " & _
                                                 "VALUES (@transaction_id, @order_id, @item_id, @quantity, @price)"
                        
                        conn.AddParam("@transaction_id", transactionId)
                        conn.AddParam("@order_id", orderId)
                        conn.AddParam("@item_id", item.item_id)
                        conn.AddParam("@quantity", item.quantity)
                        conn.AddParam("@price", item.price)
                        
                        conn.Query(itemQuery)
                    Next
                End If
                
                Return orderId
            End If
        End If
        
        Return 0
    End Function
    
    Public Function UpdateOrderStatus(ByVal orderId As Integer, ByVal status As String) As Boolean
        Dim query As String = "UPDATE orders SET status = @status WHERE order_id = @order_id"
        
        conn.AddParam("@order_id", orderId)
        conn.AddParam("@status", status)
        
        Return conn.Query(query)
    End Function
    
    Public Function UpdateOrderDeliveryInfo(ByVal orderId As Integer, ByVal driverName As String, ByVal deliveryService As String, ByVal trackingLink As String, ByVal deliveryNotes As String) As Boolean
        Dim query As String = "UPDATE orders " & _
                             "SET driver_name = @driver_name, " & _
                             "    delivery_service = @delivery_service, " & _
                             "    tracking_link = @tracking_link, " & _
                             "    delivery_notes = @delivery_notes " & _
                             "WHERE order_id = @order_id"
        
        conn.AddParam("@order_id", orderId)
        conn.AddParamWithNull("@driver_name", driverName)
        conn.AddParamWithNull("@delivery_service", deliveryService)
        conn.AddParamWithNull("@tracking_link", trackingLink)
        conn.AddParamWithNull("@delivery_notes", deliveryNotes)
        
        Return conn.Query(query)
    End Function
    
    Public Function GetOrderItemsByOrderId(ByVal orderId As Integer) As List(Of OrderItem)
        Dim orderItems As New List(Of OrderItem)()
        Dim query As String = "SELECT oi.*, m.name as item_name FROM order_items oi " & _
                             "INNER JOIN menu m ON oi.item_id = m.item_id " & _
                             "WHERE oi.order_id = @order_id"
        
        conn.AddParam("@order_id", orderId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                Dim orderItem As OrderItem = MapDataRowToOrderItem(row)
                
                ' Set menu item properties
                orderItem.MenuItem = New MenuItem()
                orderItem.MenuItem.item_id = orderItem.item_id
                orderItem.MenuItem.name = If(row("item_name") IsNot DBNull.Value, row("item_name").ToString(), Nothing)
                
                orderItems.Add(orderItem)
            Next
        End If
        
        Return orderItems
    End Function
    
    Private Function MapDataRowToOrder(ByVal row As DataRow) As Order
        Dim order As New Order()
        
        order.order_id = Convert.ToInt32(row("order_id"))
        order.user_id = Convert.ToInt32(row("user_id"))
        order.order_date = Convert.ToDateTime(row("order_date"))
        
        If row("transaction_id") IsNot DBNull.Value Then
            order.transaction_id = Convert.ToInt32(row("transaction_id"))
        End If
        
        order.subtotal = If(row("subtotal") IsNot DBNull.Value, row("subtotal").ToString(), Nothing)
        order.shipping_fee = If(row("shipping_fee") IsNot DBNull.Value, row("shipping_fee").ToString(), Nothing)
        order.tax = If(row("tax") IsNot DBNull.Value, row("tax").ToString(), Nothing)
        order.total_amount = Convert.ToDecimal(row("total_amount"))
        order.status = row("status").ToString()
        order.driver_name = If(row("driver_name") IsNot DBNull.Value, row("driver_name").ToString(), Nothing)
        order.delivery_service = If(row("delivery_service") IsNot DBNull.Value, row("delivery_service").ToString(), Nothing)
        order.tracking_link = If(row("tracking_link") IsNot DBNull.Value, row("tracking_link").ToString(), Nothing)
        order.delivery_notes = If(row("delivery_notes") IsNot DBNull.Value, row("delivery_notes").ToString(), Nothing)
        
        Return order
    End Function
    
    Private Function MapDataRowToOrderItem(ByVal row As DataRow) As OrderItem
        Dim orderItem As New OrderItem()
        
        orderItem.order_item_id = Convert.ToInt32(row("order_item_id"))
        orderItem.transaction_id = Convert.ToInt32(row("transaction_id"))
        orderItem.item_id = Convert.ToInt32(row("item_id"))
        orderItem.quantity = Convert.ToInt32(row("quantity"))
        orderItem.price = Convert.ToDecimal(row("price"))
        
        If row("order_id") IsNot DBNull.Value Then
            orderItem.order_id = Convert.ToInt32(row("order_id"))
        End If
        
        Return orderItem
    End Function
End Class