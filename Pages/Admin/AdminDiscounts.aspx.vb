Imports System.Data
Imports System.Text
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls
Imports System.Web.UI
Imports HapagDB

Partial Class Pages_Admin_AdminDiscounts
    Inherits AdminBasePage
    Private discountController As New DiscountController()
    Private ReadOnly Property IsViewOnly As Boolean
        Get
            Return IsStaffUser() And Not IsAdminUser()
        End Get
    End Property

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

        ' Check if we're in view-only mode and disable editing controls
        If IsViewOnly Then
            DisableEditingControls()
            ShowViewOnlyNotice()
        End If
    End Sub

    Private Sub DisableEditingControls()
        ' Disable buttons
        If AddBtn IsNot Nothing Then AddBtn.Enabled = False
        If EditBtn IsNot Nothing Then EditBtn.Enabled = False
        If DeleteBtn IsNot Nothing Then DeleteBtn.Enabled = False
        If ClearBtn IsNot Nothing Then ClearBtn.Enabled = False

        ' Optional: Add visual indication that buttons are disabled
        If AddBtn IsNot Nothing Then AddBtn.CssClass = AddBtn.CssClass & " disabled"
        If EditBtn IsNot Nothing Then EditBtn.CssClass = EditBtn.CssClass & " disabled"
        If DeleteBtn IsNot Nothing Then DeleteBtn.CssClass = DeleteBtn.CssClass & " disabled"
        If ClearBtn IsNot Nothing Then ClearBtn.CssClass = ClearBtn.CssClass & " disabled"
    End Sub

    Private Sub ShowViewOnlyNotice()
        Try
            ' Use the master page's notice method if it exists
            Dim masterPage As Pages_Admin_AdminTemplate = DirectCast(Me.Master, Pages_Admin_AdminTemplate)
            masterPage.ShowInfo("You are in view-only mode. Editing functionality is restricted.")
        Catch ex As Exception
            ' Fallback to local message display if master page method fails
            showAlert("You are in view-only mode. Editing functionality is restricted.", "info")
        End Try
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

            ' Create a new Discount object
            Dim newDiscount As New Discount()
            newDiscount.name = NameTxt.Text.Trim()
            newDiscount.discount_type = Integer.Parse(DiscountTypeDdl.SelectedValue)
            newDiscount.value = value
            newDiscount.applicable_to = Integer.Parse(ApplicableToDdl.SelectedValue)
            newDiscount.start_date = startDate
            newDiscount.end_date = endDate
            newDiscount.min_order_amount = minOrderAmount
            newDiscount.status = Integer.Parse(StatusDdl.SelectedValue)
            newDiscount.description = DescriptionTxt.Text.Trim()

            ' Use DiscountController to create the discount
            If discountController.CreateDiscount(newDiscount) Then
                showAlert("Discount added successfully!", "success")
                ClearForm()
                ViewTable()
            Else
                showAlert("Failed to add discount!", "danger")
            End If
        Catch ex As Exception
            showAlert("Error adding discount: " & ex.Message, "danger")
            System.Diagnostics.Debug.WriteLine("Error in AddBtn_Click: " & ex.Message)
            System.Diagnostics.Debug.WriteLine(ex.StackTrace)
        End Try
    End Sub

    Protected Sub EditBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles EditBtn.Click
        Try
            ' Validate discount ID
            If String.IsNullOrEmpty(DiscountIdTxt.Text) Then
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

            ' Create a Discount object for the update
            Dim discount As New Discount()
            discount.discount_id = Integer.Parse(DiscountIdTxt.Text)
            discount.name = NameTxt.Text.Trim()
            discount.discount_type = Integer.Parse(DiscountTypeDdl.SelectedValue)
            discount.value = value
            discount.applicable_to = Integer.Parse(ApplicableToDdl.SelectedValue)
            discount.start_date = startDate
            discount.end_date = endDate
            discount.min_order_amount = minOrderAmount
            discount.status = Integer.Parse(StatusDdl.SelectedValue)
            discount.description = DescriptionTxt.Text.Trim()

            ' Use DiscountController to update the discount
            If discountController.UpdateDiscount(discount) Then
                showAlert("Discount updated successfully!", "success")
                ClearForm()
                ViewTable()
            Else
                showAlert("Failed to update discount!", "danger")
            End If
        Catch ex As Exception
            showAlert("Error updating discount: " & ex.Message, "danger")
            System.Diagnostics.Debug.WriteLine("Error in EditBtn_Click: " & ex.Message)
            System.Diagnostics.Debug.WriteLine(ex.StackTrace)
        End Try
    End Sub

    Protected Sub RemoveBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles DeleteBtn.Click
        Try
            ' Validate discount ID
            If String.IsNullOrEmpty(DiscountIdTxt.Text) Then
                showAlert("Please select a discount to delete!", "warning")
                Return
            End If

            ' Use DiscountController to delete the discount
            If discountController.DeleteDiscount(Integer.Parse(DiscountIdTxt.Text)) Then
                showAlert("Discount deleted successfully!", "success")
                ClearForm()
                ViewTable()
            Else
                showAlert("Failed to delete discount!", "danger")
            End If
        Catch ex As Exception
            showAlert("Error deleting discount: " & ex.Message, "danger")
            System.Diagnostics.Debug.WriteLine("Error in RemoveBtn_Click: " & ex.Message)
            System.Diagnostics.Debug.WriteLine(ex.StackTrace)
        End Try
    End Sub

    Protected Sub ClearBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ClearBtn.Click
        ClearForm()
    End Sub

    ' Validates that the database table has all required columns
    Private Sub ValidateTableStructure()
        Try
            ' We'll rely on the DiscountController for database operations
            ' The controller should handle table structure validation if needed
            System.Diagnostics.Debug.WriteLine("Table structure validation handled by controller")
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error validating table structure: " & ex.Message)
        End Try
    End Sub

    Public Sub ViewTable()
        Try
            ' Get all discounts from the controller
            Dim discounts = discountController.GetAllDiscounts()
            
            System.Diagnostics.Debug.WriteLine("Retrieved " & discounts.Count & " discounts from controller")
            
            ' Show or hide the NoRecords panel based on whether we have data
            TableContainer.Visible = (discounts.Count > 0)
            NoRecords.Visible = (discounts.Count = 0)
            
            Table1.Rows.Clear()

            If discounts.Count > 0 Then
                ' Create header row
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

                ' Add data rows
                For Each discount As Discount In discounts
                    Dim row As New TableRow()
                    
                    ' Add cells with data
                    row.Cells.Add(New TableCell() With {.Text = discount.name})
                    
                    ' Discount type
                    Dim discountTypeText As String = GetDiscountTypeName(discount.discount_type)
                    row.Cells.Add(New TableCell() With {.Text = discountTypeText})
                    
                    ' Format discount value
                    Dim formattedValue As String = FormatDiscountValue(discount.value, discount.discount_type)
                    row.Cells.Add(New TableCell() With {.Text = formattedValue})
                    
                    ' Applicable to
                    Dim applicableToText As String = GetApplicableToName(discount.applicable_to)
                    row.Cells.Add(New TableCell() With {.Text = applicableToText})
                    
                    ' Dates
                    row.Cells.Add(New TableCell() With {.Text = discount.start_date.ToString("MM/dd/yyyy")})
                    row.Cells.Add(New TableCell() With {.Text = discount.end_date.ToString("MM/dd/yyyy")})
                    
                    ' Min order amount
                    Dim minOrderText As String = If(discount.min_order_amount > 0, "₱" & discount.min_order_amount.ToString("0.00"), "None")
                    row.Cells.Add(New TableCell() With {.Text = minOrderText})
                    
                    ' Status with styling
                    Dim statusCell As New TableCell()
                    Dim statusSpan As New HtmlGenericControl("span")
                    statusSpan.InnerText = GetStatusName(discount.status)
                    statusSpan.Attributes.Add("class", If(discount.status = 1, "status-active", "status-inactive"))
                    statusCell.Controls.Add(statusSpan)
                    row.Cells.Add(statusCell)
                    
                    ' Add data attributes for JavaScript
                    row.Attributes.Add("data-discount_id", discount.discount_id.ToString())
                    row.Attributes.Add("data-description", discount.description)
                    
                    Table1.Rows.Add(row)
                Next
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error in ViewTable: " & ex.Message)
            showAlert("Error loading discounts: " & ex.Message, "danger")
        End Try
    End Sub

    ' Helper method to format discount value for display
    Protected Function FormatDiscountValue(ByVal value As Decimal, ByVal discountType As Integer) As String
        If discountType = 1 Then ' Percentage discount
            Return value.ToString("0.##") & "%"
        Else ' Fixed amount discount
            Return "₱" & value.ToString("0.00")
        End If
    End Function
    
    ' Helper method to get the text description of discount type
    Protected Function GetDiscountTypeName(ByVal discountType As Integer) As String
        Select Case discountType
            Case 1
                Return "Percentage"
            Case 0, 2
                Return "Fixed Amount"
            Case Else
                Return "Unknown"
        End Select
    End Function
    
    ' Helper method to get the text description of applicable to
    Protected Function GetApplicableToName(ByVal applicableTo As Integer) As String
        Select Case applicableTo
            Case 1
                Return "All Products"
            Case 2
                Return "Specific Category"
            Case 3
                Return "Specific Product"
            Case Else
                Return "Unknown"
        End Select
    End Function
    
    ' Helper method to get the text description of status
    Protected Function GetStatusName(ByVal status As Integer) As String
        Select Case status
            Case 1
                Return "Active"
            Case 0
                Return "Inactive"
            Case Else
                Return "Unknown"
        End Select
    End Function

    Private Sub ClearForm()
        DiscountIdTxt.Text = ""
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

    Private Sub showAlert(message As String, type As String)
        Try
            ' Use the master page's alert methods
            Dim masterPage As Pages_Admin_AdminTemplate = DirectCast(Me.Master, Pages_Admin_AdminTemplate)
            
            Select Case type
                Case "success"
                    masterPage.ShowAlert(message, True)
                Case "danger", "error"
                    masterPage.ShowAlert(message, False)
                Case "warning"
                    masterPage.ShowWarning(message)
                Case "info"
                    masterPage.ShowInfo(message)
                Case Else
                    masterPage.ShowInfo(message)
            End Select
        Catch ex As Exception
            ' Fallback to original method if master page method fails
            alertMessage.Style("display") = "block"
            
            Select Case type
                Case "success"
                    alertMessage.Attributes("class") = "alert-message alert-success"
                Case "danger", "error"
                    alertMessage.Attributes("class") = "alert-message alert-danger"
                Case "warning"
                    alertMessage.Attributes("class") = "alert-message alert-warning"
                Case "info"
                    alertMessage.Attributes("class") = "alert-message alert-info"
                Case Else
                    alertMessage.Attributes("class") = "alert-message alert-info"
            End Select
            
            AlertLiteral.Text = message
            
            ' Auto-hide after 5 seconds using JavaScript
            Dim script As String = "setTimeout(function() { document.getElementById('" & alertMessage.ClientID & "').style.display = 'none'; }, 5000);"
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "hideAlert", script, True)
        End Try
    End Sub
End Class
