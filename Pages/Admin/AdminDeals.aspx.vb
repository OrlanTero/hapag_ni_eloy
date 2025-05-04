Imports System.Data
Imports HapagDB

Partial Class Pages_Admin_AdminDeals
    Inherits System.Web.UI.Page
    Private dealController As New DealController()

    Protected Sub AddBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddBtn.Click
        Dim name = NameTxt.Text
        Dim value = ValueTxt.Text
        Dim value_type = ValueTypeDdl.SelectedValue
        Dim start_date = StartDateTxt.Text
        Dim valid_until = ValidUntilTxt.Text
        Dim description = DescriptionTxt.Text
        Dim image = ""

        ' Create a new Deal object
        Dim newDeal As New Deal()
        newDeal.name = name
        newDeal.value = Convert.ToDecimal(value)
        newDeal.value_type = Convert.ToInt32(value_type)
        newDeal.start_date = Convert.ToDateTime(start_date)
        newDeal.valid_until = Convert.ToDateTime(valid_until)
        newDeal.description = description
        newDeal.image = image

        ' Use DealController to create the deal
        If dealController.CreateDeal(newDeal) Then
            ShowAlert("Successfully Added!")
        Else
            ShowAlert("Failed to Add!")
        End If

        ViewTable()
        ClearFormFields()
    End Sub

    Protected Sub EditBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles EditBtn.Click
        Dim name = NameTxt.Text
        Dim value = ValueTxt.Text
        Dim value_type = ValueTypeDdl.SelectedValue
        Dim start_date = StartDateTxt.Text
        Dim valid_until = ValidUntilTxt.Text
        Dim description = DescriptionTxt.Text
        Dim image = ""
        Dim deals_id = DealIdTxt.Text

        ' Create a Deal object for the update
        Dim deal As New Deal()
        deal.deals_id = Convert.ToInt32(deals_id)
        deal.name = name
        deal.value = Convert.ToDecimal(value)
        deal.value_type = Convert.ToInt32(value_type)
        deal.start_date = Convert.ToDateTime(start_date)
        deal.valid_until = Convert.ToDateTime(valid_until)
        deal.description = description
        deal.image = image

        ' Use DealController to update the deal
        If dealController.UpdateDeal(deal) Then
            ShowAlert("Successfully Updated!")
        Else
            ShowAlert("Failed to Update!")
        End If

        ViewTable()
        ClearFormFields()
    End Sub

    Protected Sub RemoveBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RemoveBtn.Click
        Dim deals_id = DealIdTxt.Text()

        ' Use DealController to delete the deal
        If dealController.DeleteDeal(Convert.ToInt32(deals_id)) Then
            ShowAlert("Successfully Deleted!")
        Else
            ShowAlert("Failed to Delete!")
        End If

        ViewTable()
        ClearFormFields()
    End Sub

    Protected Sub ClearBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ClearBtn.Click
        ClearFormFields()
        DealIdTxt.Text = ""
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ViewTable()
        End If
    End Sub

    Public Sub ViewTable()
        ' Get all deals from the controller
        Dim deals = dealController.GetAllDeals()

        Table1.Rows.Clear()

        Dim headerRow As New TableHeaderRow()
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Name"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Value"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Value Type"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Start Date"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Valid Until"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Date Created"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Description"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Image"})
        Table1.Rows.Add(headerRow)

        For Each deal As Deal In deals
            Dim tableRow As New TableRow()

            tableRow.Cells.Add(New TableCell() With {.Text = deal.name})
            tableRow.Cells.Add(New TableCell() With {.Text = deal.value.ToString()})
            
            ' Convert value_type to readable text
            Dim valueTypeText As String = "Fixed"
            If deal.value_type = 1 Then
                valueTypeText = "Percentage"
            End If
            tableRow.Cells.Add(New TableCell() With {.Text = valueTypeText})
            
            tableRow.Cells.Add(New TableCell() With {.Text = deal.start_date.ToString("MM/dd/yyyy")})
            tableRow.Cells.Add(New TableCell() With {.Text = deal.valid_until.ToString("MM/dd/yyyy")})
            tableRow.Cells.Add(New TableCell() With {.Text = If(deal.date_created.HasValue, deal.date_created.Value.ToString("MM/dd/yyyy"), "")})
            tableRow.Cells.Add(New TableCell() With {.Text = If(deal.description, "")})
            tableRow.Cells.Add(New TableCell() With {.Text = If(deal.image, "")})

            tableRow.Attributes.Add("data-deals_id", deal.deals_id.ToString())
            Table1.Rows.Add(tableRow)
        Next
    End Sub

    Public Sub ClearFormFields()
        NameTxt.Text = ""
        ValueTxt.Text = ""
        StartDateTxt.Text = ""
        ValidUntilTxt.Text = ""
        DescriptionTxt.Text = ""
    End Sub
    
    Private Sub ShowAlert(ByVal message As String)
        Try
            ' Use the master page's alert methods
            Dim masterPage As Pages_Admin_AdminTemplate = DirectCast(Me.Master, Pages_Admin_AdminTemplate)
            
            If message.Contains("Successfully") Then
                masterPage.ShowAlert(message, True)
            ElseIf message.Contains("Error") Or message.Contains("Failed") Then
                masterPage.ShowAlert(message, False)
            ElseIf message.Contains("Note") Or message.Contains("Please") Or message.Contains("Cannot") Then
                masterPage.ShowWarning(message)
            Else
                masterPage.ShowInfo(message)
            End If
        Catch ex As Exception
            ' Fallback to using a JavaScript alert
            Dim script As String = "alert('" & message & "');"
            ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
        End Try
    End Sub
End Class
