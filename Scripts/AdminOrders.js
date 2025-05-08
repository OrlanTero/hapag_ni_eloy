// Admin Orders JavaScript

// Document ready function
document.addEventListener('DOMContentLoaded', function() {
    // Initialize the page
    setupViewDetailsButtons();
    ensureVerifyButtonsExist();
    setupEventListeners();
});

// Setup view details buttons
function setupViewDetailsButtons() {
    document.querySelectorAll('.view-details-btn').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Get order ID from the button's command argument
            const orderId = this.getAttribute('data-order-id') || 
                            this.getAttribute('CommandArgument');
            
            if (orderId) {
                toggleOrderDetails(orderId);
            }
        });
    });
}

// Toggle order details visibility
function toggleOrderDetails(orderId) {
    const detailsContainer = document.querySelector(`.details-for-${orderId}`);
    if (detailsContainer) {
        if (detailsContainer.style.display === 'none' || !detailsContainer.style.display) {
            detailsContainer.style.display = 'block';
        } else {
            detailsContainer.style.display = 'none';
        }
    }
}

// Set up event listeners
function setupEventListeners() {
    // Close modal buttons
    document.querySelectorAll('.close-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            const modalId = this.closest('.modal').id;
            document.getElementById(modalId).style.display = 'none';
        });
    });
    
    // Cancel buttons in modals
    document.querySelectorAll('.btn-secondary').forEach(function(btn) {
        btn.addEventListener('click', function() {
            const modalId = this.closest('.modal').id;
            document.getElementById(modalId).style.display = 'none';
        });
    });
    
    // Click outside modal to close
    window.addEventListener('click', function(e) {
        document.querySelectorAll('.modal').forEach(function(modal) {
            if (e.target === modal) {
                modal.style.display = 'none';
            }
        });
    });
}

// Ensure verify buttons exist and are properly configured
function ensureVerifyButtonsExist() {
    console.log("Ensuring verify buttons exist");
    try {
        const buttons = document.querySelectorAll(".btn-verify-direct");
        console.log("Found " + buttons.length + " buttons");
        
        buttons.forEach(function(btn) {
            btn.style.display = "inline-block";
            btn.style.visibility = "visible";
            btn.style.opacity = "1";
            
            const hasHandler = btn.getAttribute("onclick") && 
                              btn.getAttribute("onclick").indexOf("showVerificationModal") !== -1;
            
            if (!hasHandler) {
                const handler = "try { " +
                              "var oid = this.getAttribute('data-order-id'); " +
                              "var tid = this.getAttribute('data-transaction-id'); " + 
                              "window.showVerificationModal(oid, tid); " +
                              "return false; " +
                              "} catch(e) { " +
                              "alert('Error: ' + e.message); " +
                              "return false; " +
                              "}";
                
                btn.setAttribute("onclick", handler);
                console.log("Added handler to button");
            }
        });
    } catch (err) {
        console.error("Error in ensureVerifyButtonsExist:", err);
    }
}

