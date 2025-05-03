Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls

Partial Class Pages_Admin_AdminOrders
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

     Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Check if delivery columns exist and create them if they don't
        EnsureDeliveryColumnsExist()

        ' Set the current year in the footer
        YearLiteral.Text = DateTime.Now.Year.ToString()

        If Not IsPostBack Then
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

    ' Modify the LoadOrders method to handle potential missing columns gracefully
    Private Sub LoadOrders()
        Try
            ' First check if all columns exist
            Dim columnExists As Boolean = DoColumnsExist()

            ' Get all orders with customer information
            Dim query As String

            If columnExists Then
                query = "SELECT o.order_id, o.order_date, o.status, o.total_amount, " & _
                       "u.display_name AS customer_name, u.contact AS customer_contact, u.address AS customer_address, " & _
                       "o.driver_name, o.delivery_service, o.tracking_link " & _
                       "FROM orders o " & _
                       "INNER JOIN users u ON o.user_id = u.user_id " & _
                       "ORDER BY o.order_date DESC"
            Else
                ' Use a simplified query without the delivery columns
                query = "SELECT o.order_id, o.order_date, o.status, o.total_amount, " & _
                       "u.display_name AS customer_name, u.contact AS customer_contact, u.address AS customer_address " & _
                       "FROM orders o " & _
                       "INNER JOIN users u ON o.user_id = u.user_id " & _
                       "ORDER BY o.order_date DESC"
            End If

            Connect.Query(query)

            If Connect.DataCount > 0 Then
                OrdersListView.DataSource = Connect.Data
                OrdersListView.DataBind()
            Else
                OrdersListView.DataSource = Nothing
                OrdersListView.DataBind()
            End If
        Catch ex As Exception
            ShowAlert("Error loading orders: " & ex.Message, "alert-danger")
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
            Dim query As String = "SELECT oi.order_item_id, oi.item_id, oi.quantity, oi.price, m.name " & _
                                "FROM order_items oi " & _
                                "INNER JOIN menu m ON oi.item_id = m.item_id " & _
                                "WHERE oi.order_id = @order_id"

            Connect.ClearParams()
            Connect.AddParam("@order_id", orderId)
            Connect.Query(query)

            If Connect.DataCount > 0 Then
                Return Connect.Data.Tables(0)
            Else
                Return New DataTable()
            End If
        Catch ex As Exception
            Return New DataTable()
        End Try
    End Function

    Protected Sub OrdersListView_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.ListViewCommandEventArgs)
        Try
            System.Diagnostics.Debug.WriteLine("OrdersListView_ItemCommand called with command name: " & e.CommandName)
            
            ' Ensure we have a valid command argument
            If e.CommandArgument Is Nothing Then
                System.Diagnostics.Debug.WriteLine("Command argument is null")
                Return
            End If
            
            Dim orderId As Integer
            If Not Integer.TryParse(e.CommandArgument.ToString(), orderId) Then
                System.Diagnostics.Debug.WriteLine("Invalid order ID: " & e.CommandArgument.ToString())
                Return
            End If
            
            System.Diagnostics.Debug.WriteLine("Processing command " & e.CommandName & " for order ID: " & orderId)

            Select Case e.CommandName
                Case "Accept"
                    UpdateOrderStatus(orderId, "accepted")
                    ShowAlert("Order #" & orderId & " has been accepted.", "alert-success")
                    LoadOrders()

                Case "Decline"
                    UpdateOrderStatus(orderId, "declined")
                    ShowAlert("Order #" & orderId & " has been declined.", "alert-warning")
                    LoadOrders()

                Case "UpdateStatus"
                    System.Diagnostics.Debug.WriteLine("Handling UpdateStatus command for order: " & orderId)
                    ' Get the current status directly
                    Dim currentStatus As String = GetOrderStatus(orderId)
                    SelectedOrderId.Value = orderId.ToString()
                    
                    ' Open modal through JavaScript
                    Dim script As String = "openUpdateStatusModal('" & orderId & "', '" & orderId & "', '" & currentStatus & "');"
                    System.Diagnostics.Debug.WriteLine("Registering script: " & script)
                    
                    ' Make sure the script executes immediately
                    ClientScript.RegisterStartupScript(Me.GetType(), "OpenStatusModal" & DateTime.Now.Ticks, 
                        "setTimeout(function() { " & script & " }, 100);", True)

                Case "SetDelivery"
                    System.Diagnostics.Debug.WriteLine("Handling SetDelivery command for order: " & orderId)
                    ' Set the order ID for the delivery modal
                    DeliveryOrderId.Value = orderId.ToString()
                    
                    ' Load existing delivery info if any
                    LoadDeliveryInfo(orderId)
                    
                    ' Open delivery info modal
                    Dim script As String = "openDeliveryInfoModal('" & orderId & "', '" & orderId & "');"
                    System.Diagnostics.Debug.WriteLine("Registering script: " & script)
                    
                    ' Make sure the script executes immediately
                    ClientScript.RegisterStartupScript(Me.GetType(), "OpenDeliveryModal" & DateTime.Now.Ticks, 
                        "setTimeout(function() { " & script & " }, 100);", True)

                Case Else
                    System.Diagnostics.Debug.WriteLine("Unknown command: " & e.CommandName)
            End Select
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error in OrdersListView_ItemCommand: " & ex.Message)
            ShowAlert("Error processing command: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Method to get current order status
    Private Function GetOrderStatus(ByVal orderId As Integer) As String
        Try
            Dim query As String = "SELECT status FROM orders WHERE order_id = @order_id"
            Connect.ClearParams()
            Connect.AddParam("@order_id", orderId)
            Connect.Query(query)

            If Connect.DataCount > 0 Then
                Return Connect.Data.Tables(0).Rows(0)("status").ToString()
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
            
            Dim query As String = "SELECT delivery_service, driver_name, tracking_link, delivery_notes FROM orders WHERE order_id = @order_id"
            Connect.ClearParams()
            Connect.AddParam("@order_id", orderId)
            Connect.Query(query)

            System.Diagnostics.Debug.WriteLine("Query returned " & Connect.DataCount & " rows")

            If Connect.DataCount > 0 AndAlso DoColumnsExist() Then
                Dim row As DataRow = Connect.Data.Tables(0).Rows(0)
                
                ' Debug - Output what was found in the database
                System.Diagnostics.Debug.WriteLine("Delivery info from database:")
                If row.Table.Columns.Contains("delivery_service") Then
                    System.Diagnostics.Debug.WriteLine("  delivery_service: " & (If(row.IsNull("delivery_service"), "NULL", row("delivery_service").ToString())))
                End If
                
                If row.Table.Columns.Contains("driver_name") Then
                    System.Diagnostics.Debug.WriteLine("  driver_name: " & (If(row.IsNull("driver_name"), "NULL", row("driver_name").ToString())))
                End If
                
                If row.Table.Columns.Contains("tracking_link") Then
                    System.Diagnostics.Debug.WriteLine("  tracking_link: " & (If(row.IsNull("tracking_link"), "NULL", row("tracking_link").ToString())))
                End If
                
                If row.Table.Columns.Contains("delivery_notes") Then
                    System.Diagnostics.Debug.WriteLine("  delivery_notes: " & (If(row.IsNull("delivery_notes"), "NULL", row("delivery_notes").ToString())))
                End If
                
                ' Reset dropdown to default
                DeliveryServiceDropDown.SelectedIndex = 0
                
                ' Set the dropdown to the saved value if it exists
                If row.Table.Columns.Contains("delivery_service") AndAlso Not row.IsNull("delivery_service") Then
                    Dim service As String = row("delivery_service").ToString().Trim()
                    System.Diagnostics.Debug.WriteLine("Retrieved delivery service from database: '" & service & "'")
                    
                    If Not String.IsNullOrEmpty(service) Then
                        ' First try selection by value
                        Try
                            DeliveryServiceDropDown.SelectedValue = service
                            System.Diagnostics.Debug.WriteLine("Set delivery service dropdown by value to: '" & service & "'")
                        Catch ex As Exception
                            System.Diagnostics.Debug.WriteLine("Could not set dropdown by value: " & ex.Message)
                            
                            ' Try selection by text
                            Try
                                Dim item As ListItem = DeliveryServiceDropDown.Items.FindByText(service)
                                If item IsNot Nothing Then
                                    DeliveryServiceDropDown.SelectedValue = item.Value
                                    System.Diagnostics.Debug.WriteLine("Set delivery service dropdown by text to: '" & service & "'")
                                Else
                                    ' Try case-insensitive match
                                    For i As Integer = 0 To DeliveryServiceDropDown.Items.Count - 1
                                        If String.Compare(DeliveryServiceDropDown.Items(i).Text, service, True) = 0 OrElse 
                                           String.Compare(DeliveryServiceDropDown.Items(i).Value, service, True) = 0 Then
                                            DeliveryServiceDropDown.SelectedIndex = i
                                            System.Diagnostics.Debug.WriteLine("Set delivery service dropdown by case-insensitive match to index: " & i)
                                            Exit For
                                        End If
                                    Next
                                End If
                            Catch innerEx As Exception
                                System.Diagnostics.Debug.WriteLine("Could not set dropdown by text: " & innerEx.Message)
                            End Try
                        End Try
                    End If
                End If
                
                ' Set the driver name if it exists
                If row.Table.Columns.Contains("driver_name") AndAlso Not row.IsNull("driver_name") Then
                    DriverNameTextBox.Text = row("driver_name").ToString()
                    System.Diagnostics.Debug.WriteLine("Set driver name textbox to: " & DriverNameTextBox.Text)
                End If
                
                ' Set the tracking link if it exists
                If row.Table.Columns.Contains("tracking_link") AndAlso Not row.IsNull("tracking_link") Then
                    TrackingLinkTextBox.Text = row("tracking_link").ToString()
                    System.Diagnostics.Debug.WriteLine("Set tracking link textbox to: " & TrackingLinkTextBox.Text)
                End If
                
                ' Set the notes if they exist
                If row.Table.Columns.Contains("delivery_notes") AndAlso Not row.IsNull("delivery_notes") Then
                    DeliveryNotesTextBox.Text = row("delivery_notes").ToString()
                    System.Diagnostics.Debug.WriteLine("Set delivery notes textbox to: " & DeliveryNotesTextBox.Text)
                End If
            Else
                ' Clear the form fields if no data exists
                System.Diagnostics.Debug.WriteLine("No delivery info found or columns don't exist, clearing form fields")
                DeliveryServiceDropDown.SelectedIndex = 0
                DriverNameTextBox.Text = String.Empty
                TrackingLinkTextBox.Text = String.Empty
                DeliveryNotesTextBox.Text = String.Empty
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error loading delivery info: " & ex.Message)
            
            ' Clear the form fields on error
            DeliveryServiceDropDown.SelectedIndex = 0
            DriverNameTextBox.Text = String.Empty
            TrackingLinkTextBox.Text = String.Empty
            DeliveryNotesTextBox.Text = String.Empty
        End Try
    End Sub

    Protected Sub SaveStatusButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim orderId As Integer
            If Integer.TryParse(SelectedOrderId.Value, orderId) Then
                Dim newStatus As String = StatusDropDown.SelectedValue

                If String.IsNullOrEmpty(newStatus) Then
                    ShowAlert("Please select a status.", "alert-warning")
                    Return
                End If

                UpdateOrderStatus(orderId, newStatus)
                ShowAlert("Order #" & orderId & " status updated to " & newStatus & ".", "alert-success")
                LoadOrders()

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
            
            ' Execute a direct query to check the database values
            Dim conn As New SqlConnection(Connect.ConnectionString)
            Dim cmd As New SqlCommand("SELECT order_id, driver_name, delivery_service, tracking_link, delivery_notes FROM orders WHERE order_id = @OrderID", conn)
            cmd.Parameters.AddWithValue("@OrderID", orderId)
            
            conn.Open()
            Dim reader As SqlDataReader = cmd.ExecuteReader()
            
            If reader.Read() Then
                System.Diagnostics.Debug.WriteLine("VALUES IN DATABASE:")
                System.Diagnostics.Debug.WriteLine("  order_id: " & reader("order_id").ToString())
                
                System.Diagnostics.Debug.WriteLine("  driver_name: " & 
                    If(reader.IsDBNull(reader.GetOrdinal("driver_name")), "NULL", "'" & reader("driver_name").ToString() & "'"))
                
                System.Diagnostics.Debug.WriteLine("  delivery_service: " & 
                    If(reader.IsDBNull(reader.GetOrdinal("delivery_service")), "NULL", "'" & reader("delivery_service").ToString() & "'"))
                
                System.Diagnostics.Debug.WriteLine("  tracking_link: " & 
                    If(reader.IsDBNull(reader.GetOrdinal("tracking_link")), "NULL", "'" & reader("tracking_link").ToString() & "'"))
                
                System.Diagnostics.Debug.WriteLine("  delivery_notes: " & 
                    If(reader.IsDBNull(reader.GetOrdinal("delivery_notes")), "NULL", "'" & reader("delivery_notes").ToString() & "'"))
            Else
                System.Diagnostics.Debug.WriteLine("No record found for order ID: " & orderId)
            End If
            
            reader.Close()
            conn.Close()
            
            System.Diagnostics.Debug.WriteLine("===================================================")
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error verifying delivery info: " & ex.Message)
        End Try
    End Sub

    Private Function UpdateDeliveryInfoDirectADO(ByVal orderId As Integer, ByVal deliveryService As String, ByVal driverName As String, _
                                      ByVal trackingLink As String, ByVal notes As String) As Boolean
        Try
            System.Diagnostics.Debug.WriteLine("Using direct ADO.NET method for update...")
            System.Diagnostics.Debug.WriteLine("  deliveryService: '" & deliveryService & "'")
            System.Diagnostics.Debug.WriteLine("  driverName: '" & driverName & "'")
            
            Dim conn As New SqlConnection(Connect.ConnectionString)
            Dim cmd As New SqlCommand("UPDATE orders SET " & _
                                     "delivery_service = @DeliveryService, " & _
                                     "driver_name = @DriverName, " & _
                                     "tracking_link = @TrackingLink, " & _
                                     "delivery_notes = @Notes " & _
                                     "WHERE order_id = @OrderID", conn)
            
            ' Add parameters with proper handling of NULL/empty values
            cmd.Parameters.Add("@OrderID", SqlDbType.Int).Value = orderId
            
            ' Make sure the delivery service is not null or empty even if selected from dropdown
            If String.IsNullOrEmpty(deliveryService) Then
                cmd.Parameters.Add("@DeliveryService", SqlDbType.NVarChar, 50).Value = DBNull.Value
            Else
                cmd.Parameters.Add("@DeliveryService", SqlDbType.NVarChar, 50).Value = deliveryService.Trim()
                System.Diagnostics.Debug.WriteLine("Setting @DeliveryService parameter value: '" & deliveryService.Trim() & "'")
            End If
            
            ' Handle other parameters
            If String.IsNullOrEmpty(driverName) Then
                cmd.Parameters.Add("@DriverName", SqlDbType.NVarChar, 100).Value = DBNull.Value
            Else
                cmd.Parameters.Add("@DriverName", SqlDbType.NVarChar, 100).Value = driverName.Trim()
            End If
            
            If String.IsNullOrEmpty(trackingLink) Then
                cmd.Parameters.Add("@TrackingLink", SqlDbType.NVarChar, 255).Value = DBNull.Value
            Else
                cmd.Parameters.Add("@TrackingLink", SqlDbType.NVarChar, 255).Value = trackingLink.Trim()
            End If
            
            If String.IsNullOrEmpty(notes) Then
                cmd.Parameters.Add("@Notes", SqlDbType.NVarChar, 500).Value = DBNull.Value
            Else
                cmd.Parameters.Add("@Notes", SqlDbType.NVarChar, 500).Value = notes.Trim()
            End If
            
            conn.Open()
            Dim rowsAffected As Integer = cmd.ExecuteNonQuery()
            conn.Close()
            
            System.Diagnostics.Debug.WriteLine("Direct ADO.NET update rows affected: " & rowsAffected)
            Return rowsAffected > 0
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error in direct ADO.NET update: " & ex.Message)
            Return False
        End Try
    End Function
    
    Protected Sub SaveDeliveryButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim orderId As Integer
            If Integer.TryParse(DeliveryOrderId.Value, orderId) Then
                System.Diagnostics.Debug.WriteLine("Processing delivery info for order: " & orderId)
                
                ' Make sure we get the selected value correctly
                Dim deliveryService As String = DeliveryServiceDropDown.SelectedValue.Trim()
                Dim selectedIndex As Integer = DeliveryServiceDropDown.SelectedIndex
                Dim selectedText As String = DeliveryServiceDropDown.SelectedItem.Text.Trim()
                
                System.Diagnostics.Debug.WriteLine("DROPDOWN VALUES:")
                System.Diagnostics.Debug.WriteLine("  SelectedValue: '" & deliveryService & "'")
                System.Diagnostics.Debug.WriteLine("  SelectedIndex: " & selectedIndex)
                System.Diagnostics.Debug.WriteLine("  SelectedText: '" & selectedText & "'")
                System.Diagnostics.Debug.WriteLine("  Items Count: " & DeliveryServiceDropDown.Items.Count)
                
                For i As Integer = 0 To DeliveryServiceDropDown.Items.Count - 1
                    System.Diagnostics.Debug.WriteLine("  Item " & i & ": Value='" & DeliveryServiceDropDown.Items(i).Value & "', Text='" & DeliveryServiceDropDown.Items(i).Text & "'")
                Next
                
                Dim driverName As String = DriverNameTextBox.Text.Trim()
                Dim trackingLink As String = TrackingLinkTextBox.Text.Trim()
                Dim notes As String = DeliveryNotesTextBox.Text.Trim()

                System.Diagnostics.Debug.WriteLine("==== INPUT VALUES ====")
                System.Diagnostics.Debug.WriteLine("deliveryService: " & If(String.IsNullOrEmpty(deliveryService), "EMPTY", deliveryService))
                System.Diagnostics.Debug.WriteLine("driverName: " & If(String.IsNullOrEmpty(driverName), "EMPTY", driverName))
                System.Diagnostics.Debug.WriteLine("trackingLink: " & If(String.IsNullOrEmpty(trackingLink), "EMPTY", trackingLink))
                System.Diagnostics.Debug.WriteLine("notes: " & If(String.IsNullOrEmpty(notes), "EMPTY", notes))

                ' If the dropdown index is 0, that's the "Select Service" option - handle it as empty
                If selectedIndex = 0 OrElse String.IsNullOrEmpty(deliveryService) Then
                    ShowAlert("Please select a delivery service.", "alert-warning")
                    Return
                End If

                If String.IsNullOrEmpty(driverName) Then
                    ShowAlert("Please enter driver name.", "alert-warning")
                    Return
                End If

                ' First, test if the database actually contains these columns
                Try
                    Dim testQuery As String = "SELECT TOP 1 order_id, ISNULL(driver_name, 'NULL') AS driver_name, " & _
                                            "ISNULL(delivery_service, 'NULL') AS delivery_service, " & _
                                            "ISNULL(tracking_link, 'NULL') AS tracking_link, " & _
                                            "ISNULL(delivery_notes, 'NULL') AS delivery_notes " & _
                                            "FROM orders " & _
                                            "WHERE order_id = @order_id"
                    Connect.ClearParams()
                    Connect.AddParam("@order_id", orderId)
                    Dim success = Connect.Query(testQuery)
                    System.Diagnostics.Debug.WriteLine("Test query for columns result: " & success)
                    
                    If success Then
                        System.Diagnostics.Debug.WriteLine("Columns exist in database. Current values:")
                        System.Diagnostics.Debug.WriteLine("  driver_name: " & Connect.Data.Tables(0).Rows(0)("driver_name").ToString())
                        System.Diagnostics.Debug.WriteLine("  delivery_service: " & Connect.Data.Tables(0).Rows(0)("delivery_service").ToString())
                        System.Diagnostics.Debug.WriteLine("  tracking_link: " & Connect.Data.Tables(0).Rows(0)("tracking_link").ToString())
                        System.Diagnostics.Debug.WriteLine("  delivery_notes: " & Connect.Data.Tables(0).Rows(0)("delivery_notes").ToString())
                    End If
                Catch ex As Exception
                    System.Diagnostics.Debug.WriteLine("ERROR testing columns: " & ex.Message)
                    
                    ' Ensure delivery columns exist before saving
                    If Not DoColumnsExist() Then
                        EnsureDeliveryColumnsExist()
                    End If
                End Try

                ' Try the direct ADO.NET approach first (most reliable)
                Dim adoResult As Boolean = UpdateDeliveryInfoDirectADO(orderId, deliveryService, driverName, trackingLink, notes)
                System.Diagnostics.Debug.WriteLine("Direct ADO.NET update result: " & adoResult)
                
                ' If that fails, try the other methods
                If Not adoResult Then
                    Dim saveResult As Boolean = SaveDeliveryInfo(orderId, deliveryService, driverName, trackingLink, notes)
                    System.Diagnostics.Debug.WriteLine("SaveDeliveryInfo result: " & saveResult)
                    
                    ' If standard update fails, try alternate method
                    If Not saveResult Then
                        System.Diagnostics.Debug.WriteLine("Standard update failed, trying alternate method...")
                        SaveDeliveryInfoAlternateMethod(orderId, deliveryService, driverName, trackingLink, notes)
                    End If
                End If
                
                ' Verify the database content after updates
                VerifyDeliveryInfoSaved(orderId)
                
                ' Final fallback: use the most direct SQL approach possible just for delivery_service
                Try
                    Dim directConn As New SqlConnection(Connect.ConnectionString)
                    Dim directCommand As String = "UPDATE orders SET delivery_service = @service WHERE order_id = @id"
                    Dim directCmd As New SqlCommand(directCommand, directConn)
                    
                    directCmd.Parameters.AddWithValue("@id", orderId)
                    directCmd.Parameters.AddWithValue("@service", deliveryService)
                    
                    directConn.Open()
                    Dim updateResult As Integer = directCmd.ExecuteNonQuery()
                    directConn.Close()
                    
                    System.Diagnostics.Debug.WriteLine("EMERGENCY DIRECT UPDATE - Result: " & updateResult & " rows affected")
                Catch directEx As Exception
                    System.Diagnostics.Debug.WriteLine("Error in emergency direct update: " & directEx.Message)
                End Try
                
                ' Check column types if having issues
                CheckColumnTypes()
                
                ' Verify the update was successful by reloading the delivery info
                System.Diagnostics.Debug.WriteLine("Verifying delivery info was saved...")
                LoadDeliveryInfo(orderId)
                
                ' Check current status and only update to delivering if not already completed
                Dim currentStatus As String = GetOrderStatus(orderId)
                If currentStatus.ToLower() <> "completed" AndAlso currentStatus.ToLower() <> "delivering" Then
                    UpdateOrderStatus(orderId, "delivering")
                End If
                
                ShowAlert("Delivery information saved for Order #" & orderId & ".", "alert-success")
                LoadOrders()

                ' Close modal through JavaScript
                Dim script As String = "closeModal('deliveryInfoModal');"
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "CloseDeliveryModal", script, True)
            Else
                ShowAlert("Invalid order ID: " & DeliveryOrderId.Value, "alert-danger")
                System.Diagnostics.Debug.WriteLine("Invalid order ID in SaveDeliveryButton_Click: " & DeliveryOrderId.Value)
            End If
        Catch ex As Exception
            ShowAlert("Error saving delivery information: " & ex.Message, "alert-danger")
            System.Diagnostics.Debug.WriteLine("Error in SaveDeliveryButton_Click: " & ex.Message)
        End Try
    End Sub

    Private Sub UpdateOrderStatus(ByVal orderId As Integer, ByVal status As String)
        Try
            Dim query As String = "UPDATE orders SET status = @status WHERE order_id = @order_id"
            Connect.ClearParams()
            Connect.AddParam("@order_id", orderId)
            Connect.AddParam("@status", status)
            Connect.Query(query)
        Catch ex As Exception
            ShowAlert("Error updating order status: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Private Function SaveDeliveryInfo(ByVal orderId As Integer, ByVal deliveryService As String, ByVal driverName As String, _
                                 ByVal trackingLink As String, ByVal notes As String) As Boolean
        Try
            ' Debug information
            System.Diagnostics.Debug.WriteLine("SaveDeliveryInfo called with:")
            System.Diagnostics.Debug.WriteLine("  Order ID: " & orderId)
            System.Diagnostics.Debug.WriteLine("  Service: " & deliveryService)
            System.Diagnostics.Debug.WriteLine("  Driver: " & driverName)
            System.Diagnostics.Debug.WriteLine("  Tracking: " & trackingLink)
            System.Diagnostics.Debug.WriteLine("  Notes: " & notes)
            
            ' Ensure columns exist before saving
            If Not DoColumnsExist() Then
                EnsureDeliveryColumnsExist()
            End If

            ' TESTING APPROACH 1: Simple single-field update
            System.Diagnostics.Debug.WriteLine("TESTING APPROACH 1: Simple single-field update")
            Dim singleUpdate As String = "UPDATE orders SET driver_name = 1, delivery_service = 2, tracking_link = 3, delivery_notes = 4 WHERE order_id = @order_id"
            Connect.ClearParams()
            Connect.AddParam("@order_id", orderId)
            Connect.AddParamWithNull("@driver_name", If(String.IsNullOrEmpty(driverName), Nothing, driverName.Trim()))
            Connect.AddParamWithNull("@delivery_service", If(String.IsNullOrEmpty(deliveryService), Nothing, deliveryService.Trim()))
            Connect.AddParamWithNull("@tracking_link", If(String.IsNullOrEmpty(trackingLink), Nothing, trackingLink.Trim()))
            Connect.AddParamWithNull("@delivery_notes", If(String.IsNullOrEmpty(notes), Nothing, notes.Trim()))

            Dim success1 As Boolean = Connect.Query(singleUpdate)
            System.Diagnostics.Debug.WriteLine("Simple update result: " & success1)
            
            ' TESTING APPROACH 2: Update with all fields using standard UPDATE syntax
            System.Diagnostics.Debug.WriteLine("TESTING APPROACH 2: Standard multi-field update")
            Dim query As String = "UPDATE orders SET " & _
                               "delivery_service = @delivery_service, " & _
                               "driver_name = @driver_name, " & _
                               "tracking_link = @tracking_link, " & _
                               "delivery_notes = @delivery_notes " & _
                               "WHERE order_id = @order_id"

            System.Diagnostics.Debug.WriteLine("SQL Query: " & query)
            
            Connect.ClearParams()
            Connect.AddParam("@order_id", orderId)
            Connect.AddParamWithNull("@delivery_service", If(String.IsNullOrEmpty(deliveryService), Nothing, deliveryService.Trim()))
            Connect.AddParamWithNull("@driver_name", If(String.IsNullOrEmpty(driverName), Nothing, driverName.Trim()))
            Connect.AddParamWithNull("@tracking_link", If(String.IsNullOrEmpty(trackingLink), Nothing, trackingLink.Trim()))
            Connect.AddParamWithNull("@delivery_notes", If(String.IsNullOrEmpty(notes), Nothing, notes.Trim()))
            
            Dim success2 As Boolean = Connect.Query(query)
            System.Diagnostics.Debug.WriteLine("Standard update result: " & success2)
            
            ' TESTING APPROACH 3: Direct SQL Query without parameters
            System.Diagnostics.Debug.WriteLine("TESTING APPROACH 3: Direct SQL")
            
            ' Format string values for SQL
            Dim sqlDeliveryService As String = If(String.IsNullOrEmpty(deliveryService), "NULL", "'" & deliveryService.Replace("'", "''").Trim() & "'")
            Dim sqlDriverName As String = If(String.IsNullOrEmpty(driverName), "NULL", "'" & driverName.Replace("'", "''").Trim() & "'")
            Dim sqlTrackingLink As String = If(String.IsNullOrEmpty(trackingLink), "NULL", "'" & trackingLink.Replace("'", "''").Trim() & "'")
            Dim sqlNotes As String = If(String.IsNullOrEmpty(notes), "NULL", "'" & notes.Replace("'", "''").Trim() & "'")
            
            Dim directSql As String = "UPDATE orders SET " & _
                               "delivery_service = " & sqlDeliveryService & ", " & _
                               "driver_name = " & sqlDriverName & ", " & _
                               "tracking_link = " & sqlTrackingLink & ", " & _
                               "delivery_notes = " & sqlNotes & " " & _
                               "WHERE order_id = " & orderId
            
            System.Diagnostics.Debug.WriteLine("Direct SQL: " & directSql)
                               
            Dim success3 As Boolean = Connect.DirectQuery(directSql)
            System.Diagnostics.Debug.WriteLine("Direct SQL result: " & success3)
            
            Return success1 Or success2 Or success3
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error in SaveDeliveryInfo: " & ex.Message)
            ShowAlert("Error saving delivery information: " & ex.Message, "alert-danger")
            Return False
        End Try
    End Function

    Protected Sub SearchButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim searchTerm As String = SearchBox.Text.Trim()

        If String.IsNullOrEmpty(searchTerm) Then
            LoadOrders()
            Return
        End If

        Try
            ' First check if all columns exist
            Dim columnExists As Boolean = DoColumnsExist()

            ' Search for orders matching the search term
            Dim query As String

            If columnExists Then
                query = "SELECT o.order_id, o.order_date, o.status, o.total_amount, " & _
                      "u.display_name AS customer_name, u.contact AS customer_contact, u.address AS customer_address, " & _
                      "o.driver_name, o.delivery_service, o.tracking_link " & _
                      "FROM orders o " & _
                      "INNER JOIN users u ON o.user_id = u.user_id " & _
                      "WHERE o.order_id LIKE @search " & _
                      "OR u.display_name LIKE @search " & _
                      "OR o.status LIKE @search " & _
                      "OR u.contact LIKE @search " & _
                      "OR u.address LIKE @search " & _
                      "ORDER BY o.order_date DESC"
            Else
                ' Use a simplified query without the delivery columns
                query = "SELECT o.order_id, o.order_date, o.status, o.total_amount, " & _
                      "u.display_name AS customer_name, u.contact AS customer_contact, u.address AS customer_address " & _
                      "FROM orders o " & _
                      "INNER JOIN users u ON o.user_id = u.user_id " & _
                      "WHERE o.order_id LIKE @search " & _
                      "OR u.display_name LIKE @search " & _
                      "OR o.status LIKE @search " & _
                      "OR u.contact LIKE @search " & _
                      "OR u.address LIKE @search " & _
                      "ORDER BY o.order_date DESC"
            End If

            Connect.ClearParams()
            Connect.AddParam("@search", "%" & searchTerm & "%")
            Connect.Query(query)

            If Connect.DataCount > 0 Then
                OrdersListView.DataSource = Connect.Data
                OrdersListView.DataBind()
            Else
                OrdersListView.DataSource = Nothing
                OrdersListView.DataBind()
                ShowAlert("No orders found matching '" & searchTerm & "'.", "alert-info")
            End If
        Catch ex As Exception
            ShowAlert("Error searching orders: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Private Sub ShowAlert(ByVal message As String, ByVal alertType As String)
        alertMessage.Visible = True
        alertMessage.Attributes("class") = "alert-message " & alertType
        AlertLiteral.Text = message
    End Sub

    Protected Sub OrdersListView_ItemDataBound(ByVal sender As Object, ByVal e As ListViewItemEventArgs)
        If e.Item.ItemType = ListViewItemType.DataItem Then
            Try
                Dim dataItem As DataRowView = CType(e.Item.DataItem, DataRowView)
                Dim row As DataRow = dataItem.Row

                ' Get references to the action panels
                Dim pendingActionsPanel As Panel = CType(e.Item.FindControl("PendingActionsPanel"), Panel)
                Dim inProgressActionsPanel As Panel = CType(e.Item.FindControl("InProgressActionsPanel"), Panel)

                ' Set visibility of action panels based on status
                If pendingActionsPanel IsNot Nothing AndAlso inProgressActionsPanel IsNot Nothing Then
                    Dim status As String = row("status").ToString().ToLower()

                    ' Show pending actions for pending orders
                    pendingActionsPanel.Visible = (status = "pending")

                    ' Show in progress actions for accepted, preparing, ready, or processing orders
                    inProgressActionsPanel.Visible = (status = "accepted" OrElse
                                                     status = "preparing" OrElse
                                                     status = "ready" OrElse
                                                     status = "processing")
                End If

                ' Get references to the controls
                Dim deliveryPanel As Panel = CType(e.Item.FindControl("DeliveryInfoPanel"), Panel)
                If deliveryPanel IsNot Nothing Then
                    ' Default visibility to false
                    deliveryPanel.Visible = False

                    Try
                        ' Get literals and controls
                        Dim serviceLabel As Literal = CType(deliveryPanel.FindControl("DeliveryServiceLiteral"), Literal)
                        Dim driverLabel As Literal = CType(deliveryPanel.FindControl("DriverNameLiteral"), Literal)
                        Dim trackingPanel As Panel = CType(deliveryPanel.FindControl("TrackingPanel"), Panel)

                        If serviceLabel IsNot Nothing AndAlso driverLabel IsNot Nothing AndAlso trackingPanel IsNot Nothing Then
                            Dim trackingLink As HyperLink = CType(trackingPanel.FindControl("TrackingLink"), HyperLink)

                            ' By default, hide the tracking panel
                            trackingPanel.Visible = False

                            ' Check if driver_name or delivery_service column exists and has a value
                            Dim hasDriverInfo As Boolean = False

                            ' Handle driver_name column
                            If row.Table.Columns.Contains("driver_name") Then
                                If Not row.IsNull("driver_name") AndAlso Not String.IsNullOrEmpty(row("driver_name").ToString()) Then
                                    hasDriverInfo = True
                                    driverLabel.Text = row("driver_name").ToString()
                                Else
                                    driverLabel.Text = "Not specified"
                                End If
                            Else
                                driverLabel.Text = "Not specified"
                            End If

                            ' Handle delivery_service column
                            If row.Table.Columns.Contains("delivery_service") Then
                                If Not row.IsNull("delivery_service") AndAlso Not String.IsNullOrEmpty(row("delivery_service").ToString()) Then
                                    hasDriverInfo = True ' If we have delivery service, show the panel
                                    serviceLabel.Text = row("delivery_service").ToString()
                                Else
                                    serviceLabel.Text = "Not specified"
                                End If
                            Else
                                serviceLabel.Text = "Not specified"
                            End If

                            ' Handle tracking_link column
                            If trackingLink IsNot Nothing Then
                                If row.Table.Columns.Contains("tracking_link") Then
                                    If Not row.IsNull("tracking_link") AndAlso Not String.IsNullOrEmpty(row("tracking_link").ToString()) Then
                                        trackingLink.NavigateUrl = row("tracking_link").ToString()
                                        trackingPanel.Visible = True
                                        hasDriverInfo = True ' If we have tracking, show the panel
                                    End If
                                End If
                            End If

                            ' Show the delivery panel if we have any delivery information
                            deliveryPanel.Visible = hasDriverInfo
                        End If
                    Catch innerEx As Exception
                        ' Log inner exception but continue
                        System.Diagnostics.Debug.WriteLine("Error accessing controls in ItemDataBound: " & innerEx.Message)
                    End Try
                End If
            Catch ex As Exception
                ' Log the error but continue
                System.Diagnostics.Debug.WriteLine("Error in ItemDataBound: " & ex.Message)
            End Try
        End If
    End Sub
End Class
