Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls
Imports HapagDB

Partial Class Pages_Admin_AdminOrders
    Inherits System.Web.UI.Page
    Private orderController As New OrderController()
    Private Connect As New Connection() ' Keep this for now as we'll migrate functionality gradually

    ' Helper method for logging errors
    Private Sub LogError(ByVal errorMessage As String)
        System.Diagnostics.Debug.WriteLine(errorMessage)
        ' You can add additional error logging here if needed
    End Sub

    ' Helper method to display alert messages to the user
    Private Sub ShowAlert(ByVal message As String, ByVal alertType As String)
        If alertMessage IsNot Nothing Then
            alertMessage.Visible = True
            AlertLiteral.Text = "<div class='alert " & alertType & "'>" & message & "</div>"
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Check if delivery columns exist and create them if they don't
        EnsureDeliveryColumnsExist()
        
        ' Check if transaction status columns exist and create them if they don't
        EnsureTransactionStatusColumnsExist()

        ' Set the current year in the footer
        YearLiteral.Text = DateTime.Now.Year.ToString()

        If Not IsPostBack Then
            ' Clear any previous search/filter values
            ViewState("SearchTerm") = Nothing
            ViewState("SelectedStatus") = Nothing
            SearchBox.Text = String.Empty
            StatusDropDown.SelectedIndex = 0
            
            ' Load all orders with no filters
            LoadOrders()
        End If
    End Sub

    ' Function to ensure delivery columns exist in the orders table
    Private Sub EnsureDeliveryColumnsExist()
        Try
            System.Diagnostics.Debug.WriteLine("Ensuring delivery columns exist in orders table...")
            
            ' First get a list of columns that already exist
            Dim columnsQuery As String = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS " & _
                                      "WHERE TABLE_NAME = 'orders' AND COLUMN_NAME IN " & _
                                      "('driver_name', 'delivery_service', 'tracking_link', 'delivery_notes')"
            Connect.ClearParams()
            Connect.Query(columnsQuery)
            
            ' Create hashset of existing column names for easy lookup
            Dim existingColumns As New HashSet(Of String)
            If Connect.DataCount > 0 Then
                For Each row As DataRow In Connect.Data.Tables(0).Rows
                    existingColumns.Add(row("COLUMN_NAME").ToString().ToLower())
                Next
            End If
            
            System.Diagnostics.Debug.WriteLine("Existing delivery columns: " & String.Join(", ", existingColumns))
            
            ' Add each missing column individually
            Try
                If Not existingColumns.Contains("driver_name") Then
                    System.Diagnostics.Debug.WriteLine("Adding driver_name column...")
                    Dim alterQuery As String = "ALTER TABLE orders ADD driver_name VARCHAR(100) NULL"
                    Connect.Query(alterQuery)
                    System.Diagnostics.Debug.WriteLine("driver_name column added successfully")
                End If
                
                If Not existingColumns.Contains("delivery_service") Then
                    System.Diagnostics.Debug.WriteLine("Adding delivery_service column...")
                    Dim alterQuery As String = "ALTER TABLE orders ADD delivery_service VARCHAR(50) NULL"
                    Connect.Query(alterQuery)
                    System.Diagnostics.Debug.WriteLine("delivery_service column added successfully")
                End If
                
                If Not existingColumns.Contains("tracking_link") Then
                    System.Diagnostics.Debug.WriteLine("Adding tracking_link column...")
                    Dim alterQuery As String = "ALTER TABLE orders ADD tracking_link VARCHAR(255) NULL"
                    Connect.Query(alterQuery)
                    System.Diagnostics.Debug.WriteLine("tracking_link column added successfully")
                End If
                
                If Not existingColumns.Contains("delivery_notes") Then
                    System.Diagnostics.Debug.WriteLine("Adding delivery_notes column...")
                    Dim alterQuery As String = "ALTER TABLE orders ADD delivery_notes VARCHAR(500) NULL"
                    Connect.Query(alterQuery)
                    System.Diagnostics.Debug.WriteLine("delivery_notes column added successfully")
                End If
                
                ' Display message to admin if any columns were added
                If existingColumns.Count < 4 Then
                    ShowAlert("Delivery columns have been added to the database.", "alert-info")
                    System.Diagnostics.Debug.WriteLine("Successfully added missing delivery columns to orders table")
                Else
                    System.Diagnostics.Debug.WriteLine("All delivery columns already exist")
                End If
            Catch alterEx As Exception
                ' Log the specific error when altering the table
                System.Diagnostics.Debug.WriteLine("Error adding delivery columns: " & alterEx.Message)
                ShowAlert("Error adding delivery columns: " & alterEx.Message, "alert-danger")
            End Try
        Catch ex As Exception
            ' Log the error but continue execution
            System.Diagnostics.Debug.WriteLine("Error checking delivery columns: " & ex.Message)
            ShowAlert("Error checking delivery columns: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Function to ensure transaction status columns exist in the transactions table
    Private Sub EnsureTransactionStatusColumnsExist()
        Try
            System.Diagnostics.Debug.WriteLine("Ensuring transaction status columns exist in transactions table...")
            
            ' First get a list of columns that already exist
            Dim columnsQuery As String = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS " & _
                                      "WHERE TABLE_NAME = 'transactions' AND COLUMN_NAME IN " & _
                                      "('status', 'verification_date')"
            Connect.ClearParams()
            Connect.Query(columnsQuery)
            
            ' Create hashset of existing column names for easy lookup
            Dim existingColumns As New HashSet(Of String)
            If Connect.DataCount > 0 Then
                For Each row As DataRow In Connect.Data.Tables(0).Rows
                    existingColumns.Add(row("COLUMN_NAME").ToString().ToLower())
                Next
            End If
            
            System.Diagnostics.Debug.WriteLine("Existing transaction status columns: " & String.Join(", ", existingColumns))
            
            ' Add each missing column individually
            Try
                If Not existingColumns.Contains("status") Then
                    System.Diagnostics.Debug.WriteLine("Adding status column to transactions table...")
                    Dim alterQuery As String = "ALTER TABLE transactions ADD status VARCHAR(50) NULL"
                    Connect.Query(alterQuery)
                    System.Diagnostics.Debug.WriteLine("status column added successfully")
                End If
                
                If Not existingColumns.Contains("verification_date") Then
                    System.Diagnostics.Debug.WriteLine("Adding verification_date column to transactions table...")
                    Dim alterQuery As String = "ALTER TABLE transactions ADD verification_date DATETIME NULL"
                    Connect.Query(alterQuery)
                    System.Diagnostics.Debug.WriteLine("verification_date column added successfully")
                End If
                
                ' Display message to admin if any columns were added
                If existingColumns.Count < 2 Then
                    ShowAlert("Transaction status columns have been added to the database.", "alert-info")
                    System.Diagnostics.Debug.WriteLine("Successfully added missing transaction status columns to transactions table")
                Else
                    System.Diagnostics.Debug.WriteLine("All transaction status columns already exist")
                End If
            Catch alterEx As Exception
                ' Log the specific error when altering the table
                System.Diagnostics.Debug.WriteLine("Error adding transaction status columns: " & alterEx.Message)
                ShowAlert("Error adding transaction status columns: " & alterEx.Message, "alert-danger")
            End Try
        Catch ex As Exception
            ' Log the error but continue execution
            System.Diagnostics.Debug.WriteLine("Error checking transaction status columns: " & ex.Message)
            ShowAlert("Error checking transaction status columns: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Modify the LoadOrders method to handle potential missing columns gracefully
    Private Sub LoadOrders()
        Try
            ' First check if all columns exist
            Dim columnExists As Boolean = DoColumnsExist()

            ' Get all orders with customer information
            Dim orders As New DataTable()
            orders.Columns.Add("order_id", GetType(Integer))
            orders.Columns.Add("order_date", GetType(DateTime))
            orders.Columns.Add("status", GetType(String))
            orders.Columns.Add("subtotal", GetType(String))
            orders.Columns.Add("total_amount", GetType(Decimal))
            orders.Columns.Add("customer_name", GetType(String))
            orders.Columns.Add("customer_contact", GetType(String))
            orders.Columns.Add("customer_address", GetType(String))
            orders.Columns.Add("delivery_address", GetType(String))
            orders.Columns.Add("transaction_id", GetType(Integer))
            orders.Columns.Add("delivery_type", GetType(String))
            orders.Columns.Add("discount_info", GetType(String))
            orders.Columns.Add("payment_method", GetType(String))
            orders.Columns.Add("app_name", GetType(String))
            orders.Columns.Add("tracking_url", GetType(String))
            orders.Columns.Add("estimated_time", GetType(String))
            
            ' Add columns for GCash payment details
            orders.Columns.Add("reference_number", GetType(String))
            orders.Columns.Add("sender_name", GetType(String))
            orders.Columns.Add("sender_number", GetType(String))
            orders.Columns.Add("transaction_status", GetType(String))
            orders.Columns.Add("verification_date", GetType(String))

            If columnExists Then
                orders.Columns.Add("driver_name", GetType(String))
                orders.Columns.Add("delivery_service", GetType(String))
                orders.Columns.Add("tracking_link", GetType(String))
                orders.Columns.Add("delivery_notes", GetType(String))
            End If

            ' Get all orders using the OrderController
            Dim allOrders = orderController.GetAllOrders()
            
            ' Create a user controller to get user info
            Dim userController As New UserController()
            
            ' Create a customer address controller to get delivery addresses
            Dim addressController As New CustomerAddressController()
            
            ' Now get user information for each order and populate the DataTable
            For Each order In allOrders
                ' Skip if doesn't match search term
                Dim user = userController.GetUserById(order.user_id)
                Dim userName As String = If(user IsNot Nothing, user.display_name, "Unknown")
                
                ' Apply search term filter if provided
                If Not String.IsNullOrEmpty(searchTerm) Then
                    ' Check if any relevant fields match the search term
                    Dim orderIdMatch As Boolean = order.order_id.ToString().Contains(searchTerm)
                    Dim statusMatch As Boolean = order.status.ToLower().Contains(searchTerm.ToLower())
                    Dim userNameMatch As Boolean = userName.ToLower().Contains(searchTerm.ToLower())
                    Dim amountMatch As Boolean = order.total_amount.ToString().Contains(searchTerm)
                    
                    ' Skip if no match
                    If Not (orderIdMatch Or statusMatch Or userNameMatch Or amountMatch) Then
                        Continue For
                    End If
                End If
                
                ' Apply status filter if provided
                If Not String.IsNullOrEmpty(selectedStatus) Then
                    If Not order.status.ToLower().Equals(selectedStatus.ToLower()) Then
                        Continue For
                    End If
                End If
                
                ' Get transaction details to get payment method
                Dim paymentMethod As String = "Unknown"
                Dim appName As String = ""
                Dim trackingUrl As String = ""
                Dim estimatedTime As String = ""
                Dim referenceNumber As String = ""
                Dim senderName As String = ""
                Dim senderNumber As String = ""
                Dim transactionStatus As String = "Pending"
                Dim verificationDate As String = ""
                
                If order.transaction_id > 0 Then
                    Dim transactionQuery As String = "SELECT payment_method, app_name, tracking_url, estimated_time, " & _
                                                   "reference_number, sender_name, sender_number, " & _
                                                   "status, verification_date " & _
                                                   "FROM transactions WHERE transaction_id = @transaction_id"
                    Connect.ClearParams()
                    Connect.AddParam("@transaction_id", order.transaction_id)
                    Connect.Query(transactionQuery)
                    
                    If Connect.DataCount > 0 Then
                        Dim transactionRow As DataRow = Connect.Data.Tables(0).Rows(0)
                        paymentMethod = If(transactionRow("payment_method") IsNot DBNull.Value, transactionRow("payment_method").ToString(), "Unknown")
                        appName = If(transactionRow("app_name") IsNot DBNull.Value, transactionRow("app_name").ToString(), "")
                        trackingUrl = If(transactionRow("tracking_url") IsNot DBNull.Value, transactionRow("tracking_url").ToString(), "")
                        estimatedTime = If(transactionRow("estimated_time") IsNot DBNull.Value, transactionRow("estimated_time").ToString(), "")
                        referenceNumber = If(transactionRow("reference_number") IsNot DBNull.Value, transactionRow("reference_number").ToString(), "")
                        senderName = If(transactionRow("sender_name") IsNot DBNull.Value, transactionRow("sender_name").ToString(), "")
                        senderNumber = If(transactionRow("sender_number") IsNot DBNull.Value, transactionRow("sender_number").ToString(), "")
                        
                        ' Get transaction status if the column exists
                        If transactionRow.Table.Columns.Contains("status") Then
                            transactionStatus = If(transactionRow("status") IsNot DBNull.Value, transactionRow("status").ToString(), "Pending")
                        End If
                        
                        ' Get verification date if the column exists
                        If transactionRow.Table.Columns.Contains("verification_date") AndAlso transactionRow("verification_date") IsNot DBNull.Value Then
                            verificationDate = Convert.ToDateTime(transactionRow("verification_date")).ToString("MMM dd, yyyy hh:mm tt")
                        End If
                        
                        ' Log GCash payment info
                        If paymentMethod.ToLower().Contains("gcash") Then
                            System.Diagnostics.Debug.WriteLine("GCash payment found for Order #" & order.order_id)
                            System.Diagnostics.Debug.WriteLine("  Status: " & order.status)
                            System.Diagnostics.Debug.WriteLine("  Transaction Status: " & transactionStatus)
                            System.Diagnostics.Debug.WriteLine("  Reference #: " & referenceNumber)
                            System.Diagnostics.Debug.WriteLine("  Sender: " & senderName)
                            System.Diagnostics.Debug.WriteLine("  Number: " & senderNumber)
                            
                            ' For pending GCash payments, make sure we log this
                            If order.status.ToLower() = "pending" Then
                                System.Diagnostics.Debug.WriteLine("  *** This order should show verification buttons ***")
                            End If
                        End If
                    End If
                End If
                
                ' Try to get delivery address from customer_addresses if there's any
                Dim deliveryAddress As String = "Not specified"
                
                ' Extract delivery info from delivery_notes if available
                Dim discountInfo As String = "None"
                Dim deliveryType As String = "Standard"
                
                If order.delivery_notes IsNot Nothing AndAlso order.delivery_notes.Trim().Length > 0 Then
                    ' Parse delivery notes to extract discount information
                    ' Format is typically: "Delivery Type: {type}. Discount: {amount}. Promotion: {amount}. Deal: {amount}"
                    Dim notes As String = order.delivery_notes
                    
                    ' Extract delivery type
                    If notes.Contains("Delivery Type:") Then
                        Dim startIndex As Integer = notes.IndexOf("Delivery Type:") + "Delivery Type:".Length
                        Dim endIndex As Integer = notes.IndexOf(".", startIndex)
                        If endIndex > startIndex Then
                            deliveryType = notes.Substring(startIndex, endIndex - startIndex).Trim()
                        End If
                    End If
                    
                    ' Build discount info from all discount types
                    Dim discountInfoBuilder As New System.Text.StringBuilder()
                    
                    ' Extract discount amount
                    If notes.Contains("Discount:") Then
                        Dim startIndex As Integer = notes.IndexOf("Discount:") + "Discount:".Length
                        Dim endIndex As Integer = notes.IndexOf(".", startIndex)
                        If endIndex > startIndex Then
                            Dim discountAmount As String = notes.Substring(startIndex, endIndex - startIndex).Trim()
                            If discountAmount <> "0" AndAlso discountAmount <> "0.00" Then
                                discountInfoBuilder.Append("Discount: PHP " & discountAmount)
                            End If
                        End If
                    End If
                    
                    ' Extract promotion amount
                    If notes.Contains("Promotion:") Then
                        Dim startIndex As Integer = notes.IndexOf("Promotion:") + "Promotion:".Length
                        Dim endIndex As Integer = notes.IndexOf(".", startIndex)
                        If endIndex > startIndex Then
                            Dim promotionAmount As String = notes.Substring(startIndex, endIndex - startIndex).Trim()
                            If promotionAmount <> "0" AndAlso promotionAmount <> "0.00" Then
                                If discountInfoBuilder.Length > 0 Then
                                    discountInfoBuilder.Append(", ")
                                End If
                                discountInfoBuilder.Append("Promotion: PHP " & promotionAmount)
                            End If
                        End If
                    End If
                    
                    ' Extract deal amount
                    If notes.Contains("Deal:") Then
                        Dim startIndex As Integer = notes.IndexOf("Deal:") + "Deal:".Length
                        Dim endIndex As Integer = notes.IndexOf(".", startIndex)
                        If endIndex > startIndex Then
                            Dim dealAmount As String = notes.Substring(startIndex, endIndex - startIndex).Trim()
                            If dealAmount <> "0" AndAlso dealAmount <> "0.00" Then
                                If discountInfoBuilder.Length > 0 Then
                                    discountInfoBuilder.Append(", ")
                                End If
                                discountInfoBuilder.Append("Deal: PHP " & dealAmount)
                            End If
                        End If
                    End If
                    
                    If discountInfoBuilder.Length > 0 Then
                        discountInfo = discountInfoBuilder.ToString()
                    End If
                End If
                
                ' Create a data row for the order
                Dim orderDataRow = orders.NewRow()
                orderDataRow("order_id") = order.order_id
                orderDataRow("order_date") = order.order_date
                orderDataRow("status") = order.status
                orderDataRow("subtotal") = order.subtotal
                orderDataRow("total_amount") = order.total_amount
                orderDataRow("transaction_id") = order.transaction_id
                orderDataRow("delivery_type") = deliveryType
                orderDataRow("discount_info") = discountInfo
                orderDataRow("payment_method") = paymentMethod
                orderDataRow("delivery_address") = deliveryAddress
                orderDataRow("app_name") = appName
                orderDataRow("tracking_url") = trackingUrl
                orderDataRow("estimated_time") = estimatedTime
                orderDataRow("reference_number") = referenceNumber
                orderDataRow("sender_name") = senderName
                orderDataRow("sender_number") = senderNumber
                orderDataRow("transaction_status") = transactionStatus
                orderDataRow("verification_date") = verificationDate
                
                ' Populate customer info
                If user IsNot Nothing Then
                    orderDataRow("customer_name") = user.display_name
                    orderDataRow("customer_contact") = user.contact
                    orderDataRow("customer_address") = user.address
                Else
                    orderDataRow("customer_name") = "Unknown"
                    orderDataRow("customer_contact") = "Unknown"
                    orderDataRow("customer_address") = "Unknown"
                End If

                ' Populate delivery info if columns exist
                If columnExists Then
                    orderDataRow("driver_name") = If(order.driver_name IsNot Nothing, order.driver_name, "Not assigned")
                    orderDataRow("delivery_service") = If(order.delivery_service IsNot Nothing, order.delivery_service, "Not specified")
                    orderDataRow("tracking_link") = If(order.tracking_link IsNot Nothing, order.tracking_link, "")
                    orderDataRow("delivery_notes") = If(order.delivery_notes IsNot Nothing, order.delivery_notes, "")
                End If
                
                orders.Rows.Add(orderDataRow)
            Next

            If orders.Rows.Count > 0 Then
                Dim dataset As New DataSet()
                dataset.Tables.Add(orders)
                
                OrdersListView.DataSource = dataset
                OrdersListView.DataBind()
            Else
                OrdersListView.DataSource = Nothing
                OrdersListView.DataBind()
                ShowAlert("No orders found.", "alert-info")
            End If
        Catch ex As Exception
            ShowAlert("Error loading orders: " & ex.Message, "alert-danger")
            System.Diagnostics.Debug.WriteLine("Error in LoadOrders: " & ex.Message)
            System.Diagnostics.Debug.WriteLine("Stack trace: " & ex.StackTrace)
        End Try
    End Sub

    ' Helper function to check if all needed columns exist
    Private Function DoColumnsExist() As Boolean
        Try
            System.Diagnostics.Debug.WriteLine("Checking if delivery columns exist...")
            
            Dim checkQuery As String = "SELECT " & _
                                     "SUM(CASE WHEN COLUMN_NAME = 'driver_name' THEN 1 ELSE 0 END) AS has_driver, " & _
                                     "SUM(CASE WHEN COLUMN_NAME = 'delivery_service' THEN 1 ELSE 0 END) AS has_service, " & _
                                     "SUM(CASE WHEN COLUMN_NAME = 'tracking_link' THEN 1 ELSE 0 END) AS has_tracking, " & _
                                     "SUM(CASE WHEN COLUMN_NAME = 'delivery_notes' THEN 1 ELSE 0 END) AS has_notes " & _
                                     "FROM INFORMATION_SCHEMA.COLUMNS " & _
                                     "WHERE TABLE_NAME = 'orders'"

            Connect.ClearParams()
            Connect.Query(checkQuery)

            If Connect.DataCount > 0 Then
                Dim row As DataRow = Connect.Data.Tables(0).Rows(0)
                Dim hasDriver As Integer = Convert.ToInt32(row("has_driver"))
                Dim hasService As Integer = Convert.ToInt32(row("has_service"))  
                Dim hasTracking As Integer = Convert.ToInt32(row("has_tracking"))
                Dim hasNotes As Integer = Convert.ToInt32(row("has_notes"))
                
                System.Diagnostics.Debug.WriteLine("Column check results:")
                System.Diagnostics.Debug.WriteLine("  driver_name: " & hasDriver)
                System.Diagnostics.Debug.WriteLine("  delivery_service: " & hasService)
                System.Diagnostics.Debug.WriteLine("  tracking_link: " & hasTracking)
                System.Diagnostics.Debug.WriteLine("  delivery_notes: " & hasNotes)
                
                ' If we have all 4 columns, return true
                Dim allColumnsExist As Boolean = (hasDriver = 1 AndAlso hasService = 1 AndAlso hasTracking = 1 AndAlso hasNotes = 1)
                System.Diagnostics.Debug.WriteLine("All columns exist: " & allColumnsExist)
                Return allColumnsExist
            Else
                System.Diagnostics.Debug.WriteLine("No column info returned from query")
                Return False
            End If
        Catch ex As Exception
            ' On error, assume columns don't exist
            System.Diagnostics.Debug.WriteLine("Error checking columns: " & ex.Message)
            Return False
        End Try
    End Function

    Protected Function GetOrderItems(ByVal orderId As Integer) As DataTable
        Try
            Dim query As String = "SELECT oi.order_item_id, oi.item_id, oi.quantity, oi.price, " & _
                                "m.name, m.category, m.type, m.image " & _
                                "FROM order_items oi " & _
                                "INNER JOIN menu m ON oi.item_id = m.item_id " & _
                                "WHERE oi.order_id = @order_id"

            Connect.ClearParams()
            Connect.AddParam("@order_id", orderId)
            Dim success As Boolean = Connect.Query(query)
            
            System.Diagnostics.Debug.WriteLine("GetOrderItems for order ID " & orderId & ": Success=" & success & ", Count=" & Connect.DataCount)

            If Connect.DataCount > 0 Then
                Return Connect.Data.Tables(0)
            Else
                ' Create an empty table with the expected columns
                Dim emptyTable As New DataTable()
                emptyTable.Columns.Add("order_item_id", GetType(Integer))
                emptyTable.Columns.Add("item_id", GetType(Integer))
                emptyTable.Columns.Add("quantity", GetType(Integer))
                emptyTable.Columns.Add("price", GetType(Decimal))
                emptyTable.Columns.Add("name", GetType(String))
                emptyTable.Columns.Add("category", GetType(String))
                emptyTable.Columns.Add("type", GetType(String))
                emptyTable.Columns.Add("image", GetType(String))
                Return emptyTable
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error in GetOrderItems: " & ex.Message)
            
            ' Create an empty table with the expected columns
            Dim errorTable As New DataTable()
            errorTable.Columns.Add("order_item_id", GetType(Integer))
            errorTable.Columns.Add("item_id", GetType(Integer))
            errorTable.Columns.Add("quantity", GetType(Integer))
            errorTable.Columns.Add("price", GetType(Decimal))
            errorTable.Columns.Add("name", GetType(String))
            errorTable.Columns.Add("category", GetType(String))
            errorTable.Columns.Add("type", GetType(String))
            errorTable.Columns.Add("image", GetType(String))
            
            ' Add a row with error information
            Dim row As DataRow = errorTable.NewRow()
            row("name") = "Error loading items: " & ex.Message
            row("quantity") = 0
            row("price") = 0
            errorTable.Rows.Add(row)
            
            Return errorTable
        End Try
    End Function

    Protected Sub OrdersListView_ItemCommand(sender As Object, e As ListViewCommandEventArgs) Handles OrdersListView.ItemCommand
        Dim orderId As Integer = Convert.ToInt32(e.CommandArgument)
        System.Diagnostics.Debug.WriteLine("Command received: " & e.CommandName & " for order " & orderId.ToString())
        
        Try
            Select Case e.CommandName
                Case "ViewDetails"
                    ' Debugging
                    System.Diagnostics.Debug.WriteLine("View Details button clicked for order " & orderId.ToString())
                    
                    ' Create a more robust script with detailed console logging
                    Dim script As String = "" & _
                        "console.log('Attempting to toggle order details for order #" & orderId.ToString() & "');" & _
                        "var detailsId = 'order-details-" & orderId.ToString() & "';" & _
                        "console.log('Looking for element with ID: ' + detailsId);" & _
                        "var detailsElement = document.getElementById(detailsId);" & _
                        "if (detailsElement) {" & _
                        "    console.log('Found element! Current display style: ' + detailsElement.style.display);" & _
                        "    if (detailsElement.style.display === 'none' || detailsElement.style.display === '') {" & _
                        "        detailsElement.style.display = 'block';" & _
                        "        console.log('Set display to block');" & _
                        "    } else {" & _
                        "        detailsElement.style.display = 'none';" & _
                        "        console.log('Set display to none');" & _
                        "    }" & _
                        "} else {" & _
                        "    console.error('Element not found with ID: ' + detailsId);" & _
                        "    console.log('Attempting alternate method...');" & _
                        "    var containers = document.getElementsByClassName('order-details-container');" & _
                        "    console.log('Found ' + containers.length + ' order-details-container elements');" & _
                        "    for (var i = 0; i < containers.length; i++) {" & _
                        "        console.log('Container ' + i + ' ID: ' + containers[i].id);" & _
                        "        if (containers[i].id.indexOf('" & orderId.ToString() & "') !== -1) {" & _
                        "            console.log('Found matching container: ' + containers[i].id);" & _
                        "            if (containers[i].style.display === 'none' || containers[i].style.display === '') {" & _
                        "                containers[i].style.display = 'block';" & _
                        "                console.log('Set display to block');" & _
                        "            } else {" & _
                        "                containers[i].style.display = 'none';" & _
                        "                console.log('Set display to none');" & _
                        "            }" & _
                        "            break;" & _
                        "        }" & _
                        "    }" & _
                        "}"
                    
                    ' Use the existing ScriptManager if it exists, otherwise use ClientScript
                    Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
                    If sm IsNot Nothing Then
                        System.Diagnostics.Debug.WriteLine("Using ScriptManager to register script")
                        sm.RegisterStartupScript(Me, Me.GetType(), "ToggleDetails" & orderId, script, True)
                    Else
                        System.Diagnostics.Debug.WriteLine("Using ClientScript to register script")
                        Page.ClientScript.RegisterStartupScript(Me.GetType(), "ToggleDetails" & orderId, script, True)
                    End If
            
                Case "VerifyPayment"
                    Try
                        System.Diagnostics.Debug.WriteLine("=== VERIFY PAYMENT COMMAND STARTED ===")
                        System.Diagnostics.Debug.WriteLine("Order ID: " & orderId.ToString())

                        ' Get order and transaction details
                        Dim order = orderController.GetOrderById(orderId)
                        
                        ' Log the verify payment action for debugging
                        System.Diagnostics.Debug.WriteLine("VerifyPayment command received for order " & orderId.ToString())
                        System.Diagnostics.Debug.WriteLine("Order object retrieved: " & (order IsNot Nothing).ToString())
                        
                        If order IsNot Nothing Then
                            System.Diagnostics.Debug.WriteLine("Order transaction ID: " & order.transaction_id.ToString())
                            System.Diagnostics.Debug.WriteLine("Order status: " & order.status)
                            
                            If order.transaction_id > 0 Then
                                ' Store IDs for reference
                                PaymentOrderId.Value = orderId.ToString()
                                PaymentTransactionId.Value = order.transaction_id.ToString()
                                
                                System.Diagnostics.Debug.WriteLine("Set hidden fields - Order ID: " & PaymentOrderId.Value & ", Transaction ID: " & PaymentTransactionId.Value)
                                
                                ' Load payment details for verification
                                ' Show the verification modal
                                System.Diagnostics.Debug.WriteLine("Preparing to show verification modal")
                                
                                ' Get the exact modal ID
                                System.Diagnostics.Debug.WriteLine("Payment verification modal ID: " & PaymentVerificationModal.ClientID)
                                
                                Dim script As String = "document.getElementById('" & PaymentVerificationModal.ClientID & "').style.display = 'block'; console.log('Showing payment verification modal');"
                                
                                System.Diagnostics.Debug.WriteLine("Script to execute: " & script)
                                
                                ' Use the existing ScriptManager if it exists, otherwise use ClientScript
                                Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
                                If sm IsNot Nothing Then
                                    System.Diagnostics.Debug.WriteLine("Using ScriptManager to register script")
                                    sm.RegisterStartupScript(Me, Me.GetType(), "ShowPaymentModal", script, True)
                                Else
                                    System.Diagnostics.Debug.WriteLine("Using ClientScript to register script")
                                    Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowPaymentModal", script, True)
                                End If
                                
                                System.Diagnostics.Debug.WriteLine("Verification modal shown successfully")
                            Else
                                ' No transaction associated with this order
                                System.Diagnostics.Debug.WriteLine("No transaction ID found for this order")
                                Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('No payment information found for this order.');", True)
                            End If
                        Else
                            System.Diagnostics.Debug.WriteLine("Order not found")
                            Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Order not found.');", True)
                        End If
                        
                        System.Diagnostics.Debug.WriteLine("=== VERIFY PAYMENT COMMAND COMPLETED ===")
                    Catch ex As Exception
                        System.Diagnostics.Debug.WriteLine("=== ERROR IN VERIFY PAYMENT COMMAND ===")
                        System.Diagnostics.Debug.WriteLine("Error: " & ex.Message)
                        System.Diagnostics.Debug.WriteLine("Stack trace: " & ex.StackTrace)
                        LogError("Error loading payment verification: " & ex.Message)
                        Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Error loading payment verification: " & ex.Message & "');", True)
                    End Try

                Case "AcceptPayment"
                    Try
                        OrderController.UpdateOrderStatus(orderId, "Payment Accepted")
                        Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Payment accepted.');", True)
                        LoadFilteredOrders()
                    Catch ex As Exception
                        LogError("Error accepting payment: " & ex.Message)
                        Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Error accepting payment: " & ex.Message & "');", True)
                    End Try
                    
                Case "Process"
                    Try
                        OrderController.UpdateOrderStatus(orderId, "Processing")
                        Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Order is now being processed.');", True)
                        LoadFilteredOrders()
                    Catch ex As Exception
                        LogError("Error processing order: " & ex.Message)
                        Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Error processing order: " & ex.Message & "');", True)
                    End Try
                    
                Case "Complete"
                    Try
                        OrderController.UpdateOrderStatus(orderId, "Completed")
                        Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Order marked as complete.');", True)
                        LoadFilteredOrders()
                    Catch ex As Exception
                        LogError("Error completing order: " & ex.Message)
                        Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Error completing order: " & ex.Message & "');", True)
                    End Try
                    
                Case "Cancel"
                    Try
                        OrderController.UpdateOrderStatus(orderId, "Cancelled")
                        Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Order cancelled.');", True)
                        LoadFilteredOrders()
                    Catch ex As Exception
                        LogError("Error cancelling order: " & ex.Message)
                        Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Error cancelling order: " & ex.Message & "');", True)
                    End Try

                Case "UpdateStatus"
                    ' Store the order ID and show the modal
                    SelectedOrderId.Value = orderId.ToString()
                    
                    Try
                        ' Set the dropdown to the current status
                        Dim currentStatus As String = GetOrderStatus(orderId)
                        For i As Integer = 0 To OrderStatusDropDown.Items.Count - 1
                            If OrderStatusDropDown.Items(i).Value.ToLower() = currentStatus.ToLower() Then
                                OrderStatusDropDown.SelectedIndex = i
                                Exit For
                            End If
                        Next
                        
                        ' Register script to show the modal
                        Dim script As String = "document.getElementById('updateStatusModal').style.display = 'block';"
                        
                        ' Use the existing ScriptManager if it exists, otherwise use ClientScript
                        Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
                        If sm IsNot Nothing Then
                            sm.RegisterStartupScript(Me, Me.GetType(), "ShowStatusModal", script, True)
                        Else
                            Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowStatusModal", script, True)
                        End If
                        
                        System.Diagnostics.Debug.WriteLine("Registered script to show status modal")
                    Catch ex As Exception
                        LogError("Error preparing status update: " & ex.Message)
                        Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Error preparing status update: " & ex.Message & "');", True)
                    End Try

                Case "SetDelivery"
                    Try
                        ' Store the order ID
                        DeliveryOrderId.Value = orderId.ToString()
                        
                        ' Load existing delivery info if available
                        LoadDeliveryInfo(orderId)
                        
                        ' Show the modal using JavaScript
                        Dim script As String = "document.getElementById('" & DeliveryModal.ClientID & "').style.display = 'block';"
                        
                        ' Use the existing ScriptManager if it exists, otherwise use ClientScript
                        Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
                        If sm IsNot Nothing Then
                            sm.RegisterStartupScript(Me, Me.GetType(), "ShowDeliveryModal", script, True)
                        Else
                            Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowDeliveryModal", script, True)
                        End If
                        
                        System.Diagnostics.Debug.WriteLine("Registered script to show delivery modal")
                    Catch ex As Exception
                        LogError("Error preparing delivery update: " & ex.Message)
                        Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Error preparing delivery update: " & ex.Message & "');", True)
                    End Try
            End Select
        Catch ex As Exception
            LogError("Error in OrdersListView_ItemCommand: " & ex.Message)
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('An error occurred: " & ex.Message & "');", True)
        End Try
    End Sub

    ' Method to get current order status
    Private Function GetOrderStatus(ByVal orderId As Integer) As String
        Try
            ' Get the order using OrderController
            Dim order = orderController.GetOrderById(orderId)
            
            If order IsNot Nothing Then
                Return order.status
            End If
            Return "pending" ' Default status if not found
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error getting order status: " & ex.Message)
            Return "pending" ' Default status on error
        End Try
    End Function

    ' Method to load delivery information for an order
    Private Sub LoadDeliveryInfo(ByVal orderId As Integer)
        Try
            System.Diagnostics.Debug.WriteLine("Loading delivery info for order #" & orderId)
            
            ' Get the order using OrderController
            Dim order = orderController.GetOrderById(orderId)
            
            System.Diagnostics.Debug.WriteLine("Order found: " & (order IsNot Nothing))

            If order IsNot Nothing AndAlso DoColumnsExist() Then
                ' Debug - Output what was found in the database
                System.Diagnostics.Debug.WriteLine("Delivery info from database:")
                System.Diagnostics.Debug.WriteLine("  delivery_service: " & If(order.delivery_service Is Nothing, "NULL", order.delivery_service))
                System.Diagnostics.Debug.WriteLine("  driver_name: " & If(order.driver_name Is Nothing, "NULL", order.driver_name))
                System.Diagnostics.Debug.WriteLine("  tracking_link: " & If(order.tracking_link Is Nothing, "NULL", order.tracking_link))
                System.Diagnostics.Debug.WriteLine("  delivery_notes: " & If(order.delivery_notes Is Nothing, "NULL", order.delivery_notes))
                
                ' Get additional fields from transactions table
                Dim appName As String = ""
                Dim trackingUrl As String = ""
                Dim estimatedTime As String = ""
                
                If order.transaction_id > 0 Then
                    ' Get transaction info
                    Dim transQuery As String = "SELECT app_name, tracking_url, estimated_time FROM transactions WHERE transaction_id = @transaction_id"
                    Connect.ClearParams()
                    Connect.AddParam("@transaction_id", order.transaction_id)
                    Connect.Query(transQuery)
                    
                    If Connect.DataCount > 0 Then
                        Dim row As DataRow = Connect.Data.Tables(0).Rows(0)
                        appName = If(row("app_name") IsNot DBNull.Value, row("app_name").ToString(), "")
                        trackingUrl = If(row("tracking_url") IsNot DBNull.Value, row("tracking_url").ToString(), "")
                        estimatedTime = If(row("estimated_time") IsNot DBNull.Value, row("estimated_time").ToString(), "")
                        
                        System.Diagnostics.Debug.WriteLine("Transaction info from database:")
                        System.Diagnostics.Debug.WriteLine("  app_name: " & appName)
                        System.Diagnostics.Debug.WriteLine("  tracking_url: " & trackingUrl)
                        System.Diagnostics.Debug.WriteLine("  estimated_time: " & estimatedTime)
                    End If
                End If
                
                ' Reset dropdown to default
                DeliveryServiceDropDown.SelectedIndex = 0
                
                ' Use app_name from transactions table if available, else use delivery_service from orders
                If Not String.IsNullOrEmpty(appName) Then
                    ' Try to select the app name in the dropdown
                    Try
                        DeliveryServiceDropDown.SelectedValue = appName
                        System.Diagnostics.Debug.WriteLine("Set delivery service dropdown to app_name: '" & appName & "'")
                    Catch ex As Exception
                        System.Diagnostics.Debug.WriteLine("Could not set dropdown to app_name: " & ex.Message)
                        
                        ' Fall back to delivery_service from orders table
                        If order.delivery_service IsNot Nothing Then
                            Try
                                DeliveryServiceDropDown.SelectedValue = order.delivery_service
                                System.Diagnostics.Debug.WriteLine("Set delivery service dropdown to delivery_service: '" & order.delivery_service & "'")
                            Catch innerEx As Exception
                                System.Diagnostics.Debug.WriteLine("Could not set dropdown to delivery_service: " & innerEx.Message)
                            End Try
                        End If
                    End Try
                ElseIf order.delivery_service IsNot Nothing Then
                    ' Use delivery_service from orders if app_name is not available
                    Try
                        DeliveryServiceDropDown.SelectedValue = order.delivery_service
                        System.Diagnostics.Debug.WriteLine("Set delivery service dropdown to delivery_service: '" & order.delivery_service & "'")
                    Catch ex As Exception
                        System.Diagnostics.Debug.WriteLine("Could not set dropdown to delivery_service: " & ex.Message)
                    End Try
                End If
                
                ' Set the driver name if it exists
                If order.driver_name IsNot Nothing Then
                    DriverNameTextBox.Text = order.driver_name
                    System.Diagnostics.Debug.WriteLine("Set driver name textbox to: " & DriverNameTextBox.Text)
                End If
                
                ' Set the tracking link (use tracking_url from transactions if available, else use tracking_link from orders)
                If Not String.IsNullOrEmpty(trackingUrl) Then
                    TrackingLinkTextBox.Text = trackingUrl
                    System.Diagnostics.Debug.WriteLine("Set tracking link textbox to tracking_url: " & trackingUrl)
                ElseIf order.tracking_link IsNot Nothing Then
                    TrackingLinkTextBox.Text = order.tracking_link
                    System.Diagnostics.Debug.WriteLine("Set tracking link textbox to tracking_link: " & order.tracking_link)
                End If
                
                ' Set the estimated delivery time
                If Not String.IsNullOrEmpty(estimatedTime) Then
                    EstimatedTimeTextBox.Text = estimatedTime
                    System.Diagnostics.Debug.WriteLine("Set estimated time textbox to: " & estimatedTime)
                End If
                
                ' Set the notes if they exist
                If order.delivery_notes IsNot Nothing Then
                    DeliveryNotesTextBox.Text = order.delivery_notes
                    System.Diagnostics.Debug.WriteLine("Set delivery notes textbox to: " & DeliveryNotesTextBox.Text)
                End If
            Else
                ' Clear the form fields if no data exists
                System.Diagnostics.Debug.WriteLine("No delivery info found or columns don't exist, clearing form fields")
                DeliveryServiceDropDown.SelectedIndex = 0
                DriverNameTextBox.Text = String.Empty
                TrackingLinkTextBox.Text = String.Empty
                EstimatedTimeTextBox.Text = String.Empty
                DeliveryNotesTextBox.Text = String.Empty
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error loading delivery info: " & ex.Message)
            
            ' Clear the form fields on error
            DeliveryServiceDropDown.SelectedIndex = 0
            DriverNameTextBox.Text = String.Empty
            TrackingLinkTextBox.Text = String.Empty
            EstimatedTimeTextBox.Text = String.Empty
            DeliveryNotesTextBox.Text = String.Empty
        End Try
    End Sub

    Protected Sub SaveStatusButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim orderId As Integer
            If Integer.TryParse(SelectedOrderId.Value, orderId) Then
                Dim newStatus As String = OrderStatusDropDown.SelectedValue

                If String.IsNullOrEmpty(newStatus) Then
                    ShowAlert("Please select a status.", "alert-warning")
                    Return
                End If

                UpdateOrderStatus(orderId, newStatus)
                ShowAlert("Order #" & orderId & " status updated to " & newStatus & ".", "alert-success")
                LoadFilteredOrders()

                ' Close modal through JavaScript
                Dim script As String = "closeModal('updateStatusModal');"
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "CloseStatusModal", script, True)
            Else
                ShowAlert("Invalid order ID: " & SelectedOrderId.Value, "alert-danger")
                System.Diagnostics.Debug.WriteLine("Invalid order ID in SaveStatusButton_Click: " & SelectedOrderId.Value)
            End If
        Catch ex As Exception
            ShowAlert("Error saving status: " & ex.Message, "alert-danger")
            System.Diagnostics.Debug.WriteLine("Error in SaveStatusButton_Click: " & ex.Message)
        End Try
    End Sub

    Private Sub CheckColumnTypes()
        Try
            System.Diagnostics.Debug.WriteLine("Checking column data types for orders table")
            Dim query As String = "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH " & _
                                 "FROM INFORMATION_SCHEMA.COLUMNS " & _
                                 "WHERE TABLE_NAME = 'orders' AND COLUMN_NAME IN " & _
                                 "('order_id', 'driver_name', 'delivery_service', 'tracking_link', 'delivery_notes')"
            
            Connect.ClearParams()
            Connect.Query(query)
            
            If Connect.DataCount > 0 Then
                System.Diagnostics.Debug.WriteLine("Column information:")
                For Each row As DataRow In Connect.Data.Tables(0).Rows
                    Dim columnName As String = row("COLUMN_NAME").ToString()
                    Dim dataType As String = row("DATA_TYPE").ToString()
                    Dim maxLength As String = If(row.IsNull("CHARACTER_MAXIMUM_LENGTH"), 
                                             "N/A", 
                                             row("CHARACTER_MAXIMUM_LENGTH").ToString())
                    
                    System.Diagnostics.Debug.WriteLine("  " & columnName & ": " & dataType & 
                                                     " (MaxLength: " & maxLength & ")")
                Next
            Else
                System.Diagnostics.Debug.WriteLine("No column info found")
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error checking column types: " & ex.Message)
        End Try
    End Sub

    Private Sub SaveDeliveryInfoAlternateMethod(ByVal orderId As Integer, ByVal deliveryService As String, ByVal driverName As String, _
                                        ByVal trackingLink As String, ByVal notes As String)
        Try
            System.Diagnostics.Debug.WriteLine("Using alternate update method...")
            
            ' Update each column individually to isolate any issues
            ' First update delivery service
            Dim query1 As String = "UPDATE orders SET delivery_service = @delivery_service WHERE order_id = @order_id"
            Connect.ClearParams()
            Connect.AddParam("@order_id", orderId)
            Connect.AddParamWithNull("@delivery_service", If(String.IsNullOrEmpty(deliveryService), Nothing, deliveryService.Trim()))
            Dim success1 As Boolean = Connect.Query(query1)
            System.Diagnostics.Debug.WriteLine("Update delivery_service result: " & success1)
            
            ' Then update driver name
            Dim query2 As String = "UPDATE orders SET driver_name = @driver_name WHERE order_id = @order_id"
            Connect.ClearParams()
            Connect.AddParam("@order_id", orderId)
            Connect.AddParamWithNull("@driver_name", If(String.IsNullOrEmpty(driverName), Nothing, driverName.Trim()))
            Dim success2 As Boolean = Connect.Query(query2)
            System.Diagnostics.Debug.WriteLine("Update driver_name result: " & success2)
            
            ' Then update tracking link
            Dim query3 As String = "UPDATE orders SET tracking_link = @tracking_link WHERE order_id = @order_id"
            Connect.ClearParams()
            Connect.AddParam("@order_id", orderId)
            Connect.AddParamWithNull("@tracking_link", If(String.IsNullOrEmpty(trackingLink), Nothing, trackingLink.Trim()))
            Dim success3 As Boolean = Connect.Query(query3)
            System.Diagnostics.Debug.WriteLine("Update tracking_link result: " & success3)
            
            ' Finally update notes
            Dim query4 As String = "UPDATE orders SET delivery_notes = @delivery_notes WHERE order_id = @order_id"
            Connect.ClearParams()
            Connect.AddParam("@order_id", orderId)
            Connect.AddParamWithNull("@delivery_notes", If(String.IsNullOrEmpty(notes), Nothing, notes.Trim()))
            Dim success4 As Boolean = Connect.Query(query4)
            System.Diagnostics.Debug.WriteLine("Update delivery_notes result: " & success4)
            
            ' Check the final result
            System.Diagnostics.Debug.WriteLine("Alternate update completed with results: " & 
                                              success1 & ", " & success2 & ", " & success3 & ", " & success4)
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error in alternate update method: " & ex.Message)
        End Try
    End Sub

    Private Sub VerifyDeliveryInfoSaved(ByVal orderId As Integer)
        Try
            System.Diagnostics.Debug.WriteLine("======= VERIFYING DELIVERY INFO WAS SAVED =======")
            
            ' Get the order using OrderController
            Dim order = orderController.GetOrderById(orderId)
            
            If order IsNot Nothing Then
                System.Diagnostics.Debug.WriteLine("VALUES IN DATABASE:")
                System.Diagnostics.Debug.WriteLine("  order_id: " & order.order_id)
                System.Diagnostics.Debug.WriteLine("  driver_name: " & If(order.driver_name Is Nothing, "NULL", "'" & order.driver_name & "'"))
                System.Diagnostics.Debug.WriteLine("  delivery_service: " & If(order.delivery_service Is Nothing, "NULL", "'" & order.delivery_service & "'"))
                System.Diagnostics.Debug.WriteLine("  tracking_link: " & If(order.tracking_link Is Nothing, "NULL", "'" & order.tracking_link & "'")) 
                System.Diagnostics.Debug.WriteLine("  delivery_notes: " & If(order.delivery_notes Is Nothing, "NULL", "'" & order.delivery_notes & "'"))
            Else
                System.Diagnostics.Debug.WriteLine("No record found for order ID: " & orderId)
            End If
            
            System.Diagnostics.Debug.WriteLine("===================================================")
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error verifying delivery info: " & ex.Message)
        End Try
    End Sub

    Private Function UpdateDeliveryInfoDirectADO(ByVal orderId As Integer, ByVal deliveryService As String, ByVal driverName As String, _
                                      ByVal trackingLink As String, ByVal notes As String) As Boolean
        Try
            System.Diagnostics.Debug.WriteLine("Using OrderController for update...")
            System.Diagnostics.Debug.WriteLine("  deliveryService: '" & deliveryService & "'")
            System.Diagnostics.Debug.WriteLine("  driverName: '" & driverName & "'")
            
            ' Use OrderController to update delivery info
            Dim success = orderController.UpdateOrderDeliveryInfo(orderId, driverName, deliveryService, trackingLink, notes)
            
            System.Diagnostics.Debug.WriteLine("OrderController update result: " & success)
            Return success
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error in OrderController update: " & ex.Message)
            Return False
        End Try
    End Function
    
    ' Method to update transaction delivery info
    Private Function UpdateTransactionDeliveryInfo(ByVal orderId As Integer, ByVal appName As String, _
                                                  ByVal trackingUrl As String, ByVal estimatedTime As String) As Boolean
        Try
            ' First get the transaction ID from the order
            Dim order = orderController.GetOrderById(orderId)
            If order Is Nothing OrElse order.transaction_id <= 0 Then
                System.Diagnostics.Debug.WriteLine("No transaction found for order ID: " & orderId)
                Return False
            End If
            
            ' Update the transaction table
            Dim updateQuery As String = "UPDATE transactions SET " & _
                                      "app_name = @app_name, " & _
                                      "tracking_url = @tracking_url, " & _
                                      "estimated_time = @estimated_time " & _
                                      "WHERE transaction_id = @transaction_id"
            
            Connect.ClearParams()
            Connect.AddParam("@transaction_id", order.transaction_id)
            Connect.AddParamWithNull("@app_name", If(String.IsNullOrEmpty(appName), Nothing, appName.Trim()))
            Connect.AddParamWithNull("@tracking_url", If(String.IsNullOrEmpty(trackingUrl), Nothing, trackingUrl.Trim()))
            Connect.AddParamWithNull("@estimated_time", If(String.IsNullOrEmpty(estimatedTime), Nothing, estimatedTime.Trim()))
            
            Dim success As Boolean = Connect.Query(updateQuery)
            System.Diagnostics.Debug.WriteLine("Transaction update result: " & success)
            Return success
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error updating transaction delivery info: " & ex.Message)
            Return False
        End Try
    End Function
    
    Protected Sub SaveDeliveryButton_Click(sender As Object, e As EventArgs)
        Try
            ' Get the order ID from the hidden field
            Dim orderId As Integer = Convert.ToInt32(DeliveryOrderId.Value)
            
            ' Get the current order status before making any changes
            Dim currentStatus As String = GetOrderStatus(orderId)
            System.Diagnostics.Debug.WriteLine("Current order status before delivery update: " & currentStatus)
            
            ' Get the values from the form
            Dim driverName As String = DriverNameTextBox.Text.Trim()
            Dim deliveryService As String = DeliveryServiceDropDown.SelectedValue
            Dim trackingLink As String = TrackingLinkTextBox.Text.Trim()
            Dim deliveryNotes As String = DeliveryNotesTextBox.Text.Trim()
            Dim estimatedTime As String = EstimatedTimeTextBox.Text.Trim()
            
            ' Update the delivery information
            Dim success As Boolean = orderController.UpdateOrderDeliveryInfo(orderId, driverName, deliveryService, trackingLink, deliveryNotes)
            
            If success Then
                ' Also update transaction table with app_name, tracking_url, and estimated_time
                success = UpdateTransactionDeliveryInfo(orderId, deliveryService, trackingLink, estimatedTime)
                
                ' Check if the status was changed to "Out for Delivery" and restore the original status if needed
                Dim newStatus As String = GetOrderStatus(orderId)
                If newStatus <> currentStatus AndAlso newStatus = "Delivering" Then
                    System.Diagnostics.Debug.WriteLine("Status was automatically changed to Delivering. Restoring original status: " & currentStatus)
                    success = orderController.UpdateOrderStatus(orderId, currentStatus)
                End If
                    
                If success Then
                    ShowAlert("Delivery information for order #" & orderId & " has been updated.", "alert-success")
                Else
                    ShowAlert("Delivery information updated in orders but failed to update transaction details.", "alert-warning")
                End If
            Else
                ShowAlert("Error updating delivery information for order #" & orderId & ".", "alert-danger")
            End If
            
            ' Close the modal
            CloseDeliveryModal()
            
            ' Reload orders to reflect the changes
            LoadFilteredOrders()
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error saving delivery info: " & ex.Message)
            ShowAlert("Error saving delivery information: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Private Sub UpdateOrderStatus(ByVal orderId As Integer, ByVal status As String)
        Try
            ' Use the OrderController to update the status
            Dim success = orderController.UpdateOrderStatus(orderId, status)
            
            If Not success Then
                ShowAlert("Error updating order status: Database update failed.", "alert-danger")
            End If
        Catch ex As Exception
            ShowAlert("Error updating order status: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Private Sub LoadFilteredOrders()
        Try
            ' Get search term and status filter from ViewState
            Dim searchTerm As String = If(ViewState("SearchTerm") IsNot Nothing, ViewState("SearchTerm").ToString(), String.Empty)
            Dim statusFilter As String = If(ViewState("SelectedStatus") IsNot Nothing, ViewState("SelectedStatus").ToString(), String.Empty)
            
            ' Store in local variables for use in LoadOrders
            Me.searchTerm = searchTerm
            Me.selectedStatus = statusFilter
            
            ' Load orders with the current filters
            LoadOrders()
        Catch ex As Exception
            LogError("Error in LoadFilteredOrders: " & ex.Message)
            ShowAlert("Error loading orders: " & ex.Message, "alert-danger")
        End Try
    End Sub
    
    Protected Sub SearchButton_Click(sender As Object, e As EventArgs)
        Try
            ' Store the search term in ViewState
            ViewState("SearchTerm") = SearchBox.Text.Trim()
            
            ' Load orders with the search filter
            LoadFilteredOrders()
        Catch ex As Exception
            LogError("Error in SearchButton_Click: " & ex.Message)
            ShowAlert("Error searching orders: " & ex.Message, "alert-danger")
        End Try
    End Sub
    
    Protected Sub StatusDropDown_SelectedIndexChanged(sender As Object, e As EventArgs)
        Try
            ' Store the selected status in ViewState
            ViewState("SelectedStatus") = StatusDropDown.SelectedValue
            
            ' Load orders with the status filter
            LoadFilteredOrders()
        Catch ex As Exception
            LogError("Error in StatusDropDown_SelectedIndexChanged: " & ex.Message)
            ShowAlert("Error filtering orders: " & ex.Message, "alert-danger")
        End Try
    End Sub
    
    ' Private variables to store search and filter values
    Private searchTerm As String = String.Empty
    Private selectedStatus As String = String.Empty

    ' Method to close the delivery modal
    Private Sub CloseDeliveryModal()
        Try
            ' Use JavaScript to close the modal
            Dim script As String = "document.getElementById('" & DeliveryModal.ClientID & "').style.display = 'none';"
            
            ' Use the existing ScriptManager if it exists, otherwise use ClientScript
            Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
            If sm IsNot Nothing Then
                sm.RegisterStartupScript(Me, Me.GetType(), "CloseDeliveryModal", script, True)
            Else
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "CloseDeliveryModal", script, True)
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error closing delivery modal: " & ex.Message)
        End Try
    End Sub

    ' Method to close the status modal
    Private Sub CloseStatusModal()
        Try
            ' Use JavaScript to close the modal
            Dim script As String = "document.getElementById('updateStatusModal').style.display = 'none';"
            
            ' Use the existing ScriptManager if it exists, otherwise use ClientScript
            Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
            If sm IsNot Nothing Then
                sm.RegisterStartupScript(Me, Me.GetType(), "CloseStatusModal", script, True)
            Else
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "CloseStatusModal", script, True)
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error closing status modal: " & ex.Message)
        End Try
    End Sub
    
    ' Method to close the payment modal
    Private Sub ClosePaymentModal()
        Try
            ' Use JavaScript to close the modal
            Dim script As String = "document.getElementById('" & PaymentVerificationModal.ClientID & "').style.display = 'none';"
            
            ' Use the existing ScriptManager if it exists, otherwise use ClientScript
            Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
            If sm IsNot Nothing Then
                sm.RegisterStartupScript(Me, Me.GetType(), "ClosePaymentModal", script, True)
            Else
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "ClosePaymentModal", script, True)
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error closing payment modal: " & ex.Message)
        End Try
    End Sub
    
    ' Event handlers for the modal buttons
    Protected Sub CloseStatusModalButton_Click(sender As Object, e As EventArgs)
        CloseStatusModal()
    End Sub
    
    Protected Sub CloseDeliveryModalButton_Click(sender As Object, e As EventArgs)
        CloseDeliveryModal()
    End Sub
    
    Protected Sub ClosePaymentModalButton_Click(sender As Object, e As EventArgs)
        ClosePaymentModal()
    End Sub
    
    Protected Sub ConfirmPaymentButton_Click(sender As Object, e As EventArgs)
        Try
            System.Diagnostics.Debug.WriteLine("=== CONFIRM PAYMENT BUTTON CLICKED ===")
            
            ' Get the order ID and transaction ID from the hidden fields
            Dim orderId As Integer = Convert.ToInt32(PaymentOrderId.Value)
            Dim transactionId As Integer = Convert.ToInt32(PaymentTransactionId.Value)
            
            System.Diagnostics.Debug.WriteLine("Order ID: " & orderId)
            System.Diagnostics.Debug.WriteLine("Transaction ID: " & transactionId)
            
            ' First check if the transaction table has the status column
            Dim columnQuery As String = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS " & _
                                      "WHERE TABLE_NAME = 'transactions' AND COLUMN_NAME IN ('status', 'verification_date')"
            Connect.ClearParams()
            Connect.Query(columnQuery)
            
            Dim hasStatusColumn As Boolean = False
            Dim hasVerificationDateColumn As Boolean = False
            
            If Connect.DataCount > 0 Then
                For Each row As DataRow In Connect.Data.Tables(0).Rows
                    Dim columnName As String = row("COLUMN_NAME").ToString().ToLower()
                    If columnName = "status" Then
                        hasStatusColumn = True
                    ElseIf columnName = "verification_date" Then
                        hasVerificationDateColumn = True
                    End If
                Next
            End If
            
            System.Diagnostics.Debug.WriteLine("Has status column: " & hasStatusColumn)
            System.Diagnostics.Debug.WriteLine("Has verification_date column: " & hasVerificationDateColumn)
            
            ' If columns don't exist, create them
            If Not hasStatusColumn OrElse Not hasVerificationDateColumn Then
                EnsureTransactionStatusColumnsExist()
            End If
            
            ' Update the order status
            UpdateOrderStatus(orderId, "Payment Accepted")
            System.Diagnostics.Debug.WriteLine("Order status updated to 'Payment Accepted'")
            
            ' Also update the transaction status in the transactions table
            Dim updateTransactionQuery As String = "UPDATE transactions SET "
            
            If hasStatusColumn Then
                updateTransactionQuery += "status = 'Verified'"
            End If
            
            If hasStatusColumn AndAlso hasVerificationDateColumn Then
                updateTransactionQuery += ", "
            End If
            
            If hasVerificationDateColumn Then
                updateTransactionQuery += "verification_date = @verification_date"
            End If
            
            updateTransactionQuery += " WHERE transaction_id = @transaction_id"
            
            Connect.ClearParams()
            Connect.AddParam("@transaction_id", transactionId)
            
            If hasVerificationDateColumn Then
                Connect.AddParam("@verification_date", DateTime.Now)
            End If
            
            System.Diagnostics.Debug.WriteLine("Transaction update query: " & updateTransactionQuery)
            Dim transactionUpdateSuccess As Boolean = Connect.Query(updateTransactionQuery)
            
            System.Diagnostics.Debug.WriteLine("Transaction status update result: " & transactionUpdateSuccess)
            
            ' Show success message
            If transactionUpdateSuccess Then
                ShowAlert("Payment confirmed for order #" & orderId & " and transaction #" & transactionId & " marked as verified.", "alert-success")
            Else
                ShowAlert("Payment confirmed for order #" & orderId & " but could not update transaction status.", "alert-warning")
            End If
            
            ' Close the modal
            ClosePaymentModal()
            
            ' Reload orders to reflect the changes
            LoadFilteredOrders()
            
            System.Diagnostics.Debug.WriteLine("=== CONFIRM PAYMENT COMPLETED ===")
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("=== ERROR IN CONFIRM PAYMENT ===")
            System.Diagnostics.Debug.WriteLine("Error: " & ex.Message)
            System.Diagnostics.Debug.WriteLine("Stack trace: " & ex.StackTrace)
            LogError("Error confirming payment: " & ex.Message)
            ShowAlert("Error confirming payment: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Protected Sub RejectPaymentButton_Click(sender As Object, e As EventArgs)
        Try
            System.Diagnostics.Debug.WriteLine("=== REJECT PAYMENT BUTTON CLICKED ===")
            
            ' Get the order ID and transaction ID from the hidden fields
            Dim orderId As Integer = Convert.ToInt32(PaymentOrderId.Value)
            Dim transactionId As Integer = Convert.ToInt32(PaymentTransactionId.Value)
            
            System.Diagnostics.Debug.WriteLine("Order ID: " & orderId)
            System.Diagnostics.Debug.WriteLine("Transaction ID: " & transactionId)
            
            ' First check if the transaction table has the status column
            Dim columnQuery As String = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS " & _
                                      "WHERE TABLE_NAME = 'transactions' AND COLUMN_NAME IN ('status', 'verification_date')"
            Connect.ClearParams()
            Connect.Query(columnQuery)
            
            Dim hasStatusColumn As Boolean = False
            Dim hasVerificationDateColumn As Boolean = False
            
            If Connect.DataCount > 0 Then
                For Each row As DataRow In Connect.Data.Tables(0).Rows
                    Dim columnName As String = row("COLUMN_NAME").ToString().ToLower()
                    If columnName = "status" Then
                        hasStatusColumn = True
                    ElseIf columnName = "verification_date" Then
                        hasVerificationDateColumn = True
                    End If
                Next
            End If
            
            System.Diagnostics.Debug.WriteLine("Has status column: " & hasStatusColumn)
            System.Diagnostics.Debug.WriteLine("Has verification_date column: " & hasVerificationDateColumn)
            
            ' If columns don't exist, create them
            If Not hasStatusColumn OrElse Not hasVerificationDateColumn Then
                EnsureTransactionStatusColumnsExist()
            End If
            
            ' Update the order status to cancelled
            UpdateOrderStatus(orderId, "Cancelled")
            System.Diagnostics.Debug.WriteLine("Order status updated to 'Cancelled'")
            
            ' Also update the transaction status in the transactions table
            Dim updateTransactionQuery As String = "UPDATE transactions SET "
            
            If hasStatusColumn Then
                updateTransactionQuery += "status = 'Rejected'"
            End If
            
            If hasStatusColumn AndAlso hasVerificationDateColumn Then
                updateTransactionQuery += ", "
            End If
            
            If hasVerificationDateColumn Then
                updateTransactionQuery += "verification_date = @verification_date"
            End If
            
            updateTransactionQuery += " WHERE transaction_id = @transaction_id"
            
            Connect.ClearParams()
            Connect.AddParam("@transaction_id", transactionId)
            
            If hasVerificationDateColumn Then
                Connect.AddParam("@verification_date", DateTime.Now)
            End If
            
            System.Diagnostics.Debug.WriteLine("Transaction update query: " & updateTransactionQuery)
            Dim transactionUpdateSuccess As Boolean = Connect.Query(updateTransactionQuery)
            
            System.Diagnostics.Debug.WriteLine("Transaction status update result: " & transactionUpdateSuccess)
            
            ' Show message
            If transactionUpdateSuccess Then
                ShowAlert("Payment rejected for order #" & orderId & ". Order has been cancelled and transaction marked as rejected.", "alert-warning")
            Else
                ShowAlert("Payment rejected for order #" & orderId & ". Order has been cancelled but could not update transaction status.", "alert-warning")
            End If
            
            ' Close the modal
            ClosePaymentModal()
            
            ' Reload orders to reflect the changes
            LoadFilteredOrders()
            
            System.Diagnostics.Debug.WriteLine("=== REJECT PAYMENT COMPLETED ===")
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("=== ERROR IN REJECT PAYMENT ===")
            System.Diagnostics.Debug.WriteLine("Error: " & ex.Message)
            System.Diagnostics.Debug.WriteLine("Stack trace: " & ex.StackTrace)
            LogError("Error rejecting payment: " & ex.Message)
            ShowAlert("Error rejecting payment: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Protected Sub VerifyGCashButton_Click(sender As Object, e As EventArgs)
        Try
            System.Diagnostics.Debug.WriteLine("=== DIRECT VERIFY PAYMENT BUTTON CLICK HANDLER ===")
            
            ' Get the button that was clicked
            Dim btn As Button = TryCast(sender, Button)
            If btn Is Nothing Then
                System.Diagnostics.Debug.WriteLine("Button not found")
                Return
            End If
            
            ' Get the order ID from the button's CommandArgument
            Dim orderId As Integer
            If Integer.TryParse(btn.CommandArgument, orderId) Then
                System.Diagnostics.Debug.WriteLine("Order ID: " & orderId.ToString())
                
                ' Get order and transaction details
                Dim order = orderController.GetOrderById(orderId)
                If order IsNot Nothing AndAlso order.transaction_id > 0 Then
                    System.Diagnostics.Debug.WriteLine("Order found with transaction ID: " & order.transaction_id)
                    
                    ' Store IDs for reference
                    PaymentOrderId.Value = orderId.ToString()
                    PaymentTransactionId.Value = order.transaction_id.ToString()
                    
                    ' Load payment details for the verification modal
                    
                    ' Show the verification modal
                    System.Diagnostics.Debug.WriteLine("Showing payment verification modal")
                    Dim script As String = "document.getElementById('" & PaymentVerificationModal.ClientID & "').style.display = 'block'; console.log('Payment verification modal shown');"
                    Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowPaymentModal", script, True)
                Else
                    System.Diagnostics.Debug.WriteLine("Order not found or has no transaction ID")
                    ShowAlert("No valid payment information found for this order.", "alert-warning")
                End If
            Else
                System.Diagnostics.Debug.WriteLine("Could not parse order ID: " & btn.CommandArgument)
                ShowAlert("Invalid order ID.", "alert-danger")
            End If
            
            System.Diagnostics.Debug.WriteLine("=== DIRECT VERIFY PAYMENT BUTTON CLICK HANDLER COMPLETED ===")
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("=== ERROR IN DIRECT VERIFY PAYMENT BUTTON CLICK ===")
            System.Diagnostics.Debug.WriteLine("Error: " & ex.Message)
            System.Diagnostics.Debug.WriteLine("Stack trace: " & ex.StackTrace)
            ShowAlert("Error loading payment verification: " & ex.Message, "alert-danger")
        End Try
    End Sub
End Class
