Imports System.Data
Imports HapagDB

Partial Class Pages_Admin_AdminTemplate
    Inherits System.Web.UI.MasterPage
    Dim Connect As New Connection()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in
            If Session("CURRENT_SESSION") Is Nothing Then
                Response.Redirect("~/Pages/LoginPortal/AdminStaffLoginPortal.aspx")
            End If

            ' Display user name and initials
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            UserDisplayNameLiteral.Text = currentUser.display_name
            UserInitialsLiteral.Text = GetInitials(currentUser.display_name)
        End If
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

    Protected Sub LogoutButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        ' Clear session
        Session.Clear()
        Session.Abandon()

        ' Redirect to login page
        Response.Redirect("~/Pages/LoginPortal/AdminStaffLoginPortal.aspx")
    End Sub

    ' Helper method to show alert messages
    Protected Sub ShowAlert(ByVal message As String, Optional ByVal isSuccess As Boolean = True)
        alertMessage.Visible = True
        
        If isSuccess Then
            alertMessage.Attributes("class") = "alert-message alert-success"
        Else
            alertMessage.Attributes("class") = "alert-message alert-danger"
        End If
        
        AlertLiteral.Text = message
    End Sub
    
    ' Helper method to show warning messages
    Protected Sub ShowWarning(ByVal message As String)
        alertMessage.Visible = True
        alertMessage.Attributes("class") = "alert-message alert-warning"
        AlertLiteral.Text = message
    End Sub
    
    ' Helper method to show info messages
    Protected Sub ShowInfo(ByVal message As String)
        alertMessage.Visible = True
        alertMessage.Attributes("class") = "alert-message alert-info"
        AlertLiteral.Text = message
    End Sub
End Class 