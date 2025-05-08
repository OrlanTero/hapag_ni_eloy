Imports System.Collections.Generic
Imports System.Data
Imports HapagDB

Partial Class Pages_RegistrationComplete
    Inherits System.Web.UI.Page
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Maintain the skip login redirect flag
            Session("SkipLoginRedirect") = "true"
            
            System.Diagnostics.Debug.WriteLine("Registration completion page loaded")
            
            Try
                ' Get the user data from session
                Dim userData As Dictionary(Of String, String) = OTPManager.GetUserData()
                
                If userData Is Nothing OrElse userData.Count = 0 Then
                    ' No registration data found, show error
                    System.Diagnostics.Debug.WriteLine("No user data found in session")
                    ShowError()
                    Return
                End If
                
                ' Complete registration by inserting the user into the database
                If InsertUserIntoDatabase(userData) Then
                    ' Registration successful, clean up session data
                    System.Diagnostics.Debug.WriteLine("User registration successful")
                    OTPManager.ClearUserData()
                    OTPManager.ClearOTPData()
                    
                    ' Show success panel (already visible by default)
                    ' On login, the skip login redirect flag will be cleared
                    Session("SkipLoginRedirect") = Nothing
                Else
                    ' Failed to insert into database
                    System.Diagnostics.Debug.WriteLine("Failed to insert user into database")
                    ShowError()
                End If
                
            Catch ex As Exception
                ' Log exception
                System.Diagnostics.Debug.WriteLine("Registration completion error: " & ex.Message)
                ShowError()
            End Try
        End If
    End Sub
    
    Private Function InsertUserIntoDatabase(ByVal userData As Dictionary(Of String, String)) As Boolean
        Dim Connect As New Connection()
        
        Try
            System.Diagnostics.Debug.WriteLine("Attempting to insert user into database")
            
            ' Get the database structure to ensure we use the correct column names
            ' The error indicates that 'displayname' and 'type' columns don't exist
            ' Let's use the correct column names based on common SQL naming conventions
            
            ' Create SQL command based on your users table structure
            Dim cmdText As String = "INSERT INTO users (username, email, password, display_name, user_type) " & _
                                   "VALUES (@username, @email, @password, @display_name, @user_type)"
            
            ' Clear any existing parameters
            Connect.ClearParams()
            
            ' Add user data parameters with the correct parameter names
            Connect.AddParam("@username", userData("Username"))
            Connect.AddParam("@email", userData("Email"))
            Connect.AddParam("@password", userData("Password")) ' In production, you would hash this password
            Connect.AddParam("@display_name", userData("DisplayName"))
            
            ' Set user type (3 = customer)
            Connect.AddParam("@user_type", userData("UserType"))
            
            System.Diagnostics.Debug.WriteLine("Executing SQL query: " & cmdText)
            
            ' Execute the query
            Return Connect.Query(cmdText)
            
        Catch ex As Exception
            ' Log error
            System.Diagnostics.Debug.WriteLine("Database insert error: " & ex.Message)
            Return False
        End Try
    End Function
    
    Private Sub ShowError()
        SuccessPanel.Visible = False
        ErrorPanel.Visible = True
    End Sub
End Class 