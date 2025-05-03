<%@ Application Language="VB" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Web.SessionState" %>
<%@ Import Namespace="System.Web.Caching" %>

<script runat="server">
    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs on application startup
        System.Diagnostics.Debug.WriteLine("Application started")
    End Sub
    
    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs on application shutdown
        System.Diagnostics.Debug.WriteLine("Application ended")
    End Sub
        
    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs when an unhandled error occurs
        Dim ex As Exception = Server.GetLastError()
        System.Diagnostics.Debug.WriteLine("Application error: " & ex.Message)
    End Sub

    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs when a new session is started
        System.Diagnostics.Debug.WriteLine("Session started")
    End Sub

    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs when a session ends
        System.Diagnostics.Debug.WriteLine("Session ended")
    End Sub
</script> 