Imports System.Data
Imports HapagDB

Partial Class Pages_Admin_AdminAccounts
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

    Protected Sub AddBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddBtn.Click
        Dim username = UsernameTxt.Text
        Dim password = PasswordTxt.Text
        Dim display_name = DisplayNameTxt.Text
        Dim contact = ContactTxt.Text
        Dim address = AddressTxt.Text
        Dim user_type = UsertypeDdl.SelectedValue

        Dim query = "INSERT INTO users (username, password, display_name, contact, address, user_type) VALUES (@username, @password, @display_name, @contact, @address, @user_type)"

        Connect.AddParam("@username", username)
        Connect.AddParam("@password", password)
        Connect.AddParam("@display_name", display_name)
        Connect.AddParam("@contact", contact)
        Connect.AddParam("@address", address)
        Connect.AddParam("@user_type", user_type)

        Dim insert = Connect.Query(query)

        If insert Then
            Dim script As String = "alert('Successfully Added!');"

            ClientScript.RegisterStartupScript(Me.GetType, "alertMessage", script, True)
        Else
            Dim script As String = "alert('Failed to Add!');"

            ClientScript.RegisterStartupScript(Me.GetType, "alertMessage", script, True)
        End If

        ViewTable()

        UserIdTxt.Text = ""
        UsernameTxt.Text = ""
        PasswordTxt.Text = ""
        DisplayNameTxt.Text = ""
        ContactTxt.Text = ""
        AddressTxt.Text = ""

    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ViewTable()
    End Sub

    Public Sub ViewTable()

        Dim query = "SELECT * FROM users"

        Connect.Query(query)

        Table1.Rows.Clear()

        Dim headerRow As New TableHeaderRow

        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Username"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Password"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Display Name"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Contact"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Address"})
        headerRow.Cells.Add(New TableHeaderCell() With {.Text = "User Type"})
        Table1.Rows.Add(headerRow)

        For Each row As DataRow In Connect.Data.Tables(0).Rows
            Dim tableRow As New TableRow()

            tableRow.Cells.Add(New TableCell() With {.Text = row("username").ToString()})
            tableRow.Cells.Add(New TableCell() With {.Text = row("password").ToString()})
            tableRow.Cells.Add(New TableCell() With {.Text = row("display_name").ToString()})
            tableRow.Cells.Add(New TableCell() With {.Text = row("contact").ToString()})
            tableRow.Cells.Add(New TableCell() With {.Text = row("address").ToString()})
            tableRow.Cells.Add(New TableCell() With {.Text = row("user_type").ToString()})

            tableRow.Attributes.Add("data-user_id", row("user_id").ToString())
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

        Dim query = "UPDATE users SET username = @username,password = @password, display_name = @display_name, contact = @contact, address = @address, user_type = @user_type WHERE user_id = @user_id"

        CONNECT.AddParam("@username", username)
        Connect.AddParam("@password", password)
        Connect.AddParam("@display_name", display_name)
        CONNECT.AddParam("@contact", contact)
        CONNECT.AddParam("@address", address)
        Connect.AddParam("@user_type", user_type)
        Connect.AddParam("@user_id", user_id)

        Dim updateResult = CONNECT.Query(query)

        If updateResult Then
            Dim script As String = "alert('Successfully Updated!');"
            ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
        Else
            Dim script As String = "alert('Failed to Update!');"
            ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
        End If

        ViewTable()

        UserIdTxt.Text = ""
        UsernameTxt.Text = ""
        PasswordTxt.Text = ""
        DisplayNameTxt.Text = ""
        ContactTxt.Text = ""
        AddressTxt.Text = ""

    End Sub

    Protected Sub RemoveBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RemoveBtn.Click
        Dim user_id = UserIdTxt.Text

        Dim query = "DELETE FROM users WHERE user_id = @user_id"

        Connect.AddParam("@user_id", user_id)

        Dim deleteResult = Connect.Query(query)

        If deleteResult Then
            Dim script As String = "alert('Successfully Deleted!');"
            ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
        Else
            Dim script As String = "alert('Failed to Delete!');"
            ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
        End If

        ViewTable()

        UserIdTxt.Text = ""
        UsernameTxt.Text = ""
        PasswordTxt.Text = ""
        DisplayNameTxt.Text = ""
        ContactTxt.Text = ""
        AddressTxt.Text = ""

    End Sub

    Public Function HasSelectedRow() As Boolean
        Return UserIdTxt.Text.Length > 0
    End Function
End Class

