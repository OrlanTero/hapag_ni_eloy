Imports System.Data
Imports System.IO

Partial Class Pages_Admin_AdminMenu
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadCategories()
            LoadTypes()
            ViewTable()
        End If
    End Sub

    Private Sub LoadCategories()
        Dim query = "SELECT category_id, category_name FROM menu_categories WHERE is_active = 1 ORDER BY category_name"
        Connect.Query(query)

        CategoryDdl.Items.Clear()
        CategoryDdl.Items.Add(New ListItem("-- Select Category --", ""))

        For Each row As DataRow In Connect.Data.Tables(0).Rows
            CategoryDdl.Items.Add(New ListItem(row("category_name").ToString(), row("category_id").ToString()))
        Next
    End Sub

    Private Sub LoadTypes()
        Dim query = "SELECT type_id, type_name FROM menu_types WHERE is_active = 1 ORDER BY type_name"
        Connect.Query(query)

        TypeDdl.Items.Clear()
        TypeDdl.Items.Add(New ListItem("-- Select Type --", ""))

        For Each row As DataRow In Connect.Data.Tables(0).Rows
            TypeDdl.Items.Add(New ListItem(row("type_name").ToString(), row("type_id").ToString()))
        Next
    End Sub

    Protected Sub AddBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddBtn.Click
        Dim name = NameTxt.Text
        Dim price = PriceTxt.Text
        Dim categoryId = CategoryDdl.SelectedValue
        Dim typeId = TypeDdl.SelectedValue
        Dim availability = AvailabilityDdl.SelectedValue
        Dim servings = ServingsTxt.Text
        Dim description = DescriptionTxt.Text
        Dim imagePath = ImagePathHidden.Value

        If String.IsNullOrEmpty(name) Then
            ShowAlert("Menu item name cannot be empty!")
            Return
        End If

        If String.IsNullOrEmpty(price) Then
            ShowAlert("Price cannot be empty!")
            Return
        End If

        If String.IsNullOrEmpty(categoryId) Then
            ShowAlert("Please select a category!")
            Return
        End If

        If String.IsNullOrEmpty(typeId) Then
            ShowAlert("Please select a type!")
            Return
        End If

        ' Get category and type names for backward compatibility
        Dim categoryName = CategoryDdl.SelectedItem.Text
        Dim typeName = TypeDdl.SelectedItem.Text

        Try
            ' Try to insert with no_of_serving column
            Dim query = "INSERT INTO menu (name, price, category_id, type_id, category, type, availability, no_of_serving, description, image) " & _
                        "VALUES (@name, @price, @category_id, @type_id, @category, @type, @availability, @no_of_serving, @description, @image)"

            Connect.AddParam("@name", name)
            Connect.AddParam("@price", price)
            Connect.AddParam("@category_id", categoryId)
            Connect.AddParam("@type_id", typeId)
            Connect.AddParam("@category", categoryName)
            Connect.AddParam("@type", typeName)
            Connect.AddParam("@availability", availability)
            Connect.AddParam("@no_of_serving", servings)
            Connect.AddParam("@description", description)
            Connect.AddParam("@image", If(String.IsNullOrEmpty(imagePath), "", imagePath))

            Dim insert = Connect.Query(query)

            If insert Then
                ShowAlert("Menu Item Added Successfully!")
            Else
                ShowAlert("Failed to Add Menu Item!")
            End If
        Catch ex As Exception
            ' If there's an error, try without no_of_serving column
            If ex.Message.Contains("no_of_serving") Then
                Try
                    Dim query = "INSERT INTO menu (name, price, category_id, type_id, category, type, availability, description, image) " & _
                                "VALUES (@name, @price, @category_id, @type_id, @category, @type, @availability, @description, @image)"

        Connect.AddParam("@name", name)
        Connect.AddParam("@price", price)
                    Connect.AddParam("@category_id", categoryId)
                    Connect.AddParam("@type_id", typeId)
                    Connect.AddParam("@category", categoryName)
                    Connect.AddParam("@type", typeName)
        Connect.AddParam("@availability", availability)
                    Connect.AddParam("@description", description)
                    Connect.AddParam("@image", If(String.IsNullOrEmpty(imagePath), DBNull.Value, imagePath))

        Dim insert = Connect.Query(query)

        If insert Then
                        ShowAlert("Menu Item Added Successfully! (Note: Servings field was not saved due to database schema issue)")
                    Else
                        ShowAlert("Failed to Add Menu Item!")
                    End If
                Catch innerEx As Exception
                    ShowAlert("Error: " & innerEx.Message)
                End Try
            Else
                ShowAlert("Error: " & ex.Message)
        End If
        End Try

        ViewTable()
        ClearFormFields()
    End Sub

    Protected Sub EditBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles EditBtn.Click
        Dim itemId = ItemIdTxt.Text
        Dim name = NameTxt.Text
        Dim price = PriceTxt.Text
        Dim categoryId = CategoryDdl.SelectedValue
        Dim typeId = TypeDdl.SelectedValue
        Dim availability = AvailabilityDdl.SelectedValue
        Dim servings = ServingsTxt.Text
        Dim description = DescriptionTxt.Text
        Dim imagePath = ImagePathHidden.Value

        If String.IsNullOrEmpty(itemId) Then
            ShowAlert("Please select a menu item to edit!")
            Return
        End If

        If String.IsNullOrEmpty(name) Then
            ShowAlert("Menu item name cannot be empty!")
            Return
        End If

        If String.IsNullOrEmpty(price) Then
            ShowAlert("Price cannot be empty!")
            Return
        End If

        If String.IsNullOrEmpty(categoryId) Then
            ShowAlert("Please select a category!")
            Return
        End If

        If String.IsNullOrEmpty(typeId) Then
            ShowAlert("Please select a type!")
            Return
        End If

        ' Get category and type names for backward compatibility
        Dim categoryName = CategoryDdl.SelectedItem.Text
        Dim typeName = TypeDdl.SelectedItem.Text

        Try
            ' Try to update with no_of_serving column
            Dim query = "UPDATE menu SET name = @name, price = @price, category_id = @category_id, type_id = @type_id, " & _
                        "category = @category, type = @type, availability = @availability, no_of_serving = @no_of_serving, " & _
                        "description = @description, image = @image WHERE item_id = @item_id"

            Connect.AddParam("@name", name)
            Connect.AddParam("@price", price)
            Connect.AddParam("@category_id", categoryId)
            Connect.AddParam("@type_id", typeId)
            Connect.AddParam("@category", categoryName)
            Connect.AddParam("@type", typeName)
            Connect.AddParam("@availability", availability)
            Connect.AddParam("@no_of_serving", servings)
            Connect.AddParam("@description", description)
            Connect.AddParam("@image", If(String.IsNullOrEmpty(imagePath), DBNull.Value, imagePath))
            Connect.AddParam("@item_id", itemId)

            Dim updateResult = Connect.Query(query)

            If updateResult Then
                ShowAlert("Menu Item Updated Successfully!")
            Else
                ShowAlert("Failed to Update Menu Item!")
            End If
        Catch ex As Exception
            ' If there's an error, try without no_of_serving column
            If ex.Message.Contains("no_of_serving") Then
                Try
                    Dim query = "UPDATE menu SET name = @name, price = @price, category_id = @category_id, type_id = @type_id, " & _
                                "category = @category, type = @type, availability = @availability, " & _
                                "description = @description, image = @image WHERE item_id = @item_id"

        Connect.AddParam("@name", name)
        Connect.AddParam("@price", price)
                    Connect.AddParam("@category_id", categoryId)
                    Connect.AddParam("@type_id", typeId)
                    Connect.AddParam("@category", categoryName)
                    Connect.AddParam("@type", typeName)
        Connect.AddParam("@availability", availability)
                    Connect.AddParam("@description", description)
                    Connect.AddParam("@image", If(String.IsNullOrEmpty(imagePath), DBNull.Value, imagePath))
                    Connect.AddParam("@item_id", itemId)

                    Dim updateResult = Connect.Query(query)

        If updateResult Then
                        ShowAlert("Menu Item Updated Successfully! (Note: Servings field was not saved due to database schema issue)")
                    Else
                        ShowAlert("Failed to Update Menu Item!")
                    End If
                Catch innerEx As Exception
                    ShowAlert("Error: " & innerEx.Message)
                End Try
            Else
                ShowAlert("Error: " & ex.Message)
        End If
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

        ' Check if menu item is in use in orders
        ' This would require a check against order_items table if you have one
        ' For now, we'll just delete the item

        Dim query = "DELETE FROM menu WHERE item_id = @item_id"
        Connect.AddParam("@item_id", itemId)

        Dim deleteResult = Connect.Query(query)

        If deleteResult Then
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
                    MsgBox(uploadDirectory)
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
            ' Try with no_of_serving column
            Dim query = "SELECT m.*, mc.category_name, mt.type_name, " & _
                        "CASE WHEN m.availability = 1 THEN 'Available' ELSE 'Not Available' END as availability_text " & _
                        "FROM menu m " & _
                        "LEFT JOIN menu_categories mc ON m.category_id = mc.category_id " & _
                        "LEFT JOIN menu_types mt ON m.type_id = mt.type_id " & _
                        "ORDER BY m.name"

            Connect.Query(query)

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

            For Each row As DataRow In Connect.Data.Tables(0).Rows
                Dim tableRow As New TableRow()

                ' Use SafeGetString for all text values
                tableRow.Cells.Add(New TableCell() With {.Text = SafeGetString(row, "name")})
                tableRow.Cells.Add(New TableCell() With {.Text = SafeGetString(row, "price")})
                tableRow.Cells.Add(New TableCell() With {.Text = SafeGetString(row, "category_name")})
                tableRow.Cells.Add(New TableCell() With {.Text = SafeGetString(row, "type_name")})
                tableRow.Cells.Add(New TableCell() With {.Text = SafeGetString(row, "availability_text", "Not Available")})
                tableRow.Cells.Add(New TableCell() With {.Text = SafeGetString(row, "no_of_serving")})
                
                ' Create image cell
                Dim imageCell As New TableCell()
                Dim imagePath = SafeGetString(row, "image")
                If Not String.IsNullOrEmpty(imagePath) Then
                    Dim img As New System.Web.UI.WebControls.Image()
                    img.ImageUrl = imagePath
                    img.Width = Unit.Pixel(50)
                    img.Height = Unit.Pixel(50)
                    imageCell.Controls.Add(img)
                Else
                    imageCell.Text = "No Image"
                End If
                tableRow.Cells.Add(imageCell)

                ' Add data attributes for JavaScript using SafeGetString
                tableRow.Attributes.Add("data-item_id", SafeGetString(row, "item_id"))
                tableRow.Attributes.Add("data-category_id", SafeGetString(row, "category_id"))
                tableRow.Attributes.Add("data-type_id", SafeGetString(row, "type_id"))
                tableRow.Attributes.Add("data-description", SafeGetString(row, "description"))
                tableRow.Attributes.Add("data-image", SafeGetString(row, "image"))
                
                Table1.Rows.Add(tableRow)
            Next
        Catch ex As Exception
            ' If there's an error, try without no_of_serving column
            If ex.Message.Contains("no_of_serving") Then
                Try
                    Dim query = "SELECT m.*, mc.category_name, mt.type_name, " & _
                                "CASE WHEN m.availability = 1 THEN 'Available' ELSE 'Not Available' END as availability_text " & _
                                "FROM menu m " & _
                                "LEFT JOIN menu_categories mc ON m.category_id = mc.category_id " & _
                                "LEFT JOIN menu_types mt ON m.type_id = mt.type_id " & _
                                "ORDER BY m.name"

        Connect.Query(query)

        Table1.Rows.Clear()

                    ' Add header row
                    Dim headerRow As New TableRow()
                    headerRow.Cells.Add(New TableCell() With {.Text = "Name"})
                    headerRow.Cells.Add(New TableCell() With {.Text = "Price"})
                    headerRow.Cells.Add(New TableCell() With {.Text = "Category"})
                    headerRow.Cells.Add(New TableCell() With {.Text = "Type"})
                    headerRow.Cells.Add(New TableCell() With {.Text = "Availability"})
                    headerRow.Cells.Add(New TableCell() With {.Text = "Image"})
        Table1.Rows.Add(headerRow)

        For Each row As DataRow In Connect.Data.Tables(0).Rows
            Dim tableRow As New TableRow()

                        ' Use SafeGetString for all text values
                        tableRow.Cells.Add(New TableCell() With {.Text = SafeGetString(row, "name")})
                        tableRow.Cells.Add(New TableCell() With {.Text = SafeGetString(row, "price")})
                        tableRow.Cells.Add(New TableCell() With {.Text = SafeGetString(row, "category_name")})
                        tableRow.Cells.Add(New TableCell() With {.Text = SafeGetString(row, "type_name")})
                        tableRow.Cells.Add(New TableCell() With {.Text = SafeGetString(row, "availability_text", "Not Available")})
                        
                        ' Create image cell
                        Dim imageCell As New TableCell()
                        Dim imagePath = SafeGetString(row, "image")
                        If Not String.IsNullOrEmpty(imagePath) Then
                            Dim img As New System.Web.UI.WebControls.Image()
                            img.ImageUrl = imagePath
                            img.Width = Unit.Pixel(50)
                            img.Height = Unit.Pixel(50)
                            imageCell.Controls.Add(img)
                        Else
                            imageCell.Text = "No Image"
                        End If
                        tableRow.Cells.Add(imageCell)

                        ' Add data attributes for JavaScript using SafeGetString
                        tableRow.Attributes.Add("data-item_id", SafeGetString(row, "item_id"))
                        tableRow.Attributes.Add("data-category_id", SafeGetString(row, "category_id"))
                        tableRow.Attributes.Add("data-type_id", SafeGetString(row, "type_id"))
                        tableRow.Attributes.Add("data-description", SafeGetString(row, "description"))
                        tableRow.Attributes.Add("data-image", SafeGetString(row, "image"))
                        
            Table1.Rows.Add(tableRow)
        Next

                    ' Show a message to the user about the missing column
                    ShowAlert("Note: The 'Servings' column is missing from the database. Please run the SQL script to add it.")
                Catch innerEx As Exception
                    ShowAlert("Error loading menu items: " & innerEx.Message)
                End Try
            Else
                ShowAlert("Error loading menu items: " & ex.Message)
            End If
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

    Private Sub ShowAlert(ByVal message As String)
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
    End Sub

    ' Add helper function at the top of the class
    Private Function SafeGetString(ByVal row As DataRow, ByVal columnName As String, Optional ByVal defaultValue As String = "") As String
        Try
            If row Is Nothing OrElse IsDBNull(row(columnName)) Then
                Return defaultValue
            End If
            Return row(columnName).ToString()
        Catch ex As Exception
            Return defaultValue
        End Try
    End Function
End Class
