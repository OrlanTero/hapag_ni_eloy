<%@ Page Language="VB" AutoEventWireup="true" CodeFile="PrintReceiptItems.aspx.vb" Inherits="Pages_Admin_PrintReceiptItems" %>

<%
    ' Check if we have an order ID
    Dim orderId As Integer = 0
    If Not String.IsNullOrEmpty(Request.QueryString("orderId")) Then
        Integer.TryParse(Request.QueryString("orderId"), orderId)
    End If
    
    ' Check if format is specified (json or html, default to html)
    Dim outputFormat As String = "html"
    If Not String.IsNullOrEmpty(Request.QueryString("format")) Then
        outputFormat = Request.QueryString("format").ToLower()
    End If
    
    ' Ensure proper content type based on format
    If outputFormat = "json" Then
        Response.ContentType = "application/json; charset=utf-8"
        ' Add cache control headers to prevent caching of JSON responses
        Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.Cache.SetNoStore()
    Else
        Response.ContentType = "text/html; charset=utf-8"
    End If
    
    If orderId > 0 Then
        ' Create a simple connection
        Dim Connection As New HapagDB.Connection()
        
        ' Get the order items
        Dim query As String = "SELECT oi.order_item_id, oi.item_id, oi.quantity, oi.price, " & _
                              "m.name " & _
                              "FROM order_items oi " & _
                              "INNER JOIN menu m ON oi.item_id = m.item_id " & _
                              "WHERE oi.order_id = @order_id"

        Connection.ClearParams()
        Connection.AddParam("@order_id", orderId)
        Dim success As Boolean = Connection.Query(query)
        
        If success AndAlso Connection.DataCount > 0 Then
            Dim dt As System.Data.DataTable = Connection.Data.Tables(0)
            
            ' If JSON format is requested, output JSON
            If outputFormat = "json" Then
                ' Create JSON array for items
                Dim jsonArray As New System.Text.StringBuilder()
                jsonArray.Append("[")
                
                For i As Integer = 0 To dt.Rows.Count - 1
                    Dim row As System.Data.DataRow = dt.Rows(i)
                    Dim itemName As String = row("name").ToString()
                    Dim quantity As Integer = Convert.ToInt32(row("quantity"))
                    Dim price As Decimal = Convert.ToDecimal(row("price"))
                    
                    ' Create JSON object for each item
                    jsonArray.Append("{")
                    jsonArray.Append("""name"":""" & itemName.Replace("""", "\""") & """,")
                    jsonArray.Append("""quantity"":" & quantity & ",")
                    jsonArray.Append("""price"":" & price.ToString("0.00", System.Globalization.CultureInfo.InvariantCulture))
                    jsonArray.Append("}")
                    
                    ' Add comma if not the last item
                    If i < dt.Rows.Count - 1 Then
                        jsonArray.Append(",")
                    End If
                Next
                
                jsonArray.Append("]")
                
                ' Write the JSON output directly without any additional formatting
                Response.Write(jsonArray.ToString())
            Else
                ' Default HTML output
                For Each row As System.Data.DataRow In dt.Rows
                    Dim itemName As String = row("name").ToString()
                    Dim quantity As Integer = Convert.ToInt32(row("quantity"))
                    Dim price As Decimal = Convert.ToDecimal(row("price"))
                    Dim subtotal As Decimal = price * quantity
                    
                    ' Output the item as a table row
                    Response.Write("<tr>")
                    Response.Write("<td>" & itemName & "</td>")
                    Response.Write("<td class='qty'>" & quantity & "</td>")
                    Response.Write("<td class='price'>" & String.Format("{0:0.00}", price) & "</td>")
                    Response.Write("<td class='amount'>" & String.Format("{0:0.00}", subtotal) & "</td>")
                    Response.Write("</tr>")
                Next
            End If
        Else
            If outputFormat = "json" Then
                ' Return empty array for JSON
                Response.Write("[]")
            Else
                ' Return message for HTML
                Response.Write("<tr><td colspan='4'>No items found</td></tr>")
            End If
        End If
    Else
        If outputFormat = "json" Then
            ' Return empty array for JSON with invalid order ID
            Response.Write("[]")
        Else
            ' Return message for HTML with invalid order ID
            Response.Write("<tr><td colspan='4'>Invalid order ID</td></tr>")
        End If
    End If
    
    ' Ensure response is complete and ends properly
    Response.Flush()
    Response.End()
%> 