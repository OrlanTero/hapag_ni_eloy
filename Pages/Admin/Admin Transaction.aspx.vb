Imports System.Data
Imports HapagDB

Partial Class Pages_Admin_Admin_Transaction
    Inherits System.Web.UI.Page
    Private transactionController As New TransactionController()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ViewTable()
        End If
        
        ' Handle view transaction details if posted back from client-side
        If IsPostBack Then
            Dim eventTarget As String = Request("__EVENTTARGET")
            Dim eventArgument As String = Request("__EVENTARGUMENT")
            
            If eventTarget = "ViewTransactionDetails" AndAlso Not String.IsNullOrEmpty(eventArgument) Then
                ViewTransactionDetails(Convert.ToInt32(eventArgument))
            End If
        End If
    End Sub

    Public Sub ViewTable()
        Try
            ' Get all transactions using the controller
            Dim transactions = transactionController.GetAllTransactions()

            Table1.Rows.Clear()

            Dim headerRow As New TableHeaderRow
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Transaction ID"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Reference #"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Date"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Payment Method"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Customer"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Total Amount"})
            headerRow.Cells.Add(New TableHeaderCell() With {.Text = "Status"})
            Table1.Rows.Add(headerRow)

            For Each transaction In transactions
                Dim tableRow As New TableRow()

                ' Transaction ID
                tableRow.Cells.Add(New TableCell() With {.Text = transaction.transaction_id.ToString()})
                
                ' Reference Number
                tableRow.Cells.Add(New TableCell() With {.Text = If(transaction.reference_number IsNot Nothing, transaction.reference_number, "N/A")})
                
                ' Transaction Date
                Dim transactionDate As DateTime
                Dim dateDisplay As String = "N/A"
                If DateTime.TryParse(transaction.transaction_date.ToString(), transactionDate) Then
                    dateDisplay = Format(transactionDate, "MMM dd, yyyy hh:mm tt")
                End If
                tableRow.Cells.Add(New TableCell() With {.Text = dateDisplay})
                
                ' Payment Method
                Dim paymentMethodDisplay = "Unknown"
                Select Case transaction.payment_method
                    Case "1"
                        paymentMethodDisplay = "GCash"
                    Case "2"
                        paymentMethodDisplay = "Cash"
                    Case Else
                        paymentMethodDisplay = transaction.payment_method
                End Select
                tableRow.Cells.Add(New TableCell() With {.Text = paymentMethodDisplay})
                
                ' Customer info - get username from user_id if available
                Dim customerName As String = "Customer #" & transaction.user_id.ToString()
                tableRow.Cells.Add(New TableCell() With {.Text = customerName})
                
                ' Total Amount
                tableRow.Cells.Add(New TableCell() With {.Text = "PHP " & Format(If(Decimal.TryParse(transaction.total_amount.ToString(), 0), CDec(transaction.total_amount), 0), "N2")})
                
                ' Payment Status with color coding
                Dim statusCell As New TableCell()
                Dim statusText As String = If(transaction.status IsNot Nothing, transaction.status.ToString(), "Pending")
                statusCell.Text = statusText
                
                Select Case statusText.ToLower()
                    Case "paid"
                        statusCell.CssClass = "status-paid"
                    Case "canceled"
                        statusCell.CssClass = "status-canceled"
                    Case Else
                        statusCell.CssClass = "status-pending"
                End Select
                
                tableRow.Cells.Add(statusCell)

                tableRow.Attributes.Add("data-transaction_id", transaction.transaction_id.ToString())
                Table1.Rows.Add(tableRow)
            Next
        Catch ex As Exception
            ShowAlert("Error loading transactions: " & ex.Message, "error")
        End Try
    End Sub
    
    Protected Sub ViewTransactionDetails(ByVal transactionId As Integer)
        Try
            Dim transaction = transactionController.GetTransactionById(transactionId)
            
            If transaction Is Nothing Then
                ShowAlert("Transaction not found!", "error")
                transactionDetails.Visible = False
                Return
            End If
            
            ' Fill transaction details
            TransactionIdLiteral.Text = transaction.transaction_id.ToString()
            ReferenceNumberLiteral.Text = If(transaction.reference_number IsNot Nothing, transaction.reference_number, "N/A")
            
            ' Format transaction date
            Dim transactionDate As DateTime
            Dim dateDisplay As String = "N/A"
            If DateTime.TryParse(transaction.transaction_date.ToString(), transactionDate) Then
                dateDisplay = Format(transactionDate, "MMMM dd, yyyy hh:mm:ss tt")
            End If
            TransactionDateLiteral.Text = dateDisplay
            
            ' Payment method display
            Dim paymentMethodDisplay = "Unknown"
            Select Case transaction.payment_method
                Case "1"
                    paymentMethodDisplay = "GCash"
                Case "2"
                    paymentMethodDisplay = "Cash"
                Case Else
                    paymentMethodDisplay = transaction.payment_method
            End Select
            PaymentMethodLiteral.Text = paymentMethodDisplay
            
            ' Format amounts
            SubtotalLiteral.Text = "PHP " & Format(If(Decimal.TryParse(transaction.subtotal, 0), CDec(transaction.subtotal), 0), "N2")
            DiscountLiteral.Text = "PHP " & Format(If(Decimal.TryParse(transaction.discount, 0), CDec(transaction.discount), 0), "N2")
            DeliveryFeeLiteral.Text = "PHP " & Format(transaction.delivery_fee, "N2")
            TotalAmountLiteral.Text = "PHP " & Format(If(Decimal.TryParse(transaction.total_amount.ToString(), 0), CDec(transaction.total_amount), 0), "N2")
            
            ' Get customer info from user_id
            Dim customerName As String = "Customer #" & transaction.user_id.ToString()
            CustomerLiteral.Text = customerName
            
            ' Other details
            SenderNameLiteral.Text = If(transaction.sender_name IsNot Nothing, transaction.sender_name, "N/A")
            SenderNumberLiteral.Text = If(transaction.sender_number IsNot Nothing, transaction.sender_number, "N/A")
            DriverNameLiteral.Text = If(transaction.driver_name IsNot Nothing, transaction.driver_name, "N/A")
            TrackingUrlLiteral.Text = If(transaction.tracking_url IsNot Nothing, "<a href='" & transaction.tracking_url & "' target='_blank'>" & transaction.tracking_url & "</a>", "N/A")
            EstDeliveryLiteral.Text = If(transaction.estimated_time IsNot Nothing, transaction.estimated_time, "N/A")
            
            ' Status with styling
            Dim statusText As String = If(transaction.status IsNot Nothing, transaction.status.ToString(), "Pending")
            Dim statusClass As String = ""
            
            Select Case statusText.ToLower()
                Case "paid"
                    statusClass = "status-paid"
                Case "canceled"
                    statusClass = "status-canceled"
                Case Else
                    statusClass = "status-pending"
            End Select
            
            StatusLiteral.Text = "<span class='" & statusClass & "'>" & statusText & "</span>"
            
            ' Set selected value in dropdown
            For i As Integer = 0 To StatusDdl.Items.Count - 1
                If StatusDdl.Items(i).Text.Equals(statusText, StringComparison.OrdinalIgnoreCase) Then
                    StatusDdl.SelectedIndex = i
                    Exit For
                End If
            Next
            
            ' Store transaction ID in hidden field for update
            TransactionIdHidden.Value = transaction.transaction_id.ToString()
            
            ' Show transaction details panel
            transactionDetails.Visible = True
            
        Catch ex As Exception
            ShowAlert("Error loading transaction details: " & ex.Message, "error")
            transactionDetails.Visible = False
        End Try
    End Sub

    Protected Sub UpdateStatusBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles UpdateStatusBtn.Click
        Try
            Dim transactionId As Integer
            If Not Integer.TryParse(TransactionIdHidden.Value, transactionId) Then
                ShowAlert("Invalid transaction ID", "error")
                Return
            End If
            
            ' Get the transaction
            Dim transaction = transactionController.GetTransactionById(transactionId)
            
            If transaction Is Nothing Then
                ShowAlert("Transaction not found!", "error")
                Return
            End If
            
            ' Update status
            Dim newStatus As String = StatusDdl.SelectedValue
            
            ' Update transaction status
            transaction.status = newStatus
            
            ' For GCash transactions that are being marked as Paid, we can set verification_date
            If transaction.payment_method = "1" AndAlso newStatus.ToLower() = "paid" AndAlso transaction.verification_date Is Nothing Then
                transaction.verification_date = DateTime.Now
            End If
            
            ' Update the transaction
            Dim updateResult = transactionController.UpdateTransactionStatus(transaction)
            
            If updateResult Then
                ShowAlert("Transaction status successfully updated to " & newStatus & "!", "success")
                ViewTable() ' Refresh the table
                ViewTransactionDetails(transactionId) ' Reload details
            Else
                ShowAlert("Failed to update transaction status!", "error")
            End If
            
        Catch ex As Exception
            ShowAlert("Error updating transaction status: " & ex.Message, "error")
        End Try
    End Sub
    
    Private Sub ShowAlert(message As String, type As String)
        Try
            ' Use the master page's alert methods
            Dim masterPage As Pages_Admin_AdminTemplate = DirectCast(Me.Master, Pages_Admin_AdminTemplate)
            
            Select Case type.ToLower()
                Case "success"
                    masterPage.ShowAlert(message, True)
                Case "error", "danger"
                    masterPage.ShowAlert(message, False)
                Case "warning"
                    masterPage.ShowWarning(message)
                Case "info"
                    masterPage.ShowInfo(message)
                Case Else
                    masterPage.ShowInfo(message)
            End Select
        Catch ex As Exception
            ' Fallback to original method if master page method fails
            alertMessage.Visible = True
            
            Select Case type.ToLower()
                Case "success"
                    alertMessage.Attributes("class") = "alert-message alert-success"
                Case "error", "danger"
                    alertMessage.Attributes("class") = "alert-message alert-danger"
                Case "warning"
                    alertMessage.Attributes("class") = "alert-message alert-warning"
                Case "info"
                    alertMessage.Attributes("class") = "alert-message alert-info"
                Case Else
                    alertMessage.Attributes("class") = "alert-message alert-info"
            End Select
            
            AlertLiteral.Text = message
        End Try
    End Sub
End Class
