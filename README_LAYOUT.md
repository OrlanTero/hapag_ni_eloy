# Website Layout Improvements

## Overview

This update introduces a new layout system for the Food Ordering System (FOS) website. The changes focus on improving the visual consistency, responsiveness, and user experience across all pages.

## Key Changes

1. **New Layout.css File**
   - Created a centralized layout system in `StyleSheets/Layout.css`
   - Implemented responsive design for all screen sizes
   - Added modern UI components and consistent spacing

2. **Improved Admin Interface**
   - Redesigned sidebar navigation with better visual feedback
   - Created a consistent content container system
   - Added responsive tables and forms
   - Implemented mobile-friendly navigation

3. **New Alert System**
   - Added styled alert messages (success, warning, error, info)
   - Replaced JavaScript alerts with in-page notifications

4. **Template System**
   - Created `AdminTemplate.aspx` as a base template for all admin pages
   - Added a standardized code-behind file with helper methods
   - Simplified the process of creating new admin pages

## How to Use

### For Existing Pages

To update an existing page to use the new layout:

1. Add the Layout.css reference to your page:
   ```html
   <link href="./../../StyleSheets/Layout.css" rel="stylesheet" type="text/css" />
   ```

2. Update your page structure to match the template:
   ```html
   <div class="page-container">
       <!-- Admin Sidebar -->
       <div class="admin-sidebar">
           <!-- Sidebar content -->
       </div>
       
       <!-- Main Content -->
       <div class="main-content">
           <!-- Content containers -->
       </div>
   </div>
   ```

3. Update your code-behind file to use the new alert system:
   ```vb
   Protected Sub ShowAlert(ByVal message As String)
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
   ```

### For New Pages

For new admin pages:

1. Copy `AdminTemplate.aspx` and `AdminTemplate.aspx.vb`
2. Rename the files to your desired page name
3. Update the class name and inheritance in the code-behind file
4. Add your specific content to the template

## CSS Classes Reference

### Layout Classes

- `.page-container` - Main container for the entire page
- `.admin-sidebar` - Sidebar navigation container
- `.main-content` - Main content area
- `.content-container` - Container for content sections
- `.content-header` - Header for content sections

### Form Classes

- `.form-container` - Container for forms
- `.form-row` - Row in a form (uses flexbox)
- `.form-group` - Full-width form group
- `.form-group-half` - Half-width form group

### Alert Classes

- `.alert-message` - Base class for alerts
- `.alert-success` - Success message (green)
- `.alert-warning` - Warning message (yellow)
- `.alert-danger` - Error message (red)
- `.alert-info` - Information message (blue)

### Table Classes

- `.table-responsive` - Makes tables responsive
- `.table-container` - Container for tables

## Responsive Breakpoints

- **Large screens**: 992px and above
- **Medium screens**: 768px to 991px
- **Small screens**: 576px to 767px
- **Extra small screens**: Below 576px

## Browser Compatibility

The new layout has been tested and works well in:
- Google Chrome (latest)
- Mozilla Firefox (latest)
- Microsoft Edge (latest)
- Safari (latest)

## Future Improvements

- Add dark mode support
- Implement more interactive UI components
- Create a user-side template system
- Add more animation and transitions 