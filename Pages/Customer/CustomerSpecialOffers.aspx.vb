Imports System.Data

Partial Class Pages_Customer_CustomerSpecialOffers
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in
            If Session("CURRENT_SESSION") Is Nothing Then
                Response.Redirect("~/Pages/LoginPortal/CustomerLoginPortal.aspx")
                Return
            End If
            
            ' Load promotions, deals, and discounts
            LoadPromotions()
            LoadDeals()
            LoadDiscounts()
        End If
    End Sub

    Private Sub LoadPromotions()
        Try
            ' Get active promotions
            Dim query As String = "SELECT * FROM promotions WHERE "
            query &= "(CONVERT(datetime, start_date, 101) <= GETDATE() AND CONVERT(datetime, valid_until, 101) >= GETDATE()) OR "
            query &= "(start_date IS NULL OR valid_until IS NULL) "
            query &= "ORDER BY name ASC"

            Connect.ClearParams()
            Connect.Query(query)

            If Connect.DataCount > 0 Then
                PromotionsRepeater.DataSource = Connect.Data
                PromotionsRepeater.DataBind()
                PromotionsPlaceholder.Visible = True
                NoPromotionsPlaceholder.Visible = False
            Else
                PromotionsPlaceholder.Visible = False
                NoPromotionsPlaceholder.Visible = True
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error loading promotions: " & ex.Message)
            PromotionsPlaceholder.Visible = False
            NoPromotionsPlaceholder.Visible = True
            
            Dim masterPage As Pages_Customer_CustomerTemplate = DirectCast(Me.Master, Pages_Customer_CustomerTemplate)
            masterPage.ShowAlert("Error loading promotions: " & ex.Message, False)
        End Try
    End Sub

    Private Sub LoadDeals()
        Try
            ' Get active deals
            Dim query As String = "SELECT * FROM deals WHERE "
            query &= "(CONVERT(datetime, start_date, 101) <= GETDATE() AND CONVERT(datetime, valid_until, 101) >= GETDATE()) OR "
            query &= "(start_date IS NULL OR valid_until IS NULL) "
            query &= "ORDER BY name ASC"

            Connect.ClearParams()
            Connect.Query(query)

            If Connect.DataCount > 0 Then
                DealsRepeater.DataSource = Connect.Data
                DealsRepeater.DataBind()
                DealsPlaceholder.Visible = True
                NoDealsPlaceholder.Visible = False
            Else
                DealsPlaceholder.Visible = False
                NoDealsPlaceholder.Visible = True
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error loading deals: " & ex.Message)
            DealsPlaceholder.Visible = False
            NoDealsPlaceholder.Visible = True
            
            Dim masterPage As Pages_Customer_CustomerTemplate = DirectCast(Me.Master, Pages_Customer_CustomerTemplate)
            masterPage.ShowAlert("Error loading deals: " & ex.Message, False)
        End Try
    End Sub

    Private Sub LoadDiscounts()
        Try
            ' Get active discounts
            Dim query As String = "SELECT * FROM discounts ORDER BY name ASC"

            Connect.ClearParams()
            Connect.Query(query)

            If Connect.DataCount > 0 Then
                DiscountsRepeater.DataSource = Connect.Data
                DiscountsRepeater.DataBind()
                DiscountsPlaceholder.Visible = True
                NoDiscountsPlaceholder.Visible = False
            Else
                DiscountsPlaceholder.Visible = False
                NoDiscountsPlaceholder.Visible = True
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error loading discounts: " & ex.Message)
            DiscountsPlaceholder.Visible = False
            NoDiscountsPlaceholder.Visible = True
            
            Dim masterPage As Pages_Customer_CustomerTemplate = DirectCast(Me.Master, Pages_Customer_CustomerTemplate)
            masterPage.ShowAlert("Error loading discounts: " & ex.Message, False)
        End Try
    End Sub

    Protected Function GetImageUrl(ByVal imagePath As Object) As String
        If imagePath Is Nothing OrElse String.IsNullOrEmpty(imagePath.ToString()) Then
            Return ResolveUrl("~/Assets/Images/default-food.jpg")
        End If

        Dim path As String = imagePath.ToString()

        ' Check if the path already contains the full URL
        If path.StartsWith("http") Then
            Return path
        End If

        ' Check if the path starts with ~/ or /
        If Not path.StartsWith("~/") AndAlso Not path.StartsWith("/") Then
            path = "~/Assets/Images/Menu/" & path
        End If

        Return ResolveUrl(path)
    End Function

    Protected Function GetValueDisplay(ByVal value As Object, ByVal valueType As Object) As String
        If value Is Nothing OrElse valueType Is Nothing Then
            Return ""
        End If

        Dim val As String = value.ToString()
        Dim type As String = valueType.ToString()

        If String.IsNullOrEmpty(val) Then
            Return ""
        End If

        If type = "1" Then
            ' Percentage
            Return val & "% OFF"
        ElseIf type = "2" Then
            ' Fixed amount
            Return "PHP " & val & " OFF"
        Else
            Return val
        End If
    End Function

    Protected Function FormatDate(ByVal dateValue As Object) As String
        If dateValue Is Nothing OrElse String.IsNullOrEmpty(dateValue.ToString()) Then
            Return "N/A"
        End If

        Try
            Dim date1 As DateTime = DateTime.Parse(dateValue.ToString())
            Return date1.ToString("MMM dd, yyyy")
        Catch ex As Exception
            Return dateValue.ToString()
        End Try
    End Function
End Class 