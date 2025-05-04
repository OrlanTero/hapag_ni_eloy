Imports System.Data
Imports HapagDB

Partial Class Pages_Admin_CustomerSupport
    Inherits AdminBasePage
    Dim Connect As New Connection()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in
            If Session("CURRENT_SESSION") Is Nothing Then
                Response.Redirect("~/Pages/LoginPortal/AdminStaffLoginPortal.aspx")
            End If

            ' Verify user has staff role
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            If currentUser.role.ToLower() <> "staff" Then
                System.Diagnostics.Debug.WriteLine("CustomerSupport: Access denied for non-staff user")
                ShowAlert("This page is only accessible to staff members.", False)
                Response.Redirect("~/Pages/Admin/AdminDashboard.aspx")
            Else
                System.Diagnostics.Debug.WriteLine("CustomerSupport: Staff access granted")
            End If
        End If
    End Sub

    Private Sub ShowAlert(ByVal message As String, ByVal isSuccess As Boolean)
        alertMessage.Visible = True
        If isSuccess Then
            alertMessage.Attributes("class") = "alert-message alert-success"
        Else
            alertMessage.Attributes("class") = "alert-message alert-danger"
        End If
        AlertLiteral.Text = message
    End Sub
End Class 