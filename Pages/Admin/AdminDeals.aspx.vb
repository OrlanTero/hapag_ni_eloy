Imports System.Data
Imports HapagDB

Partial Class Pages_Admin_AdminDeals
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

    Protected Sub AddBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddBtn.Click

        Dim name = NameTxt.Text
        Dim value = ValueTxt.Text
        Dim value_type = ValueTypeDdl.SelectedValue
        Dim start_date = StartDateTxt.Text
        Dim valid_until = ValidUntilTxt.Text
        Dim description = DescriptionTxt.Text
        Dim image = ""

        Dim query = "INSERT INTO deals (name, value, value_type, start_date, valid_until, description, image) VALUES (@name, @value, @value_type, @start_date, @valid_until , @description, @image)"

        Connect.AddParam("@name", name)
        Connect.AddParam("@value", value)
        Connect.AddParam("@value_type", value_type)
        Connect.AddParam("@start_date", start_date)
        Connect.AddParam("@valid_until", valid_until)
        Connect.AddParam("@description", description)
        Connect.AddParam("@image", image)

        Dim insert = Connect.Query(query)

        If insert Then
            Dim script As String = "alert('Successfully Added!');"
            ClientScript.RegisterStartupScript(Me.GetType, "alertMessage", script, True)
        Else
            Dim script As String = "alert('Failed to Add!');"
            ClientScript.RegisterStartupScript(Me.GetType, "alertMessage", script, True)
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
        Dim deals_id = DealIdTxt

        Dim query = "UPDATE deals SET name = @name, value = @value, value_type = @value_type,  start_date = @start_date, valid_until = @valid_until, description = @description, image = @image  WHERE deals_id = @deals_id"

        Connect.AddParam("@name", name)
        Connect.AddParam("@value", value)
        Connect.AddParam("@value_type", value_type)
        Connect.AddParam("@start_date", start_date)
        Connect.AddParam("@valid_until", valid_until)
        Connect.AddParam("@description", description)
        Connect.AddParam("@image", image)
        Connect.AddParam("@deals_id", deals_id.Text)

        Dim updateResult = CONNECT.Query(query)

        If updateResult Then
            Dim script As String = "alert('Successfully Updated!');"
            ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
        Else
            Dim script As String = "alert('Failed to Update!');"
            ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
        End If

        ViewTable()
        ClearFormFields()
    End Sub

    Protected Sub RemoveBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RemoveBtn.Click
        Dim deals_id = DealIdTxt.Text()

        Dim query = "DELETE FROM deals WHERE deals_id = @deals_id"

        Connect.AddParam("@deals_id", deals_id)

        Dim deleteResult = Connect.Query(query)

        If deleteResult Then
            Dim script As String = "alert('Successfully Deleted!');"
            ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
        Else
            Dim script As String = "alert('Failed to Delete!');"
            ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
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
        Dim query = "SELECT * FROM deals"
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

            tableRow.Attributes.Add("data-deals_id", row("deals_id").ToString())
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
End Class
