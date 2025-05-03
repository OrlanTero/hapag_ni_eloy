Imports Microsoft.VisualBasic
Imports System.Data
Imports HapagDB

Public Class DBUtils
    Dim Connect As New Connection()

    Public Function RegisterUser(ByVal username As String, ByVal password As String) As Boolean
        Dim q = "INSERT INTO users (username, password, user_type) VALUES (@username, @password, @user_type)"

        Connect.AddParam("@username", username)
        Connect.AddParam("@password", password)
        Connect.AddParam("@user_type", 3)
        Return Connect.Query(q)
    End Function

    Public Function LoginUser(ByVal username As String, ByVal password As String, Optional ByVal user_type As Integer = 3) As DataRow
        Dim q = "SELECT * FROM users WHERE username = @username AND password = @password AND user_type = @user_type"

        Connect.AddParam("@username", username)
        Connect.AddParam("@password", password)
        Connect.AddParam("@user_type", user_type)   
        Connect.Query(q)

        If Connect.DataCount > 0 Then
            Return Connect.Data.Tables(0).Rows(0)
        End If

        Return Nothing
    End Function
End Class
