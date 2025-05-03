Imports System.Data
Imports HapagDB

Partial Class Pages_Admin_AdminMenuTypes
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

    Protected Sub AddBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddBtn.Click
        Dim typeName = TypeNameTxt.Text
        Dim description = DescriptionTxt.Text
        Dim isActive = StatusDdl.SelectedValue

        If String.IsNullOrEmpty(typeName) Then
            ShowAlert("Type name cannot be empty!")
            Return
        End If

        Dim query = "INSERT INTO menu_types (type_name, description, is_active) VALUES (@type_name, @description, @is_active)"

        Connect.AddParam("@type_name", typeName)
        Connect.AddParam("@description", description)
        Connect.AddParam("@is_active", isActive)

        Dim insert = Connect.Query(query)

        If insert Then
            ShowAlert("Type Added Successfully!")
        Else
            ShowAlert("Failed to Add Type!")
        End If

        ViewTable()
        ClearFormFields()
    End Sub

    Protected Sub EditBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles EditBtn.Click
        Dim typeId = TypeIdTxt.Text
        Dim typeName = TypeNameTxt.Text
        Dim description = DescriptionTxt.Text
        Dim isActive = StatusDdl.SelectedValue

        If String.IsNullOrEmpty(typeId) Then
            ShowAlert("Please select a type to edit!")
            Return
        End If

        If String.IsNullOrEmpty(typeName) Then
            ShowAlert("Type name cannot be empty!")
            Return
        End If

        Dim query = "UPDATE menu_types SET type_name = @type_name, description = @description, is_active = @is_active WHERE type_id = @type_id"

        Connect.AddParam("@type_name", typeName)
        Connect.AddParam("@description", description)
        Connect.AddParam("@is_active", isActive)
        Connect.AddParam("@type_id", typeId)

        Dim updateResult = Connect.Query(query)

        If updateResult Then
            ShowAlert("Type Updated Successfully!")
        Else
            ShowAlert("Failed to Update Type!")
        End If

        ViewTable()
        ClearFormFields()
    End Sub

    Protected Sub RemoveBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RemoveBtn.Click
        Dim typeId = TypeIdTxt.Text

        If String.IsNullOrEmpty(typeId) Then
            ShowAlert("Please select a type to remove!")
            Return
        End If

        ' Check if type is in use
        Dim checkQuery = "SELECT COUNT(*) FROM menu WHERE type_id = @type_id"
        Connect.AddParam("@type_id", typeId)
        Connect.Query(checkQuery)

        If Connect.Data.Tables(0).Rows(0)(0) > 0 Then
            ShowAlert("Cannot delete type because it is being used by menu items!")
            Return
        End If

        Dim query = "DELETE FROM menu_types WHERE type_id = @type_id"
        Connect.AddParam("@type_id", typeId)

        Dim deleteResult = Connect.Query(query)

        If deleteResult Then
            ShowAlert("Type Deleted Successfully!")
        Else
            ShowAlert("Failed to Delete Type!")
        End If

        ViewTable()
        ClearFormFields()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ViewTable()
        End If
    End Sub

    Public Sub ViewTable()
        Dim query = "SELECT * FROM menu_types ORDER BY type_name"
        Connect.Query(query)

        Table1.Rows.Clear()

        Dim headerRow As New TableHeaderRow()
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Type Name"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Description"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Status"})
        Table1.Rows.Add(headerRow)

        For Each row As DataRow In Connect.Data.Tables(0).Rows
            Dim tableRow As New TableRow()

            tableRow.Cells.Add(New TableCell() With {.Text = row("type_name").ToString()})
            tableRow.Cells.Add(New TableCell() With {.Text = row("description").ToString()})
            
            Dim isActive As Boolean = Convert.ToBoolean(row("is_active"))
            tableRow.Cells.Add(New TableCell() With {.Text = If(isActive, "Active", "Inactive")})

            tableRow.Attributes.Add("data-type_id", row("type_id").ToString())
            Table1.Rows.Add(tableRow)
        Next
    End Sub

    Public Sub ClearFormFields()
        TypeIdTxt.Text = ""
        TypeNameTxt.Text = ""
        DescriptionTxt.Text = ""
        StatusDdl.SelectedIndex = 0
    End Sub

    Private Sub ShowAlert(ByVal message As String)
        Dim script As String = "alert('" & message & "');"
        ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
    End Sub
End Class 