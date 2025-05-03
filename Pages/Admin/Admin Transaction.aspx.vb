Imports System.Data
Imports HapagDB

Partial Class Pages_Admin_Admin_Transaction
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

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

            Dim query = "INSERT INTO transactions (payment_method, subtotal, total, discount, driver, payment_status, created_at) " & _
                       "VALUES (@payment_method, @subtotal, @total, @discount, @driver, @payment_status, GETDATE())"

        Connect.AddParam("@payment_method", payment_method)
        Connect.AddParam("@subtotal", subtotal)
        Connect.AddParam("@total", total)
        Connect.AddParam("@discount", discount)
        Connect.AddParam("@driver", driver)
            Connect.AddParam("@payment_status", payment_status)

        Dim insert = Connect.Query(query)

        If insert Then
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
            Dim query = "SELECT t.*, " & _
                       "CASE WHEN t.payment_method = '1' THEN 'GCash' ELSE 'Cash' END as payment_method_display, " & _
                       "FORMAT(t.subtotal, 'N2') as formatted_subtotal, " & _
                       "FORMAT(t.total, 'N2') as formatted_total, " & _
                       "FORMAT(t.discount, 'N2') as formatted_discount " & _
                       "FROM transactions t " & _
                       "ORDER BY t.created_at DESC"

        Connect.Query(query)

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

        For Each row As DataRow In Connect.Data.Tables(0).Rows
            Dim tableRow As New TableRow()

                ' Payment Method
                tableRow.Cells.Add(New TableCell() With {.Text = row("payment_method_display").ToString()})
                
                ' Payment Status with color coding
                Dim statusCell As New TableCell()
                Dim statusText As String = row("payment_status").ToString()
                statusCell.Text = statusText
                statusCell.CssClass = If(statusText = "Paid", "status-paid", "status-pending")
                tableRow.Cells.Add(statusCell)
                
                ' Formatted amounts
                tableRow.Cells.Add(New TableCell() With {.Text = "PHP " & row("formatted_subtotal").ToString()})
                tableRow.Cells.Add(New TableCell() With {.Text = "PHP " & row("formatted_total").ToString()})
                tableRow.Cells.Add(New TableCell() With {.Text = "PHP " & row("formatted_discount").ToString()})
            tableRow.Cells.Add(New TableCell() With {.Text = row("driver").ToString()})
                tableRow.Cells.Add(New TableCell() With {.Text = Format(Convert.ToDateTime(row("created_at")), "MMM dd, yyyy hh:mm tt")})

                tableRow.Attributes.Add("data-user_id", row("transaction_id").ToString())
            Table1.Rows.Add(tableRow)
        Next
        Catch ex As Exception
            showAlert("Error loading transactions: " & ex.Message, "error")
        End Try
    End Sub

    Protected Sub EditBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles EditBtn.Click
        Try
            Dim transaction_id = UserIdTxt.Text
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

            Dim query = "UPDATE transactions SET " & _
                       "payment_method = @payment_method, " & _
                       "subtotal = @subtotal, " & _
                       "total = @total, " & _
                       "discount = @discount, " & _
                       "driver = @driver, " & _
                       "payment_status = @payment_status, " & _
                       "updated_at = GETDATE() " & _
                       "WHERE transaction_id = @transaction_id"

        Connect.AddParam("@payment_method", payment_method)
        Connect.AddParam("@subtotal", subtotal)
        Connect.AddParam("@total", total)
        Connect.AddParam("@discount", discount)
        Connect.AddParam("@driver", driver)
            Connect.AddParam("@payment_status", payment_status)
            Connect.AddParam("@transaction_id", transaction_id)

        Dim updateResult = Connect.Query(query)

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
        Dim user_id = UserIdTxt.Text

        Dim query = "DELETE FROM transactions WHERE user_id = @user_id"

        Connect.AddParam("@user_id", user_id)

        Dim deleteResult = Connect.Query(query)

        If deleteResult Then
            Dim script As String = "alert('Successfully Deleted!');"
            ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
        Else
            Dim script As String = "alert('Failed to Delete!');"
            ClientScript.RegisterStartupScript(Me.GetType(), "alertMessage", script, True)
        End If

        ViewTable()

        SubtotalTxt.Text = ""
        TotalTxt.Text = ""
        DiscountTxt.Text = ""

    End Sub

    Public Function HasSelectedRow() As Boolean
        Return UserIdTxt.Text.Length > 0
    End Function
End Class
