Imports System.Data
Imports HapagDB

Partial Class Pages_Admin_AdminAccounts
    Inherits System.Web.UI.Page
    Private userController As New UserController()

    Protected Sub AddBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddBtn.Click
        Dim username = UsernameTxt.Text
        Dim password = PasswordTxt.Text
        Dim display_name = DisplayNameTxt.Text
        Dim contact = ContactTxt.Text
        Dim address = AddressTxt.Text
        Dim user_type = UsertypeDdl.SelectedValue

        ' Create a new User object
        Dim newUser As New User()
        newUser.username = username
        newUser.password = password
        newUser.display_name = display_name
        newUser.contact = contact
        newUser.address = address
        newUser.user_type = Convert.ToInt32(user_type)

        ' Use UserController to create the user
        If userController.CreateUser(newUser) Then
            ShowAlert("Successfully Added!")
        Else
            ShowAlert("Failed to Add!")
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
        ' Get all users from the controller
        Dim users = userController.GetAllUsers()

        Table1.Rows.Clear()

        Dim headerRow As New TableHeaderRow
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Username"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Password"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Display Name"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Contact"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Address"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "User Type"})
        Table1.Rows.Add(headerRow)

        For Each user As User In users
            Dim tableRow As New TableRow()

            tableRow.Cells.Add(New TableCell() With {.Text = user.username})
            tableRow.Cells.Add(New TableCell() With {.Text = user.password})
            tableRow.Cells.Add(New TableCell() With {.Text = user.display_name})
            tableRow.Cells.Add(New TableCell() With {.Text = If(user.contact, "")})
            tableRow.Cells.Add(New TableCell() With {.Text = If(user.address, "")})
            
            ' Convert user_type to readable text
            Dim userTypeText As String = "Customer"
            If user.user_type = 1 Then
                userTypeText = "Admin"
            End If
            tableRow.Cells.Add(New TableCell() With {.Text = userTypeText})

            tableRow.Attributes.Add("data-user_id", user.user_id.ToString())
            Table1.Rows.Add(tableRow)
        Next
    End Sub

    Protected Sub EditBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles EditBtn.Click
        Dim user_id = UserIdTxt.Text
        Dim username = UsernameTxt.Text
        Dim password = PasswordTxt.Text
        Dim display_name = DisplayNameTxt.Text
        Dim contact = ContactTxt.Text
        Dim address = AddressTxt.Text
        Dim user_type = UsertypeDdl.SelectedValue

        ' Create a User object for the update
        Dim user As New User()
        user.user_id = Convert.ToInt32(user_id)
        user.username = username
        user.password = password
        user.display_name = display_name
        user.contact = contact
        user.address = address
        user.user_type = Convert.ToInt32(user_type)

        ' Use UserController to update the user
        If userController.UpdateUser(user) Then
            ShowAlert("Successfully Updated!")
        Else
            ShowAlert("Failed to Update!")
        End If

        ViewTable()
        ClearFormFields()
    End Sub

    Protected Sub RemoveBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RemoveBtn.Click
        Dim user_id = UserIdTxt.Text

        ' Use UserController to delete the user
        If userController.DeleteUser(Convert.ToInt32(user_id)) Then
            ShowAlert("Successfully Deleted!")
        Else
            ShowAlert("Failed to Delete!")
        End If

        ViewTable()
        ClearFormFields()
    End Sub

    Public Function HasSelectedRow() As Boolean
        Return UserIdTxt.Text.Length > 0
    End Function

    Private Sub ClearFormFields()
        UserIdTxt.Text = ""
        UsernameTxt.Text = ""
        PasswordTxt.Text = ""
        DisplayNameTxt.Text = ""
        ContactTxt.Text = ""
        AddressTxt.Text = ""
    End Sub

    Private Sub ShowAlert(ByVal message As String)
        Dim script As String = "alert('" & message & "');"
        ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
    End Sub
End Class

