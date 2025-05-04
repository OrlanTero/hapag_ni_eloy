Imports System.Data
Imports System.IO
Imports HapagDB

Partial Class Pages_Admin_AdminMenu
    Inherits AdminBasePage
    Private menuController As New MenuController()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadCategories()
            LoadTypes()
            ViewTable()
            
            ' Check if the page should be in read-only mode (for staff)
            If IsReadOnlyMode() Then
                System.Diagnostics.Debug.WriteLine("AdminMenu: Page is in read-only mode")
                SetPageToReadOnly()
                ShowViewOnlyNotice()
                
                ' Also disable specific buttons
                If AddBtn IsNot Nothing Then AddBtn.Enabled = False
                If EditBtn IsNot Nothing Then EditBtn.Enabled = False
                If RemoveBtn IsNot Nothing Then RemoveBtn.Enabled = False
                If ClearBtn IsNot Nothing Then ClearBtn.Enabled = False
                If UploadBtn IsNot Nothing Then UploadBtn.Enabled = False
            Else
                System.Diagnostics.Debug.WriteLine("AdminMenu: Page is in full access mode")
            End If
        End If
    End Sub

    Private Sub LoadCategories()
        ' Use MenuController to get all categories
        Dim categories = menuController.GetAllCategories()
        
        CategoryDdl.Items.Clear()
        CategoryDdl.Items.Add(New ListItem("-- Select Category --", ""))
        
        ' Only add active categories to the dropdown
        For Each category As MenuCategory In categories
            If category.is_active Then
                CategoryDdl.Items.Add(New ListItem(category.category_name, category.category_id.ToString()))
            End If
        Next
    End Sub

    Private Sub LoadTypes()
        ' Use MenuController to get all types
        Dim types = menuController.GetAllTypes()
        
        TypeDdl.Items.Clear()
        TypeDdl.Items.Add(New ListItem("-- Select Type --", ""))
        
        ' Only add active types to the dropdown
        For Each menuType As MenuType In types
            If menuType.is_active Then
                TypeDdl.Items.Add(New ListItem(menuType.type_name, menuType.type_id.ToString()))
            End If
        Next
    End Sub

    Protected Sub AddBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddBtn.Click
        ' Validate input
        If Not ValidateInput() Then
            Return
        End If
        
        Try
            ' Create a new MenuItem object
            Dim newMenuItem As New MenuItem()
            newMenuItem.name = NameTxt.Text
            newMenuItem.price = PriceTxt.Text
            newMenuItem.category_id = Convert.ToInt32(CategoryDdl.SelectedValue)
            newMenuItem.type_id = Convert.ToInt32(TypeDdl.SelectedValue)
            newMenuItem.category = CategoryDdl.SelectedItem.Text
            newMenuItem.type = TypeDdl.SelectedItem.Text
            newMenuItem.availability = AvailabilityDdl.SelectedValue
            newMenuItem.no_of_serving = ServingsTxt.Text
            newMenuItem.description = DescriptionTxt.Text
            newMenuItem.image = If(String.IsNullOrEmpty(ImagePathHidden.Value), Nothing, ImagePathHidden.Value)
            
            ' Use MenuController to create menu item
            If menuController.CreateMenuItem(newMenuItem) Then
                ShowAlert("Menu Item Added Successfully!")
            Else
                ShowAlert("Failed to Add Menu Item!")
            End If
            
        Catch ex As Exception
            ' Show error message
            ShowAlert("Error: " & ex.Message)
        End Try
        
        ViewTable()
        ClearFormFields()
    End Sub

    Protected Sub EditBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles EditBtn.Click
        ' Check if an item is selected
        If String.IsNullOrEmpty(ItemIdTxt.Text) Then
            ShowAlert("Please select a menu item to edit!")
            Return
        End If
        
        ' Validate input
        If Not ValidateInput() Then
            Return
        End If
        
        Try
            ' Create MenuItem object for update
            Dim menuItem As New MenuItem()
            menuItem.item_id = Convert.ToInt32(ItemIdTxt.Text)
            menuItem.name = NameTxt.Text
            menuItem.price = PriceTxt.Text
            menuItem.category_id = Convert.ToInt32(CategoryDdl.SelectedValue)
            menuItem.type_id = Convert.ToInt32(TypeDdl.SelectedValue)
            menuItem.category = CategoryDdl.SelectedItem.Text
            menuItem.type = TypeDdl.SelectedItem.Text
            menuItem.availability = AvailabilityDdl.SelectedValue
            menuItem.no_of_serving = ServingsTxt.Text
            menuItem.description = DescriptionTxt.Text
            menuItem.image = If(String.IsNullOrEmpty(ImagePathHidden.Value), Nothing, ImagePathHidden.Value)
            
            ' Use MenuController to update menu item
            If menuController.UpdateMenuItem(menuItem) Then
                ShowAlert("Menu Item Updated Successfully!")
            Else
                ShowAlert("Failed to Update Menu Item!")
            End If
            
        Catch ex As Exception
            ShowAlert("Error: " & ex.Message)
        End Try
        
        ViewTable()
        ClearFormFields()
    End Sub
    
    Protected Sub RemoveBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RemoveBtn.Click
        Dim itemId = ItemIdTxt.Text

        If String.IsNullOrEmpty(itemId) Then
            ShowAlert("Please select a menu item to remove!")
            Return
        End If

        ' Use MenuController to delete menu item
        If menuController.DeleteMenuItem(Convert.ToInt32(itemId)) Then
            ShowAlert("Menu Item Deleted Successfully!")
        Else
            ShowAlert("Failed to Delete Menu Item!")
        End If

        ViewTable()
        ClearFormFields()
    End Sub

    Protected Sub UploadBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If ImageUpload.HasFile Then
            Try
                Dim fileName As String = Path.GetFileName(ImageUpload.FileName)
                Dim fileExtension As String = Path.GetExtension(fileName).ToLower()
                
                ' Check if the file is an image
                If fileExtension = ".jpg" OrElse fileExtension = ".jpeg" OrElse fileExtension = ".png" OrElse fileExtension = ".gif" Then
                    ' Create directory if it doesn't exist
                    Dim uploadDirectory As String = Server.MapPath("~/Assets/Images/Menu/")
                    If Not Directory.Exists(uploadDirectory) Then
                        Directory.CreateDirectory(uploadDirectory)
                    End If
                    
                    ' Generate unique filename
                    Dim uniqueFileName As String = Guid.NewGuid().ToString() & fileExtension
                    Dim filePath As String = Path.Combine(uploadDirectory, uniqueFileName)
                    
                    ' Save the file
                    ImageUpload.SaveAs(filePath)
                    
                    ' Set the image path in the hidden field (store relative path)
                    Dim relativePath As String = "~/Assets/Images/Menu/" & uniqueFileName
                    ImagePathHidden.Value = relativePath
                    
                    ' Display the image
                    ItemImage.ImageUrl = relativePath
                    ItemImage.Visible = True
                    
                    ShowAlert("Image uploaded successfully!")
                Else
                    ShowAlert("Please upload only image files (.jpg, .jpeg, .png, .gif).")
                End If
            Catch ex As Exception
                ShowAlert("Error uploading image: " & ex.Message)
            End Try
        Else
            ShowAlert("Please select an image to upload.")
        End If
    End Sub

    Protected Sub ClearBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        ClearFormFields()
    End Sub

    Public Sub ViewTable()
        Try
            ' Use MenuController to get all menu items
            Dim menuItems = menuController.GetAllMenuItems()
            
            Table1.Rows.Clear()

            ' Add header row
            Dim headerRow As New TableRow()
            headerRow.Cells.Add(New TableCell() With {.Text = "Name"})
            headerRow.Cells.Add(New TableCell() With {.Text = "Price"})
            headerRow.Cells.Add(New TableCell() With {.Text = "Category"})
            headerRow.Cells.Add(New TableCell() With {.Text = "Type"})
            headerRow.Cells.Add(New TableCell() With {.Text = "Availability"})
            headerRow.Cells.Add(New TableCell() With {.Text = "Servings"})
            headerRow.Cells.Add(New TableCell() With {.Text = "Image"})
            Table1.Rows.Add(headerRow)

            ' Get category and type info for better display
            Dim categories = menuController.GetAllCategories()
            Dim types = menuController.GetAllTypes()
            
            ' Create lookup dictionaries for faster access
            Dim categoryDict As New Dictionary(Of Integer, String)
            Dim typeDict As New Dictionary(Of Integer, String)
            
            For Each category As MenuCategory In categories
                categoryDict(category.category_id) = category.category_name
            Next
            
            For Each menuType As MenuType In types
                typeDict(menuType.type_id) = menuType.type_name
            Next

            For Each item As MenuItem In menuItems
                Dim tableRow As New TableRow()

                ' Add cells with menu item data
                tableRow.Cells.Add(New TableCell() With {.Text = If(item.name, "")})
                tableRow.Cells.Add(New TableCell() With {.Text = If(item.price, "")})
                
                ' Use dictionaries to get category and type names
                Dim categoryName As String = ""
                If item.category_id > 0 AndAlso categoryDict.ContainsKey(item.category_id) Then
                    categoryName = categoryDict(item.category_id)
                ElseIf Not String.IsNullOrEmpty(item.category) Then
                    categoryName = item.category
                End If
                tableRow.Cells.Add(New TableCell() With {.Text = categoryName})
                
                Dim typeName As String = ""
                If item.type_id > 0 AndAlso typeDict.ContainsKey(item.type_id) Then
                    typeName = typeDict(item.type_id)
                ElseIf Not String.IsNullOrEmpty(item.type) Then
                    typeName = item.type
                End If
                tableRow.Cells.Add(New TableCell() With {.Text = typeName})
                
                ' Convert availability to text
                Dim availabilityText As String = "Not Available"
                If Not String.IsNullOrEmpty(item.availability) AndAlso item.availability = "1" Then
                    availabilityText = "Available"
                End If
                tableRow.Cells.Add(New TableCell() With {.Text = availabilityText})
                
                tableRow.Cells.Add(New TableCell() With {.Text = If(item.no_of_serving, "")})
                
                ' Create image cell
                Dim imageCell As New TableCell()
                If Not String.IsNullOrEmpty(item.image) Then
                    Dim img As New System.Web.UI.WebControls.Image()
                    img.ImageUrl = item.image
                    img.Width = Unit.Pixel(50)
                    img.Height = Unit.Pixel(50)
                    imageCell.Controls.Add(img)
                Else
                    imageCell.Text = "No Image"
                End If
                tableRow.Cells.Add(imageCell)

                ' Add data attributes for JavaScript
                tableRow.Attributes.Add("data-item_id", item.item_id.ToString())
                tableRow.Attributes.Add("data-category_id", If(item.category_id > 0, item.category_id.ToString(), ""))
                tableRow.Attributes.Add("data-type_id", If(item.type_id > 0, item.type_id.ToString(), ""))
                tableRow.Attributes.Add("data-description", If(item.description, ""))
                tableRow.Attributes.Add("data-image", If(item.image, ""))
                
                Table1.Rows.Add(tableRow)
            Next
        Catch ex As Exception
            ShowAlert("Error loading menu items: " & ex.Message)
        End Try
    End Sub

    Public Sub ClearFormFields()
        ItemIdTxt.Text = ""
        NameTxt.Text = ""
        PriceTxt.Text = ""
        CategoryDdl.SelectedIndex = 0
        TypeDdl.SelectedIndex = 0
        AvailabilityDdl.SelectedIndex = 0
        ServingsTxt.Text = ""
        DescriptionTxt.Text = ""
        ImagePathHidden.Value = ""
        ItemImage.ImageUrl = ""
        ItemImage.Visible = False
    End Sub
    
    Private Function ValidateInput() As Boolean
        ' Validate required fields
        If String.IsNullOrEmpty(NameTxt.Text) Then
            ShowAlert("Menu item name cannot be empty!")
            Return False
        End If

        If String.IsNullOrEmpty(PriceTxt.Text) Then
            ShowAlert("Price cannot be empty!")
            Return False
        End If

        If String.IsNullOrEmpty(CategoryDdl.SelectedValue) Then
            ShowAlert("Please select a category!")
            Return False
        End If

        If String.IsNullOrEmpty(TypeDdl.SelectedValue) Then
            ShowAlert("Please select a type!")
            Return False
        End If
        
        Return True
    End Function

    Private Sub ShowAlert(ByVal message As String)
        Try
            ' Use the master page's alert methods
            Dim masterPage As Pages_Admin_AdminTemplate = DirectCast(Me.Master, Pages_Admin_AdminTemplate)
            
            If message.Contains("Successfully") Then
                masterPage.ShowAlert(message, True)
            ElseIf message.Contains("Error") Or message.Contains("Failed") Then
                masterPage.ShowAlert(message, False)
            ElseIf message.Contains("Note") Or message.Contains("Please") Then
                masterPage.ShowWarning(message)
            Else
                masterPage.ShowInfo(message)
            End If
        Catch ex As Exception
            ' Fallback to original method if master page method fails
            alertMessage.Visible = True
            
            If message.Contains("Successfully") Then
                alertMessage.Attributes("class") = "alert-message alert-success"
            ElseIf message.Contains("Error") Or message.Contains("Failed") Then
                alertMessage.Attributes("class") = "alert-message alert-danger"
            ElseIf message.Contains("Note") Then
                alertMessage.Attributes("class") = "alert-message alert-warning"
            Else
                alertMessage.Attributes("class") = "alert-message alert-info"
            End If
            
            AlertLiteral.Text = message
        End Try
    End Sub

    ' Display a notification for view-only mode
    Private Sub ShowViewOnlyNotice()
        Try
            Dim masterPage As Pages_Admin_AdminTemplate = DirectCast(Me.Master, Pages_Admin_AdminTemplate)
            If masterPage IsNot Nothing Then
                masterPage.ShowInfo("You have view-only access to this page. Editing functionality is restricted.")
            End If
        Catch ex As Exception
            ' Fallback if master page alert fails
            ClientScript.RegisterStartupScript(Me.GetType(), "ViewOnlyAlert", 
                "alert('You have view-only access to this page. Editing functionality is restricted.');", True)
        End Try
    End Sub
End Class