// Print receipt function
function printReceipt(orderId, customerName, totalAmount, orderDate) {
    try {
        // First try to open the popup window
        const receiptWindow = window.open('', 'ReceiptWindow', 'width=400,height=600');
        
        // Check if the popup was blocked
        if (!receiptWindow || receiptWindow.closed || typeof receiptWindow.closed === 'undefined') {
            console.warn("Popup was blocked. Falling back to direct page navigation.");
            // Fallback: Open the standalone receipt page
            window.open('Receipt.aspx?orderId=' + orderId, '_blank');
            return;
        }
        
        // Continue with popup-based receipt
        receiptWindow.document.write("<!DOCTYPE html><html><head>");
        receiptWindow.document.write("<title>Order Receipt</title>");
        receiptWindow.document.write("<meta charset='utf-8'>");
        receiptWindow.document.write("<style>");
        receiptWindow.document.write("@media print {");
        receiptWindow.document.write("  body { margin: 0; padding: 0; color: #000; background-color: #fff; font-family: Arial, sans-serif; font-size: 12pt; }");
        receiptWindow.document.write("  .receipt { width: 100%; max-width: 80mm; margin: 0 auto; }");
        receiptWindow.document.write("}");
        receiptWindow.document.write("body { margin: 0; padding: 10px; font-family: Arial, sans-serif; font-size: 12pt; }");
        receiptWindow.document.write(".receipt { width: 100%; max-width: 80mm; margin: 0 auto; }");
        receiptWindow.document.write(".header { text-align: center; margin-bottom: 10px; }");
        receiptWindow.document.write(".logo { font-weight: bold; font-size: 20px; margin-bottom: 5px; }");
        receiptWindow.document.write(".address, .contact { font-size: 12px; margin-bottom: 5px; }");
        receiptWindow.document.write(".divider { border-bottom: 1px dashed #000; margin: 10px 0; }");
        receiptWindow.document.write(".order-info { font-size: 14px; margin-bottom: 10px; }");
        receiptWindow.document.write(".items { width: 100%; border-collapse: collapse; font-size: 12px; }");
        receiptWindow.document.write(".items th, .items td { padding: 3px; text-align: left; vertical-align: top; }");
        receiptWindow.document.write(".items .qty { text-align: center; width: 40px; }");
        receiptWindow.document.write(".items .price, .items .amount { text-align: right; width: 60px; }");
        receiptWindow.document.write(".total { text-align: right; font-weight: bold; margin: 10px 0; font-size: 16px; }");
        receiptWindow.document.write(".footer { text-align: center; font-size: 12px; margin-top: 15px; }");
        receiptWindow.document.write("</style>");
        receiptWindow.document.write("</head><body>");
        
        // Receipt Content
        receiptWindow.document.write("<div class='receipt'>");
        
        // Header
        receiptWindow.document.write("<div class='header'>");
        receiptWindow.document.write("<div class='logo'>Hapag Restaurant</div>");
        receiptWindow.document.write("<div class='address'>123 Hapag Food Corporation, Manila, Philippines</div>");
        receiptWindow.document.write("<div class='contact'>Tel: (123) 456-7890</div>");
        receiptWindow.document.write("</div>");
        
        receiptWindow.document.write("<div class='divider'></div>");
        
        // Order Information
        receiptWindow.document.write("<div class='order-info'>");
        receiptWindow.document.write("<div><strong>Order #:</strong> " + orderId + "</div>");
        receiptWindow.document.write("<div><strong>Customer:</strong> " + customerName + "</div>");
        receiptWindow.document.write("<div><strong>Date:</strong> " + orderDate + "</div>");
        receiptWindow.document.write("</div>");
        
        receiptWindow.document.write("<div class='divider'></div>");
        
        // Items Table
        receiptWindow.document.write("<table class='items'>");
        receiptWindow.document.write("<thead><tr><th>Item</th><th class='qty'>Qty</th><th class='price'>Price</th><th class='amount'>Amount</th></tr></thead>");
        receiptWindow.document.write("<tbody id='receipt-items'><tr><td colspan='4'>Loading items...</td></tr></tbody>");
        receiptWindow.document.write("</table>");
        
        receiptWindow.document.write("<div class='divider'></div>");
        
        // Total
        receiptWindow.document.write("<div class='total'>Total: PHP " + totalAmount + "</div>");
        
        receiptWindow.document.write("<div class='divider'></div>");
        
        // Footer
        receiptWindow.document.write("<div class='footer'>");
        receiptWindow.document.write("<p>Thank you for dining with us!</p>");
        receiptWindow.document.write("</div>");
        
        receiptWindow.document.write("</body></html>");

        // Load items via AJAX
        const xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        const itemsContainer = receiptWindow.document.getElementById("receipt-items");
                        if (itemsContainer) {
                            // Try to parse JSON if the response starts with [ or {
                            const responseText = xhr.responseText.trim();
                            if ((responseText.startsWith('[') && responseText.endsWith(']')) || 
                                (responseText.startsWith('{') && responseText.endsWith('}'))) {
                                try {
                                    // Fix for malformed JSON: Remove any trailing brackets/braces
                                    let cleanText = responseText;
                                    cleanText = cleanText.replace(/\]\[\]/g, ''); // Remove empty array concat like [][]
                                    cleanText = cleanText.replace(/\]\[/g, ',');  // Replace ][ with comma for concat arrays
                                    
                                    const items = JSON.parse(cleanText);
                                    let itemsHtml = '';
                                    
                                    // Check if it's an array of items
                                    if (Array.isArray(items)) {
                                        items.forEach(item => {
                                            const name = item.name || '';
                                            const quantity = item.quantity || 0;
                                            const price = parseFloat(item.price) || 0.0;
                                            const subtotal = price * quantity;
                                            
                                            itemsHtml += `<tr>
                                                <td>${name}</td>
                                                <td class="qty">${quantity}</td>
                                                <td class="price">${price.toFixed(2)}</td>
                                                <td class="amount">${subtotal.toFixed(2)}</td>
                                            </tr>`;
                                        });
                                    } else if (typeof items === 'object') {
                                        // Handle single item case
                                        const name = items.name || '';
                                        const quantity = items.quantity || 0;
                                        const price = parseFloat(items.price) || 0.0;
                                        const subtotal = price * quantity;
                                        
                                        itemsHtml += `<tr>
                                            <td>${name}</td>
                                            <td class="qty">${quantity}</td>
                                            <td class="price">${price.toFixed(2)}</td>
                                            <td class="amount">${subtotal.toFixed(2)}</td>
                                        </tr>`;
                                    }
                                    
                                    // If we have generated HTML, use it; otherwise fall back to the response text
                                    if (itemsHtml) {
                                        itemsContainer.innerHTML = itemsHtml;
                                    } else {
                                        console.error("No items to display. Raw response:", responseText);
                                        itemsContainer.innerHTML = "<tr><td colspan='4'>No items found. Please check the order.</td></tr>";
                                    }
                                } catch (jsonError) {
                                    console.error("Error parsing JSON:", jsonError, "Raw response:", responseText);
                                    // Try to extract JSON inside brackets if the response contains literal JSON string
                                    const jsonMatch = responseText.match(/\[(.*)\]/);
                                    if (jsonMatch && jsonMatch[0]) {
                                        try {
                                            const extractedJson = JSON.parse(jsonMatch[0]);
                                            let itemsHtml = '';
                                            
                                            if (Array.isArray(extractedJson)) {
                                                extractedJson.forEach(item => {
                                                    const name = item.name || '';
                                                    const quantity = item.quantity || 0;
                                                    const price = parseFloat(item.price) || 0.0;
                                                    const subtotal = price * quantity;
                                                    
                                                    itemsHtml += `<tr>
                                                        <td>${name}</td>
                                                        <td class="qty">${quantity}</td>
                                                        <td class="price">${price.toFixed(2)}</td>
                                                        <td class="amount">${subtotal.toFixed(2)}</td>
                                                    </tr>`;
                                                });
                                                
                                                if (itemsHtml) {
                                                    itemsContainer.innerHTML = itemsHtml;
                                                } else {
                                                    itemsContainer.innerHTML = "<tr><td colspan='4'>No items found in extracted JSON.</td></tr>";
                                                }
                                            } else {
                                                itemsContainer.innerHTML = "<tr><td colspan='4'>Invalid items format in extracted JSON.</td></tr>";
                                            }
                                        } catch (extractError) {
                                            // Failed to extract JSON, display formatted response as HTML
                                            console.error("Error extracting inner JSON:", extractError);
                                            itemsContainer.innerHTML = formatResponseAsHtml(responseText);
                                        }
                                    } else {
                                        // No JSON found, format as HTML
                                        itemsContainer.innerHTML = formatResponseAsHtml(responseText);
                                    }
                                }
                            } else {
                                // Not JSON, format the response as HTML
                                itemsContainer.innerHTML = formatResponseAsHtml(responseText);
                            }
                            
                            // Automatically print once content is loaded
                            setTimeout(function() {
                                receiptWindow.print();
                            }, 500);
                        }
                    } catch (err) {
                        console.error("Error updating receipt content:", err);
                        alert("Error updating receipt content. The popup may have been closed. Trying fallback method...");
                        // Fallback to standalone receipt page if an error occurs
                        window.open('Receipt.aspx?orderId=' + orderId, '_blank');
                    }
                } else {
                    console.error("Failed to load receipt items. Status:", xhr.status);
                    try {
                        receiptWindow.document.getElementById("receipt-items").innerHTML = 
                            "<tr><td colspan='4'>Failed to load items. Please try again.</td></tr>";
                    } catch (e) {
                        console.error("Could not update receipt window:", e);
                        // Fallback to standalone receipt page if an error occurs
                        window.open('Receipt.aspx?orderId=' + orderId, '_blank');
                    }
                }
            }
        };
        xhr.open("GET", "PrintReceiptItems.aspx?orderId=" + orderId + "&format=json", true);
        xhr.send();
    } catch (e) {
        console.error("Error printing receipt:", e);
        alert("Error printing receipt: " + e.message + "\n\nFalling back to standalone receipt page.");
        // Fallback to standalone receipt page if an error occurs
        window.open('Receipt.aspx?orderId=' + orderId, '_blank');
    }
}

