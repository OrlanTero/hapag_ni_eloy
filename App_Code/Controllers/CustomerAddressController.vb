Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Collections.Generic
Imports HapagDB

Public Class CustomerAddressController
    Private conn As New Connection()
    
    Public Function GetAddressById(ByVal addressId As Integer) As CustomerAddress
        Dim query As String = "SELECT * FROM customer_addresses WHERE address_id = @address_id"
        conn.AddParam("@address_id", addressId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            Return MapDataRowToAddress(conn.Data.Tables(0).Rows(0))
        End If
        
        Return Nothing
    End Function
    
    Public Function GetAddressesByUserId(ByVal userId As Integer) As List(Of CustomerAddress)
        Dim addresses As New List(Of CustomerAddress)()
        Dim query As String = "SELECT * FROM customer_addresses WHERE user_id = @user_id ORDER BY is_default DESC, date_added DESC"
        
        conn.AddParam("@user_id", userId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                addresses.Add(MapDataRowToAddress(row))
            Next
        End If
        
        Return addresses
    End Function
    
    Public Function GetDefaultAddress(ByVal userId As Integer) As CustomerAddress
        Dim query As String = "SELECT * FROM customer_addresses WHERE user_id = @user_id AND is_default = 1"
        
        conn.AddParam("@user_id", userId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            Return MapDataRowToAddress(conn.Data.Tables(0).Rows(0))
        End If
        
        Return Nothing
    End Function
    
    Public Function CreateAddress(ByVal address As CustomerAddress) As Boolean
        ' If this is the first address or marked as default, clear other default addresses
        If address.is_default Then
            ClearDefaultAddresses(address.user_id)
        End If
        
        Dim query As String = "INSERT INTO customer_addresses (user_id, address_name, recipient_name, contact_number, address_line, city, postal_code, is_default, date_added) " & _
                             "VALUES (@user_id, @address_name, @recipient_name, @contact_number, @address_line, @city, @postal_code, @is_default, @date_added)"
        
        conn.AddParam("@user_id", address.user_id)
        conn.AddParamWithNull("@address_name", address.address_name)
        conn.AddParamWithNull("@recipient_name", address.recipient_name)
        conn.AddParamWithNull("@contact_number", address.contact_number)
        conn.AddParamWithNull("@address_line", address.address_line)
        conn.AddParamWithNull("@city", address.city)
        conn.AddParamWithNull("@postal_code", address.postal_code)
        conn.AddParam("@is_default", If(address.is_default, 1, 0))
        conn.AddParam("@date_added", DateTime.Now)
        
        Return conn.Query(query)
    End Function
    
    Public Function UpdateAddress(ByVal address As CustomerAddress) As Boolean
        ' If updating to default, clear other defaults
        If address.is_default Then
            ClearDefaultAddresses(address.user_id)
        End If
        
        Dim query As String = "UPDATE customer_addresses " & _
                             "SET address_name = @address_name, " & _
                             "    recipient_name = @recipient_name, " & _
                             "    contact_number = @contact_number, " & _
                             "    address_line = @address_line, " & _
                             "    city = @city, " & _
                             "    postal_code = @postal_code, " & _
                             "    is_default = @is_default " & _
                             "WHERE address_id = @address_id"
        
        conn.AddParam("@address_id", address.address_id)
        conn.AddParamWithNull("@address_name", address.address_name)
        conn.AddParamWithNull("@recipient_name", address.recipient_name)
        conn.AddParamWithNull("@contact_number", address.contact_number)
        conn.AddParamWithNull("@address_line", address.address_line)
        conn.AddParamWithNull("@city", address.city)
        conn.AddParamWithNull("@postal_code", address.postal_code)
        conn.AddParam("@is_default", If(address.is_default, 1, 0))
        
        Return conn.Query(query)
    End Function
    
    Public Function DeleteAddress(ByVal addressId As Integer) As Boolean
        ' Check if this is a default address
        Dim getQuery As String = "SELECT * FROM customer_addresses WHERE address_id = @address_id"
        conn.AddParam("@address_id", addressId)
        
        If conn.Query(getQuery) AndAlso conn.DataCount > 0 Then
            Dim address As CustomerAddress = MapDataRowToAddress(conn.Data.Tables(0).Rows(0))
            
            ' If deleting a default address, set another one as default if available
            If address.is_default Then
                Dim userId As Integer = address.user_id
                
                ' Delete first
                Dim deleteQuery As String = "DELETE FROM customer_addresses WHERE address_id = @address_id"
                conn.AddParam("@address_id", addressId)
                conn.Query(deleteQuery)
                
                ' Find another address to make default
                Dim findQuery As String = "SELECT TOP 1 * FROM customer_addresses WHERE user_id = @user_id"
                conn.AddParam("@user_id", userId)
                
                If conn.Query(findQuery) AndAlso conn.DataCount > 0 Then
                    Dim newDefaultAddress As CustomerAddress = MapDataRowToAddress(conn.Data.Tables(0).Rows(0))
                    
                    ' Make this one default
                    Dim updateQuery As String = "UPDATE customer_addresses SET is_default = 1 WHERE address_id = @address_id"
                    conn.AddParam("@address_id", newDefaultAddress.address_id)
                    conn.Query(updateQuery)
                End If
                
                Return True
            Else
                ' Just delete it
                Dim deleteQuery As String = "DELETE FROM customer_addresses WHERE address_id = @address_id"
                conn.AddParam("@address_id", addressId)
                Return conn.Query(deleteQuery)
            End If
        End If
        
        Return False
    End Function
    
    Private Function ClearDefaultAddresses(ByVal userId As Integer) As Boolean
        Dim query As String = "UPDATE customer_addresses SET is_default = 0 WHERE user_id = @user_id"
        
        conn.AddParam("@user_id", userId)
        
        Return conn.Query(query)
    End Function
    
    Private Function MapDataRowToAddress(ByVal row As DataRow) As CustomerAddress
        Dim address As New CustomerAddress()
        
        address.address_id = Convert.ToInt32(row("address_id"))
        address.user_id = Convert.ToInt32(row("user_id"))
        address.address_name = If(row("address_name") IsNot DBNull.Value, row("address_name").ToString(), Nothing)
        address.recipient_name = If(row("recipient_name") IsNot DBNull.Value, row("recipient_name").ToString(), Nothing)
        address.contact_number = If(row("contact_number") IsNot DBNull.Value, row("contact_number").ToString(), Nothing)
        address.address_line = If(row("address_line") IsNot DBNull.Value, row("address_line").ToString(), Nothing)
        address.city = If(row("city") IsNot DBNull.Value, row("city").ToString(), Nothing)
        address.postal_code = If(row("postal_code") IsNot DBNull.Value, row("postal_code").ToString(), Nothing)
        address.is_default = If(row("is_default") IsNot DBNull.Value, Convert.ToBoolean(row("is_default")), False)
        
        If row("date_added") IsNot DBNull.Value Then
            address.date_added = Convert.ToDateTime(row("date_added"))
        End If
        
        Return address
    End Function
End Class 