Imports System.Data
Imports System.Web.UI
Imports System.Collections.Generic

Public Class AdminBasePage
    Inherits System.Web.UI.Page
    
    ' Define page access levels
    Private _staffViewOnlyPages As List(Of String) = New List(Of String) From {
        "adminmenu.aspx",
        "adminmenucategories.aspx",
        "adminmenutypes.aspx",
        "admindeals.aspx",
        "adminpromotions.aspx",
        "admindiscounts.aspx",
        "admin transaction.aspx"
    }
    
    ' Staff full access pages
    Private _staffFullAccessPages As List(Of String) = New List(Of String) From {
        "admindashboard.aspx",
        "adminorders.aspx",
        "customersupport.aspx"
    }
    
    ' Admin only pages
    Private _adminOnlyPages As List(Of String) = New List(Of String) From {
        "adminaccounts.aspx"
    }
    
    ' Override OnInit to check permissions
    Protected Overrides Sub OnInit(ByVal e As EventArgs)
        MyBase.OnInit(e)
        
        ' Check if user is logged in
        If Session("CURRENT_SESSION") Is Nothing Then
            Response.Redirect("~/Pages/LoginPortal/AdminStaffLoginPortal.aspx")
            Return
        End If
        
        ' Get current user and page
        Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
        Dim currentPage As String = System.IO.Path.GetFileName(Request.Path).ToLower()
        
        System.Diagnostics.Debug.WriteLine("=== PAGE PERMISSIONS CHECK ===")
        System.Diagnostics.Debug.WriteLine("Current User: " & currentUser.username)
        System.Diagnostics.Debug.WriteLine("Current User Role: " & currentUser.role)
        System.Diagnostics.Debug.WriteLine("Is Staff: " & IsStaffUser())
        System.Diagnostics.Debug.WriteLine("Is Admin: " & IsAdminUser())
        System.Diagnostics.Debug.WriteLine("Current Page: " & currentPage)
        
        ' Check permissions based on role
        If IsStaffUser() Then
            ' Staff permissions
            System.Diagnostics.Debug.WriteLine("Checking staff permissions")
            
            ' Check if this is an admin-only page
            If _adminOnlyPages.Contains(currentPage) Then
                ' Show access denied message and redirect
                System.Diagnostics.Debug.WriteLine("Admin-only page, redirecting to Dashboard")
                Session("ACCESS_DENIED_MESSAGE") = "You do not have permission to access that page."
                Response.Redirect("~/Pages/Admin/AdminDashboard.aspx")
                Return
            End If
            
            ' Check if this is a view-only page
            If _staffViewOnlyPages.Contains(currentPage) Then
                ' Set page to read-only mode - this will be checked in each page
                System.Diagnostics.Debug.WriteLine("Setting page to READ_ONLY mode")
                Session("PAGE_ACCESS_MODE") = "READ_ONLY"
            ElseIf _staffFullAccessPages.Contains(currentPage) Then
                ' Set page to full access mode
                System.Diagnostics.Debug.WriteLine("Setting page to FULL_ACCESS mode")
                Session("PAGE_ACCESS_MODE") = "FULL_ACCESS"
            Else
                ' Unknown page - default to read-only
                System.Diagnostics.Debug.WriteLine("Unknown page, defaulting to READ_ONLY mode")
                Session("PAGE_ACCESS_MODE") = "READ_ONLY"
            End If
        Else
            ' Admin has full access to all pages
            System.Diagnostics.Debug.WriteLine("Admin user, setting FULL_ACCESS mode")
            Session("PAGE_ACCESS_MODE") = "FULL_ACCESS"
        End If
    End Sub
    
    ' Override OnLoad to ensure permissions are checked/applied on each load
    Protected Overrides Sub OnLoad(ByVal e As EventArgs)
        MyBase.OnLoad(e)
        
        ' Apply read-only restrictions if needed
        If Not IsPostBack Then
            If IsReadOnlyMode() Then
                System.Diagnostics.Debug.WriteLine("Applying read-only restrictions")
                SetPageToReadOnly()
            End If
        End If
    End Sub
    
    ' Helper method to check if the page is in read-only mode
    Protected Function IsReadOnlyMode() As Boolean
        Dim result As Boolean = (Session("PAGE_ACCESS_MODE") IsNot Nothing AndAlso Session("PAGE_ACCESS_MODE").ToString() = "READ_ONLY")
        System.Diagnostics.Debug.WriteLine("IsReadOnlyMode: " & result)
        Return result
    End Function
    
    ' Helper method to disable all edit controls on a page
    Protected Sub SetPageToReadOnly()
        ' Find all input controls and disable them
        System.Diagnostics.Debug.WriteLine("SetPageToReadOnly called")
        DisableAllInputControls(Page)
        
        ' Also disable controls in the master page if it exists
        If Master IsNot Nothing Then
            System.Diagnostics.Debug.WriteLine("Disabling controls in master page")
            DisableAllInputControls(Master)
        End If
    End Sub
    
    ' Recursively disable all input controls
    Private Sub DisableAllInputControls(ByVal parent As Control)
        For Each ctrl As Control In parent.Controls
            ' Process button controls
            If TypeOf ctrl Is System.Web.UI.WebControls.Button Then
                Dim btn As System.Web.UI.WebControls.Button = DirectCast(ctrl, System.Web.UI.WebControls.Button)
                If Not (btn.ID IsNot Nothing AndAlso (btn.ID.ToLower().Contains("view") OrElse btn.ID.ToLower().Contains("search") OrElse btn.ID.ToLower().Contains("filter"))) Then
                    ' Disable buttons that are not view/search/filter buttons
                    System.Diagnostics.Debug.WriteLine("Disabling button: " & btn.ID)
                    btn.Enabled = False
                End If
            ' Process LinkButton controls
            ElseIf TypeOf ctrl Is System.Web.UI.WebControls.LinkButton Then
                Dim lnkBtn As System.Web.UI.WebControls.LinkButton = DirectCast(ctrl, System.Web.UI.WebControls.LinkButton)
                If Not (lnkBtn.ID IsNot Nothing AndAlso (lnkBtn.ID.ToLower().Contains("view") OrElse lnkBtn.ID.ToLower().Contains("search") OrElse lnkBtn.ID.ToLower().Contains("filter"))) Then
                    ' Disable LinkButtons that are not view/search/filter buttons
                    System.Diagnostics.Debug.WriteLine("Disabling LinkButton: " & lnkBtn.ID)
                    lnkBtn.Enabled = False
                End If
            ' Process TextBox controls
            ElseIf TypeOf ctrl Is System.Web.UI.WebControls.TextBox Then
                Dim txt As System.Web.UI.WebControls.TextBox = DirectCast(ctrl, System.Web.UI.WebControls.TextBox)
                If Not (txt.ID IsNot Nothing AndAlso (txt.ID.ToLower().Contains("search") OrElse txt.ID.ToLower().Contains("filter"))) Then
                    ' Disable TextBoxes that are not search/filter textboxes
                    System.Diagnostics.Debug.WriteLine("Disabling TextBox: " & txt.ID)
                    txt.Enabled = False
                End If
            ' Process DropDownList controls
            ElseIf TypeOf ctrl Is System.Web.UI.WebControls.DropDownList Then
                Dim ddl As System.Web.UI.WebControls.DropDownList = DirectCast(ctrl, System.Web.UI.WebControls.DropDownList)
                If Not (ddl.ID IsNot Nothing AndAlso (ddl.ID.ToLower().Contains("search") OrElse ddl.ID.ToLower().Contains("filter"))) Then
                    ' Disable DropDownLists that are not search/filter dropdowns
                    System.Diagnostics.Debug.WriteLine("Disabling DropDownList: " & ddl.ID)
                    ddl.Enabled = False
                End If
            End If
            
            ' Process child controls
            If ctrl.HasControls() Then
                DisableAllInputControls(ctrl)
            End If
        Next
    End Sub
    
    ' Helper method to check if the current user is a staff member
    Protected Function IsStaffUser() As Boolean
        If Session("CURRENT_SESSION") Is Nothing Then
            Return False
        End If
        
        Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
        Dim isStaff As Boolean = currentUser.role.ToLower() = "staff"
        
        System.Diagnostics.Debug.WriteLine("IsStaffUser check: " & isStaff & " for user with role " & currentUser.role)
        Return isStaff
    End Function
    
    ' Helper method to check if the current user is an admin
    Protected Function IsAdminUser() As Boolean
        If Session("CURRENT_SESSION") Is Nothing Then
            Return False
        End If
        
        Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
        Dim isAdmin As Boolean = currentUser.role.ToLower() = "admin"
        
        System.Diagnostics.Debug.WriteLine("IsAdminUser check: " & isAdmin & " for user with role " & currentUser.role)
        Return isAdmin
    End Function
End Class 