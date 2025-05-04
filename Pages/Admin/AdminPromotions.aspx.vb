Imports System.Data
Imports HapagDB

Partial Class Pages_Admin_AdminPromotions
    Inherits System.Web.UI.Page
    Private promotionController As New PromotionController()

    Protected Sub AddBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddBtn.Click
        Try
            ' Validate required fields
            If String.IsNullOrEmpty(NameTxt.Text) OrElse String.IsNullOrEmpty(DiscountAmountTxt.Text) Then
                showAlert("Name and Discount Amount are required fields!", "warning")
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
            Dim value As Decimal
            If Not Decimal.TryParse(DiscountAmountTxt.Text, value) Then
                showAlert("Please enter a valid discount amount!", "warning")
                Return
            End If

            If DiscountTypeDdl.SelectedValue = "1" AndAlso (value <= 0 OrElse value > 100) Then
                showAlert("Percentage discount must be between 0 and 100!", "warning")
                Return
            End If

            ' Parse min_purchase
            Dim minPurchase As Double = 0
            If Not String.IsNullOrEmpty(MinPurchaseTxt.Text) Then
                If Not Double.TryParse(MinPurchaseTxt.Text, minPurchase) Then
                    showAlert("Please enter a valid minimum purchase amount!", "warning")
                    Return
                End If
            End If

            ' Create a new Promotion object
            Dim newPromotion As New Promotion()
            newPromotion.code = CodeTxt.Text.Trim()
            newPromotion.name = NameTxt.Text.Trim()
            newPromotion.value = value
            newPromotion.value_type = Convert.ToInt32(DiscountTypeDdl.SelectedValue)
            newPromotion.start_date = startDate
            newPromotion.valid_until = endDate
            newPromotion.description = DescriptionTxt.Text.Trim()
            newPromotion.image = ""
            newPromotion.min_purchase = minPurchase
            newPromotion.is_active = (StatusDdl.SelectedValue = "1")

            ' Use PromotionController to create the promotion
            If promotionController.CreatePromotion(newPromotion) Then
                showAlert("Promotion successfully added!", "success")
                ClearForm()
            Else
                showAlert("Failed to add promotion!", "error")
            End If

            ViewTable()
        Catch ex As Exception
            showAlert("Error: " & ex.Message, "error")
        End Try
    End Sub

    Protected Sub EditBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles EditBtn.Click
        Try
            ' Validate required fields
            If String.IsNullOrEmpty(PromotionIdTxt.Text) Then
                showAlert("Please select a promotion to edit!", "warning")
                Return
            End If

            If String.IsNullOrEmpty(NameTxt.Text) OrElse String.IsNullOrEmpty(DiscountAmountTxt.Text) Then
                showAlert("Name and Discount Amount are required fields!", "warning")
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
            Dim value As Decimal
            If Not Decimal.TryParse(DiscountAmountTxt.Text, value) Then
                showAlert("Please enter a valid discount amount!", "warning")
                Return
            End If

            If DiscountTypeDdl.SelectedValue = "1" AndAlso (value <= 0 OrElse value > 100) Then
                showAlert("Percentage discount must be between 0 and 100!", "warning")
                Return
            End If

            ' Parse min_purchase
            Dim minPurchase As Double = 0
            If Not String.IsNullOrEmpty(MinPurchaseTxt.Text) Then
                If Not Double.TryParse(MinPurchaseTxt.Text, minPurchase) Then
                    showAlert("Please enter a valid minimum purchase amount!", "warning")
                    Return
                End If
            End If

            ' Create a Promotion object for the update
            Dim promotion As New Promotion()
            promotion.promotion_id = Convert.ToInt32(PromotionIdTxt.Text)
            promotion.code = CodeTxt.Text.Trim()
            promotion.name = NameTxt.Text.Trim()
            promotion.value = value
            promotion.value_type = Convert.ToInt32(DiscountTypeDdl.SelectedValue)
            promotion.start_date = startDate
            promotion.valid_until = endDate
            promotion.description = DescriptionTxt.Text.Trim()
            promotion.image = ""
            promotion.min_purchase = minPurchase
            promotion.is_active = (StatusDdl.SelectedValue = "1")

            ' Use PromotionController to update the promotion
            If promotionController.UpdatePromotion(promotion) Then
                showAlert("Promotion successfully updated!", "success")
                ClearForm()
            Else
                showAlert("Failed to update promotion!", "error")
            End If

            ViewTable()
        Catch ex As Exception
            showAlert("Error: " & ex.Message, "error")
        End Try
    End Sub

    Protected Sub RemoveBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RemoveBtn.Click
        Try
            If String.IsNullOrEmpty(PromotionIdTxt.Text) Then
                showAlert("Please select a promotion to remove!", "warning")
                Return
            End If

            ' Use PromotionController to delete the promotion
            If promotionController.DeletePromotion(Convert.ToInt32(PromotionIdTxt.Text)) Then
                showAlert("Promotion successfully removed!", "success")
                ClearForm()
            Else
                showAlert("Failed to remove promotion!", "error")
            End If

            ViewTable()
        Catch ex As Exception
            showAlert("Error: " & ex.Message, "error")
        End Try
    End Sub

    Protected Sub ClearBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ClearBtn.Click
        ClearForm()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ViewTable()
        End If
    End Sub

    Public Sub ViewTable()
        ' Get all promotions from the controller
        Dim promotions = promotionController.GetAllPromotions()

        Table1.Rows.Clear()

        Dim headerRow As New TableHeaderRow()
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Name"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Code"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Value"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Type"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Start Date"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "End Date"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Min Purchase"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Status"})
        Table1.Rows.Add(headerRow)

        For Each promotion As Promotion In promotions
            Dim tableRow As New TableRow()

            tableRow.Cells.Add(New TableCell() With {.Text = promotion.name})
            tableRow.Cells.Add(New TableCell() With {.Text = If(promotion.code, "")})
            tableRow.Cells.Add(New TableCell() With {.Text = promotion.value})
            
            ' Convert value_type to readable text
            Dim valueTypeText As String = "Fixed"
            If promotion.value_type = "1" Then
                valueTypeText = "Percentage"
            End If
            tableRow.Cells.Add(New TableCell() With {.Text = valueTypeText})
            
            ' Format dates for better readability
            Dim startDate As DateTime
            Dim endDate As DateTime
            Dim startDateText As String = promotion.start_date
            Dim endDateText As String = promotion.valid_until
            
            If DateTime.TryParse(promotion.start_date, startDate) Then
                startDateText = startDate.ToString("MM/dd/yyyy")
            End If
            
            If DateTime.TryParse(promotion.valid_until, endDate) Then
                endDateText = endDate.ToString("MM/dd/yyyy")
            End If
            
            tableRow.Cells.Add(New TableCell() With {.Text = startDateText})
            tableRow.Cells.Add(New TableCell() With {.Text = endDateText})
            tableRow.Cells.Add(New TableCell() With {.Text = promotion.min_purchase})
            
            ' Status based on is_active
            Dim statusText As String = "Inactive"
            If promotion.is_active Then
                statusText = "Active"
            End If
            tableRow.Cells.Add(New TableCell() With {.Text = statusText})

            ' Add description as a data attribute for JavaScript to use
            tableRow.Attributes.Add("data-promotion_id", promotion.promotion_id.ToString())
            tableRow.Attributes.Add("data-description", If(promotion.description, ""))
            Table1.Rows.Add(tableRow)
        Next
    End Sub

    Private Sub ClearForm()
        PromotionIdTxt.Text = ""
        NameTxt.Text = ""
        CodeTxt.Text = ""
        DiscountTypeDdl.SelectedIndex = 0
        DiscountAmountTxt.Text = ""
        StartDateTxt.Text = ""
        EndDateTxt.Text = ""
        MinPurchaseTxt.Text = ""
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
                Case "error", "danger"
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
            alertMessage.Visible = True
            
            Select Case type
                Case "success"
                    alertMessage.Attributes("class") = "alert-message alert-success"
                Case "error", "danger"
                    alertMessage.Attributes("class") = "alert-message alert-danger"
                Case "warning"
                    alertMessage.Attributes("class") = "alert-message alert-warning"
                Case "info"
                    alertMessage.Attributes("class") = "alert-message alert-info"
                Case Else
                    alertMessage.Attributes("class") = "alert-message alert-info"
            End Select
            
            AlertLiteral.Text = message
        End Try
    End Sub
End Class
