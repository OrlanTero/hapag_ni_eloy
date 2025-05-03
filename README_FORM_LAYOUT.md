# Form Layout Improvements

## Overview

This update enhances the form layout system for the Food Ordering System (FOS) website. The changes focus on improving form alignment, spacing, and overall visual consistency across all forms in the application.

## Key Improvements

1. **Enhanced Form Container**
   - Added proper padding and background color
   - Improved border radius for a modern look
   - Consistent spacing between form elements

2. **Flexible Grid System**
   - Implemented a responsive grid system for form fields
   - Added support for different column widths (full, half, third, quarter)
   - Improved alignment of form labels and inputs

3. **Standardized Form Controls**
   - Created consistent styling for all form inputs
   - Added proper focus states for better accessibility
   - Standardized heights and padding for all form elements

4. **Improved Button Layout**
   - Created a dedicated form actions section
   - Added consistent button styling
   - Improved button spacing and alignment

5. **Enhanced Table Styling**
   - Added striped rows for better readability
   - Improved header styling
   - Added hover effects for better user interaction

## How to Use

### Basic Form Structure

```html
<div class="form-container">
    <!-- Form rows -->
    <div class="form-row">
        <!-- Form groups -->
        <div class="form-group-half">
            <h3>Label:</h3>
            <input type="text" class="form-control" />
        </div>
        <div class="form-group-half">
            <h3>Another Label:</h3>
            <input type="text" class="form-control" />
        </div>
    </div>
    
    <!-- Form actions -->
    <div class="form-actions">
        <button type="button" class="btn btn-primary">Save</button>
        <button type="button" class="btn btn-secondary">Edit</button>
    </div>
</div>
```

### Available Column Widths

- `form-group` - Full width (100%)
- `form-group-half` - Half width (50%)
- `form-group-third` - One-third width (33.33%)
- `form-group-quarter` - Quarter width (25%)

### Button Styles

- `btn btn-primary` - Green button (for primary actions)
- `btn btn-secondary` - Yellow button (for secondary actions)
- `btn btn-danger` - Red button (for destructive actions)
- `btn btn-info` - Blue button (for informational actions)

### Table Styles

- `table` - Basic table styling
- `table-striped` - Adds zebra-striping to table rows
- `table-hover` - Adds hover effect to table rows
- `table-bordered` - Adds borders to all sides of table cells

## Examples

### Two-Column Form

```html
<div class="form-container">
    <div class="form-row">
        <div class="form-group-half">
            <h3>First Name:</h3>
            <input type="text" class="form-control" />
        </div>
        <div class="form-group-half">
            <h3>Last Name:</h3>
            <input type="text" class="form-control" />
        </div>
    </div>
</div>
```

### Three-Column Form

```html
<div class="form-container">
    <div class="form-row">
        <div class="form-group-third">
            <h3>Day:</h3>
            <select class="form-control">
                <!-- Options -->
            </select>
        </div>
        <div class="form-group-third">
            <h3>Month:</h3>
            <select class="form-control">
                <!-- Options -->
            </select>
        </div>
        <div class="form-group-third">
            <h3>Year:</h3>
            <select class="form-control">
                <!-- Options -->
            </select>
        </div>
    </div>
</div>
```

### Form with Image Upload

```html
<div class="form-container">
    <div class="form-row">
        <div class="form-group">
            <h3>Image:</h3>
            <div class="image-upload-container">
                <div class="image-preview">
                    <img src="..." alt="Preview" />
                </div>
                <div class="file-upload">
                    <input type="file" class="form-control" />
                    <button type="button" class="btn btn-info">Upload</button>
                </div>
            </div>
        </div>
    </div>
</div>
```

## Responsive Behavior

The form layout system is fully responsive:

- On large screens (992px+), all columns display as defined
- On medium screens (768px-991px), quarter columns become half columns
- On small screens (576px-767px), half and third columns become full width
- On extra small screens (<576px), all columns become full width

## Accessibility Considerations

- All form controls have proper focus states
- Labels are properly associated with form controls
- Color contrast meets WCAG 2.1 AA standards
- Form elements have appropriate sizing for touch targets 