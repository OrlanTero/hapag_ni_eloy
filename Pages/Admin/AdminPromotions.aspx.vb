Imports System.Data
Imports HapagDB

Partial Class Pages_Admin_AdminPromotions
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

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

            Dim query = "INSERT INTO promotions (name, value, value_type, start_date, valid_until, description, image, date_created) VALUES " & _
                       "(@name, @value, @value_type, @start_date, @valid_until, @description, @image, GETDATE())"

            Connect.AddParam("@name", NameTxt.Text.Trim())
            Connect.AddParam("@value", value)
            Connect.AddParam("@value_type", DiscountTypeDdl.SelectedValue)
            Connect.AddParam("@start_date", startDate)
            Connect.AddParam("@valid_until", endDate)
            Connect.AddParam("@description", DescriptionTxt.Text.Trim())
            Connect.AddParam("@image", "")

            Dim insert = Connect.Query(query)

            If insert Then
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

            Dim query = "UPDATE promotions SET " & _
                       "name = @name, " & _
                       "value = @value, " & _
                       "value_type = @value_type, " & _
                       "start_date = @start_date, " & _
                       "valid_until = @valid_until, " & _
                       "description = @description, " & _
                       "image = @image " & _
                       "WHERE promotion_id = @promotion_id"

            Connect.AddParam("@promotion_id", PromotionIdTxt.Text)
            Connect.AddParam("@name", NameTxt.Text.Trim())
            Connect.AddParam("@value", value)
            Connect.AddParam("@value_type", DiscountTypeDdl.SelectedValue)
            Connect.AddParam("@start_date", startDate)
            Connect.AddParam("@valid_until", endDate)
            Connect.AddParam("@description", DescriptionTxt.Text.Trim())
            Connect.AddParam("@image", "")

            Dim updateResult = Connect.Query(query)

            If updateResult Then
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

            Dim query = "DELETE FROM promotions WHERE promotion_id = @promotion_id"
            Connect.AddParam("@promotion_id", PromotionIdTxt.Text)

            Dim deleteResult = Connect.Query(query)

            If deleteResult Then
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
        Dim query = "SELECT * FROM promotions ORDER BY date_created DESC"
        Connect.Query(query)

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

        For Each row As DataRow In Connect.Data.Tables(0).Rows
            Dim tableRow As New TableRow()

            tableRow.Cells.Add(New TableCell() With {.Text = row("name").ToString()})
            tableRow.Cells.Add(New TableCell() With {.Text = row("value").ToString()})
            tableRow.Cells.Add(New TableCell() With {.Text = row("value_type").ToString()})
            tableRow.Cells.Add(New TableCell() With {.Text = row("start_date").ToString()})
            tableRow.Cells.Add(New TableCell() With {.Text = row("valid_until").ToString()})
            tableRow.Cells.Add(New TableCell() With {.Text = row("date_created").ToString()})
            tableRow.Cells.Add(New TableCell() With {.Text = row("description").ToString()})
            tableRow.Cells.Add(New TableCell() With {.Text = row("image").ToString()})

            tableRow.Attributes.Add("data-promotion_id", row("promotion_id").ToString())
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
        DescriptionTxt.Text = ""
    End Sub

    Private Sub showAlert(message As String, type As String)
        Dim script As String = "showAlert('" & message & "', '" & type & "');"
        ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
    End Sub
End Class
