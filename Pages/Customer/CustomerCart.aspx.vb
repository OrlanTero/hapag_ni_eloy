Imports System.Data
Imports System.Web.Services
Imports System.Web.Script.Serialization
Imports System.Data.SqlClient
Imports Newtonsoft.Json
Imports HapagDB

' Define the Discount class
Public Class Discount
    Public Property DiscountId As Integer
    Public Property Name As String
    Public Property DiscountType As Integer
    Public Property Value As Decimal
    Public Property Description As String

    Public Sub New(id As Integer, name As String, type As Integer, value As Decimal, description As String)
        DiscountId = id
        Name = name
        DiscountType = type
        Value = value
        Description = description
    End Sub
End Class

' Define the Promotion class
Public Class Promotion
    Public Property PromotionId As Integer
    Public Property Name As String
    Public Property PromotionType As Integer
    Public Property Value As Decimal
    Public Property Description As String

    Public Sub New(id As Integer, name As String, type As Integer, value As Decimal, description As String)
        PromotionId = id
        Name = name
        PromotionType = type
        Value = value
        Description = description
    End Sub
End Class

' Define the Deal class
Public Class Deal
    Public Property DealId As Integer
    Public Property Name As String
    Public Property DealType As Integer
    Public Property Value As Decimal
    Public Property Description As String

    Public Sub New(id As Integer, name As String, type As Integer, value As Decimal, description As String)
        DealId = id
        Name = name
        DealType = type
        Value = value
        Description = description
    End Sub
End Class

