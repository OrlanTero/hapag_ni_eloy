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
    
    Sub Application_BeginRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Track page requests to debug redirection issues
        System.Diagnostics.Debug.WriteLine("Begin Request: " & Request.Url.ToString())
        
        ' Check if this is the OTP verification page - just log it, don't try to access Session
        If Request.Url.ToString().Contains("OTPVerification.aspx") Then
            System.Diagnostics.Debug.WriteLine("OTP Verification page requested")
        End If
    End Sub
    
    ' AcquireRequestState is the proper event to use when you need to access Session
    Sub Application_AcquireRequestState(ByVal sender As Object, ByVal e As EventArgs)
        ' At this point in the pipeline, Session is available
        If Context IsNot Nothing AndAlso Context.Handler IsNot Nothing Then
            Try
                ' Skip login redirects for OTP verification
                If Request.Url.ToString().Contains("OTPVerification.aspx") AndAlso
                   Session IsNot Nothing AndAlso
                   Session("SkipLoginRedirect") IsNot Nothing AndAlso
                   Session("SkipLoginRedirect").ToString() = "true" Then
                    
                    System.Diagnostics.Debug.WriteLine("OTP verification page with SkipLoginRedirect flag")
                    
                    ' OTP was generated, allowing access to verification page
                    If Session("OTPGenerated") IsNot Nothing AndAlso Session("OTPGenerated").ToString() = "true" Then
                        System.Diagnostics.Debug.WriteLine("Found OTPGenerated flag, keeping it for the request")
                    End If
                End If
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error in AcquireRequestState: " & ex.Message)
            End Try
        End If
    End Sub
    
    Sub Application_EndRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Track redirects but don't try to access Session directly
        If Response.StatusCode = 302 Then
            System.Diagnostics.Debug.WriteLine("Redirect detected to: " & Response.RedirectLocation)
            
            ' Just log information, don't try to interfere with the redirect here
            ' since we might not have access to Session
        End If
    End Sub
</script> 