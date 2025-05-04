Imports System.Data
Imports HapagDB

Partial Class Pages_Admin_AdminMenuTypes
    Inherits System.Web.UI.Page
    Private menuController As New MenuController()

    Protected Sub AddBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddBtn.Click
        Dim typeName = TypeNameTxt.Text
        Dim description = DescriptionTxt.Text
        Dim isActive = StatusDdl.SelectedValue

        If String.IsNullOrEmpty(typeName) Then
            ShowAlert("Type name cannot be empty!")
            Return
        End If

        ' Create a new MenuType object
        Dim newType As New MenuType()
        newType.type_name = typeName
        newType.description = description
        ' Convert "1" to True and "0" to False
        newType.is_active = (isActive = "1")

        ' Use MenuController to create the type
        If menuController.CreateMenuType(newType) Then
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

        ' Create a MenuType object for the update
        Dim menuType As New MenuType()
        menuType.type_id = Convert.ToInt32(typeId)
        menuType.type_name = typeName
        menuType.description = description
        ' Convert "1" to True and "0" to False
        menuType.is_active = (isActive = "1")

        ' Use MenuController to update the type
        If menuController.UpdateMenuType(menuType) Then
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
        If menuController.IsTypeInUse(Convert.ToInt32(typeId)) Then
            ShowAlert("Cannot delete type because it is being used by menu items!")
            Return
        End If

        ' Use MenuController to delete the type
        If menuController.DeleteMenuType(Convert.ToInt32(typeId)) Then
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
        ' Get all menu types from the controller
        Dim types = menuController.GetAllTypes()
        
        Table1.Rows.Clear()

        Dim headerRow As New TableHeaderRow()
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Type Name"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Description"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Status"})
        Table1.Rows.Add(headerRow)

        For Each menuType As MenuType In types
            Dim tableRow As New TableRow()

            tableRow.Cells.Add(New TableCell() With {.Text = menuType.type_name})
            tableRow.Cells.Add(New TableCell() With {.Text = If(menuType.description, "")})
            tableRow.Cells.Add(New TableCell() With {.Text = If(menuType.is_active, "Active", "Inactive")})

            tableRow.Attributes.Add("data-type_id", menuType.type_id.ToString())
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