Partial Class Pages_Customer_CustomerCart
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not IsPostBack Then
                ' Check if user is logged in
                If Session("CURRENT_SESSION") Is Nothing Then
                    Response.Redirect("~/Pages/LoginPortal/CustomerLoginPortal.aspx")
                End If

                ' Initialize hidden fields and panels
                DeliveryOptionsPanel.Visible = False
                NewAddressPanel.Visible = False

                ' Load cart items
                LoadCartItems()
                
                ' Load available discounts, promotions, and deals
                LoadAvailableDiscounts()
                LoadAvailablePromotions()
                LoadAvailableDeals()
                
                ' Apply selected options
                ApplySelectedDiscount()
                ApplySelectedPromotion()
                ApplySelectedDeal()
                
                ' Update the order summary
                UpdateOrderSummary()
            End If
        Catch ex As Exception
            ' Log the error but continue
            System.Diagnostics.Debug.WriteLine("Error on Page_Load: " & ex.Message)
        End Try
    End Sub

    Private Sub UpdateOrderSummary()
        Try
            ' Get the subtotal from cart items
            Dim subtotal As Decimal = GetCartTotal()
            
            ' Debug info
            System.Diagnostics.Debug.WriteLine("Starting calculation with subtotal: " + Format(subtotal, "0.00"))
            
            ' Set the values in the UI
            CartSummarySubtotalLiteral.Text = Format(subtotal, "0.00")
            CartSummaryItemsLiteral.Text = GetTotalItems().ToString()
            
            ' Initialize total savings and amounts for each type of discount
            Dim totalSavings As Decimal = 0
            Dim discountAmount As Decimal = 0
            Dim promotionAmount As Decimal = 0
            Dim dealAmount As Decimal = 0
            
            ' Calculate discount amount if applicable
            If Session("SelectedDiscountId") IsNot Nothing Then
                Dim discountId As Integer = Convert.ToInt32(Session("SelectedDiscountId"))
                If discountId > 0 Then
                    ' Get discount details from database
                    Dim query As String = "SELECT discount_type, value FROM discounts WHERE discount_id = @discount_id"
                    Connect.ClearParams()
                    Connect.AddParam("@discount_id", discountId)
                    Connect.Query(query)
                    
                    If Connect.DataCount > 0 Then
                        Dim discountType As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)("discount_type"))
                        Dim discountValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                        
                        ' Calculate discount amount
                        If discountType = 1 Then ' Percentage discount
                            discountAmount = Math.Round((subtotal * discountValue) / 100, 2)
                            System.Diagnostics.Debug.WriteLine("Applied percentage discount: " & discountValue & "% = " & discountAmount)
                        Else ' Fixed amount discount
                            discountAmount = Math.Min(discountValue, subtotal)
                            System.Diagnostics.Debug.WriteLine("Applied fixed discount: " & discountAmount)
                        End If
                        
                        DiscountRow.Visible = True
                        DiscountAmountLiteral.Text = Format(discountAmount, "0.00")
                        totalSavings += discountAmount
                    End If
                Else
                    DiscountRow.Visible = False
                End If
            Else
                DiscountRow.Visible = False
            End If
            
            ' Calculate promotion amount if applicable
            If Session("SelectedPromotionId") IsNot Nothing Then
                Dim promotionId As Integer = Convert.ToInt32(Session("SelectedPromotionId"))
                If promotionId > 0 Then
                    ' Get promotion details from database
                    Dim query As String = "SELECT value, value_type FROM promotions WHERE promotion_id = @promotion_id"
                    Connect.ClearParams()
                    Connect.AddParam("@promotion_id", promotionId)
                    Connect.Query(query)
                    
                    If Connect.DataCount > 0 Then
                        Dim promotionValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                        Dim valueType As String = Connect.Data.Tables(0).Rows(0)("value_type").ToString()
                        Dim promotionType As Integer = IIf(valueType.Equals("percent", StringComparison.OrdinalIgnoreCase), 1, 2)
                        
                        ' Calculate promotion amount
                        If promotionType = 1 Then ' Percentage promotion
                            promotionAmount = Math.Round((subtotal * promotionValue) / 100, 2)
                            System.Diagnostics.Debug.WriteLine("Applied percentage promotion: " & promotionValue & "% = " & promotionAmount)
                        Else ' Fixed amount promotion
                            promotionAmount = Math.Min(promotionValue, subtotal)
                            System.Diagnostics.Debug.WriteLine("Applied fixed promotion: " & promotionAmount)
                        End If
                        
                        PromotionRow.Visible = True
                        PromotionAmountLiteral.Text = Format(promotionAmount, "0.00")
                        totalSavings += promotionAmount
                    End If
                Else
                    PromotionRow.Visible = False
                End If
            Else
                PromotionRow.Visible = False
            End If
            
            ' Calculate deal amount if applicable
            If Session("SelectedDealId") IsNot Nothing Then
                Dim dealId As Integer = Convert.ToInt32(Session("SelectedDealId"))
                If dealId > 0 Then
                    ' Get deal details from database
                    Dim query As String = "SELECT value, value_type FROM deals WHERE deals_id = @deal_id"
                    Connect.ClearParams()
                    Connect.AddParam("@deal_id", dealId)
                    Connect.Query(query)
                    
                    If Connect.DataCount > 0 Then
                        Dim dealValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                        Dim valueType As String = Connect.Data.Tables(0).Rows(0)("value_type").ToString()
                        Dim dealType As Integer = IIf(valueType.Equals("percent", StringComparison.OrdinalIgnoreCase), 1, 2)
                        
                        ' Calculate deal amount
                        If dealType = 1 Then ' Percentage deal
                            dealAmount = Math.Round((subtotal * dealValue) / 100, 2)
                            System.Diagnostics.Debug.WriteLine("Applied percentage deal: " & dealValue & "% = " & dealAmount)
                        Else ' Fixed amount deal
                            dealAmount = Math.Min(dealValue, subtotal)
                            System.Diagnostics.Debug.WriteLine("Applied fixed deal: " & dealAmount)
                        End If
                        
                        DealRow.Visible = True
                        DealAmountLiteral.Text = Format(dealAmount, "0.00")
                        totalSavings += dealAmount
                    End If
                Else
                    DealRow.Visible = False
                End If
            Else
                DealRow.Visible = False
            End If
            
            ' Update total savings row if there are any savings
            If totalSavings > 0 Then
                TotalSavingsRow.Visible = True
                TotalSavingsLiteral.Text = Format(totalSavings, "0.00")
                System.Diagnostics.Debug.WriteLine("Total savings: " & totalSavings)
            Else
                TotalSavingsRow.Visible = False
            End If
            
            ' Calculate and display grand total
            Dim grandTotal As Decimal = subtotal - totalSavings
            
            ' Add delivery fee
            Dim deliveryFee As Decimal = 0
            If Not String.IsNullOrEmpty(DeliveryFeeHidden.Value) Then
                deliveryFee = Convert.ToDecimal(DeliveryFeeHidden.Value)
            End If
            grandTotal += deliveryFee
            
            System.Diagnostics.Debug.WriteLine("Grand total calculation: " & subtotal & " - " & totalSavings & " + " & deliveryFee & " = " & grandTotal)
            CartSummaryTotalLiteral.Text = Format(grandTotal, "0.00")
            
        Catch ex As Exception
            ShowAlert("Error updating order summary: " & ex.Message, False)
            System.Diagnostics.Debug.WriteLine("Error in UpdateOrderSummary: " & ex.Message & " " & ex.StackTrace)
        End Try
    End Sub

    Private Sub LoadAvailableDiscounts()
        Try
            ' Clear any existing items
            DiscountDropDown.Items.Clear()
            ' Add the default option
            DiscountDropDown.Items.Add(New ListItem("-- Select a Discount --", "0"))
            
            ' Get the cart total to check against min_order_amount
            Dim cartTotal As Decimal = GetCartTotal()
            
            ' Get active discounts where current date is between start_date and end_date
            ' and min_order_amount is met by the cart total
            Dim query As String = "SELECT discount_id, name, discount_type, value, description " & _
                                 "FROM discounts " & _
                                 "WHERE status = 1 " & _
                                 "AND GETDATE() BETWEEN start_date AND end_date " & _
                                 "AND (min_order_amount IS NULL OR min_order_amount <= @cart_total) " & _
                                 "ORDER BY value DESC"
            
            Connect.ClearParams()
            Connect.AddParam("@cart_total", cartTotal)
            Connect.Query(query)
            
            If Connect.DataCount > 0 Then
                For Each row As DataRow In Connect.Data.Tables(0).Rows
                    Dim discountId As Integer = Convert.ToInt32(row("discount_id"))
                    Dim discountName As String = row("name").ToString()
                    Dim discountType As Integer = Convert.ToInt32(row("discount_type"))
                    Dim discountValue As Decimal = Convert.ToDecimal(row("value"))
                    
                    ' Format the display text
                    Dim displayText As String = discountName
                    If discountType = 1 Then ' Percentage discount
                        displayText &= " (" & discountValue & "%)"
                    Else ' Fixed amount discount
                        displayText &= " (PHP " & Format(discountValue, "0.00") & ")"
                    End If
                    
                    DiscountDropDown.Items.Add(New ListItem(displayText, discountId.ToString()))
                Next
            End If
            
            ' Restore selected discount if it exists in the session
            If Session("SelectedDiscountId") IsNot Nothing Then
                Dim selectedDiscountId As String = Session("SelectedDiscountId").ToString()
                Dim foundItem As ListItem = DiscountDropDown.Items.FindByValue(selectedDiscountId)
                If foundItem IsNot Nothing Then
                    foundItem.Selected = True
                    DiscountIdHidden.Value = selectedDiscountId
                End If
            End If
            
        Catch ex As Exception
            ShowAlert("Error loading discounts: " & ex.Message, False)
        End Try
    End Sub
    
    Protected Sub DiscountDropDown_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim selectedDiscountId As Integer = Convert.ToInt32(DiscountDropDown.SelectedValue)
            
            If selectedDiscountId > 0 Then
                ' Store the selected discount in the session
                Session("SelectedDiscountId") = selectedDiscountId
                DiscountIdHidden.Value = selectedDiscountId.ToString()
                
                ' Apply the selected discount
                ApplySelectedDiscount()
            Else
                ' No discount selected
                Session("SelectedDiscountId") = Nothing
                DiscountIdHidden.Value = "0"
                DiscountInfo.Visible = False
            End If
            
            UpdateOrderSummary()
            
        Catch ex As Exception
            ShowAlert("Error applying discount: " & ex.Message, False)
        End Try
    End Sub
    
    Private Sub ApplySelectedDiscount()
        Try
            ' Check if a discount is selected
            If Session("SelectedDiscountId") IsNot Nothing Then
                Dim discountId As Integer = Convert.ToInt32(Session("SelectedDiscountId"))
                
                If discountId > 0 Then
                    ' Get the discount details
                    Dim query As String = "SELECT name, discount_type, value, description " & _
                                         "FROM discounts " & _
                                         "WHERE discount_id = @discount_id"
                    
                    Connect.ClearParams()
                    Connect.AddParam("@discount_id", discountId)
                    Connect.Query(query)
                    
                    If Connect.DataCount > 0 Then
                        Dim discountName As String = Connect.Data.Tables(0).Rows(0)("name").ToString()
                        Dim discountType As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)("discount_type"))
                        Dim discountValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                        Dim discountDescription As String = Connect.Data.Tables(0).Rows(0)("description").ToString()
                        
                        ' Set the discount information
                        DiscountNameLiteral.Text = discountName
                        DiscountDescriptionLiteral.Text = discountDescription
                        
                        ' Format the discount value display
                        If discountType = 1 Then ' Percentage discount
                            DiscountValueLiteral.Text = discountValue & "% off the subtotal"
                        Else ' Fixed amount discount
                            DiscountValueLiteral.Text = "PHP " & Format(discountValue, "0.00") & " off the subtotal"
                        End If
                        
                        ' Show the discount info section
                        DiscountInfo.Visible = True
                        
                        ' Store the discount details
                        DiscountIdHidden.Value = discountId.ToString()
                        
                        ' Store the discount in the session
                        Session("SelectedDiscount") = New Discount(discountId, discountName, discountType, discountValue, discountDescription)
                        
                        Return
                    End If
                End If
            End If
            
            ' If we get here, no valid discount was found
            DiscountInfo.Visible = False
            DiscountIdHidden.Value = "0"
            
        Catch ex As Exception
            ShowAlert("Error applying discount: " & ex.Message, False)
        End Try
    End Sub
    
    Private Function GetAppliedDiscountAmount(ByVal subtotal As Decimal) As Decimal
        Try
            ' Check if a discount is selected
            If Session("SelectedDiscountId") IsNot Nothing Then
                Dim discountId As Integer = Convert.ToInt32(Session("SelectedDiscountId"))
                
                If discountId > 0 Then
                    ' Get the discount details
                    Dim query As String = "SELECT discount_type, value " & _
                                         "FROM discounts " & _
                                         "WHERE discount_id = @discount_id"
                    
                    Connect.ClearParams()
                    Connect.AddParam("@discount_id", discountId)
                    Connect.Query(query)
                    
                    If Connect.DataCount > 0 Then
                        Dim discountType As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)("discount_type"))
                        Dim discountValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                        
                        ' Calculate the discount amount
                        If discountType = 1 Then ' Percentage discount
                            Return Math.Round((subtotal * discountValue) / 100, 2)
                        Else ' Fixed amount discount
                            Return Math.Min(discountValue, subtotal) ' Ensure discount doesn't exceed subtotal
                        End If
                    End If
                End If
            End If
            
            ' No valid discount
            Return 0
            
        Catch ex As Exception
            ' Log the error but don't interrupt the user experience
            System.Diagnostics.Debug.WriteLine("Error calculating discount: " & ex.Message)
            Return 0
        End Try
    End Function

    Private Sub LoadAvailablePromotions()
        Try
            ' Clear any existing items
            PromotionDropDown.Items.Clear()
            ' Add the default option
            PromotionDropDown.Items.Add(New ListItem("-- Select a Promotion --", "0"))
            
            ' Get the cart total to check against min_order_amount if needed
            Dim cartTotal As Decimal = GetCartTotal()
            
            ' Get active promotions where current date is between start_date and end_date
            Dim query As String = "SELECT promotion_id, name, value, value_type, description, valid_until " & _
                                 "FROM promotions " & _
                                 "WHERE GETDATE() BETWEEN start_date AND valid_until " & _
                                 "ORDER BY value DESC"
            
            Connect.ClearParams()
            Connect.Query(query)
            
            If Connect.DataCount > 0 Then
                For Each row As DataRow In Connect.Data.Tables(0).Rows
                    Dim promotionId As Integer = Convert.ToInt32(row("promotion_id"))
                    Dim promotionName As String = row("name").ToString()
                    Dim promotionValue As Decimal = Convert.ToDecimal(row("value"))
                    Dim promotionType As Integer = IIf(row("value_type").ToString().Equals("percent", StringComparison.OrdinalIgnoreCase), 1, 2)
                    
                    ' Format the display text
                    Dim displayText As String = promotionName
                    If promotionType = 1 Then ' Percentage discount
                        displayText &= " (" & promotionValue & "%)"
                    Else ' Fixed amount discount
                        displayText &= " (PHP " & Format(promotionValue, "0.00") & ")"
                    End If
                    
                    PromotionDropDown.Items.Add(New ListItem(displayText, promotionId.ToString()))
                Next
            End If
            
            ' Restore selected promotion if it exists in the session
            If Session("SelectedPromotionId") IsNot Nothing Then
                Dim selectedPromotionId As String = Session("SelectedPromotionId").ToString()
                Dim foundItem As ListItem = PromotionDropDown.Items.FindByValue(selectedPromotionId)
                If foundItem IsNot Nothing Then
                    foundItem.Selected = True
                    PromotionIdHidden.Value = selectedPromotionId
                End If
            End If
            
        Catch ex As Exception
            ShowAlert("Error loading promotions: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub PromotionDropDown_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim selectedPromotionId As Integer = Convert.ToInt32(PromotionDropDown.SelectedValue)
            
            ' Debug info
            System.Diagnostics.Debug.WriteLine("Selected promotion ID: " & selectedPromotionId)
            
            If selectedPromotionId > 0 Then
                ' Store the selected promotion ID in the session
                Session("SelectedPromotionId") = selectedPromotionId
                PromotionIdHidden.Value = selectedPromotionId.ToString()
                
                ' Apply the selected promotion
                ApplySelectedPromotion()
                
                ' Force update of the promotion amount in the UI
                Dim selectedPromotion As Promotion = TryCast(Session("SelectedPromotion"), Promotion)
                If selectedPromotion IsNot Nothing Then
                    Dim subtotal As Decimal = GetCartTotal()
                    Dim promotionAmount As Decimal = 0
                    
                    If selectedPromotion.PromotionType = 1 Then ' Percentage promotion
                        promotionAmount = Math.Round((subtotal * selectedPromotion.Value) / 100, 2)
                    Else ' Fixed amount promotion
                        promotionAmount = Math.Min(selectedPromotion.Value, subtotal)
                    End If
                    
                    PromotionRow.Visible = True
                    PromotionAmountLiteral.Text = Format(promotionAmount, "0.00")
                    PromotionInfo.Visible = True
                    
                    System.Diagnostics.Debug.WriteLine("Applied promotion: " & selectedPromotion.Name & ", Amount: " & promotionAmount)
                End If
            Else
                ' No promotion selected
                Session("SelectedPromotionId") = Nothing
                Session("SelectedPromotion") = Nothing
                PromotionIdHidden.Value = "0"
                PromotionInfo.Visible = False
                PromotionRow.Visible = False
            End If
            
            ' Update order summary with all applied discounts/promotions/deals
            UpdateOrderSummary()
            
        Catch ex As Exception
            ShowAlert("Error applying promotion: " & ex.Message, False)
        End Try
    End Sub
    
    Private Sub ApplySelectedPromotion()
        Try
            ' Check if a promotion is selected
            If Session("SelectedPromotionId") IsNot Nothing Then
                Dim promotionId As Integer = Convert.ToInt32(Session("SelectedPromotionId"))
                
                If promotionId > 0 Then
                    ' Get the promotion details
                    Dim query As String = "SELECT name, value, value_type, description " & _
                                         "FROM promotions " & _
                                         "WHERE promotion_id = @promotion_id"
            
            Connect.ClearParams()
                    Connect.AddParam("@promotion_id", promotionId)
            Connect.Query(query)
            
            If Connect.DataCount > 0 Then
                        Dim promotionName As String = Connect.Data.Tables(0).Rows(0)("name").ToString()
                        Dim promotionValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                        Dim valueType As String = Connect.Data.Tables(0).Rows(0)("value_type").ToString()
                        Dim promotionType As Integer = IIf(valueType.Equals("percent", StringComparison.OrdinalIgnoreCase), 1, 2)
                        Dim promotionDescription As String = Connect.Data.Tables(0).Rows(0)("description").ToString()
                        
                        ' Set the promotion information
                        PromotionNameLiteral.Text = promotionName
                        PromotionDescriptionLiteral.Text = promotionDescription
                        
                        ' Format the promotion value display
                        If promotionType = 1 Then ' Percentage discount
                            PromotionValueLiteral.Text = promotionValue & "% off the subtotal"
                        Else ' Fixed amount discount
                            PromotionValueLiteral.Text = "PHP " & Format(promotionValue, "0.00") & " off the subtotal"
            End If
                        
                        ' Show the promotion info section
                        PromotionInfo.Visible = True
                        
                        ' Store the promotion details
                        PromotionIdHidden.Value = promotionId.ToString()
                        
                        ' Store the promotion in the session
                        Session("SelectedPromotion") = New Promotion(promotionId, promotionName, promotionType, promotionValue, promotionDescription)
                        
                        Return
                    End If
                End If
            End If
            
            ' If we get here, no valid promotion was found
            PromotionInfo.Visible = False
            PromotionIdHidden.Value = "0"
            
        Catch ex As Exception
            ShowAlert("Error applying promotion: " & ex.Message, False)
        End Try
    End Sub

    Private Function GetAppliedPromotionAmount(ByVal subtotal As Decimal) As Decimal
        Try
            ' Check if a promotion is selected
            If Session("SelectedPromotionId") IsNot Nothing Then
                Dim promotionId As Integer = Convert.ToInt32(Session("SelectedPromotionId"))
                
                If promotionId > 0 Then
                    ' Get the promotion details
                    Dim query As String = "SELECT value, value_type " & _
                                 "FROM promotions " & _
                                         "WHERE promotion_id = @promotion_id"
            
            Connect.ClearParams()
                    Connect.AddParam("@promotion_id", promotionId)
            Connect.Query(query)
            
            If Connect.DataCount > 0 Then
                Dim promotionValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                        Dim valueType As String = Connect.Data.Tables(0).Rows(0)("value_type").ToString()
                        Dim promotionType As Integer = IIf(valueType.Equals("percent", StringComparison.OrdinalIgnoreCase), 1, 2)
                
                        ' Calculate the promotion amount
                If promotionType = 1 Then ' Percentage promotion
                    Return Math.Round((subtotal * promotionValue) / 100, 2)
                Else ' Fixed amount promotion
                    Return Math.Min(promotionValue, subtotal) ' Ensure promotion doesn't exceed subtotal
                        End If
                    End If
                End If
            End If
            
            ' No valid promotion
            Return 0
            
        Catch ex As Exception
            ' Log the error but don't interrupt the user experience
            System.Diagnostics.Debug.WriteLine("Error calculating promotion: " & ex.Message)
            Return 0
        End Try
    End Function

    Private Sub LoadAvailableDeals()
        Try
            ' Clear any existing items
            DealDropDown.Items.Clear()
            ' Add the default option
            DealDropDown.Items.Add(New ListItem("-- Select a Deal --", "0"))
            
            ' Get the cart total to check against min_order_amount if needed
            Dim cartTotal As Decimal = GetCartTotal()
            
            ' Get active deals where current date is between start_date and end_date
            Dim query As String = "SELECT deals_id, name, value, value_type, description, valid_until " & _
                                 "FROM deals " & _
                                 "WHERE GETDATE() BETWEEN start_date AND valid_until " & _
                                 "ORDER BY value DESC"
            
            Connect.ClearParams()
            Connect.Query(query)
            
            If Connect.DataCount > 0 Then
                For Each row As DataRow In Connect.Data.Tables(0).Rows
                    Dim dealId As Integer = Convert.ToInt32(row("deals_id"))
                    Dim dealName As String = row("name").ToString()
                    Dim dealValue As Decimal = Convert.ToDecimal(row("value"))
                    Dim dealType As Integer = IIf(row("value_type").ToString().Equals("percent", StringComparison.OrdinalIgnoreCase), 1, 2)
                    
                    ' Format the display text
                    Dim displayText As String = dealName
                    If dealType = 1 Then ' Percentage discount
                        displayText &= " (" & dealValue & "%)"
                    Else ' Fixed amount discount
                        displayText &= " (PHP " & Format(dealValue, "0.00") & ")"
                    End If
                    
                    DealDropDown.Items.Add(New ListItem(displayText, dealId.ToString()))
                Next
            End If
            
            ' Restore selected deal if it exists in the session
            If Session("SelectedDealId") IsNot Nothing Then
                Dim selectedDealId As String = Session("SelectedDealId").ToString()
                Dim foundItem As ListItem = DealDropDown.Items.FindByValue(selectedDealId)
                If foundItem IsNot Nothing Then
                    foundItem.Selected = True
                    DealIdHidden.Value = selectedDealId
                End If
            End If
            
        Catch ex As Exception
            ShowAlert("Error loading deals: " & ex.Message, False)
        End Try
    End Sub
    
    Protected Sub DealDropDown_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim selectedDealId As Integer = Convert.ToInt32(DealDropDown.SelectedValue)
            
            If selectedDealId > 0 Then
                ' Store the selected deal in the session
                Session("SelectedDealId") = selectedDealId
                DealIdHidden.Value = selectedDealId.ToString()
                
                ' Apply the selected deal
                ApplySelectedDeal()
            Else
                ' No deal selected
                Session("SelectedDealId") = Nothing
                DealIdHidden.Value = "0"
                DealInfo.Visible = False
            End If
            
            UpdateOrderSummary()
            
        Catch ex As Exception
            ShowAlert("Error applying deal: " & ex.Message, False)
        End Try
    End Sub
    
    Private Sub ApplySelectedDeal()
        Try
            ' Check if a deal is selected
            If Session("SelectedDealId") IsNot Nothing Then
                Dim dealId As Integer = Convert.ToInt32(Session("SelectedDealId"))
                
                If dealId > 0 Then
                    ' Get the deal details
                    Dim query As String = "SELECT name, value, value_type, description " & _
                                         "FROM deals " & _
                                         "WHERE deals_id = @deal_id"
                    
                    Connect.ClearParams()
                    Connect.AddParam("@deal_id", dealId)
                    Connect.Query(query)
                    
                    If Connect.DataCount > 0 Then
                        Dim dealName As String = Connect.Data.Tables(0).Rows(0)("name").ToString()
                Dim dealValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                        Dim valueType As String = Connect.Data.Tables(0).Rows(0)("value_type").ToString()
                        Dim dealType As Integer = IIf(valueType.Equals("percent", StringComparison.OrdinalIgnoreCase), 1, 2)
                        Dim dealDescription As String = Connect.Data.Tables(0).Rows(0)("description").ToString()
                        
                        ' Set the deal information
                        DealNameLiteral.Text = dealName
                        DealDescriptionLiteral.Text = dealDescription
                        
                        ' Format the deal value display
                        If dealType = 1 Then ' Percentage discount
                            DealValueLiteral.Text = dealValue & "% off the subtotal"
                        Else ' Fixed amount discount
                            DealValueLiteral.Text = "PHP " & Format(dealValue, "0.00") & " off the subtotal"
                        End If
                        
                        ' Show the deal info section
                        DealInfo.Visible = True
                        
                        ' Store the deal details
                        DealIdHidden.Value = dealId.ToString()
                        
                        ' Store the deal in the session
                        Session("SelectedDeal") = New Deal(dealId, dealName, dealType, dealValue, dealDescription)
                        
                        Return
                    End If
                End If
            End If
            
            ' If we get here, no valid deal was found
            DealInfo.Visible = False
            DealIdHidden.Value = "0"
            
        Catch ex As Exception
            ShowAlert("Error applying deal: " & ex.Message, False)
        End Try
    End Sub
    
    Private Function GetAppliedDealAmount(ByVal subtotal As Decimal) As Decimal
        Try
            ' Check if a deal is selected
            If Session("SelectedDealId") IsNot Nothing Then
                Dim dealId As Integer = Convert.ToInt32(Session("SelectedDealId"))
                
                If dealId > 0 Then
                    ' Get the deal details
                    Dim query As String = "SELECT value, value_type " & _
                                         "FROM deals " & _
                                         "WHERE deals_id = @deal_id"
                    
                    Connect.ClearParams()
                    Connect.AddParam("@deal_id", dealId)
                    Connect.Query(query)
                    
                    If Connect.DataCount > 0 Then
                        Dim dealValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                        Dim valueType As String = Connect.Data.Tables(0).Rows(0)("value_type").ToString()
                        Dim dealType As Integer = IIf(valueType.Equals("percent", StringComparison.OrdinalIgnoreCase), 1, 2)
                        
                        ' Calculate the deal amount
                If dealType = 1 Then ' Percentage deal
                    Return Math.Round((subtotal * dealValue) / 100, 2)
                Else ' Fixed amount deal
                    Return Math.Min(dealValue, subtotal) ' Ensure deal doesn't exceed subtotal
                        End If
                    End If
                End If
            End If
            
            ' No valid deal
            Return 0
            
        Catch ex As Exception
            ' Log the error but don't interrupt the user experience
            System.Diagnostics.Debug.WriteLine("Error calculating deal: " & ex.Message)
            Return 0
        End Try
    End Function

    <WebMethod()> _
    Public Shared Function ProcessPayment(ByVal paymentDataJson As String) As String
        Try
            System.Diagnostics.Debug.WriteLine("ProcessPayment called with data: " & paymentDataJson)
            
            ' Check if user is logged in
            Dim currentUser As Object = HttpContext.Current.Session("CURRENT_SESSION")
            If currentUser Is Nothing Then
                Return "Error: User not logged in"
            End If
            
            System.Diagnostics.Debug.WriteLine("Processing payment for user: " & currentUser.user_id)
            
            Dim Connect As New Connection()

            ' Parse payment data
            Dim serializer As New JavaScriptSerializer()
            Dim paymentData As Dictionary(Of String, Object) = serializer.Deserialize(Of Dictionary(Of String, Object))(paymentDataJson)
            
            ' Fix: Check if the method key exists and is a string
            If Not paymentData.ContainsKey("method") Then
                Return "Error: Payment method not specified"
            End If
            
            Dim paymentMethod As String = paymentData("method").ToString()
            
            ' Calculate total amount from cart
            Dim totalQuery As String = "SELECT SUM(m.price * c.quantity) as total FROM cart c " & _
                                     "JOIN menu m ON c.item_id = m.item_id " & _
                                     "WHERE c.user_id = @user_id"
            
            Connect.AddParam("@user_id", CInt(currentUser.user_id))
            Connect.Query(totalQuery)

            If Connect.DataCount = 0 Then
                System.Diagnostics.Debug.WriteLine("Error: Cart is empty")
                Return "Error: Cart is empty"
            End If

            ' Get subtotal and calculate discounts
            Dim subtotalAmount As Decimal = CDec(Connect.Data.Tables(0).Rows(0)("total"))
            
            ' Get discount, promotion, and deal IDs from session
            Dim discountId As Integer = 0
            Dim promotionId As Integer = 0
            Dim dealId As Integer = 0
            Dim discountAmount As Decimal = 0
            Dim promotionAmount As Decimal = 0
            Dim dealAmount As Decimal = 0
            
            If HttpContext.Current.Session("SelectedDiscountId") IsNot Nothing Then
                discountId = Convert.ToInt32(HttpContext.Current.Session("SelectedDiscountId"))
                
                ' Calculate discount amount
                Dim discountQuery As String = "SELECT discount_type, value FROM discounts WHERE discount_id = @discount_id"
                Connect = New Connection()
                Connect.AddParam("@discount_id", discountId)
                Connect.Query(discountQuery)
                
                If Connect.DataCount > 0 Then
                    Dim discountType As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)("discount_type"))
                    Dim discountValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                    
                    If discountType = 1 Then ' Percentage discount
                        discountAmount = Math.Round((subtotalAmount * discountValue) / 100, 2)
                    Else ' Fixed amount discount
                        discountAmount = Math.Min(discountValue, subtotalAmount)
                    End If
                End If
            End If
            
            If HttpContext.Current.Session("SelectedPromotionId") IsNot Nothing Then
                promotionId = Convert.ToInt32(HttpContext.Current.Session("SelectedPromotionId"))
                
                ' Calculate promotion amount
                Dim promotionQuery As String = "SELECT promotion_type, value FROM promotions WHERE promotion_id = @promotion_id"
                Connect = New Connection()
                Connect.AddParam("@promotion_id", promotionId)
                Connect.Query(promotionQuery)
                
                If Connect.DataCount > 0 Then
                    Dim promotionType As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)("promotion_type"))
                    Dim promotionValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                    
                    If promotionType = 1 Then ' Percentage promotion
                        promotionAmount = Math.Round((subtotalAmount * promotionValue) / 100, 2)
                    Else ' Fixed amount promotion
                        promotionAmount = Math.Min(promotionValue, subtotalAmount)
                    End If
                End If
            End If
            
            If HttpContext.Current.Session("SelectedDealId") IsNot Nothing Then
                dealId = Convert.ToInt32(HttpContext.Current.Session("SelectedDealId"))

                ' Calculate deal amount
                Dim dealQuery As String = "SELECT deal_type, value FROM deals WHERE deal_id = @deal_id"
                Connect = New Connection()
                Connect.AddParam("@deal_id", dealId)
                Connect.Query(dealQuery)
                
                If Connect.DataCount > 0 Then
                    Dim dealType As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)("deal_type"))
                    Dim dealValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                    
                    If dealType = 1 Then ' Percentage deal
                        dealAmount = Math.Round((subtotalAmount * dealValue) / 100, 2)
                    Else ' Fixed amount deal
                        dealAmount = Math.Min(dealValue, subtotalAmount)
            End If
                End If
            End If

            ' Get delivery details
            Dim deliveryFee As Decimal = 0
            Dim deliveryAddressId As Integer = 0
            Dim deliveryType As String = "standard"
            Dim scheduledTime As String = ""
            
            If paymentData.ContainsKey("deliveryFee") Then
                deliveryFee = CDec(paymentData("deliveryFee"))
            End If

            If paymentData.ContainsKey("deliveryAddressId") Then
                deliveryAddressId = CInt(paymentData("deliveryAddressId"))
            End If

            If paymentData.ContainsKey("deliveryType") Then
                deliveryType = paymentData("deliveryType").ToString()
            End If

            If paymentData.ContainsKey("scheduledTime") AndAlso Not String.IsNullOrEmpty(paymentData("scheduledTime").ToString()) Then
                scheduledTime = paymentData("scheduledTime").ToString()
            End If

            ' Calculate total amount
            Dim totalAmount As Decimal = subtotalAmount - discountAmount - promotionAmount - dealAmount + deliveryFee
            
            ' Create transaction record
            Connect = New Connection()
            Dim createTransactionQuery As String = "INSERT INTO transactions (user_id, payment_method, subtotal, " & _
                                                "discount, delivery_fee, total_amount, status, transaction_date, " & _
                                                "discount_id, promotion_id, deal_id) " & _
                                                "VALUES (@user_id, @payment_method, @subtotal, @discount, " & _
                                                "@delivery_fee, @total_amount, 'Pending', GETDATE(), " & _
                                                "@discount_id, @promotion_id, @deal_id); " & _
                                                "SELECT SCOPE_IDENTITY();"
            
            Connect.AddParam("@user_id", CInt(currentUser.user_id))
            Connect.AddParam("@payment_method", paymentMethod)
            Connect.AddParam("@subtotal", subtotalAmount)
            Connect.AddParam("@discount", discountAmount + promotionAmount + dealAmount) ' Total discount amount
            Connect.AddParam("@delivery_fee", deliveryFee)
            Connect.AddParam("@total_amount", totalAmount)
            Connect.AddParam("@discount_id", If(discountId = 0, DBNull.Value, discountId))
            Connect.AddParam("@promotion_id", If(promotionId = 0, DBNull.Value, promotionId))
            Connect.AddParam("@deal_id", If(dealId = 0, DBNull.Value, dealId))
            
            Dim success As Boolean = Connect.Query(createTransactionQuery)
            
            If Not success OrElse Connect.DataCount = 0 Then
                System.Diagnostics.Debug.WriteLine("Error: Failed to create transaction")
                Return "Error: Failed to create transaction"
            End If

            Dim transactionId As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0))

            ' Create order record
            Connect = New Connection()
            Dim createOrderQuery As String = "INSERT INTO orders (user_id, order_date, status, subtotal, discount, " & _
                                           "promotion_amount, deal_amount, delivery_fee, total_amount, transaction_id, " & _
                                           "delivery_type, discount_id, promotion_id, deal_id"
            
            If Not String.IsNullOrEmpty(scheduledTime) Then
                createOrderQuery &= ", scheduled_time"
            End If
            
            createOrderQuery &= ") VALUES (@user_id, GETDATE(), 'pending', @subtotal, @discount, " & _
                              "@promotion_amount, @deal_amount, @delivery_fee, @total_amount, @transaction_id, " & _
                              "@delivery_type, @discount_id, @promotion_id, @deal_id"
            
            If Not String.IsNullOrEmpty(scheduledTime) Then
                createOrderQuery &= ", @scheduled_time"
            End If
            
            createOrderQuery &= ")"
            
            Connect.AddParam("@user_id", CInt(currentUser.user_id))
            Connect.AddParam("@subtotal", subtotalAmount)
            Connect.AddParam("@discount", discountAmount)
            Connect.AddParam("@promotion_amount", promotionAmount)
            Connect.AddParam("@deal_amount", dealAmount)
            Connect.AddParam("@delivery_fee", deliveryFee)
            Connect.AddParam("@total_amount", totalAmount)
            Connect.AddParam("@transaction_id", transactionId)
            Connect.AddParam("@delivery_type", deliveryType)
            Connect.AddParam("@discount_id", If(discountId = 0, DBNull.Value, discountId))
            Connect.AddParam("@promotion_id", If(promotionId = 0, DBNull.Value, promotionId))
            Connect.AddParam("@deal_id", If(dealId = 0, DBNull.Value, dealId))
            
            If Not String.IsNullOrEmpty(scheduledTime) Then
                Connect.AddParam("@scheduled_time", scheduledTime)
            End If
            
            Dim orderCreated As Boolean = Connect.Query(createOrderQuery)
            If Not orderCreated Then
                System.Diagnostics.Debug.WriteLine("Error: Failed to create order")
                Return "Error: Failed to create order"
            End If
            
            ' Get the order ID
            Connect = New Connection()
            Dim getOrderIdQuery As String = "SELECT MAX(order_id) FROM orders WHERE user_id = @user_id"
            Connect.AddParam("@user_id", CInt(currentUser.user_id))
            Connect.Query(getOrderIdQuery)
            
            Dim orderId As Integer = 0
            If Connect.DataCount > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                orderId = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0))
                System.Diagnostics.Debug.WriteLine("Order created with ID: " & orderId)
            Else
                System.Diagnostics.Debug.WriteLine("Error: Failed to retrieve order ID")
                Return "Error: Failed to retrieve order ID"
            End If

            ' Move items from cart to order_items
            Connect = New Connection()
            Dim moveItemsQuery As String = "INSERT INTO order_items (order_id, item_id, quantity, price, transaction_id) " & _
                                         "SELECT @order_id, c.item_id, c.quantity, m.price, @transaction_id " & _
                                         "FROM cart c JOIN menu m ON c.item_id = m.item_id " & _
                                         "WHERE c.user_id = @user_id"

            Connect.AddParam("@order_id", orderId)
            Connect.AddParam("@transaction_id", transactionId)
            Connect.AddParam("@user_id", CInt(currentUser.user_id))
            success = Connect.Query(moveItemsQuery)

            If Not success Then
                System.Diagnostics.Debug.WriteLine("Error: Failed to process order items")
                Return "Error: Failed to process order items"
            End If

            ' Clear the cart
            Connect = New Connection()
            Dim clearCartQuery As String = "DELETE FROM cart WHERE user_id = @user_id"
            Connect.AddParam("@user_id", CInt(currentUser.user_id))
            Connect.Query(clearCartQuery)
            
            ' Clear any applied discount, promotion, and deal
            HttpContext.Current.Session("SelectedDiscountId") = Nothing
            HttpContext.Current.Session("SelectedPromotionId") = Nothing
            HttpContext.Current.Session("SelectedDealId") = Nothing
            HttpContext.Current.Session("SelectedDiscount") = Nothing
            HttpContext.Current.Session("SelectedPromotion") = Nothing
            HttpContext.Current.Session("SelectedDeal") = Nothing

            System.Diagnostics.Debug.WriteLine("Payment processed successfully for order: " & orderId)
            Return "Success: Payment processed successfully! Order ID: " & orderId & " Redirecting to orders page..."
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error in ProcessPayment: " & ex.Message)
            Return "Error: " & ex.Message
        End Try
    End Function

    Private Sub LoadCartItems()
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            ' Get cart items with menu details
            Dim query As String = "SELECT c.cart_id, c.quantity, m.* " & _
                                "FROM cart c " & _
                                "INNER JOIN menu m ON c.item_id = m.item_id " & _
                                "WHERE c.user_id = @user_id"
            
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(query)

            If Connect.DataCount > 0 Then
                CartRepeater.DataSource = Connect.Data
                CartRepeater.DataBind()
                EmptyCartPanel.Visible = False
                CartItemsPanel.Visible = True
            Else
                EmptyCartPanel.Visible = True
                CartItemsPanel.Visible = False
            End If
        Catch ex As Exception
            ShowAlert("Error loading cart items: " & ex.Message, False)
        End Try
    End Sub

    Protected Function GetCartTotal() As Decimal
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            Dim query As String = "SELECT SUM(m.price * c.quantity) as total " & _
                                "FROM cart c " & _
                                "INNER JOIN menu m ON c.item_id = m.item_id " & _
                                "WHERE c.user_id = @user_id"
            
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(query)

            If Connect.DataCount > 0 AndAlso Not IsDBNull(Connect.Data.Tables(0).Rows(0)("total")) Then
                Return CDec(Connect.Data.Tables(0).Rows(0)("total"))
            End If

            Return 0
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Protected Function GetTotalItems() As Integer
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            Dim query As String = "SELECT SUM(quantity) as total_items " & _
                                "FROM cart " & _
                                "WHERE user_id = @user_id"
            
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(query)

            If Connect.DataCount > 0 AndAlso Not IsDBNull(Connect.Data.Tables(0).Rows(0)("total_items")) Then
                Return CInt(Connect.Data.Tables(0).Rows(0)("total_items"))
            End If

            Return 0
        Catch ex As Exception
            Return 0
        End Try
    End Function

    <System.Web.Services.WebMethod()> _
    Public Shared Function UpdateCartQuantity(ByVal cartId As Integer, ByVal quantity As Integer) As String
        Try
            ' Validate quantity
            If quantity < 1 Or quantity > 99 Then
                Return "Error: Invalid quantity. Please enter a value between 1 and 99."
            End If

            ' Update cart item quantity
            Dim Connect As New Connection()
            Dim updateQuery As String = "UPDATE cart SET quantity = @quantity WHERE cart_id = @cart_id"
            Connect.AddParam("@cart_id", cartId)
            Connect.AddParam("@quantity", quantity)
            Connect.Query(updateQuery)

            Return "Success: Quantity updated successfully!"
        Catch ex As Exception
            Return "Error: " & ex.Message
        End Try
    End Function

    <System.Web.Services.WebMethod()> _
    Public Shared Function RemoveCartItem(ByVal cartId As Integer) As String
        Try
            ' Remove cart item
            Dim Connect As New Connection()
            Dim deleteQuery As String = "DELETE FROM cart WHERE cart_id = @cart_id"
            Connect.AddParam("@cart_id", cartId)
            Connect.Query(deleteQuery)

            Return "Success: Item removed from cart!"
        Catch ex As Exception
            Return "Error: " & ex.Message
        End Try
    End Function

    Protected Sub ClearCartButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            ' Clear all items from cart
            Dim deleteQuery As String = "DELETE FROM cart WHERE user_id = @user_id"
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(deleteQuery)
            
            ' Clear any applied discounts, promotions, and deals
            Session("SelectedDiscountId") = Nothing
            Session("SelectedPromotionId") = Nothing
            Session("SelectedDealId") = Nothing
            Session("SelectedDiscount") = Nothing
            Session("SelectedPromotion") = Nothing
            Session("SelectedDeal") = Nothing

            ShowAlert("Cart cleared successfully!", True)
            LoadCartItems()
            UpdateOrderSummary()
        Catch ex As Exception
            ShowAlert("Error clearing cart: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub CancelAddressButton_Click(sender As Object, e As EventArgs)
        ' Hide the new address form
        NewAddressPanel.Visible = False
        
        ' Apply CSS to ensure it's hidden
        NewAddressPanel.Attributes("style") = "display: none;"
        
        ' Update the UI
        LoadCustomerAddresses() ' Reload the addresses
        UpdateOrderSummary()
    End Sub

    Private Sub HideNewAddressForm()
        NewAddressPanel.Visible = False
        NewAddressPanel.Attributes("style") = "display: none;"
    End Sub

    Private Sub ShowNewAddressForm()
        NewAddressPanel.Visible = True
        NewAddressPanel.Attributes.Remove("style")
    End Sub

    Protected Function GetImageUrl(ByVal imagePath As String) As String
        If String.IsNullOrEmpty(imagePath) Then
            Return ResolveUrl("~/Assets/Images/default-food.jpg")
        End If

        ' Check if the path already contains the full URL
        If imagePath.StartsWith("http") Then
            Return imagePath
        End If

        ' Check if the path starts with ~/ or /
        If Not imagePath.StartsWith("~/") AndAlso Not imagePath.StartsWith("/") Then
            imagePath = "~/Assets/Images/Menu/" & imagePath
        End If

        Return ResolveUrl(imagePath)
    End Function

    Protected Sub CheckoutButton_Click(sender As Object, e As EventArgs)
        ' Show delivery options panel
        DeliveryOptionsPanel.Visible = True
        
        ' Make sure new address panel is hidden
        HideNewAddressForm()
        
        ' Load customer's saved addresses
        LoadCustomerAddresses()
        
        ' Update order summary with delivery fee
        UpdateOrderSummary()
    End Sub

    Private Sub LoadCustomerAddresses()
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            Dim userId As Integer = currentUser.user_id
            
            ' Only hide new address panel if it's not meant to be shown
            If Not NewAddressPanel.Visible Then
                NewAddressPanel.Attributes("style") = "display: none;"
            Else
                ' If panel should be visible, make sure any hiding style is removed
                NewAddressPanel.Attributes.Remove("style")
            End If
            
            If userId > 0 Then
                ' Query to get all customer addresses
                Dim query As String = "SELECT address_id, address_name, recipient_name, contact_number, " & _
                                     "address_line, city, postal_code, is_default " & _
                                     "FROM customer_addresses " & _
                                     "WHERE user_id = @UserId " & _
                                     "ORDER BY is_default DESC, date_added DESC"
                
                Connect.ClearParams()
                Connect.AddParam("@UserId", userId)
                Connect.Query(query)
                
                If Connect.DataCount > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                    ' Clear any existing items
                    AddressRadioList.Items.Clear()
                    
                    ' Add addresses to the radio button list
                    For Each row As DataRow In Connect.Data.Tables(0).Rows
                        Dim addressId As Integer = Convert.ToInt32(row("address_id"))
                        Dim addressName As String = If(IsDBNull(row("address_name")), "", row("address_name").ToString())
                        Dim recipientName As String = row("recipient_name").ToString()
                        Dim contactNumber As String = row("contact_number").ToString()
                        Dim addressLine As String = row("address_line").ToString()
                        Dim city As String = row("city").ToString()
                        Dim postalCode As String = If(IsDBNull(row("postal_code")), "", row("postal_code").ToString())
                        Dim isDefault As Boolean = Convert.ToBoolean(row("is_default"))
                        
                        ' Format the address text
                        Dim addressText As String = String.Format("{0}<br />{1}<br />{2}, {3} {4}", 
                                                                recipientName, 
                                                                addressLine, 
                                                                city, 
                                                                postalCode,
                                                                contactNumber)
                        
                        ' Add a label for default or address name
                        If isDefault Then
                            addressText = "<strong>Default Address</strong><br />" & addressText
                        ElseIf Not String.IsNullOrEmpty(addressName) Then
                            addressText = "<strong>" & addressName & "</strong><br />" & addressText
                        End If
                        
                        ' Add to radio button list
                        Dim item As New ListItem(addressText, addressId.ToString())
                        item.Selected = isDefault
                        AddressRadioList.Items.Add(item)
                    Next
                    
                    ' Show addresses and hide no address message
                    AddressRadioList.Visible = True
                    NoAddressPanel.Visible = False
                    
                    ' Set the selected address to the delivery address hidden field
                    If AddressRadioList.SelectedItem IsNot Nothing Then
                        Dim selectedAddressId As Integer = Convert.ToInt32(AddressRadioList.SelectedValue)
                        DeliveryAddressHidden.Value = selectedAddressId.ToString()
                    End If
                Else
                    ' No addresses found
                    AddressRadioList.Visible = False
                    NoAddressPanel.Visible = True
                End If
            End If
        Catch ex As Exception
            ' Log error and show message to user
            ShowAlert("Error loading addresses: " & ex.Message, False)
        End Try
    End Sub
    
    Protected Sub AddressRadioList_SelectedIndexChanged(sender As Object, e As EventArgs)
        ' Update the selected address ID
        If AddressRadioList.SelectedItem IsNot Nothing Then
            Dim selectedAddressId As Integer = Convert.ToInt32(AddressRadioList.SelectedValue)
            DeliveryAddressHidden.Value = selectedAddressId.ToString()
        End If
    End Sub
    
    Protected Sub ShowNewAddressButton_Click(sender As Object, e As EventArgs)
        ' Show delivery options panel and address form
        DeliveryOptionsPanel.Visible = True
        NewAddressPanel.Visible = True
        
        ' Force the form to be visible by removing any inline style
        NewAddressPanel.Attributes.Remove("style")
        
        ' Reload addresses to ensure the form is correctly displayed
        LoadCustomerAddresses()
        
        ' Update the UI
        UpdateOrderSummary()
    End Sub
    
    Protected Sub SaveAddressButton_Click(sender As Object, e As EventArgs)
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            Dim userId As Integer = currentUser.user_id
            
            ' Get address details from form
            Dim addressName As String = AddressNameTextBox.Text.Trim()
            Dim recipientName As String = RecipientNameTextBox.Text.Trim()
            Dim contactNumber As String = ContactNumberTextBox.Text.Trim()
            Dim addressLine As String = AddressLineTextBox.Text.Trim()
            Dim city As String = CityTextBox.Text.Trim()
            Dim postalCode As String = PostalCodeTextBox.Text.Trim()
            Dim isDefault As Boolean = DefaultAddressCheckBox.Checked
            
            ' Validate required fields
            If String.IsNullOrEmpty(recipientName) OrElse 
               String.IsNullOrEmpty(contactNumber) OrElse 
               String.IsNullOrEmpty(addressLine) OrElse 
               String.IsNullOrEmpty(city) Then
                ShowAlert("Please fill in all required fields", False)
                Return
            End If
            
            ' If setting as default, update existing addresses to not be default
            If isDefault Then
                Dim updateDefaultQuery As String = "UPDATE customer_addresses SET is_default = 0 WHERE user_id = @UserId"
                Connect.ClearParams()
                Connect.AddParam("@UserId", userId)
                Connect.Query(updateDefaultQuery)
            End If
            
            ' Insert new address
            Dim insertQuery As String = "INSERT INTO customer_addresses (" & _
                                       "user_id, address_name, recipient_name, contact_number, " & _
                                       "address_line, city, postal_code, is_default) " & _
                                       "VALUES (@UserId, @AddressName, @RecipientName, @ContactNumber, " & _
                                       "@AddressLine, @City, @PostalCode, @IsDefault)"
            
            Connect.ClearParams()
            Connect.AddParam("@UserId", userId)
            Connect.AddParam("@AddressName", If(String.IsNullOrEmpty(addressName), DBNull.Value, addressName))
            Connect.AddParam("@RecipientName", recipientName)
            Connect.AddParam("@ContactNumber", contactNumber)
            Connect.AddParam("@AddressLine", addressLine)
            Connect.AddParam("@City", city)
            Connect.AddParam("@PostalCode", If(String.IsNullOrEmpty(postalCode), DBNull.Value, postalCode))
            Connect.AddParam("@IsDefault", If(isDefault, 1, 0)) ' Convert boolean to integer
            
            Dim success As Boolean = Connect.Query(insertQuery)
            
            If success Then
                ' Get the new address ID
                Dim getIdQuery As String = "SELECT MAX(address_id) FROM customer_addresses WHERE user_id = @UserId"
                Connect.ClearParams()
                Connect.AddParam("@UserId", userId)
                Connect.Query(getIdQuery)
                
                Dim newAddressId As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0))
                
                ' Set as selected address
                DeliveryAddressHidden.Value = newAddressId.ToString()
                
                ' Clear the form
                AddressNameTextBox.Text = ""
                RecipientNameTextBox.Text = ""
                ContactNumberTextBox.Text = ""
                AddressLineTextBox.Text = ""
                CityTextBox.Text = ""
                PostalCodeTextBox.Text = ""
                DefaultAddressCheckBox.Checked = False
                
                ' Hide the form
                HideNewAddressForm()
                
                ' Reload addresses
                LoadCustomerAddresses()
                
                ShowAlert("Address saved successfully", True)
            Else
                ShowAlert("Error saving address", False)
            End If
        Catch ex As Exception
            ShowAlert("Error saving address: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub PlaceOrderButton_Click(sender As Object, e As EventArgs)
        Try
            ' Get selected address ID
            Dim selectedAddressId As Integer = 0
            If Not String.IsNullOrEmpty(DeliveryAddressHidden.Value) Then
                selectedAddressId = Convert.ToInt32(DeliveryAddressHidden.Value)
            ElseIf AddressRadioList.SelectedItem IsNot Nothing Then
                selectedAddressId = Convert.ToInt32(AddressRadioList.SelectedValue)
            End If
            
            If selectedAddressId <= 0 Then
                ShowAlert("Please select a delivery address", False)
                Return
            End If

            ' Get delivery type and fee
            Dim deliveryType As String = Request.Form("deliveryOption")
            Dim deliveryFee As Decimal = 0
            If deliveryType = "priority" Then
                deliveryFee = 50
            End If

            ' Get scheduled time if applicable
            Dim scheduledTime As String = ""
            If deliveryType = "scheduled" Then
                scheduledTime = Request.Form("scheduledTime")
                If String.IsNullOrEmpty(scheduledTime) Then
                    ShowAlert("Please select a delivery time", False)
                    Return
                End If
            End If

            ' Get payment method
            Dim paymentMethod As String = Request.Form("paymentMethod")
            
            ' For GCash payments, validate reference number and sender details
            If paymentMethod = "gcash" Then
                Dim referenceNumber As String = Request.Form("referenceNumber")
                Dim senderName As String = Request.Form("senderName")
                Dim senderNumber As String = Request.Form("senderNumber")
                
                If String.IsNullOrEmpty(referenceNumber) OrElse
                   String.IsNullOrEmpty(senderName) OrElse
                   String.IsNullOrEmpty(senderNumber) Then
                    ShowAlert("Please fill in all GCash payment details", False)
                    Return
                End If
            End If

            ' Prepare payment data for the payment processor
            Dim paymentData As New Dictionary(Of String, Object)
            paymentData.Add("method", paymentMethod)
            paymentData.Add("deliveryType", deliveryType)
            paymentData.Add("deliveryFee", deliveryFee)
            paymentData.Add("deliveryAddressId", selectedAddressId)
            
            If Not String.IsNullOrEmpty(scheduledTime) Then
                paymentData.Add("scheduledTime", scheduledTime)
            End If
            
            ' Add GCash details if applicable
            If paymentMethod = "gcash" Then
                paymentData.Add("referenceNumber", Request.Form("referenceNumber"))
                paymentData.Add("senderName", Request.Form("senderName"))
                paymentData.Add("senderNumber", Request.Form("senderNumber"))
            End If
            
            ' Convert to JSON and process payment
                    Dim serializer As New JavaScriptSerializer()
            Dim paymentDataJson As String = serializer.Serialize(paymentData)
            
            Dim result As String = ProcessPayment(paymentDataJson)
            
            If result.StartsWith("Success") Then
                ' Clear cart on successful payment
                ShowAlert("Order placed successfully! Redirecting to your orders...", True)
                
                ' Redirect to orders page after a short delay (handled by client-side script)
                ClientScript.RegisterStartupScript(Me.GetType(), "RedirectScript", 
                    "setTimeout(function() { window.location.href = 'CustomerOrders.aspx'; }, 3000);", True)
            Else
                ShowAlert(result, False)
            End If
                Catch ex As Exception
            ShowAlert("Error placing order: " & ex.Message, False)
        End Try
    End Sub

    ' Helper method to show alert messages
    Protected Sub ShowAlert(ByVal message As String, Optional ByVal isSuccess As Boolean = True)
        ' Check if the page has a master page with ShowAlert method
        If Me.Master IsNot Nothing Then
            Try
                ' Access the ShowAlert method on the master page using reflection
                Dim masterShowAlertMethod As System.Reflection.MethodInfo = Me.Master.GetType().GetMethod("ShowAlert")
                If masterShowAlertMethod IsNot Nothing Then
                    masterShowAlertMethod.Invoke(Me.Master, New Object() {message, isSuccess})
                    Return
                End If
            Catch ex As Exception
                ' Fallback to local alert if reflection fails
                System.Diagnostics.Debug.WriteLine("Error calling master ShowAlert: " & ex.Message)
            End Try
        End If

        ' Fallback to show alert using JavaScript
        Dim alertClass As String = If(isSuccess, "alert-success", "alert-danger")
        Dim script As String = String.Format("showAlertMessage('{0}', '{1}');", message.Replace("'", "\'"), alertClass)
        
        If Not ClientScript.IsStartupScriptRegistered("AlertScript") Then
            ClientScript.RegisterStartupScript(Me.GetType(), "AlertScript", script, True)
        End If
        
        ' Also update alert message panel if it exists
        If alertMessage IsNot Nothing Then
            alertMessage.Visible = True
            AlertLiteral.Text = message
            
            ' Apply appropriate CSS class
            If isSuccess Then
                alertMessage.Attributes("class") = "alert-message alert-success"
            Else
                alertMessage.Attributes("class") = "alert-message alert-danger"
            End If
        End If
    End Sub

    Protected Sub RecalculateButton_Click(sender As Object, e As EventArgs)
        Try
            ' Debug info
            System.Diagnostics.Debug.WriteLine("Recalculating order summary")
            
            ' Get current selections
            Dim discountId As Integer = 0
            Dim promotionId As Integer = 0
            Dim dealId As Integer = 0
            
            If Session("SelectedDiscountId") IsNot Nothing Then
                discountId = Convert.ToInt32(Session("SelectedDiscountId"))
            End If
            
            If Session("SelectedPromotionId") IsNot Nothing Then
                promotionId = Convert.ToInt32(Session("SelectedPromotionId"))
            End If
            
            If Session("SelectedDealId") IsNot Nothing Then
                dealId = Convert.ToInt32(Session("SelectedDealId"))
            End If
            
            ' Clear session data
            Session("SelectedDiscount") = Nothing
            Session("SelectedPromotion") = Nothing
            Session("SelectedDeal") = Nothing
            
            ' Reapply all selections
            If discountId > 0 Then
                Session("SelectedDiscountId") = discountId
                ApplySelectedDiscount()
            End If
            
            If promotionId > 0 Then
                Session("SelectedPromotionId") = promotionId
                ApplySelectedPromotion()
            End If
            
            If dealId > 0 Then
                Session("SelectedDealId") = dealId
                ApplySelectedDeal()
            End If
            
            ' Update the order summary
            UpdateOrderSummary()
            
            ' Show success message
            ShowAlert("Order summary has been recalculated successfully.", True)
        Catch ex As Exception
            ' Show error message
            ShowAlert("Error recalculating order summary: " & ex.Message, False)
        End Try
    End Sub
End Class
