Imports System.Data
Imports System.Web.UI.HtmlControls
Imports System.Web.UI

Partial Class Pages_Customer_CustomerOrders
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            ' Create a timer for auto-confirmation every 1 minute
            If Not IsPostBack Then
                ' Check if user is logged in
                If Session("CURRENT_SESSION") Is Nothing Then
                    Response.Redirect("~/Pages/LoginPortal/CustomerLoginPortal.aspx")
                    Return
                End If

                ' Load orders
                LoadOrders()
                
                ' Check if there's a 'new' parameter indicating a new order was placed
                If Request.QueryString("new") IsNot Nothing Then
                    If Request.QueryString("order_id") IsNot Nothing Then
                        ' Show order-specific message if order ID is provided
                        Dim orderId As Integer
                        If Integer.TryParse(Request.QueryString("order_id"), orderId) Then
                            ShowAlert("Your order #" & orderId & " has been placed successfully! Your order is now visible below with live status updates.", True)
                            
                            ' Register JavaScript to highlight the new order and show it immediately
                            Dim script As String = "setTimeout(function() { " & _
                                             "highlightOrder('" & orderId & "', true); " & _
                                             "}, 300);"
                            ClientScript.RegisterStartupScript(Me.GetType(), "HighlightNewOrder", script, True)
                        Else
                            ShowAlert("Your order has been placed successfully! View your order and delivery information below.", True)
                        End If
                    Else
                        ShowAlert("Your order has been placed successfully! View your order and delivery information below.", True)
                    End If
                End If
                
                ' Run auto-confirmation check
                CheckOrdersForAutoConfirmation()
            End If
        Catch ex As Exception
            ShowAlert("Error loading page: " & ex.Message, False)
            System.Diagnostics.Debug.WriteLine("Error in Page_Load: " & ex.Message)
        End Try
    End Sub

    Private Sub LoadOrders()
        Try
            Dim currentUser As Object = Session("CURRENT_SESSION")
            If currentUser Is Nothing Then
                Response.Redirect("~/Pages/LoginPortal/CustomerLoginPortal.aspx")
                Return
            End If
            
            System.Diagnostics.Debug.WriteLine("Loading orders for user: " & currentUser.user_id)
            
            ' First check for orders to auto-complete
            CheckOrdersForAutoConfirmation()
            
            ' Get orders with total amount and delivery information
            ' Sort by status priority (pending/processing first), then by date descending
            Dim query As String = "SELECT o.order_id, o.order_date, o.status, o.total_amount, " & _
                                "o.driver_name, o.delivery_service, o.tracking_link, o.transaction_id " & _
                                "FROM orders o " & _
                                "WHERE o.user_id = @user_id " & _
                                "ORDER BY " & _
                                "CASE " & _
                                "   WHEN o.status LIKE 'pending' THEN 1 " & _
                                "   WHEN o.status LIKE 'accepted' THEN 2 " & _
                                "   WHEN o.status LIKE 'processing' THEN 3 " & _
                                "   WHEN o.status LIKE 'preparing' THEN 4 " & _
                                "   WHEN o.status LIKE 'ready' THEN 5 " & _
                                "   WHEN o.status LIKE 'delivering' THEN 6 " & _
                                "   WHEN o.status LIKE 'completed' THEN 7 " & _
                                "   WHEN o.status LIKE 'cancelled' THEN 8 " & _
                                "   ELSE 9 " & _
                                "END ASC, o.order_date DESC"
            
            Connect.ClearParams()
            Connect.AddParam("@user_id", CInt(currentUser.user_id))
            Connect.Query(query)

            System.Diagnostics.Debug.WriteLine("Query returned " & Connect.DataCount & " orders")

            If Connect.DataCount > 0 Then
                OrdersRepeater.DataSource = Connect.Data
                OrdersRepeater.DataBind()
                EmptyOrdersPanel.Visible = False
                OrdersPanel.Visible = True
                System.Diagnostics.Debug.WriteLine("Orders found and bound to repeater")
            Else
                EmptyOrdersPanel.Visible = True
                OrdersPanel.Visible = False
                System.Diagnostics.Debug.WriteLine("No orders found for user")
            End If
        Catch ex As Exception
            ShowAlert("Error loading orders: " & ex.Message, False)
            System.Diagnostics.Debug.WriteLine("Error in LoadOrders: " & ex.Message)
            EmptyOrdersPanel.Visible = True
            OrdersPanel.Visible = False
        End Try
    End Sub

    Protected Sub OrdersRepeater_ItemDataBound(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
            Try
                Dim orderId As Integer = DirectCast(DataBinder.Eval(e.Item.DataItem, "order_id"), Integer)
                Dim orderItemsRepeater As Repeater = DirectCast(e.Item.FindControl("OrderItemsRepeater"), Repeater)
                Dim status As String = DataBinder.Eval(e.Item.DataItem, "status").ToString()
                Dim orderDate As DateTime = DirectCast(DataBinder.Eval(e.Item.DataItem, "order_date"), DateTime)
                
                System.Diagnostics.Debug.WriteLine("ItemDataBound: Processing order #" & orderId & " with status " & status)

                ' Get order items with menu details
                Dim itemsConnect As New Connection() ' Create a new Connection for this query
                Dim query As String = "SELECT oi.quantity, m.* " & _
                                    "FROM order_items oi " & _
                                    "INNER JOIN menu m ON oi.item_id = m.item_id " & _
                                    "WHERE oi.order_id = @order_id"

                itemsConnect.AddParam("@order_id", orderId)
                itemsConnect.Query(query)
                
                System.Diagnostics.Debug.WriteLine("ItemDataBound: Found " & itemsConnect.DataCount & " items for order #" & orderId)

                orderItemsRepeater.DataSource = itemsConnect.Data
                orderItemsRepeater.DataBind()

                ' Handle Reorder button visibility based on status
                Dim reorderButton As LinkButton = DirectCast(e.Item.FindControl("ReorderButton"), LinkButton)
                If reorderButton IsNot Nothing Then
                    ' Only show reorder button for completed orders
                    reorderButton.Visible = (status.ToLower() = "completed")
                End If
                
                ' Delivery Information Section
                Dim deliveryInfoPanel As Panel = DirectCast(e.Item.FindControl("DeliveryInfoPanel"), Panel)
                If deliveryInfoPanel IsNot Nothing Then
                    ' Always make the delivery info panel visible for all orders
                    deliveryInfoPanel.Visible = True
                    
                    ' Check if we have delivery information regardless of status
                    Dim hasDriverInfo As Boolean = False
                    Dim hasTrackingInfo As Boolean = False
                    
                    ' Set delivery service info
                    Dim deliveryServiceLiteral As Literal = DirectCast(e.Item.FindControl("DeliveryServiceLiteral"), Literal)
                    If deliveryServiceLiteral IsNot Nothing Then
                        Try
                            Dim deliveryService As Object = DataBinder.Eval(e.Item.DataItem, "delivery_service")
                            If deliveryService IsNot Nothing AndAlso Not IsDBNull(deliveryService) AndAlso Not String.IsNullOrEmpty(deliveryService.ToString()) Then
                                deliveryServiceLiteral.Text = deliveryService.ToString()
                                hasDriverInfo = True
                            Else
                                deliveryServiceLiteral.Text = "Not assigned yet"
                            End If
                        Catch ex As Exception
                            System.Diagnostics.Debug.WriteLine("Error binding delivery service: " & ex.Message)
                            deliveryServiceLiteral.Text = "Not assigned yet"
                        End Try
                    End If
                    
                    ' Set driver name info
                    Dim driverNameLiteral As Literal = DirectCast(e.Item.FindControl("DriverNameLiteral"), Literal)
                    If driverNameLiteral IsNot Nothing Then
                        Try
                            Dim driverName As Object = DataBinder.Eval(e.Item.DataItem, "driver_name")
                            If driverName IsNot Nothing AndAlso Not IsDBNull(driverName) AndAlso Not String.IsNullOrEmpty(driverName.ToString()) Then
                                driverNameLiteral.Text = driverName.ToString()
                                hasDriverInfo = True
                            Else
                                driverNameLiteral.Text = "Not assigned yet"
                            End If
                        Catch ex As Exception
                            System.Diagnostics.Debug.WriteLine("Error binding driver name: " & ex.Message)
                            driverNameLiteral.Text = "Not assigned yet"
                        End Try
                    End If
                    
                    ' Set tracking link if available
                    Dim trackingPanel As Panel = DirectCast(e.Item.FindControl("TrackingPanel"), Panel)
                    If trackingPanel IsNot Nothing Then
                        Try
                            Dim trackingLink As Object = DataBinder.Eval(e.Item.DataItem, "tracking_link")
                            If trackingLink IsNot Nothing AndAlso Not IsDBNull(trackingLink) AndAlso Not String.IsNullOrEmpty(trackingLink.ToString()) Then
                                Dim trackingHyperlink As HyperLink = DirectCast(e.Item.FindControl("TrackingLink"), HyperLink)
                                If trackingHyperlink IsNot Nothing Then
                                    trackingHyperlink.NavigateUrl = trackingLink.ToString()
                                    trackingPanel.Visible = True
                                    hasTrackingInfo = True
                                End If
                            Else
                                trackingPanel.Visible = False
                            End If
                        Catch ex As Exception
                            System.Diagnostics.Debug.WriteLine("Error binding tracking link: " & ex.Message)
                            trackingPanel.Visible = False
                        End Try
                    End If
                End If

                ' Check if order can be cancelled
                Dim cancelButtonPlaceholder As PlaceHolder = DirectCast(e.Item.FindControl("CancelButtonPlaceholder"), PlaceHolder)
                
                If cancelButtonPlaceholder IsNot Nothing AndAlso CanCancelOrder(orderDate, status) Then
                    ' Create a LinkButton for cancel
                    Dim cancelBtn As New LinkButton()
                    cancelBtn.ID = "CancelButton"
                    cancelBtn.CssClass = "cancel-btn"
                    cancelBtn.CommandName = "Cancel"
                    cancelBtn.CommandArgument = orderId.ToString()
                    cancelBtn.OnClientClick = "return confirm('Are you sure you want to cancel this order? This action cannot be undone.');"
                    
                    ' Create cancel button container div
                    Dim cancelBtnContainer As New HtmlGenericControl("div")
                    cancelBtnContainer.Attributes.Add("class", "cancel-btn-container")
                    
                    ' Create icon
                    Dim icon As New HtmlGenericControl("i")
                    icon.Attributes.Add("class", "fas fa-times")
                    cancelBtn.Controls.Add(icon)
                    
                    ' Add text to button
                    cancelBtn.Text = " Cancel Order"
                    
                    ' Add button to container and container to placeholder
                    cancelBtnContainer.Controls.Add(cancelBtn)
                    cancelButtonPlaceholder.Controls.Add(cancelBtnContainer)
                End If
                
                ' Check if order can be confirmed
                Dim confirmButtonPlaceholder As PlaceHolder = DirectCast(e.Item.FindControl("ConfirmButtonPlaceholder"), PlaceHolder)
                
                If confirmButtonPlaceholder IsNot Nothing AndAlso CanConfirmOrder(orderDate, status) Then
                    ' Create a LinkButton for confirmation
                    Dim confirmBtn As New LinkButton()
                    confirmBtn.ID = "ConfirmButton"
                    confirmBtn.CssClass = "confirm-btn"
                    confirmBtn.CommandName = "Confirm"
                    confirmBtn.CommandArgument = orderId.ToString()
                    confirmBtn.OnClientClick = "return confirm('Are you sure you want to confirm this order? This will indicate you received the order.');"
                    
                    ' Create confirm button container div
                    Dim confirmBtnContainer As New HtmlGenericControl("div")
                    confirmBtnContainer.Attributes.Add("class", "confirm-btn-container")
                    
                    ' Create icon
                    Dim icon As New HtmlGenericControl("i")
                    icon.Attributes.Add("class", "fas fa-check")
                    confirmBtn.Controls.Add(icon)
                    
                    ' Add text to button
                    confirmBtn.Text = " Confirm Order"
                    
                    ' Add button to container and container to placeholder
                    confirmBtnContainer.Controls.Add(confirmBtn)
                    confirmButtonPlaceholder.Controls.Add(confirmBtnContainer)
                End If
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error in ItemDataBound: " & ex.Message)
            End Try
        End If
    End Sub

    Protected Function GetStatusClass(ByVal status As String) As String
        Select Case status.ToLower()
            Case "pending"
                Return "status-pending"
            Case "accepted", "processing", "preparing", "ready"
                Return "status-processing"
            Case "delivering"
                Return "status-delivering"
            Case "completed"
                Return "status-completed"
            Case "cancelled", "declined"
                Return "status-cancelled"
            Case Else
                Return ""
        End Select
    End Function

    Protected Function GetStatusExplanation(ByVal status As String) As String
        Select Case status.ToLower()
            Case "pending"
                Return "Your order has been submitted and is waiting for restaurant confirmation."
            Case "accepted"
                Return "The restaurant has received your order and will begin preparing it soon."
            Case "processing"
                Return "Your order is being processed by the restaurant staff."
            Case "preparing"
                Return "The kitchen is currently preparing your food."
            Case "ready"
                Return "Your order is ready and will be assigned to a delivery service soon."
            Case "delivering"
                Return "Your order is on its way to you. If tracking information is available, you can follow your delivery in real-time."
            Case "completed"
                Return "Your order has been successfully delivered."
            Case "cancelled"
                Return "This order has been cancelled."
            Case "declined"
                Return "The restaurant was unable to fulfill this order."
            Case Else
                Return "Status information unavailable."
        End Select
    End Function

    Public Function ReorderItems(ByVal orderId As Integer) As String
        Try
            System.Diagnostics.Debug.WriteLine("ReorderItems: Attempting to reorder items from order #" & orderId)
            Dim currentUser As Object = HttpContext.Current.Session("CURRENT_SESSION")
            
            If currentUser Is Nothing Then
                System.Diagnostics.Debug.WriteLine("ReorderItems: User not logged in")
                Return "Error: Please log in to reorder items"
            End If

            ' Get items from the order
            Dim itemsConnect As New Connection()
            Dim query As String = "SELECT oi.item_id, oi.quantity " & _
                                "FROM order_items oi " & _
                                "WHERE oi.order_id = @order_id"

            itemsConnect.AddParam("@order_id", orderId)
            itemsConnect.Query(query)

            If itemsConnect.DataCount > 0 Then
                System.Diagnostics.Debug.WriteLine("ReorderItems: Found " & itemsConnect.DataCount & " items to reorder")
                
                ' Add each item to the cart
                For Each row As DataRow In itemsConnect.Data.Tables(0).Rows
                    Dim itemId As Integer = CInt(row("item_id"))
                    Dim quantity As Integer = CInt(row("quantity"))
                    
                    System.Diagnostics.Debug.WriteLine("ReorderItems: Processing item ID " & itemId & " with quantity " & quantity)
                    
                    ' Check if item already exists in cart
                    Dim checkConnect As New Connection()
                    Dim checkQuery As String = "SELECT cart_id, quantity FROM cart " & _
                                             "WHERE user_id = @user_id AND item_id = @item_id"

                    checkConnect.AddParam("@user_id", CInt(currentUser.user_id))
                    checkConnect.AddParam("@item_id", itemId)
                    checkConnect.Query(checkQuery)

                    If checkConnect.DataCount > 0 Then
                        ' Update quantity if item exists
                        Dim currentQuantity As Integer = CInt(checkConnect.Data.Tables(0).Rows(0)("quantity"))
                        Dim newQuantity As Integer = currentQuantity + quantity
                        newQuantity = Math.Min(newQuantity, 99) ' Limit quantity to 99

                        System.Diagnostics.Debug.WriteLine("ReorderItems: Item exists in cart - updating quantity from " & currentQuantity & " to " & newQuantity)
                        
                        Dim updateConnect As New Connection()
                        Dim updateQuery As String = "UPDATE cart " & _
                                                  "SET quantity = @quantity " & _
                                                  "WHERE user_id = @user_id AND item_id = @item_id"

                        updateConnect.AddParam("@user_id", CInt(currentUser.user_id))
                        updateConnect.AddParam("@item_id", itemId)
                        updateConnect.AddParam("@quantity", newQuantity)
                        updateConnect.Query(updateQuery)
                    Else
                        ' Insert new item if it doesn't exist
                        System.Diagnostics.Debug.WriteLine("ReorderItems: Adding new item to cart - ID " & itemId & " with quantity " & quantity)
                        
                        Dim insertConnect As New Connection()
                        Dim insertQuery As String = "INSERT INTO cart (user_id, item_id, quantity) " & _
                                                  "VALUES (@user_id, @item_id, @quantity)"

                        insertConnect.AddParam("@user_id", CInt(currentUser.user_id))
                        insertConnect.AddParam("@item_id", itemId)
                        insertConnect.AddParam("@quantity", Math.Min(quantity, 99))
                        insertConnect.Query(insertQuery)
                    End If
                Next

                System.Diagnostics.Debug.WriteLine("ReorderItems: All items added to cart successfully")
                Return "Success: Items added to cart!"
            Else
                System.Diagnostics.Debug.WriteLine("ReorderItems: No items found in order #" & orderId)
                Return "Error: No items found in the order."
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("ReorderItems: Error - " & ex.Message)
            Return "Error: " & ex.Message
        End Try
    End Function

    Protected Function GetImageUrl(ByVal imagePath As String) As String
        If String.IsNullOrEmpty(imagePath) Then
            Return ResolveUrl("~/Assets/Images/default-food.jpg")
        End If

        ' Check if the path already contains the full URL
        If imagePath.StartsWith("http") Then
            Return imagePath
        End If

        ' Check if the path starts with ~/ or /
        If Not imagePath.StartsWith("~/") AndAlso Not imagePath.StartsWith("/") Then
            imagePath = "~/Assets/Images/Menu/" & imagePath
        End If

        Return ResolveUrl(imagePath)
    End Function

    Protected Function CanCancelOrder(ByVal orderDate As DateTime, ByVal status As String) As Boolean
        ' Check if status is "pending"
        If Not status.ToLower() = "pending" Then
            Return False
        End If

        ' Check if the order is less than 30 minutes old
        Dim timeSinceOrder As TimeSpan = DateTime.Now - orderDate
        Return timeSinceOrder.TotalMinutes < 30
    End Function

    Public Function CancelOrder(ByVal orderId As Integer) As String
        Try
            System.Diagnostics.Debug.WriteLine("CancelOrder: Attempting to cancel order #" & orderId)
            Dim cancelConnect As New Connection()
            Dim currentUser As Object = HttpContext.Current.Session("CURRENT_SESSION")
            
            If currentUser Is Nothing Then
                System.Diagnostics.Debug.WriteLine("CancelOrder: User not logged in")
                Return "Error: Please log in to cancel orders"
            End If

            ' Verify that the order belongs to the current user and can be cancelled
            Dim checkQuery As String = "SELECT order_id, order_date, status " & _
                                    "FROM orders " & _
                                    "WHERE order_id = @order_id AND user_id = @user_id"

            cancelConnect.AddParam("@order_id", orderId)
            cancelConnect.AddParam("@user_id", CInt(currentUser.user_id))
            cancelConnect.Query(checkQuery)

            If cancelConnect.DataCount > 0 Then
                Dim orderStatus As String = cancelConnect.Data.Tables(0).Rows(0)("status").ToString()
                Dim orderDate As DateTime = CDate(cancelConnect.Data.Tables(0).Rows(0)("order_date"))
                
                System.Diagnostics.Debug.WriteLine("CancelOrder: Found order #" & orderId & " with status " & orderStatus)
                
                ' Use the CanCancelOrder function to check if cancellation is allowed
                If Not CanCancelOrder(orderDate, orderStatus) Then
                    If orderStatus.ToLower() <> "pending" Then
                        System.Diagnostics.Debug.WriteLine("CancelOrder: Cannot cancel - status not pending")
                        Return "Error: Only pending orders can be cancelled."
                    Else
                        System.Diagnostics.Debug.WriteLine("CancelOrder: Cannot cancel - order too old")
                        Return "Error: Orders can only be cancelled within 30 minutes of placing them."
                    End If
                End If

                ' Update the order status to "cancelled"
                Dim updateConnect As New Connection()
                Dim updateQuery As String = "UPDATE orders SET status = 'cancelled' WHERE order_id = @order_id"
                updateConnect.AddParam("@order_id", orderId)
                updateConnect.Query(updateQuery)
                
                System.Diagnostics.Debug.WriteLine("CancelOrder: Successfully cancelled order #" & orderId)
                Return "Success: Your order has been cancelled successfully."
            Else
                System.Diagnostics.Debug.WriteLine("CancelOrder: Order not found or unauthorized")
                Return "Error: Order not found or you are not authorized to cancel this order."
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("CancelOrder: Error - " & ex.Message)
            Return "Error: " & ex.Message
        End Try
    End Function

    Private Sub ShowAlert(ByVal message As String, ByVal isSuccess As Boolean)
        Try
            alertMessage.Visible = True
            If isSuccess Then
                alertMessage.Attributes("class") = "alert-message alert-success"
            Else
                alertMessage.Attributes("class") = "alert-message alert-danger"
            End If
            AlertLiteral.Text = message
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error showing alert: " & ex.Message)
        End Try
    End Sub

    Protected Sub OrdersRepeater_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        Dim orderId As Integer = Convert.ToInt32(e.CommandArgument)
        System.Diagnostics.Debug.WriteLine("OrdersRepeater_ItemCommand: Processing command " & e.CommandName & " for order ID " & orderId)
        
        If e.CommandName = "Reorder" Then
            Try
                Dim result As String = ReorderItems(orderId)
                
                If result.StartsWith("Success") Then
                    ' Redirect to cart page
                    Response.Redirect("CustomerCart.aspx")
                Else
                    ShowAlert(result, False)
                End If
            Catch ex As Exception
                ShowAlert("Error reordering items: " & ex.Message, False)
            End Try
        ElseIf e.CommandName = "Cancel" Then
            Try
                Dim result As String = CancelOrder(orderId)
                
                If result.StartsWith("Success") Then
                    ShowAlert(result, True)
                    ' Reload orders to show updated status
                    LoadOrders()
                Else
                    ShowAlert(result, False)
                End If
            Catch ex As Exception
                ShowAlert("Error cancelling order: " & ex.Message, False)
            End Try
        ElseIf e.CommandName = "Confirm" Then
            Try
                System.Diagnostics.Debug.WriteLine("Processing confirm command for order ID " & orderId)
                Dim result As String = ConfirmOrder(orderId)
                
                If result.StartsWith("Success") Then
                    System.Diagnostics.Debug.WriteLine("Order confirmed successfully")
                    ShowAlert("Order #" & orderId & " has been confirmed as completed!", True)
                    ' Reload orders to show updated status
                    LoadOrders()
                Else
                    System.Diagnostics.Debug.WriteLine("Order confirmation failed: " & result)
                    ShowAlert(result, False)
                End If
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error in Confirm command: " & ex.Message)
                ShowAlert("Error confirming order: " & ex.Message, False)
            End Try
        End If
    End Sub

    Protected Overrides Sub OnInit(ByVal e As EventArgs)
        MyBase.OnInit(e)
        
        ' No need to add ScriptManager programmatically
        ' The master page should already have a ScriptManager
    End Sub

    Protected Sub RefreshButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            ' Reload orders
            LoadOrders()
            ShowAlert("Orders refreshed successfully!", True)
            
            ' Check if there's a specific order to highlight (from query string)
            If Request.QueryString("order_id") IsNot Nothing Then
                Dim orderId As Integer
                If Integer.TryParse(Request.QueryString("order_id"), orderId) Then
                    ' Re-register the highlight JavaScript
                    Dim script As String = "setTimeout(function() { highlightOrder('" & orderId & "'); }, 500);"
                    ClientScript.RegisterStartupScript(Me.GetType(), "HighlightNewOrder", script, True)
                End If
            End If
        Catch ex As Exception
            ShowAlert("Error refreshing orders: " & ex.Message, False)
        End Try
    End Sub

    Protected Function CanConfirmOrder(ByVal orderDate As DateTime, ByVal status As String) As Boolean
        ' Allow confirmation for all active orders except completed and cancelled ones
        Dim statusLower As String = status.ToLower()
        
        If statusLower = "completed" OrElse statusLower = "cancelled" OrElse statusLower = "declined" Then
            Return False
        End If
        
        ' All other statuses can be confirmed (pending, accepted, processing, preparing, ready, delivering)
        Return True
    End Function

    Private Sub CheckOrdersForAutoConfirmation()
        Try
            Dim currentUser As Object = Session("CURRENT_SESSION")
            If currentUser Is Nothing Then
                Return
            End If
            
            ' Get orders that are pending/accepted and older than 5 hours
            Dim autoConfirmConnect As New Connection()
            Dim query As String = "SELECT order_id, status " & _
                               "FROM orders " & _
                               "WHERE user_id = @user_id " & _
                               "AND (status = 'pending' OR status = 'accepted') " & _
                               "AND DATEDIFF(HOUR, order_date, GETDATE()) >= 5"
                               
            autoConfirmConnect.AddParam("@user_id", CInt(currentUser.user_id))
            autoConfirmConnect.Query(query)
            
            If autoConfirmConnect.DataCount > 0 Then
                System.Diagnostics.Debug.WriteLine("Found " & autoConfirmConnect.DataCount & " orders to auto-confirm")
                
                ' Auto-confirm each qualifying order
                For Each row As DataRow In autoConfirmConnect.Data.Tables(0).Rows
                    Dim orderId As Integer = CInt(row("order_id"))
                    Dim updateConnect As New Connection()
                    Dim updateQuery As String = "UPDATE orders SET status = 'processing' WHERE order_id = @order_id"
                    
                    updateConnect.AddParam("@order_id", orderId)
                    updateConnect.Query(updateQuery)
                    
                    System.Diagnostics.Debug.WriteLine("Auto-confirmed order #" & orderId)
                Next
                
                ' If any orders were auto-confirmed, refresh the page
                If autoConfirmConnect.DataCount > 0 Then
                    LoadOrders()
                End If
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error in CheckOrdersForAutoConfirmation: " & ex.Message)
        End Try
    End Sub

    Public Function ConfirmOrder(ByVal orderId As Integer) As String
        Try
            System.Diagnostics.Debug.WriteLine("ConfirmOrder: Attempting to confirm order #" & orderId)
            Dim confirmConnect As New Connection()
            Dim currentUser As Object = HttpContext.Current.Session("CURRENT_SESSION")
            
            If currentUser Is Nothing Then
                System.Diagnostics.Debug.WriteLine("ConfirmOrder: User not logged in")
                Return "Error: Please log in to confirm orders"
            End If

            ' Verify that the order belongs to the current user and can be confirmed
            Dim checkQuery As String = "SELECT order_id, order_date, status " & _
                                    "FROM orders " & _
                                    "WHERE order_id = @order_id AND user_id = @user_id"

            confirmConnect.AddParam("@order_id", orderId)
            confirmConnect.AddParam("@user_id", CInt(currentUser.user_id))
            confirmConnect.Query(checkQuery)

            If confirmConnect.DataCount > 0 Then
                Dim orderStatus As String = confirmConnect.Data.Tables(0).Rows(0)("status").ToString()
                Dim orderDate As DateTime = CDate(confirmConnect.Data.Tables(0).Rows(0)("order_date"))
                
                System.Diagnostics.Debug.WriteLine("ConfirmOrder: Found order #" & orderId & " with status " & orderStatus)
                
                ' Use the CanConfirmOrder function to check if confirmation is allowed
                If Not CanConfirmOrder(orderDate, orderStatus) Then
                    If Not (orderStatus.ToLower() = "pending" OrElse orderStatus.ToLower() = "accepted") Then
                        System.Diagnostics.Debug.WriteLine("ConfirmOrder: Cannot confirm - status not pending or accepted")
                        Return "Error: Only pending or accepted orders can be confirmed."
                    Else
                        System.Diagnostics.Debug.WriteLine("ConfirmOrder: Cannot confirm - order too old (will be auto-confirmed)")
                        Return "Error: This order will be confirmed automatically."
                    End If
                End If

                ' Update the order status to "processing"
                Dim updateConnect As New Connection()
                Dim updateQuery As String = "UPDATE orders SET status = 'processing' WHERE order_id = @order_id"
                updateConnect.AddParam("@order_id", orderId)
                updateConnect.Query(updateQuery)
                
                System.Diagnostics.Debug.WriteLine("ConfirmOrder: Successfully confirmed order #" & orderId)
                Return "Success: Your order has been confirmed successfully."
            Else
                System.Diagnostics.Debug.WriteLine("ConfirmOrder: Order not found or unauthorized")
                Return "Error: Order not found or you are not authorized to confirm this order."
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("ConfirmOrder: Error - " & ex.Message)
            Return "Error: " & ex.Message
        End Try
    End Function
End Class 