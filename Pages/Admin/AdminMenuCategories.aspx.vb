Imports System.Data
Imports HapagDB

Partial Class Pages_Admin_AdminMenuCategories
    Inherits System.Web.UI.Page
    Private menuController As New MenuController()

    Protected Sub AddBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddBtn.Click
        Dim categoryName = CategoryNameTxt.Text
        Dim description = DescriptionTxt.Text
        Dim isActive = StatusDdl.SelectedValue

        If String.IsNullOrEmpty(categoryName) Then
            ShowAlert("Category name cannot be empty!")
            Return
        End If

        ' Create a new MenuCategory object
        Dim newCategory As New MenuCategory()
        newCategory.category_name = categoryName
        newCategory.description = description
        
        ' Convert dropdown value to boolean properly
        If isActive = "1" Then
            newCategory.is_active = True
        Else
            newCategory.is_active = False
        End If

        ' Use MenuController to create the category
        If menuController.CreateMenuCategory(newCategory) Then
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

        ' Create a MenuCategory object for the update
        Dim category As New MenuCategory()
        category.category_id = Convert.ToInt32(categoryId)
        category.category_name = categoryName
        category.description = description
        
        ' Convert dropdown value to boolean properly
        If isActive = "1" Then
            category.is_active = True
        Else
            category.is_active = False
        End If

        ' Use MenuController to update the category
        If menuController.UpdateMenuCategory(category) Then
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

        ' Check if the category is being used by menu items
        If menuController.IsCategoryInUse(Convert.ToInt32(categoryId)) Then
            ShowAlert("Cannot delete category because it is being used by menu items!")
            Return
        End If

        ' Use MenuController to delete the category
        If menuController.DeleteMenuCategory(Convert.ToInt32(categoryId)) Then
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
        ' Get all menu categories from the controller
        Dim categories = menuController.GetAllCategories()

        Table1.Rows.Clear()

        Dim headerRow As New TableHeaderRow()
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Category Name"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Description"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Status"})
        Table1.Rows.Add(headerRow)

        For Each category As MenuCategory In categories
            Dim tableRow As New TableRow()

            tableRow.Cells.Add(New TableCell() With {.Text = category.category_name})
            tableRow.Cells.Add(New TableCell() With {.Text = If(category.description, "")})
            tableRow.Cells.Add(New TableCell() With {.Text = If(category.is_active, "Active", "Inactive")})

            tableRow.Attributes.Add("data-category_id", category.category_id.ToString())
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