Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Data
Imports System.Data.SqlClient
Imports HapagDB
Partial Class LandingPage
    Inherits System.Web.UI.Page

    Private Connect As New Connection()
    ' Track if we have any offers to display
    Private hasDiscounts As Boolean = False
    Private hasPromotions As Boolean = False
    Private hasDeals As Boolean = False

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadMenuItems()
            LoadDiscounts()
            LoadDeals()
            LoadPromotions()
            
            ' Check if we need to hide the entire offers section
            If Not hasDiscounts And Not hasPromotions And Not hasDeals Then
                If offersSection IsNot Nothing Then
                    offersSection.Visible = False
                End If
            End If
        End If
    End Sub

    Private Sub LoadMenuItems()
        Try
            Dim query As String = "SELECT item_id, name, description, category, type, " & _
                                "image, CAST(price AS DECIMAL(10,2)) AS price, " & _
                                "availability " & _
                                "FROM menu WHERE availability = 1 ORDER BY category, name"
            Connect.Query(query)
            
            If Connect.Data IsNot Nothing AndAlso Connect.Data.Tables.Count > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                MenuRepeater.DataSource = Connect.Data
                MenuRepeater.DataBind()
            Else
                ' If no menu items found, hide the menu section
                If menuSection IsNot Nothing Then
                    menuSection.Visible = False
                End If
            End If
        Catch ex As Exception
            ' Handle error silently for landing page
            System.Diagnostics.Debug.WriteLine("Error loading menu items: " & ex.Message)
            ' Hide menu section on error
            If menuSection IsNot Nothing Then
                menuSection.Visible = False
            End If
        End Try
    End Sub

    Private Sub LoadDiscounts()
        Try
            ' Get active discounts
            Dim query As String = "SELECT * FROM discounts WHERE " & _
                                "status = 1 AND " & _
                                "GETDATE() BETWEEN start_date AND end_date " & _
                                "ORDER BY value DESC"
            Connect.Query(query)
            
            If Connect.Data IsNot Nothing AndAlso Connect.Data.Tables.Count > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                DiscountsRepeater.DataSource = Connect.Data
                DiscountsRepeater.DataBind()
                hasDiscounts = True
            Else
                ' If no discounts found, hide the discounts section
                If discountsGrid IsNot Nothing Then
                    discountsGrid.Visible = False
                End If
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error loading discounts: " & ex.Message)
            ' Hide discounts section on error
            If discountsGrid IsNot Nothing Then
                discountsGrid.Visible = False
            End If
        End Try
    End Sub

    Private Sub LoadDeals()
        Try
            ' Get active deals
            Dim query As String = "SELECT * FROM deals WHERE " & _
                                "status = 1 AND " & _
                                "GETDATE() BETWEEN start_date AND valid_until " & _
                                "ORDER BY value DESC"
            Connect.Query(query)
            
            If Connect.Data IsNot Nothing AndAlso Connect.Data.Tables.Count > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                DealsRepeater.DataSource = Connect.Data
                DealsRepeater.DataBind()
                hasDeals = True
            Else
                ' If no deals found, hide the deals section
                If dealsGrid IsNot Nothing Then
                    dealsGrid.Visible = False
                End If
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error loading deals: " & ex.Message)
            ' Hide deals section on error
            If dealsGrid IsNot Nothing Then
                dealsGrid.Visible = False
            End If
        End Try
    End Sub

    Private Sub LoadPromotions()
        Try
            ' Get active promotions
            Dim query As String = "SELECT * FROM promotions WHERE " & _
                                "status = 1 AND " & _
                                "GETDATE() BETWEEN start_date AND valid_until " & _
                                "ORDER BY value DESC"
            Connect.Query(query)
            
            If Connect.Data IsNot Nothing AndAlso Connect.Data.Tables.Count > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                PromotionsRepeater.DataSource = Connect.Data
                PromotionsRepeater.DataBind()
                hasPromotions = True
            Else
                ' If no promotions found, hide the promotions section
                If promotionsGrid IsNot Nothing Then
                    promotionsGrid.Visible = False
                End If
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error loading promotions: " & ex.Message)
            ' Hide promotions section on error
            If promotionsGrid IsNot Nothing Then
                promotionsGrid.Visible = False
            End If
        End Try
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

    Protected Function GetValueDisplay(ByVal value As Object, ByVal valueType As Object) As String
        If value Is Nothing OrElse valueType Is Nothing Then
            Return ""
        End If

        Try
            Dim discountValue As Decimal = Convert.ToDecimal(value)
            Dim type As Integer = Convert.ToInt32(valueType)

            If type = 1 Then ' Percentage
                Return discountValue & "% OFF"
            Else ' Fixed amount
                Return "PHP " & Format(discountValue, "0.00") & " OFF"
            End If
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error formatting value display: " & ex.Message)
            Return ""
        End Try
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
