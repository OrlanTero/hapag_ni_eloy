Imports System.Data
Imports System.Text
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls
Imports HapagDB

Partial Class Pages_Admin_AdminDiscounts
    Inherits System.Web.UI.Page
    Private discountController As New DiscountController()

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
            ' Show success message and refresh table
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

            ' Create a Discount object for the update
            Dim discount As New Discount()
            discount.discount_id = Integer.Parse(DiscountIdHidden.Value)
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
            ' Show success message and refresh table
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
            If String.IsNullOrEmpty(DiscountIdHidden.Value) Then
                showAlert("Please select a discount to delete!", "warning")
                Return
            End If

            ' Use DiscountController to delete the discount
            If discountController.DeleteDiscount(Integer.Parse(DiscountIdHidden.Value)) Then
            ' Show success message and refresh table
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
            
            If discounts.Count > 0 Then
                DiscountsRepeater.DataSource = discounts
                DiscountsRepeater.DataBind()
                System.Diagnostics.Debug.WriteLine("Bound " & discounts.Count & " discounts to repeater")
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
            Case 0
                Return "Fixed Amount"
            Case Else
                Return "Unknown"
        End Select
    End Function
    
    ' Helper method to get the text description of applicable to
    Protected Function GetApplicableToName(ByVal applicableTo As Integer) As String
        Select Case applicableTo
            Case 1
                Return "Selected Items"
            Case 2
                Return "Categories"
            Case 0
                Return "All Items"
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
        AddBtn.Visible = True
        EditBtn.Visible = False
        DeleteBtn.Visible = False
    End Sub

    Private Sub showAlert(ByVal message As String, ByVal type As String)
        Dim script As String = "showAlert('" & message & "', '" & type & "');"
        ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
    End Sub

    ' Event handler for the Repeater's ItemCommand event
    Protected Sub DiscountsRepeater_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        Try
            If e.CommandName = "Edit" Then
                Dim discountId As Integer = Convert.ToInt32(e.CommandArgument)
                System.Diagnostics.Debug.WriteLine("Edit command for discount ID: " & discountId)
                
                ' Get the discount details from the controller
                Dim discount = discountController.GetDiscountById(discountId)
                
                If discount IsNot Nothing Then
                    ' Populate the form with discount details
                    DiscountIdHidden.Value = discount.discount_id.ToString()
                    NameTxt.Text = discount.name
                    DiscountTypeDdl.SelectedValue = discount.discount_type.ToString()
                    
                    If discount.discount_type = 1 Then ' Percentage
                        ValueTxt.Text = discount.value.ToString("0.##") & "%"
                    Else ' Fixed amount
                        ValueTxt.Text = discount.value.ToString("0.00")
                End If

                    ApplicableToDdl.SelectedValue = discount.applicable_to.ToString()
                    StartDateTxt.Text = discount.start_date.ToString("yyyy-MM-dd")
                    EndDateTxt.Text = discount.end_date.ToString("yyyy-MM-dd")
                    MinOrderAmountTxt.Text = discount.min_order_amount.ToString("0.00")
                    StatusDdl.SelectedValue = discount.status.ToString()
                    DescriptionTxt.Text = discount.description
                    
                    ' Show edit and delete buttons, hide add button
                    AddBtn.Visible = False
                    EditBtn.Visible = True
                    DeleteBtn.Visible = True
                    
                    ' Scroll to the form
                    ClientScript.RegisterStartupScript(Me.GetType(), "scrollToForm", "scrollToForm();", True)
                Else
                    showAlert("Discount not found!", "warning")
                End If
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error in DiscountsRepeater_ItemCommand: " & ex.Message)
            showAlert("Error: " & ex.Message, "danger")
        End Try
    End Sub
End Class