// Helper function to format response text as HTML table rows
function formatResponseAsHtml(responseText) {
    // Check if the response contains literal JSON (like "[{...}][]")
    if (responseText.includes('"name"') && responseText.includes('"quantity"') && responseText.includes('"price"')) {
        try {
            // Clean up the response by removing empty array brackets and other noise
            responseText = responseText.replace(/\]\[\]/g, '');
            
            // If we have an array-like structure, try to extract items
            const lines = responseText.split('\n');
            let itemsHtml = '';
            
            for (const line of lines) {
                if (line.includes('"name"')) {
                    // Try to extract item information using regex
                    const nameMatch = line.match(/"name":"([^"]+)"/);
                    const quantityMatch = line.match(/"quantity":(\d+)/);
                    const priceMatch = line.match(/"price":(\d+(?:\.\d+)?)/);
                    
                    if (nameMatch && quantityMatch && priceMatch) {
                        const name = nameMatch[1];
                        const quantity = parseInt(quantityMatch[1]);
                        const price = parseFloat(priceMatch[1]);
                        const subtotal = price * quantity;
                        
                        itemsHtml += `<tr>
                            <td>${name}</td>
                            <td class="qty">${quantity}</td>
                            <td class="price">${price.toFixed(2)}</td>
                            <td class="amount">${subtotal.toFixed(2)}</td>
                        </tr>`;
                    }
                }
            }
            
            if (itemsHtml) {
                return itemsHtml;
            }
        } catch (e) {
            console.error("Error in formatResponseAsHtml:", e);
        }
    }
    
    // Default fallback: format as plain text in a single row
    return `<tr><td colspan="4">${responseText}</td></tr>`;
} 