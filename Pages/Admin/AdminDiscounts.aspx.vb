Imports System.Data
Imports System.Text
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls

Partial Class Pages_Admin_AdminDiscounts
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        ' Debug initialization of controls
        System.Diagnostics.Debug.WriteLine("Page_Init called - initializing controls")
        
        ' Make sure the table container is visible by default
        If TableContainer IsNot Nothing Then
            TableContainer.Visible = True
            System.Diagnostics.Debug.WriteLine("TableContainer set to visible")
        Else
            System.Diagnostics.Debug.WriteLine("TableContainer is null in Page_Init")
        End If
        
        ' Make sure the NoRecords panel is hidden by default
        If NoRecords IsNot Nothing Then
            NoRecords.Visible = False
            System.Diagnostics.Debug.WriteLine("NoRecords set to hidden")
        Else
            System.Diagnostics.Debug.WriteLine("NoRecords is null in Page_Init")
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        System.Diagnostics.Debug.WriteLine("Page_Load called")
        If Not IsPostBack Then
            System.Diagnostics.Debug.WriteLine("First page load - validating table and populating data")
            ValidateTableStructure()
            ViewTable()
        End If
    End Sub

    Protected Sub AddBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddBtn.Click
        Try
            ' Validate required fields
            If String.IsNullOrEmpty(NameTxt.Text) OrElse String.IsNullOrEmpty(ValueTxt.Text) Then
                showAlert("Name and Value are required fields!", "warning")
                Return
            End If

            ' Validate dates
            Dim startDate As DateTime
            Dim endDate As DateTime
            If Not DateTime.TryParse(StartDateTxt.Text, startDate) OrElse Not DateTime.TryParse(EndDateTxt.Text, endDate) Then
                showAlert("Please enter valid dates!", "warning")
                Return
            End If

            ' Validate value based on type
            Dim valueText As String = ValueTxt.Text.Trim()
            ' Remove % if present
            If valueText.EndsWith("%") Then
                valueText = valueText.Substring(0, valueText.Length - 1)
            End If

            Dim value As Decimal
            If Not Decimal.TryParse(valueText, value) Then
                showAlert("Please enter a valid numeric value!", "warning")
                Return
            End If

            ' For percentage discount, validate range
            If DiscountTypeDdl.SelectedValue = "1" And (value < 0 Or value > 100) Then
                showAlert("Percentage discount must be between 0 and 100!", "warning")
                Return
            End If

            ' Validate min order amount if present
            Dim minOrderAmount As Decimal = 0
            If Not String.IsNullOrEmpty(MinOrderAmountTxt.Text) AndAlso Not Decimal.TryParse(MinOrderAmountTxt.Text, minOrderAmount) Then
                showAlert("Please enter a valid minimum order amount!", "warning")
                Return
            End If

            ' Prepare SQL query
            Dim query As String = "INSERT INTO discounts (name, discount_type, value, applicable_to, start_date, end_date, min_order_amount, status, description, created_at) " & _
                             "VALUES (@name, @discount_type, @value, @applicable_to, @start_date, @end_date, @min_order_amount, @status, @description, GETDATE())"

            ' Add parameters
            Connect.ClearParams()
            Connect.AddParam("@name", NameTxt.Text.Trim())
            Connect.AddParam("@discount_type", Integer.Parse(DiscountTypeDdl.SelectedValue))
            Connect.AddParam("@value", value)
            Connect.AddParam("@applicable_to", Integer.Parse(ApplicableToDdl.SelectedValue))
            Connect.AddParam("@start_date", startDate)
            Connect.AddParam("@end_date", endDate)
            Connect.AddParam("@min_order_amount", minOrderAmount)
            Connect.AddParam("@status", Integer.Parse(StatusDdl.SelectedValue))
            Connect.AddParam("@description", DescriptionTxt.Text.Trim())

            ' Execute query
            Connect.Query(query)

            ' Show success message and refresh table
            showAlert("Discount added successfully!", "success")
            ClearForm()
            ViewTable()

        Catch ex As Exception
            showAlert("Error adding discount: " & ex.Message, "danger")
            System.Diagnostics.Debug.WriteLine("Error in AddBtn_Click: " & ex.Message)
            System.Diagnostics.Debug.WriteLine(ex.StackTrace)
        End Try
    End Sub

    Protected Sub EditBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles EditBtn.Click
        Try
            ' Validate discount ID
            If String.IsNullOrEmpty(DiscountIdHidden.Value) Then
                showAlert("Please select a discount to edit!", "warning")
                Return
            End If

            ' Validate required fields
            If String.IsNullOrEmpty(NameTxt.Text) OrElse String.IsNullOrEmpty(ValueTxt.Text) Then
                showAlert("Name and Value are required fields!", "warning")
                Return
            End If

            ' Validate dates
            Dim startDate As DateTime
            Dim endDate As DateTime
            If Not DateTime.TryParse(StartDateTxt.Text, startDate) OrElse Not DateTime.TryParse(EndDateTxt.Text, endDate) Then
                showAlert("Please enter valid dates!", "warning")
                Return
            End If

            ' Validate value based on type
            Dim valueText As String = ValueTxt.Text.Trim()
            ' Remove % if present
            If valueText.EndsWith("%") Then
                valueText = valueText.Substring(0, valueText.Length - 1)
            End If

            Dim value As Decimal
            If Not Decimal.TryParse(valueText, value) Then
                showAlert("Please enter a valid numeric value!", "warning")
                Return
            End If

            ' For percentage discount, validate range
            If DiscountTypeDdl.SelectedValue = "1" And (value < 0 Or value > 100) Then
                showAlert("Percentage discount must be between 0 and 100!", "warning")
                Return
            End If

            ' Validate min order amount if present
            Dim minOrderAmount As Decimal = 0
            If Not String.IsNullOrEmpty(MinOrderAmountTxt.Text) AndAlso Not Decimal.TryParse(MinOrderAmountTxt.Text, minOrderAmount) Then
                showAlert("Please enter a valid minimum order amount!", "warning")
                Return
            End If

            ' Prepare SQL query
            Dim query As String = "UPDATE discounts SET " & _
                                 "name = @name, " & _
                                 "discount_type = @discount_type, " & _
                                 "value = @value, " & _
                                 "applicable_to = @applicable_to, " & _
                                 "start_date = @start_date, " & _
                                 "end_date = @end_date, " & _
                                 "min_order_amount = @min_order_amount, " & _
                                 "status = @status, " & _
                                 "description = @description, " & _
                                 "updated_at = GETDATE() " & _
                                 "WHERE discount_id = @discount_id"

            ' Add parameters
            Connect.ClearParams()
            Connect.AddParam("@discount_id", Integer.Parse(DiscountIdHidden.Value))
            Connect.AddParam("@name", NameTxt.Text.Trim())
            Connect.AddParam("@discount_type", Integer.Parse(DiscountTypeDdl.SelectedValue))
            Connect.AddParam("@value", value)
            Connect.AddParam("@applicable_to", Integer.Parse(ApplicableToDdl.SelectedValue))
            Connect.AddParam("@start_date", startDate)
            Connect.AddParam("@end_date", endDate)
            Connect.AddParam("@min_order_amount", minOrderAmount)
            Connect.AddParam("@status", Integer.Parse(StatusDdl.SelectedValue))
            Connect.AddParam("@description", DescriptionTxt.Text.Trim())

            ' Execute query
            Connect.Query(query)

            ' Show success message and refresh table
            showAlert("Discount updated successfully!", "success")
            ClearForm()
            ViewTable()

        Catch ex As Exception
            showAlert("Error updating discount: " & ex.Message, "danger")
            System.Diagnostics.Debug.WriteLine("Error in EditBtn_Click: " & ex.Message)
            System.Diagnostics.Debug.WriteLine(ex.StackTrace)
        End Try
    End Sub

    Protected Sub RemoveBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RemoveBtn.Click
        Try
            ' Validate discount ID
            If String.IsNullOrEmpty(DiscountIdHidden.Value) Then
                showAlert("Please select a discount to remove!", "warning")
                Return
            End If

            ' Prepare SQL query
            Dim query As String = "DELETE FROM discounts WHERE discount_id = @discount_id"

            ' Add parameters
            Connect.ClearParams()
            Connect.AddParam("@discount_id", Integer.Parse(DiscountIdHidden.Value))

            ' Execute query
            Connect.Query(query)

            ' Show success message and refresh table
            showAlert("Discount removed successfully!", "success")
            ClearForm()
            ViewTable()

        Catch ex As Exception
            showAlert("Error removing discount: " & ex.Message, "danger")
            System.Diagnostics.Debug.WriteLine("Error in RemoveBtn_Click: " & ex.Message)
            System.Diagnostics.Debug.WriteLine(ex.StackTrace)
        End Try
    End Sub

    Protected Sub ClearBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ClearBtn.Click
        ClearForm()
    End Sub

    Protected Sub ViewTable()
        Try
            System.Diagnostics.Debug.WriteLine("ViewTable method called")
            
            ' Add debug message about the table control
            System.Diagnostics.Debug.WriteLine("Table1 is null: " & (Table1 Is Nothing).ToString())
            System.Diagnostics.Debug.WriteLine("TableContainer is null: " & (TableContainer Is Nothing).ToString())
            System.Diagnostics.Debug.WriteLine("DiscountIdHidden is null: " & (DiscountIdHidden Is Nothing).ToString())
            
            ' Prepare SQL query to get all discounts
            Dim query As String = "SELECT discount_id, name, " & _
                                 "CASE discount_type WHEN 1 THEN 'Percentage' ELSE 'Fixed Amount' END AS discount_type, " & _
                                 "CASE discount_type " & _
                                 "    WHEN 1 THEN CAST(value AS NVARCHAR) + '%' " & _
                                 "    ELSE 'PHP ' + CAST(value AS NVARCHAR) " & _
                                 "END AS value, " & _
                                 "CASE applicable_to " & _
                                 "    WHEN 1 THEN 'All Products' " & _
                                 "    WHEN 2 THEN 'Specific Category' " & _
                                 "    ELSE 'Specific Product' " & _
                                 "END AS applicable_to, " & _
                                 "CONVERT(VARCHAR, start_date, 101) AS start_date, " & _
                                 "CONVERT(VARCHAR, end_date, 101) AS end_date, " & _
                                 "CASE WHEN min_order_amount IS NULL OR min_order_amount = 0 THEN 'None' " & _
                                 "    ELSE 'PHP ' + CAST(min_order_amount AS NVARCHAR) " & _
                                 "END AS min_order_amount, " & _
                                 "CASE status WHEN 1 THEN 'Active' ELSE 'Inactive' END AS status, " & _
                                 "description " & _
                                 "FROM discounts " & _
                                 "ORDER BY discount_id DESC"
            
            System.Diagnostics.Debug.WriteLine("Query: " & query)

            ' Clear any existing parameters before executing the query
            Connect.ClearParams()
            
            ' Execute query
            Dim success As Boolean = Connect.Query(query)
            System.Diagnostics.Debug.WriteLine("Query executed, success: " & success & ", record count: " & Connect.DataCount)
            
            ' Always clear the table to start fresh
            Table1.Rows.Clear()
            
            ' Add header row
            Dim headerRow As New TableHeaderRow()
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Name"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Type"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Value"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Applicable To"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Start Date"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "End Date"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Min Order"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Status"})
            Table1.Rows.Add(headerRow)
            
            ' Check if data exists
            If Connect.DataCount > 0 Then
                For Each dataRow As DataRow In Connect.Data.Tables(0).Rows
                    System.Diagnostics.Debug.WriteLine("Row found - ID: " & dataRow("discount_id").ToString() & ", Name: " & dataRow("name").ToString())
                    
                    ' Create a new row
                    Dim tableRow As New TableRow()
                    
                    ' Create cells and populate with data
                    tableRow.Cells.Add(New TableCell() With {.Text = dataRow("name").ToString()})
                    tableRow.Cells.Add(New TableCell() With {.Text = dataRow("discount_type").ToString()})
                    tableRow.Cells.Add(New TableCell() With {.Text = dataRow("value").ToString()})
                    tableRow.Cells.Add(New TableCell() With {.Text = dataRow("applicable_to").ToString()})
                    tableRow.Cells.Add(New TableCell() With {.Text = dataRow("start_date").ToString()})
                    tableRow.Cells.Add(New TableCell() With {.Text = dataRow("end_date").ToString()})
                    tableRow.Cells.Add(New TableCell() With {.Text = dataRow("min_order_amount").ToString()})
                    
                    ' Add status with appropriate style
                    Dim statusCell As New TableCell()
                    Dim statusText As String = dataRow("status").ToString()
                    If statusText = "Active" Then
                        statusCell.Text = "<span class='status-active'>" & statusText & "</span>"
                    Else
                        statusCell.Text = "<span class='status-inactive'>" & statusText & "</span>"
                    End If
                    tableRow.Cells.Add(statusCell)
                    
                    ' Set data attributes
                    tableRow.Attributes.Add("data-discount_id", dataRow("discount_id").ToString())
                    tableRow.Attributes.Add("data-description", dataRow("description").ToString())
                    
                    ' Add the completed row to the table
                    Table1.Rows.Add(tableRow)
                Next
                
                System.Diagnostics.Debug.WriteLine("Table populated with " & Connect.Data.Tables(0).Rows.Count & " rows")
                
                ' Show table and hide no records message
                TableContainer.Visible = True
                NoRecords.Visible = False
                
                System.Diagnostics.Debug.WriteLine("Table container set to visible")
            Else
                ' We still need to keep the header row
                System.Diagnostics.Debug.WriteLine("No data rows found, keeping header row only")
                
                ' Show "No Records" message
                NoRecords.Visible = True
                
                System.Diagnostics.Debug.WriteLine("No records panel set to visible")
            End If

        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error in ViewTable: " & ex.Message)
            System.Diagnostics.Debug.WriteLine(ex.StackTrace)
            showAlert("Error loading discounts: " & ex.Message, "danger")
        End Try
    End Sub

    Private Sub ClearForm()
        DiscountIdHidden.Value = ""
        NameTxt.Text = ""
        DiscountTypeDdl.SelectedIndex = 0
        ValueTxt.Text = ""
        ApplicableToDdl.SelectedIndex = 0
        StartDateTxt.Text = ""
        EndDateTxt.Text = ""
        MinOrderAmountTxt.Text = ""
        StatusDdl.SelectedIndex = 0
        DescriptionTxt.Text = ""
    End Sub

    Private Sub showAlert(ByVal message As String, ByVal type As String)
        Dim script As String = "showAlert('" & message & "', '" & type & "');"
        ClientScript.RegisterStartupScript(Me.GetType(), "showAlert", script, True)
    End Sub

    Private Sub ValidateTableStructure()
        Try
            System.Diagnostics.Debug.WriteLine("Validating discounts table structure...")

            ' Check if the table exists
            Dim tableQuery = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'discounts'"
            Connect.Query(tableQuery)

            If Connect.DataCount > 0 Then
                Dim tableExists As Boolean = (Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0)) > 0)       
                System.Diagnostics.Debug.WriteLine("Discounts table exists: " & tableExists)

                If Not tableExists Then
                    ' Create the table if it doesn't exist
                    System.Diagnostics.Debug.WriteLine("Creating discounts table...")
                    Dim createTableQuery = "CREATE TABLE discounts (" & _
                        "discount_id INT IDENTITY(1,1) PRIMARY KEY, " & _
                        "name NVARCHAR(100) NOT NULL, " & _
                        "discount_type INT NOT NULL, " & _
                        "value DECIMAL(10,2) NOT NULL, " & _
                        "applicable_to INT NOT NULL, " & _
                        "start_date DATETIME NOT NULL, " & _
                        "end_date DATETIME NOT NULL, " & _
                        "min_order_amount DECIMAL(10,2) NULL, " & _
                        "status INT NOT NULL, " & _
                        "description NVARCHAR(MAX) NULL, " & _
                        "created_at DATETIME NOT NULL, " & _
                        "updated_at DATETIME NULL)"

                    Connect.Query(createTableQuery)
                    System.Diagnostics.Debug.WriteLine("Discounts table created")
                    
                    ' Add a test discount
                    InsertTestDiscount()
                    Return
                End If

                ' Check if the table has any rows
                Dim rowCountQuery = "SELECT COUNT(*) FROM discounts"
                Connect.Query(rowCountQuery)
                
                If Connect.DataCount > 0 Then
                    Dim rowCount As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0))
                    System.Diagnostics.Debug.WriteLine("Discounts table has " & rowCount & " rows")
                    
                    ' If the table is empty, add a test discount
                    If rowCount = 0 Then
                        System.Diagnostics.Debug.WriteLine("No discounts found, adding a test discount")
                        InsertTestDiscount()
                    End If
                End If

                ' Check if all required columns exist
                Dim columnsQuery = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'discounts'"
                Connect.Query(columnsQuery)

                If Connect.DataCount > 0 Then
                    Dim columns As New List(Of String)
                    For Each row As DataRow In Connect.Data.Tables(0).Rows
                        columns.Add(row("COLUMN_NAME").ToString().ToLower())
                    Next

                    System.Diagnostics.Debug.WriteLine("Existing columns: " & String.Join(", ", columns.ToArray()))

                    ' Check for required columns
                    Dim requiredColumns As String() = {"discount_id", "name", "discount_type", "value", "applicable_to",
                                                      "start_date", "end_date", "min_order_amount", "status", "description", "created_at"}

                    Dim missingColumns As New List(Of String)
                    For Each col As String In requiredColumns
                        If Not columns.Contains(col.ToLower()) Then
                            missingColumns.Add(col)
                        End If
                    Next

                    If missingColumns.Count > 0 Then
                        System.Diagnostics.Debug.WriteLine("Missing columns: " & String.Join(", ", missingColumns.ToArray()))

                        ' Add missing columns
                        For Each col As String In missingColumns
                            Dim alterQuery As String = "ALTER TABLE discounts ADD "

                            Select Case col.ToLower()
                                Case "discount_id"
                                    alterQuery &= "discount_id INT IDENTITY(1,1) PRIMARY KEY"
                                Case "name"
                                    alterQuery &= "name NVARCHAR(100) NOT NULL"
                                Case "discount_type"
                                    alterQuery &= "discount_type INT NOT NULL DEFAULT 1"
                                Case "value"
                                    alterQuery &= "value DECIMAL(10,2) NOT NULL DEFAULT 0"
                                Case "applicable_to"
                                    alterQuery &= "applicable_to INT NOT NULL DEFAULT 1"
                                Case "start_date"
                                    alterQuery &= "start_date DATETIME NOT NULL DEFAULT GETDATE()"
                                Case "end_date"
                                    alterQuery &= "end_date DATETIME NOT NULL DEFAULT DATEADD(MONTH, 1, GETDATE())"
                                Case "min_order_amount"
                                    alterQuery &= "min_order_amount DECIMAL(10,2) NULL"
                                Case "status"
                                    alterQuery &= "status INT NOT NULL DEFAULT 1"
                                Case "description"
                                    alterQuery &= "description NVARCHAR(MAX) NULL"
                                Case "created_at"
                                    alterQuery &= "created_at DATETIME NOT NULL DEFAULT GETDATE()"
                                Case "updated_at"
                                    alterQuery &= "updated_at DATETIME NULL"
                            End Select

                            System.Diagnostics.Debug.WriteLine("Executing: " & alterQuery)
                            Connect.Query(alterQuery)
                        Next

                        System.Diagnostics.Debug.WriteLine("Table structure updated")
                    Else
                        System.Diagnostics.Debug.WriteLine("All required columns exist")
                    End If
                End If
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error validating table structure: " & ex.Message)
            System.Diagnostics.Debug.WriteLine(ex.StackTrace)
        End Try
    End Sub

    Private Sub InsertTestDiscount()
        Try
            System.Diagnostics.Debug.WriteLine("Inserting test discount")
            
            ' Create a test discount
            Dim query As String = "INSERT INTO discounts (name, discount_type, value, applicable_to, " & _
                               "start_date, end_date, min_order_amount, status, description, created_at) " & _
                               "VALUES ('Welcome Discount', 1, 10, 1, GETDATE(), " & _
                               "DATEADD(month, 1, GETDATE()), 100, 1, 'Test discount for new customers', GETDATE())"
            
            Connect.Query(query)
            System.Diagnostics.Debug.WriteLine("Test discount inserted")
            
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error inserting test discount: " & ex.Message)
            System.Diagnostics.Debug.WriteLine(ex.StackTrace)
        End Try
    End Sub
End Class
