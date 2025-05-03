Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Collections.Generic
Imports HapagDB

Public Class UserController
    Private conn As New Connection()
    
    Public Function GetUserById(ByVal userId As Integer) As User
        Dim query As String = "SELECT * FROM users WHERE user_id = @user_id"
        conn.AddParam("@user_id", userId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            Return MapDataRowToUser(conn.Data.Tables(0).Rows(0))
        End If
        
        Return Nothing
    End Function
    
    Public Function GetAllUsers() As List(Of User)
        Dim users As New List(Of User)()
        Dim query As String = "SELECT * FROM users"
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                users.Add(MapDataRowToUser(row))
            Next
        End If
        
        Return users
    End Function
    
    Public Function GetUsersByType(ByVal userType As String) As List(Of User)
        Dim users As New List(Of User)()
        Dim query As String = "SELECT * FROM users WHERE user_type = @user_type"
        conn.AddParam("@user_type", userType)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                users.Add(MapDataRowToUser(row))
            Next
        End If
        
        Return users
    End Function
    
    Public Function CreateUser(ByVal user As User) As Boolean
        Dim query As String = "INSERT INTO users (username, password, display_name, contact, email, address, user_type) " & _
                             "VALUES (@username, @password, @display_name, @contact, @email, @address, @user_type)"
        
        conn.AddParamWithNull("@username", user.username)
        conn.AddParamWithNull("@password", user.password)
        conn.AddParamWithNull("@display_name", user.display_name)
        conn.AddParamWithNull("@contact", user.contact)
        conn.AddParamWithNull("@email", user.email)
        conn.AddParamWithNull("@address", user.address)
        conn.AddParamWithNull("@user_type", user.user_type)
        
        Return conn.Query(query)
    End Function
    
    Public Function UpdateUser(ByVal user As User) As Boolean
        Dim query As String = "UPDATE users " & _
                             "SET username = @username, " & _
                             "    display_name = @display_name, " & _
                             "    contact = @contact, " & _
                             "    email = @email, " & _
                             "    address = @address, " & _
                             "    user_type = @user_type " & _
                             "WHERE user_id = @user_id"
        
        conn.AddParam("@user_id", user.user_id)
        conn.AddParamWithNull("@username", user.username)
        conn.AddParamWithNull("@display_name", user.display_name)
        conn.AddParamWithNull("@contact", user.contact)
        conn.AddParamWithNull("@email", user.email)
        conn.AddParamWithNull("@address", user.address)
        conn.AddParamWithNull("@user_type", user.user_type)
        
        Return conn.Query(query)
    End Function
    
    Public Function UpdateUserPassword(ByVal userId As Integer, ByVal newPassword As String) As Boolean
        Dim query As String = "UPDATE users SET password = @password WHERE user_id = @user_id"
        
        conn.AddParam("@user_id", userId)
        conn.AddParam("@password", newPassword)
        
        Return conn.Query(query)
    End Function
    
    Public Function DeleteUser(ByVal userId As Integer) As Boolean
        Dim query As String = "DELETE FROM users WHERE user_id = @user_id"
        
        conn.AddParam("@user_id", userId)
        
        Return conn.Query(query)
    End Function
    
    Public Function AuthenticateUser(ByVal username As String, ByVal password As String) As User
        Dim query As String = "SELECT * FROM users WHERE username = @username AND password = @password"
        
        conn.AddParam("@username", username)
        conn.AddParam("@password", password)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            Return MapDataRowToUser(conn.Data.Tables(0).Rows(0))
        End If
        
        Return Nothing
    End Function
    
    Private Function MapDataRowToUser(ByVal row As DataRow) As User
        Dim user As New User()
        
        user.user_id = Convert.ToInt32(row("user_id"))
        user.username = If(row("username") IsNot DBNull.Value, row("username").ToString(), Nothing)
        user.display_name = If(row("display_name") IsNot DBNull.Value, row("display_name").ToString(), Nothing)
        user.contact = If(row("contact") IsNot DBNull.Value, row("contact").ToString(), Nothing)
        user.email = If(row("email") IsNot DBNull.Value, row("email").ToString(), Nothing)
        user.address = If(row("address") IsNot DBNull.Value, row("address").ToString(), Nothing)
        user.user_type = If(row("user_type") IsNot DBNull.Value, row("user_type").ToString(), Nothing)
        
        Return user
    End Function
End Class 