Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Collections.Generic
Imports HapagDB

Public Class TransactionController
    Private conn As New Connection()
    
    Public Function GetTransactionById(ByVal transactionId As Integer) As Transaction
        Dim query As String = "SELECT * FROM transactions WHERE transaction_id = @transaction_id"
        conn.AddParam("@transaction_id", transactionId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            Return MapDataRowToTransaction(conn.Data.Tables(0).Rows(0))
        End If
        
        Return Nothing
    End Function
    
    Public Function GetAllTransactions() As List(Of Transaction)
        Dim transactions As New List(Of Transaction)()
        Dim query As String = "SELECT * FROM transactions ORDER BY transaction_date DESC"
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                transactions.Add(MapDataRowToTransaction(row))
            Next
        End If
        
        Return transactions
    End Function
    
    Public Function GetTransactionsByUserId(ByVal userId As Integer) As List(Of Transaction)
        Dim transactions As New List(Of Transaction)()
        Dim query As String = "SELECT * FROM transactions WHERE user_id = @user_id ORDER BY transaction_date DESC"
        
        conn.AddParam("@user_id", userId)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                transactions.Add(MapDataRowToTransaction(row))
            Next
        End If
        
        Return transactions
    End Function
    
    Public Function GetTransactionsByStatus(ByVal status As String) As List(Of Transaction)
        Dim transactions As New List(Of Transaction)()
        Dim query As String = "SELECT * FROM transactions WHERE status = @status ORDER BY transaction_date DESC"
        
        conn.AddParam("@status", status)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            For Each row As DataRow In conn.Data.Tables(0).Rows
                transactions.Add(MapDataRowToTransaction(row))
            Next
        End If
        
        Return transactions
    End Function
    
    Public Function CreateTransaction(ByVal transaction As Transaction) As Integer
        Dim query As String = "INSERT INTO transactions (payment_method, subtotal, total, discount, driver, user_id, total_amount, status, reference_number, sender_name, sender_number, transaction_date) " & _
                             "VALUES (@payment_method, @subtotal, @total, @discount, @driver, @user_id, @total_amount, @status, @reference_number, @sender_name, @sender_number, @transaction_date); " & _
                             "SELECT SCOPE_IDENTITY();"
        
        conn.AddParamWithNull("@payment_method", transaction.payment_method)
        conn.AddParamWithNull("@subtotal", transaction.subtotal)
        conn.AddParamWithNull("@total", transaction.total)
        conn.AddParamWithNull("@discount", transaction.discount)
        conn.AddParamWithNull("@driver", transaction.driver)
        conn.AddParam("@user_id", transaction.user_id)
        conn.AddParam("@total_amount", transaction.total_amount)
        conn.AddParam("@status", transaction.status)
        conn.AddParamWithNull("@reference_number", transaction.reference_number)
        conn.AddParamWithNull("@sender_name", transaction.sender_name)
        conn.AddParamWithNull("@sender_number", transaction.sender_number)
        conn.AddParam("@transaction_date", transaction.transaction_date)
        
        If conn.Query(query) AndAlso conn.DataCount > 0 Then
            Return Convert.ToInt32(conn.Data.Tables(0).Rows(0)(0))
        End If
        
        Return 0
    End Function
    
    Public Function UpdateTransactionStatus(ByVal transaction As Transaction) As Boolean
        Dim query As String = "UPDATE transactions SET status = @status"
        
        ' Add verification_date field if present
        If transaction.verification_date IsNot Nothing Then
            query &= ", verification_date = @verification_date"
        End If
        
        query &= " WHERE transaction_id = @transaction_id"
        
        conn.AddParam("@transaction_id", transaction.transaction_id)
        conn.AddParam("@status", transaction.status)
        
        If transaction.verification_date IsNot Nothing Then
            conn.AddParam("@verification_date", transaction.verification_date)
        End If
        
        Return conn.Query(query)
    End Function
    
    Public Function UpdateTransaction(ByVal transaction As Transaction) As Boolean
        Dim query As String = "UPDATE transactions " & _
                             "SET payment_method = @payment_method, " & _
                             "    subtotal = @subtotal, " & _
                             "    total = @total, " & _
                             "    discount = @discount, " & _
                             "    driver = @driver, " & _
                             "    user_id = @user_id, " & _
                             "    total_amount = @total_amount, " & _
                             "    status = @status, " & _
                             "    reference_number = @reference_number, " & _
                             "    sender_name = @sender_name, " & _
                             "    sender_number = @sender_number " & _
                             "WHERE transaction_id = @transaction_id"
        
        conn.AddParam("@transaction_id", transaction.transaction_id)
        conn.AddParamWithNull("@payment_method", transaction.payment_method)
        conn.AddParamWithNull("@subtotal", transaction.subtotal)
        conn.AddParamWithNull("@total", transaction.total)
        conn.AddParamWithNull("@discount", transaction.discount)
        conn.AddParamWithNull("@driver", transaction.driver)
        conn.AddParam("@user_id", transaction.user_id)
        conn.AddParam("@total_amount", transaction.total_amount)
        conn.AddParam("@status", transaction.status)
        conn.AddParamWithNull("@reference_number", transaction.reference_number)
        conn.AddParamWithNull("@sender_name", transaction.sender_name)
        conn.AddParamWithNull("@sender_number", transaction.sender_number)
        
        Return conn.Query(query)
    End Function
    
    Public Function DeleteTransaction(ByVal transactionId As Integer) As Boolean
        Dim query As String = "DELETE FROM transactions WHERE transaction_id = @transaction_id"
        
        conn.AddParam("@transaction_id", transactionId)
        
        Return conn.Query(query)
    End Function
    
    Private Function MapDataRowToTransaction(ByVal row As DataRow) As Transaction
        Dim transaction As New Transaction()
        
        transaction.transaction_id = Convert.ToInt32(row("transaction_id"))
        transaction.payment_method = If(row("payment_method") IsNot DBNull.Value, row("payment_method").ToString(), Nothing)
        transaction.subtotal = If(row("subtotal") IsNot DBNull.Value, row("subtotal").ToString(), Nothing)
        transaction.total = If(row("total") IsNot DBNull.Value, row("total").ToString(), Nothing)
        transaction.discount = If(row("discount") IsNot DBNull.Value, row("discount").ToString(), Nothing)
        transaction.driver = If(row("driver") IsNot DBNull.Value, row("driver").ToString(), Nothing)
        transaction.user_id = Convert.ToInt32(row("user_id"))
        transaction.total_amount = Convert.ToDecimal(row("total_amount"))
        transaction.status = row("status").ToString()
        transaction.reference_number = If(row("reference_number") IsNot DBNull.Value, row("reference_number").ToString(), Nothing)
        transaction.sender_name = If(row("sender_name") IsNot DBNull.Value, row("sender_name").ToString(), Nothing)
        transaction.sender_number = If(row("sender_number") IsNot DBNull.Value, row("sender_number").ToString(), Nothing)
        transaction.transaction_date = Convert.ToDateTime(row("transaction_date"))
        
        ' Map new properties with null checks
        transaction.delivery_fee = If(row.Table.Columns.Contains("delivery_fee") AndAlso row("delivery_fee") IsNot DBNull.Value, Convert.ToDecimal(row("delivery_fee")), 0)
        transaction.discount_id = If(row.Table.Columns.Contains("discount_id") AndAlso row("discount_id") IsNot DBNull.Value, Convert.ToInt32(row("discount_id")), Nothing)
        transaction.promotion_id = If(row.Table.Columns.Contains("promotion_id") AndAlso row("promotion_id") IsNot DBNull.Value, Convert.ToInt32(row("promotion_id")), Nothing)
        transaction.deal_id = If(row.Table.Columns.Contains("deal_id") AndAlso row("deal_id") IsNot DBNull.Value, Convert.ToInt32(row("deal_id")), Nothing)
        transaction.app_name = If(row.Table.Columns.Contains("app_name") AndAlso row("app_name") IsNot DBNull.Value, row("app_name").ToString(), Nothing)
        transaction.tracking_url = If(row.Table.Columns.Contains("tracking_url") AndAlso row("tracking_url") IsNot DBNull.Value, row("tracking_url").ToString(), Nothing)
        transaction.estimated_time = If(row.Table.Columns.Contains("estimated_time") AndAlso row("estimated_time") IsNot DBNull.Value, row("estimated_time").ToString(), Nothing)
        transaction.driver_name = If(row.Table.Columns.Contains("driver_name") AndAlso row("driver_name") IsNot DBNull.Value, row("driver_name").ToString(), Nothing)
        transaction.verification_date = If(row.Table.Columns.Contains("verification_date") AndAlso row("verification_date") IsNot DBNull.Value, Convert.ToDateTime(row("verification_date")), Nothing)
        
        Return transaction
    End Function
End Class 