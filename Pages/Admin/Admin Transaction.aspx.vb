Imports System.Data
Imports HapagDB

Partial Class Pages_Admin_Admin_Transaction
    Inherits System.Web.UI.Page
    Private transactionController As New TransactionController()
    Private Connect As New Connection() ' Keeping for transition if needed

    Protected Sub AddBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddBtn.Click
        Try
            Dim payment_method = PaymentMethodDdl.SelectedValue
            Dim subtotal = If(String.IsNullOrEmpty(SubtotalTxt.Text), 0, Convert.ToDecimal(SubtotalTxt.Text))
            Dim total = If(String.IsNullOrEmpty(TotalTxt.Text), 0, Convert.ToDecimal(TotalTxt.Text))
            Dim discount = If(String.IsNullOrEmpty(DiscountTxt.Text), 0, Convert.ToDecimal(DiscountTxt.Text))
            Dim driver = DriverTxt.Text
            Dim payment_status = If(payment_method = "1", "Paid", "Pending") ' 1 is GCash, 2 is Cash

            ' Validate required fields
            If subtotal <= 0 OrElse total <= 0 Then
                showAlert("Subtotal and Total are required and must be greater than 0!", "warning")
                Return
            End If

            ' Create a new Transaction object
            Dim transaction As New Transaction()
            transaction.payment_method = payment_method
            transaction.subtotal = subtotal.ToString()
            transaction.total = total.ToString()
            transaction.discount = discount.ToString()
            transaction.driver = driver
            transaction.status = payment_status
            transaction.user_id = 1 ' Default user_id, modify as needed
            transaction.total_amount = total
            transaction.transaction_date = DateTime.Now

            ' Create the transaction using the controller
            Dim transactionId = transactionController.CreateTransaction(transaction)

            If transactionId > 0 Then
                showAlert("Transaction successfully added!", "success")
                ClearForm()
            Else
                showAlert("Failed to add transaction!", "error")
            End If

            ViewTable()
        Catch ex As Exception
            showAlert("Error: " & ex.Message, "error")
        End Try
    End Sub

    Private Sub ClearForm()
        SubtotalTxt.Text = ""
        TotalTxt.Text = ""
        DiscountTxt.Text = ""
        DriverTxt.Text = ""
        PaymentMethodDdl.SelectedIndex = 0
    End Sub

    Private Sub showAlert(message As String, type As String)
        Dim script As String = "showAlert('" & message & "', '" & type & "');"
        ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ViewTable()
    End Sub

    Public Sub ViewTable()
        Try
            ' Get all transactions using the controller
            Dim transactions = transactionController.GetAllTransactions()

            Table1.Rows.Clear()

            Dim headerRow As New TableHeaderRow
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Payment Method"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Payment Status"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Subtotal"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Total"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Discount"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Driver"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Date"})
            Table1.Rows.Add(headerRow)

            For Each transaction In transactions
                Dim tableRow As New TableRow()

                ' Payment Method
                Dim paymentMethodDisplay = If(transaction.payment_method = "1", "GCash", "Cash")
                tableRow.Cells.Add(New TableCell() With {.Text = paymentMethodDisplay})
                
                ' Payment Status with color coding
                Dim statusCell As New TableCell()
                Dim statusText As String = transaction.status
                statusCell.Text = statusText
                statusCell.CssClass = If(statusText = "Paid", "status-paid", "status-pending")
                tableRow.Cells.Add(statusCell)
                
                ' Formatted amounts
                tableRow.Cells.Add(New TableCell() With {.Text = "PHP " & Format(If(Decimal.TryParse(transaction.subtotal, 0), CDec(transaction.subtotal), 0), "N2")})
                tableRow.Cells.Add(New TableCell() With {.Text = "PHP " & Format(If(Decimal.TryParse(transaction.total, 0), CDec(transaction.total), 0), "N2")})
                tableRow.Cells.Add(New TableCell() With {.Text = "PHP " & Format(If(Decimal.TryParse(transaction.discount, 0), CDec(transaction.discount), 0), "N2")})
                tableRow.Cells.Add(New TableCell() With {.Text = transaction.driver})
                tableRow.Cells.Add(New TableCell() With {.Text = Format(transaction.transaction_date, "MMM dd, yyyy hh:mm tt")})

                tableRow.Attributes.Add("data-user_id", transaction.transaction_id.ToString())
                Table1.Rows.Add(tableRow)
            Next
        Catch ex As Exception
            showAlert("Error loading transactions: " & ex.Message, "error")
        End Try
    End Sub

    Protected Sub EditBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles EditBtn.Click
        Try
            Dim transactionId = UserIdTxt.Text
            If Not Integer.TryParse(transactionId, 0) Then
                showAlert("Invalid transaction ID", "error")
                Return
            End If
            
            Dim payment_method = PaymentMethodDdl.SelectedValue
            Dim subtotal = If(String.IsNullOrEmpty(SubtotalTxt.Text), 0, Convert.ToDecimal(SubtotalTxt.Text))
            Dim total = If(String.IsNullOrEmpty(TotalTxt.Text), 0, Convert.ToDecimal(TotalTxt.Text))
            Dim discount = If(String.IsNullOrEmpty(DiscountTxt.Text), 0, Convert.ToDecimal(DiscountTxt.Text))
            Dim driver = DriverTxt.Text
            Dim payment_status = If(payment_method = "1", "Paid", "Pending")

            ' Validate required fields
            If subtotal <= 0 OrElse total <= 0 Then
                showAlert("Subtotal and Total are required and must be greater than 0!", "warning")
                Return
            End If

            ' Validate total amount
            If total < (subtotal - discount) Then
                showAlert("Total amount cannot be less than (Subtotal - Discount)!", "warning")
                Return
            End If

            ' Get the existing transaction
            Dim transaction = transactionController.GetTransactionById(Integer.Parse(transactionId))
            
            If transaction Is Nothing Then
                showAlert("Transaction not found!", "error")
                Return
            End If
            
            ' Update transaction properties
            transaction.payment_method = payment_method
            transaction.subtotal = subtotal.ToString()
            transaction.total = total.ToString()
            transaction.discount = discount.ToString()
            transaction.driver = driver
            transaction.status = payment_status
            
            ' Update the transaction using the controller
            Dim updateResult = transactionController.UpdateTransaction(transaction)

            If updateResult Then
                showAlert("Transaction successfully updated!", "success")
                ClearForm()
            Else
                showAlert("Failed to update transaction!", "error")
            End If

            ViewTable()
        Catch ex As Exception
            showAlert("Error updating transaction: " & ex.Message, "error")
        End Try
    End Sub

    Protected Sub RemoveBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RemoveBtn.Click
        Try
            Dim transactionId = UserIdTxt.Text
            
            If Not Integer.TryParse(transactionId, 0) Then
                showAlert("Invalid transaction ID", "error")
                Return
            End If
            
            ' Use the TransactionController to delete the transaction
            Dim deleteResult = transactionController.DeleteTransaction(Integer.Parse(transactionId))

            If deleteResult Then
                showAlert("Transaction successfully deleted!", "success")
                ClearForm()
            Else
                showAlert("Failed to delete transaction!", "error")
            End If

            ViewTable()
        Catch ex As Exception
            showAlert("Error deleting transaction: " & ex.Message, "error")
        End Try
    End Sub

    Public Function HasSelectedRow() As Boolean
        Return UserIdTxt.Text.Length > 0
    End Function
End Class
