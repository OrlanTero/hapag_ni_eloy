Imports System.Data

Partial Class Pages_Admin_AdminMenuCategories
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

    Protected Sub AddBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddBtn.Click
        Dim categoryName = CategoryNameTxt.Text
        Dim description = DescriptionTxt.Text
        Dim isActive = StatusDdl.SelectedValue

        If String.IsNullOrEmpty(categoryName) Then
            ShowAlert("Category name cannot be empty!")
            Return
        End If

        Dim query = "INSERT INTO menu_categories (category_name, description, is_active) VALUES (@category_name, @description, @is_active)"

        Connect.AddParam("@category_name", categoryName)
        Connect.AddParam("@description", description)
        Connect.AddParam("@is_active", isActive)

        Dim insert = Connect.Query(query)

        If insert Then
            ShowAlert("Category Added Successfully!")
        Else
            ShowAlert("Failed to Add Category!")
        End If

        ViewTable()
        ClearFormFields()
    End Sub

    Protected Sub EditBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles EditBtn.Click
        Dim categoryId = CategoryIdTxt.Text
        Dim categoryName = CategoryNameTxt.Text
        Dim description = DescriptionTxt.Text
        Dim isActive = StatusDdl.SelectedValue

        If String.IsNullOrEmpty(categoryId) Then
            ShowAlert("Please select a category to edit!")
            Return
        End If

        If String.IsNullOrEmpty(categoryName) Then
            ShowAlert("Category name cannot be empty!")
            Return
        End If

        Dim query = "UPDATE menu_categories SET category_name = @category_name, description = @description, is_active = @is_active WHERE category_id = @category_id"

        Connect.AddParam("@category_name", categoryName)
        Connect.AddParam("@description", description)
        Connect.AddParam("@is_active", isActive)
        Connect.AddParam("@category_id", categoryId)

        Dim updateResult = Connect.Query(query)

        If updateResult Then
            ShowAlert("Category Updated Successfully!")
        Else
            ShowAlert("Failed to Update Category!")
        End If

        ViewTable()
        ClearFormFields()
    End Sub

    Protected Sub RemoveBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RemoveBtn.Click
        Dim categoryId = CategoryIdTxt.Text

        If String.IsNullOrEmpty(categoryId) Then
            ShowAlert("Please select a category to remove!")
            Return
        End If

        ' Check if category is in use
        Dim checkQuery = "SELECT COUNT(*) FROM menu WHERE category_id = @category_id"
        Connect.AddParam("@category_id", categoryId)
        Connect.Query(checkQuery)

        If Connect.Data.Tables(0).Rows(0)(0) > 0 Then
            ShowAlert("Cannot delete category because it is being used by menu items!")
            Return
        End If

        Dim query = "DELETE FROM menu_categories WHERE category_id = @category_id"
        Connect.AddParam("@category_id", categoryId)

        Dim deleteResult = Connect.Query(query)

        If deleteResult Then
            ShowAlert("Category Deleted Successfully!")
        Else
            ShowAlert("Failed to Delete Category!")
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
        Dim query = "SELECT * FROM menu_categories ORDER BY category_name"
        Connect.Query(query)

        Table1.Rows.Clear()

        Dim headerRow As New TableHeaderRow()
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Category Name"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Description"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Status"})
        Table1.Rows.Add(headerRow)

        For Each row As DataRow In Connect.Data.Tables(0).Rows
            Dim tableRow As New TableRow()

            tableRow.Cells.Add(New TableCell() With {.Text = row("category_name").ToString()})
            tableRow.Cells.Add(New TableCell() With {.Text = row("description").ToString()})
            
            Dim isActive As Boolean = Convert.ToBoolean(row("is_active"))
            tableRow.Cells.Add(New TableCell() With {.Text = If(isActive, "Active", "Inactive")})

            tableRow.Attributes.Add("data-category_id", row("category_id").ToString())
            Table1.Rows.Add(tableRow)
        Next
    End Sub

    Public Sub ClearFormFields()
        CategoryIdTxt.Text = ""
        CategoryNameTxt.Text = ""
        DescriptionTxt.Text = ""
        StatusDdl.SelectedIndex = 0
    End Sub

    Private Sub ShowAlert(ByVal message As String)
        Dim script As String = "alert('" & message & "');"
        ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
    End Sub
End Class 