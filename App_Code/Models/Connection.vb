Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data
Imports System.Collections.Generic

Namespace HapagDB
    Public Class Connection
        Public ConnectionString As String = "Data Source=ORLAN\SQLEXPRESS;Initial Catalog=hapag_database;Integrated Security=True"
        Public Connect As New SqlConnection(ConnectionString)
        Public Parameters As New List(Of SqlParameter)
        Public Data As DataSet
        Public DataCount As Integer

        Public Sub New()
            System.Diagnostics.Debug.WriteLine("Connection initialized with string: " & ConnectionString)
            Try
                Connect.Open()
                System.Diagnostics.Debug.WriteLine("Test connection successful")
                Connect.Close()
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Test connection failed: " & ex.Message)
            End Try
        End Sub

        Public Sub Open()
            If Connect.State = ConnectionState.Closed Then
                Connect.Open()
            End If
        End Sub

        Public Sub Close()
            If Connect.State = ConnectionState.Open Then
                Connect.Close()
            End If
        End Sub

        Public Sub AddParam(ByVal key As String, ByVal value As String)
            If String.IsNullOrEmpty(value) Then
                System.Diagnostics.Debug.WriteLine("Adding param: " & key & " = NULL (Empty String)")
                Dim param As New SqlParameter(key, SqlDbType.VarChar)
                param.Value = DBNull.Value
                Parameters.Add(param)
            Else
                System.Diagnostics.Debug.WriteLine("Adding param: " & key & " = '" & value & "' (String)")
                Parameters.Add(New SqlParameter(key, value))
            End If
        End Sub
        
        Public Sub AddParam(ByVal key As String, ByVal value As Integer)
            System.Diagnostics.Debug.WriteLine("Adding param: " & key & " = " & value & " (Integer)")
            Parameters.Add(New SqlParameter(key, value))
        End Sub
        
        Public Sub AddParam(ByVal key As String, ByVal value As Decimal)
            System.Diagnostics.Debug.WriteLine("Adding param: " & key & " = " & value & " (Decimal)")
            Parameters.Add(New SqlParameter(key, value))
        End Sub
        
        Public Sub AddParam(ByVal key As String, ByVal value As Boolean)
            System.Diagnostics.Debug.WriteLine("Adding param: " & key & " = " & value & " (Boolean)")
            Parameters.Add(New SqlParameter(key, value))
        End Sub
        
        Public Sub AddParamWithNull(ByVal key As String, ByVal value As Object)
            If value Is Nothing Then
                System.Diagnostics.Debug.WriteLine("Adding param: " & key & " = NULL (Object is Nothing)")
                Dim param As New SqlParameter(key, SqlDbType.NVarChar)
                param.Value = DBNull.Value
                Parameters.Add(param)
            ElseIf TypeOf value Is String AndAlso String.IsNullOrEmpty(CStr(value)) Then
                System.Diagnostics.Debug.WriteLine("Adding param: " & key & " = '' (Empty string, not NULL)")
                ' For empty strings, we should use an empty string, not NULL
                Parameters.Add(New SqlParameter(key, ""))
            Else
                System.Diagnostics.Debug.WriteLine("Adding param: " & key & " = '" & value.ToString() & "' (Object)")
                Parameters.Add(New SqlParameter(key, value))
            End If
        End Sub

        Public Function Query(ByVal command_query As String) As Boolean
            Try
                Open()

                Dim command As New SqlCommand(command_query, Connect)

                If Parameters.Count > 0 Then
                    System.Diagnostics.Debug.WriteLine("Adding " & Parameters.Count & " parameters to query")
                    For Each param As SqlParameter In Parameters
                        System.Diagnostics.Debug.WriteLine("  Parameter: " & param.ParameterName & " = " & If(param.Value Is DBNull.Value, "NULL", param.Value.ToString()))
                        command.Parameters.Add(param)
                    Next
                    Parameters.Clear()
                End If

                If command_query.StartsWith("INSERT", StringComparison.OrdinalIgnoreCase) OrElse
                   command_query.StartsWith("UPDATE", StringComparison.OrdinalIgnoreCase) OrElse
                   command_query.StartsWith("DELETE", StringComparison.OrdinalIgnoreCase) OrElse
                   command_query.StartsWith("ALTER", StringComparison.OrdinalIgnoreCase) Then

                    Dim rowsAffected As Integer = command.ExecuteNonQuery()
                    System.Diagnostics.Debug.WriteLine("Non-query executed. Rows affected: " & rowsAffected)
                    
                    Close()

                    Return rowsAffected > 0
                ElseIf command_query.StartsWith("SELECT", StringComparison.OrdinalIgnoreCase) Then

                    Dim adapter As New SqlDataAdapter(command)
                    Data = New DataSet()
                    DataCount = adapter.Fill(Data)
                    System.Diagnostics.Debug.WriteLine("Select query executed. Rows returned: " & DataCount)
                    
                    Close()

                    Return DataCount > 0
                Else
                    System.Diagnostics.Debug.WriteLine("Unknown query type: " & command_query)
                    Close()
                    Return False
                End If
            Catch ex As SqlException
                System.Diagnostics.Debug.WriteLine("SQL ERROR in Query method: " & ex.Message)
                System.Diagnostics.Debug.WriteLine("SQL Error Number: " & ex.Number)
                System.Diagnostics.Debug.WriteLine("SQL Command: " & command_query)
                System.Diagnostics.Debug.WriteLine("SQL Stack Trace: " & ex.StackTrace)
                Close()
                Return False
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("General ERROR in Query method: " & ex.Message)
                System.Diagnostics.Debug.WriteLine("Query: " & command_query)
                System.Diagnostics.Debug.WriteLine("Stack Trace: " & ex.StackTrace)
                Close()
                Return False
            End Try
        End Function

        Public Sub ClearParams()
            Parameters.Clear()
        End Sub

        ' Execute the query with a direct SQL approach for troubleshooting
        Public Function DirectQuery(ByVal query As String) As Boolean
            Try
                System.Diagnostics.Debug.WriteLine("Executing direct query: " & query)
                Dim conn As New SqlConnection(ConnectionString)
                Dim cmd As New SqlCommand(query, conn)
                conn.Open()
                Dim rowsAffected As Integer = cmd.ExecuteNonQuery()
                conn.Close()
                System.Diagnostics.Debug.WriteLine("Direct query executed. Rows affected: " & rowsAffected)
                Return rowsAffected > 0
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error in direct query: " & ex.Message)
                Return False
            End Try
        End Function
    End Class
End Namespace 