Imports System.Data
Imports HapagDB
Partial Class Pages_Customer_CustomerProfile
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in
            If Session("CURRENT_SESSION") Is Nothing Then
                Response.Redirect("~/Pages/LoginPortal/CustomerLoginPortal.aspx")
            End If

            ' Load user data
            LoadUserData()
        End If
    End Sub

    Private Sub LoadUserData()
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            Dim query As String = "SELECT * FROM users WHERE user_id = @user_id"
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(query)

            If Connect.DataCount > 0 Then
                Dim row As DataRow = Connect.Data.Tables(0).Rows(0)
                
                ' Set user initials and display name
                UserInitialsLiteral.Text = GetInitials(row("display_name").ToString())
                UserDisplayNameLiteral.Text = row("display_name").ToString()

                ' Populate form fields
                DisplayNameTextBox.Text = row("display_name").ToString()
                UsernameTextBox.Text = row("username").ToString()
                EmailTextBox.Text = row("email").ToString()
                PhoneTextBox.Text = row("contact").ToString()
                AddressTextBox.Text = row("address").ToString()
            End If
        Catch ex As Exception
            ShowAlert("Error loading user data: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub UpdateProfileButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            ' Check username uniqueness if username has changed
            Connect = New Connection()
            Dim checkUsernameQuery As String = "SELECT username FROM users WHERE user_id = @user_id"
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(checkUsernameQuery)
            
            Dim currentUsername As String = ""
            If Connect.DataCount > 0 Then
                currentUsername = Connect.Data.Tables(0).Rows(0)("username").ToString()
            End If

            ' Only validate username if it has changed
            If Not String.Equals(currentUsername, UsernameTextBox.Text.Trim(), StringComparison.OrdinalIgnoreCase) Then
                Connect = New Connection()
                Dim duplicateUsernameQuery As String = "SELECT COUNT(*) FROM users WHERE username = @username AND user_id <> @user_id"
                Connect.AddParam("@username", UsernameTextBox.Text.Trim())
                Connect.AddParam("@user_id", currentUser.user_id)
                Connect.Query(duplicateUsernameQuery)
                
                If Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0)) > 0 Then
                    ShowToast("This username is already taken", "error")
                    Return
                End If
            End If

            ' Check email uniqueness if email has changed
            Connect = New Connection()
            Dim checkEmailQuery As String = "SELECT email FROM users WHERE user_id = @user_id"
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(checkEmailQuery)
            
            Dim currentEmail As String = ""
            If Connect.DataCount > 0 Then
                currentEmail = Connect.Data.Tables(0).Rows(0)("email").ToString()
            End If

            ' Only validate email if it has changed
            If Not String.Equals(currentEmail, EmailTextBox.Text.Trim(), StringComparison.OrdinalIgnoreCase) Then
                Connect = New Connection()
                Dim duplicateEmailQuery As String = "SELECT COUNT(*) FROM users WHERE email = @email AND user_id <> @user_id"
                Connect.AddParam("@email", EmailTextBox.Text.Trim())
                Connect.AddParam("@user_id", currentUser.user_id)
                Connect.Query(duplicateEmailQuery)
                
                If Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0)) > 0 Then
                    ShowToast("This email is already in use by another account", "error")
                    Return
                End If
            End If

            ' Verify current password if changing password
            If Not String.IsNullOrEmpty(CurrentPasswordTextBox.Text) Then
                Connect = New Connection()
                Dim verifyQuery As String = "SELECT password FROM users WHERE user_id = @user_id"
                Connect.AddParam("@user_id", currentUser.user_id)
                Connect.Query(verifyQuery)

                If Connect.DataCount > 0 Then
                    Dim storedPassword As String = Connect.Data.Tables(0).Rows(0)("password").ToString()
                    If storedPassword <> CurrentPasswordTextBox.Text Then
                        ShowToast("Current password is incorrect", "error")
                        Return
                    End If
                End If
            End If

            ' Build update query
            Dim updateQuery As String = "UPDATE users SET display_name = @display_name, username = @username, email = @email, contact = @contact, address = @address"

            If Not String.IsNullOrEmpty(NewPasswordTextBox.Text) Then
                updateQuery &= ", password = @password"
            End If

            updateQuery &= " WHERE user_id = @user_id"

            ' Add parameters
            Connect = New Connection()
            With Connect
                .AddParam("@user_id", currentUser.user_id)
                .AddParam("@display_name", DisplayNameTextBox.Text.Trim())
                .AddParam("@username", UsernameTextBox.Text.Trim())
                .AddParam("@email", EmailTextBox.Text.Trim())
                .AddParam("@contact", PhoneTextBox.Text.Trim())
                .AddParam("@address", AddressTextBox.Text.Trim())

                If Not String.IsNullOrEmpty(NewPasswordTextBox.Text) Then
                    .AddParam("@password", NewPasswordTextBox.Text)
                End If

                ' Execute update
                .Query(updateQuery)
            End With

            ' Update session data
            currentUser.display_name = DisplayNameTextBox.Text.Trim()
            Session("CURRENT_SESSION") = currentUser

            ' Clear password fields
            CurrentPasswordTextBox.Text = ""
            NewPasswordTextBox.Text = ""
            ConfirmPasswordTextBox.Text = ""

            ShowToast("Profile updated successfully!", "success")
            LoadUserData() ' Reload user data to refresh display

        Catch ex As Exception
            ShowToast("Error updating profile: " & ex.Message, "error")
        End Try
    End Sub

    Protected Sub DeleteAccountButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            ' Delete user's data from related tables in correct order
            ' First, delete from cart
            Connect = New Connection()
            Dim deleteCartQuery As String = "DELETE FROM cart WHERE user_id = @user_id"
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(deleteCartQuery)

            ' Delete from order_items first (child table of orders)
            Connect = New Connection()
            Dim deleteOrderItemsQuery As String = "DELETE oi FROM order_items oi INNER JOIN orders o ON oi.order_id = o.order_id WHERE o.user_id = @user_id"
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(deleteOrderItemsQuery)

            ' Then delete from orders
            Connect = New Connection()
            Dim deleteOrdersQuery As String = "DELETE FROM orders WHERE user_id = @user_id"
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(deleteOrdersQuery)

            ' Delete from transactions
            Connect = New Connection()
            Dim deleteTransactionsQuery As String = "DELETE FROM transactions WHERE user_id = @user_id"
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(deleteTransactionsQuery)

            ' Finally, delete the user account
            Connect = New Connection()
            Dim deleteUserQuery As String = "DELETE FROM users WHERE user_id = @user_id"
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(deleteUserQuery)

            ' Clear session
            Session.Clear()
            Session.Abandon()

            ' Show success message and redirect
            Response.Write("<script>alert('Account successfully deleted. You will be redirected to the login page.'); window.location.href='../../Pages/LoginPortal/CustomerLoginPortal.aspx';</script>")
            
        Catch ex As Exception
            ShowToast("Error deleting account: " & ex.Message, "error")
        End Try
    End Sub

    Private Function GetInitials(ByVal name As String) As String
        If String.IsNullOrEmpty(name) Then
            Return "U"
        End If

        Dim parts = name.Split(" "c)
        If parts.Length > 1 Then
            ' If there are multiple parts, take first letter of first and last parts
            Return (parts(0)(0) & parts(parts.Length - 1)(0)).ToUpper()
        Else
            ' If single word, take first two letters or just first letter if single character
            Return If(name.Length > 1, name.Substring(0, 2), name.Substring(0, 1)).ToUpper()
        End If
    End Function

    Protected Sub ShowAlert(ByVal message As String, Optional ByVal isSuccess As Boolean = True)
        Dim masterPage As Pages_Customer_CustomerTemplate = DirectCast(Me.Master, Pages_Customer_CustomerTemplate)
        masterPage.ShowAlert(message, isSuccess)
    End Sub

    Private Sub ShowToast(ByVal message As String, ByVal type As String)
        ' Execute the JavaScript function to show the toast
        Dim script As String = String.Format("showToast('{0}', '{1}');", message.Replace("'", "\'"), type)
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowToast", script, True)
    End Sub
End Class 