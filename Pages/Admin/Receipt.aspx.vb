Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports HapagDB

Partial Class Pages_Admin_Receipt
    Inherits System.Web.UI.Page
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadReceiptData()
        End If
    End Sub
    
    Private Sub LoadReceiptData()
        Try
            ' Check if order ID is provided
            Dim orderId As Integer = 0
            If Not String.IsNullOrEmpty(Request.QueryString("orderId")) Then
                Integer.TryParse(Request.QueryString("orderId"), orderId)
            End If
            
            If orderId <= 0 Then
                DisplayErrorMessage("Invalid order ID provided.")
                Return
            End If
            
            ' Create database connection
            Dim Connection As New Connection()
            
            ' Get order details
            Dim orderQuery As String = "SELECT o.order_id, o.order_date, o.status, o.total_amount, " & _
                                      "COALESCE(c.first_name + ' ' + c.last_name, 'Guest') AS customer_name " & _
                                      "FROM orders o " & _
                                      "LEFT JOIN customers c ON o.customer_id = c.customer_id " & _
                                      "WHERE o.order_id = @order_id"
            
            Connection.ClearParams()
            Connection.AddParam("@order_id", orderId)
            Dim success As Boolean = Connection.Query(orderQuery)
            
            If success AndAlso Connection.DataCount > 0 Then
                Dim orderRow As DataRow = Connection.Data.Tables(0).Rows(0)
                
                ' Set order details
                OrderIdLiteral.Text = orderId.ToString()
                CustomerNameLiteral.Text = orderRow("customer_name").ToString()
                OrderDateLiteral.Text = Convert.ToDateTime(orderRow("order_date")).ToString("MMM dd, yyyy hh:mm tt")
                TotalAmountLiteral.Text = Convert.ToDecimal(orderRow("total_amount")).ToString("0.00")
                
                ' Get order items
                Dim itemsQuery As String = "SELECT oi.order_item_id, oi.item_id, oi.quantity, oi.price, " & _
                                          "m.name " & _
                                          "FROM order_items oi " & _
                                          "INNER JOIN menu m ON oi.item_id = m.item_id " & _
                                          "WHERE oi.order_id = @order_id"
                
                Connection.ClearParams()
                Connection.AddParam("@order_id", orderId)
                success = Connection.Query(itemsQuery)
                
                If success AndAlso Connection.DataCount > 0 Then
                    ' Bind items to repeater
                    ItemsRepeater.DataSource = Connection.Data.Tables(0)
                    ItemsRepeater.DataBind()
                Else
                    ' No items found
                    DisplayErrorMessage("No items found for this order.")
                End If
            Else
                ' Order not found
                DisplayErrorMessage("Order not found.")
            End If
        Catch ex As Exception
            ' Log error and display message
            System.Diagnostics.Debug.WriteLine("Error loading receipt data: " & ex.Message)
            DisplayErrorMessage("An error occurred while loading the receipt. Please try again.")
        End Try
    End Sub
    
    Private Sub DisplayErrorMessage(ByVal message As String)
        ' Clear existing controls
        ItemsRepeater.Visible = False
        
        ' Add error message
        Dim errorLiteral As New Literal()
        errorLiteral.Text = "<div style='color: red; text-align: center; padding: 20px;'>" & message & "</div>"
        form1.Controls.Add(errorLiteral)
    End Sub
End Class 