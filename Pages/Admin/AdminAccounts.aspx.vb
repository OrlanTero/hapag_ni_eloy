Imports System.Data
Imports HapagDB

Partial Class Pages_Admin_AdminAccounts
    Inherits AdminBasePage
    Private userController As New UserController()
    
    Private ReadOnly Property IsViewOnly As Boolean
        Get
            Return IsStaffUser() And Not IsAdminUser()
        End Get
    End Property

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        ' Check if we're in view-only mode and disable editing controls
        If IsViewOnly Then
            DisableEditingControls()
            ShowViewOnlyNotice()
        End If
    End Sub
    
    Private Sub DisableEditingControls()
        ' Disable buttons
        If AddBtn IsNot Nothing Then AddBtn.Enabled = False
        If EditBtn IsNot Nothing Then EditBtn.Enabled = False
        If RemoveBtn IsNot Nothing Then RemoveBtn.Enabled = False
        
        ' Optional: Add visual indication that buttons are disabled
        If AddBtn IsNot Nothing Then AddBtn.CssClass = AddBtn.CssClass & " disabled"
        If EditBtn IsNot Nothing Then EditBtn.CssClass = EditBtn.CssClass & " disabled"
        If RemoveBtn IsNot Nothing Then RemoveBtn.CssClass = RemoveBtn.CssClass & " disabled"
    End Sub
    
    Private Sub ShowViewOnlyNotice()
        Try
            ' Use the master page's notice method if it exists
            Dim masterPage As Pages_Admin_AdminTemplate = DirectCast(Me.Master, Pages_Admin_AdminTemplate)
            masterPage.ShowInfo("You are in view-only mode. Editing functionality is restricted.")
        Catch ex As Exception
            ' Fallback to local message display if master page method fails
            ShowAlert("You are in view-only mode. Editing functionality is restricted.")
        End Try
    End Sub

    Protected Sub AddBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddBtn.Click
        ' Check if user is in view-only mode
        If IsViewOnly Then
            ShowViewOnlyNotice()
            Return
        End If
        
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
            ElseIf user.user_type = 2 Then
                userTypeText = "Staff"
            End If
            tableRow.Cells.Add(New TableCell() With {.Text = userTypeText})

            tableRow.Attributes.Add("data-user_id", user.user_id.ToString())
            Table1.Rows.Add(tableRow)
        Next
    End Sub

    Protected Sub EditBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles EditBtn.Click
        ' Check if user is in view-only mode
        If IsViewOnly Then
            ShowViewOnlyNotice()
            Return
        End If
        
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
        ' Check if user is in view-only mode
        If IsViewOnly Then
            ShowViewOnlyNotice()
            Return
        End If
        
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
        Try
            ' Use the master page's alert methods if possible
            Dim masterPage As Pages_Admin_AdminTemplate = DirectCast(Me.Master, Pages_Admin_AdminTemplate)
            masterPage.ShowInfo(message)
        Catch ex As Exception
            ' Fallback to original alert method
            Dim script As String = "alert('" & message & "');"
            ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
        End Try
    End Sub
End Class

