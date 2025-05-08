// Payment Verification JavaScript

// Define showVerificationModal in the global scope
window.showVerificationModal = function(orderId, transactionId) {
    console.log("SHOW VERIFICATION MODAL - Order ID:", orderId, "Transaction ID:", transactionId);
    
    try {
        // Try to convert to integers (if they're strings)
        orderId = parseInt(orderId);
        transactionId = parseInt(transactionId);
        
        if (isNaN(orderId) || isNaN(transactionId)) {
            console.error("Invalid order ID or transaction ID:", orderId, transactionId);
            alert("Error: Invalid order ID or transaction ID");
            return;
        }
        
        // Ensure hidden fields exist
        var fields = ensureHiddenFields();
        var orderIdField = fields.orderIdField;
        var transactionIdField = fields.transactionIdField;
        
        // Set hidden field values
        if (orderIdField && transactionIdField) {
            orderIdField.value = orderId;
            transactionIdField.value = transactionId;
            console.log("Set hidden fields - Order ID:", orderId, "Transaction ID:", transactionId);
        } else {
            console.error("Hidden fields not found - OrderID:", !!orderIdField, "TransactionID:", !!transactionIdField);
            alert("Error: Hidden fields not found. Please refresh the page and try again.");
            return;
        }
        
        // Try to get the order data from the DOM first
        var orderData = getOrderDataFromDOM(orderId);
        
        // Option 1: Try to display the existing modal
        var modal = document.getElementById('PaymentVerificationModal');
        if (modal) {
            console.log("Found modal, setting display to block");
            
            // If we have order data from the DOM, populate the modal
            if (orderData) {
                updateModalContent(
                    orderId,
                    orderData.customerName,
                    orderData.totalAmount,
                    orderData.paymentMethod,
                    orderData.referenceNumber,
                    orderData.senderName,
                    orderData.senderNumber,
                    orderData.transactionDate,
                    orderData.transactionStatus
                );
            }
            
            // Make sure modal is in the right place and visible
            if (!document.body.contains(modal)) {
                console.log("Moving modal to document body");
                document.body.appendChild(modal);
            }
            
            // Force modal to be visible with important styles
            modal.style.cssText = "display: block !important; position: fixed !important; z-index: 9999 !important; top: 0 !important; left: 0 !important; right: 0 !important; bottom: 0 !important; background: rgba(0,0,0,0.5) !important; padding: 50px !important;";
            
            console.log("Modal should now be visible");
            
            // Set a timeout to check if modal is visible
            setTimeout(function() {
                if (window.getComputedStyle(modal).display !== 'block') {
                    console.error("Modal still not visible, trying direct style application");
                    
                    // Try to reset all possible hiding styles
                    modal.style.cssText = "display: block !important; visibility: visible !important; opacity: 1 !important; position: fixed !important; z-index: 9999 !important; top: 0 !important; left: 0 !important; right: 0 !important; bottom: 0 !important; background: rgba(0,0,0,0.5) !important; padding: 50px !important;";
                    
                    // If still not visible, try to create a new modal
                    if (window.getComputedStyle(modal).display !== 'block') {
                        console.error("Modal still not visible after retrying, creating fallback");
                        createFallbackModal(orderId, transactionId, orderData);
                    }
                } else {
                    console.log("Modal is visible, verification can proceed");
                }
            }, 100);
        } else {
            console.error("Verification modal element not found");
            createFallbackModal(orderId, transactionId, orderData);
        }
    } catch (err) {
        console.error("Error in showVerificationModal:", err);
        alert("An error occurred while trying to show the payment verification modal: " + err.message);
    }
};

// Helper function to extract order data from the DOM
function getOrderDataFromDOM(orderId) {
    console.log("Attempting to extract order data from DOM for Order ID:", orderId);
    
    try {
        // Find the order card that matches this order ID
        var orderCards = document.querySelectorAll('.order-card');
        for (var i = 0; i < orderCards.length; i++) {
            var card = orderCards[i];
            var orderIdEl = card.querySelector('.order-id');
            
            if (orderIdEl) {
                var idText = orderIdEl.textContent.trim();
                var idMatch = idText.match(/\d+/);
                var cardOrderId = idMatch ? idMatch[0] : null;
                
                if (cardOrderId == orderId) {
                    console.log("Found matching order card for Order ID:", orderId);
                    
                    // Extract customer name
                    var customerName = "";
                    var customerEl = card.querySelector('.info-value');
                    if (customerEl) {
                        customerName = customerEl.textContent.trim();
                    }
                    
                    // Extract total amount
                    var totalAmount = "";
                    var totalEls = card.querySelectorAll('.info-label');
                    for (var j = 0; j < totalEls.length; j++) {
                        if (totalEls[j].textContent.includes('Total Amount:')) {
                            var valueEl = totalEls[j].nextElementSibling;
                            if (valueEl) {
                                totalAmount = valueEl.textContent.replace('PHP', '').trim();
                            }
                            break;
                        }
                    }
                    
                    // Extract payment method
                    var paymentMethod = "GCash";
                    var methodEls = card.querySelectorAll('.info-label');
                    for (var j = 0; j < methodEls.length; j++) {
                        if (methodEls[j].textContent.includes('Payment Method:')) {
                            var valueEl = methodEls[j].nextElementSibling;
                            if (valueEl) {
                                paymentMethod = valueEl.textContent.trim();
                            }
                            break;
                        }
                    }
                    
                    // Extract reference number
                    var referenceNumber = "Not provided";
                    var refEls = card.querySelectorAll('.info-label');
                    for (var j = 0; j < refEls.length; j++) {
                        if (refEls[j].textContent.includes('Reference Number:')) {
                            var valueEl = refEls[j].nextElementSibling;
                            if (valueEl) {
                                referenceNumber = valueEl.textContent.trim();
                            }
                            break;
                        }
                    }
                    
                    // Extract sender name
                    var senderName = "Not provided";
                    var nameEls = card.querySelectorAll('.info-label');
                    for (var j = 0; j < nameEls.length; j++) {
                        if (nameEls[j].textContent.includes('Sender Name:')) {
                            var valueEl = nameEls[j].nextElementSibling;
                            if (valueEl) {
                                senderName = valueEl.textContent.trim();
                            }
                            break;
                        }
                    }
                    
                    // Extract sender number
                    var senderNumber = "Not provided";
                    var numberEls = card.querySelectorAll('.info-label');
                    for (var j = 0; j < numberEls.length; j++) {
                        if (numberEls[j].textContent.includes('Sender Number:')) {
                            var valueEl = numberEls[j].nextElementSibling;
                            if (valueEl) {
                                senderNumber = valueEl.textContent.trim();
                            }
                            break;
                        }
                    }
                    
                    // Extract transaction date and status if available
                    var transactionDate = "-";
                    var transactionStatus = "Pending Verification";
                    
                    var statusEls = card.querySelectorAll('.info-label');
                    for (var j = 0; j < statusEls.length; j++) {
                        if (statusEls[j].textContent.includes('Payment Status:')) {
                            var valueEl = statusEls[j].nextElementSibling;
                            if (valueEl) {
                                transactionStatus = valueEl.textContent.trim();
                            }
                            break;
                        }
                    }
                    
                    return {
                        orderId: orderId,
                        customerName: customerName,
                        totalAmount: totalAmount,
                        paymentMethod: paymentMethod,
                        referenceNumber: referenceNumber,
                        senderName: senderName,
                        senderNumber: senderNumber,
                        transactionDate: transactionDate,
                        transactionStatus: transactionStatus
                    };
                }
            }
        }
        
        console.log("Could not find order data in DOM for Order ID:", orderId);
        return null;
    } catch (err) {
        console.error("Error extracting order data from DOM:", err);
        return null;
    }
}

// Function to ensure required hidden fields exist
function ensureHiddenFields() {
    console.log("Checking for required hidden fields");
    
    // Check for PaymentOrderId
    var orderIdField = document.getElementById('PaymentOrderId');
    if (!orderIdField) {
        console.log("Creating missing PaymentOrderId hidden field");
        orderIdField = document.createElement('input');
        orderIdField.type = 'hidden';
        orderIdField.id = 'PaymentOrderId';
        orderIdField.name = 'PaymentOrderId';
        document.body.appendChild(orderIdField);
    }
    
    // Check for PaymentTransactionId
    var transactionIdField = document.getElementById('PaymentTransactionId');
    if (!transactionIdField) {
        console.log("Creating missing PaymentTransactionId hidden field");
        transactionIdField = document.createElement('input');
        transactionIdField.type = 'hidden';
        transactionIdField.id = 'PaymentTransactionId';
        transactionIdField.name = 'PaymentTransactionId';
        document.body.appendChild(transactionIdField);
    }
    
    return {
        orderIdField: orderIdField,
        transactionIdField: transactionIdField
    };
}

// Function to create a fallback modal when the real one can't be shown
function createFallbackModal(orderId, transactionId, orderData) {
    console.warn("CREATING FALLBACK MODAL for Order:", orderId, "Transaction:", transactionId);
    
    var testModal = document.createElement('div');
    testModal.id = 'FallbackVerificationModal';
    testModal.style.cssText = "display: block; position: fixed; z-index: 10000; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); padding: 50px;";
    
    var modalContent = document.createElement('div');
    modalContent.style.cssText = "background: white; padding: 20px; border-radius: 5px; max-width: 600px; margin: 0 auto; position: relative;";
    
    var header = document.createElement('div');
    header.style.cssText = "margin-bottom: 20px; padding-bottom: 10px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;";
    header.innerHTML = '<h2 style="margin: 0; font-size: 20px; color: #333;">Payment Verification</h2>';
    
    var closeBtn = document.createElement('button');
    closeBtn.innerHTML = '&times;';
    closeBtn.style.cssText = "background: none; border: none; font-size: 24px; cursor: pointer; position: absolute; right: 15px; top: 10px;";
    closeBtn.onclick = function() { document.getElementById('FallbackVerificationModal').remove(); };
    
    // Create content based on available data
    var bodyContent = '';
    
    if (orderData) {
        // We have data, create a detailed view
        bodyContent = `
            <div style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px;">
                <h4 style="margin-top: 0; color: #333; font-size: 16px;">Order Information</h4>
                <p style="margin-bottom: 5px;"><strong>Order ID:</strong> ${orderId}</p>
                <p style="margin-bottom: 5px;"><strong>Customer:</strong> ${orderData.customerName}</p>
                <p style="margin-bottom: 5px;"><strong>Total Amount:</strong> PHP ${orderData.totalAmount}</p>
                    </div>
            
            <div style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px;">
                <h4 style="margin-top: 0; color: #333; font-size: 16px;">Payment Details</h4>
                <p style="margin-bottom: 5px;"><strong>Payment Method:</strong> ${orderData.paymentMethod}</p>
                <p style="margin-bottom: 5px;"><strong>Reference Number:</strong> ${orderData.referenceNumber}</p>
                <p style="margin-bottom: 5px;"><strong>Sender Name:</strong> ${orderData.senderName}</p>
                <p style="margin-bottom: 5px;"><strong>Sender Number:</strong> ${orderData.senderNumber}</p>
                <p style="margin-bottom: 5px;"><strong>Current Status:</strong> ${orderData.transactionStatus}</p>
                </div>
                
            <div style="margin-bottom: 20px; padding: 15px; background-color: #e8f4fe; border-radius: 5px; border-left: 4px solid #2196F3;">
                <h4 style="margin-top: 0; color: #0d47a1; font-size: 16px;">Verification</h4>
                    <p>Please verify the payment details before approving. Once approved, the order status will be updated and the order will be ready for processing.</p>
                </div>
        `;
    } else {
        // Basic info only
        bodyContent = `
            <div style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px;">
                <h4 style="margin-top: 0; color: #333; font-size: 16px;">Order Information</h4>
                <p style="margin-bottom: 5px;"><strong>Order ID:</strong> ${orderId}</p>
                <p style="margin-bottom: 5px;"><strong>Transaction ID:</strong> ${transactionId}</p>
            </div>
            
            <div style="margin-bottom: 20px; padding: 15px; background-color: #fff3cd; border-radius: 5px; border-left: 4px solid #ffc107;">
                <h4 style="margin-top: 0; color: #856404; font-size: 16px;">Emergency Verification</h4>
                <p>The normal verification modal could not be displayed with complete details. Please use the buttons below to verify or reject this payment.</p>
        </div>
        `;
    }
    
    var body = document.createElement('div');
    body.innerHTML = bodyContent;
    
    var footer = document.createElement('div');
    footer.style.cssText = "margin-top: 20px; text-align: right; padding-top: 15px; border-top: 1px solid #eee;";
    
    var confirmBtn = document.createElement('button');
    confirmBtn.innerText = 'Confirm Payment';
    confirmBtn.style.cssText = "padding: 8px 16px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px;";
    confirmBtn.onclick = function() {
        triggerServerConfirmPayment(orderId, transactionId);
        document.getElementById('FallbackVerificationModal').remove();
    };
    
    var rejectBtn = document.createElement('button');
    rejectBtn.innerText = 'Reject Payment';
    rejectBtn.style.cssText = "padding: 8px 16px; background: #dc3545; color: white; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px;";
    rejectBtn.onclick = function() {
        triggerServerRejectPayment(orderId, transactionId);
        document.getElementById('FallbackVerificationModal').remove();
    };
    
    var cancelBtn = document.createElement('button');
    cancelBtn.innerText = 'Cancel';
    cancelBtn.style.cssText = "padding: 8px 16px; background: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer;";
    cancelBtn.onclick = function() { document.getElementById('FallbackVerificationModal').remove(); };
    
    footer.appendChild(confirmBtn);
    footer.appendChild(rejectBtn);
    footer.appendChild(cancelBtn);
    
    modalContent.appendChild(closeBtn);
    modalContent.appendChild(header);
    modalContent.appendChild(body);
    modalContent.appendChild(footer);
    testModal.appendChild(modalContent);
    document.body.appendChild(testModal);
    
    console.log("Fallback modal created and displayed");
}

// Function to update modal content with data
function updateModalContent(orderId, customerName, totalAmount, paymentMethod, referenceNumber, senderName, senderNumber, transactionDate, transactionStatus) {
    console.log("Updating modal content with order data", {
        orderId: orderId,
        customerName: customerName,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        referenceNumber: referenceNumber,
        senderName: senderName,
        senderNumber: senderNumber,
        transactionDate: transactionDate,
        transactionStatus: transactionStatus
    });
    
    try {
        // Direct manual update of all fields in the modal
        var modal = document.getElementById('PaymentVerificationModal');
        if (!modal) {
            console.error("Modal not found!");
            return;
        }
        
        // Update each literal using querySelector within the modal
        // Order ID
        var orderIdLiteral = modal.querySelector('#OrderIdLiteral');
        if (orderIdLiteral) {
            orderIdLiteral.innerHTML = orderId || "N/A";
        } else {
            console.error("OrderIdLiteral not found");
        }
        
        // Customer Name
        var customerNameLiteral = modal.querySelector('#CustomerNameLiteral');
        if (customerNameLiteral) {
            customerNameLiteral.innerHTML = customerName || "N/A";
        } else {
            console.error("CustomerNameLiteral not found");
        }
        
        // Total Amount
        var orderAmountLiteral = modal.querySelector('#OrderAmountLiteral');
        if (orderAmountLiteral) {
            orderAmountLiteral.innerHTML = totalAmount || "0.00";
        } else {
            console.error("OrderAmountLiteral not found");
        }
        
        // Payment Method
        var paymentMethodLiteral = modal.querySelector('#PaymentMethodLiteral');
        if (paymentMethodLiteral) {
            paymentMethodLiteral.innerHTML = paymentMethod || "GCash";
        } else {
            console.error("PaymentMethodLiteral not found");
        }
        
        // Reference Number
        var referenceNumberLiteral = modal.querySelector('#ReferenceNumberLiteral');
        if (referenceNumberLiteral) {
            referenceNumberLiteral.innerHTML = referenceNumber || "Not provided";
        } else {
            console.error("ReferenceNumberLiteral not found");
        }
        
        // Sender Name
        var senderNameLiteral = modal.querySelector('#SenderNameLiteral');
        if (senderNameLiteral) {
            senderNameLiteral.innerHTML = senderName || "Not provided";
        } else {
            console.error("SenderNameLiteral not found");
        }
        
        // Sender Number
        var senderNumberLiteral = modal.querySelector('#SenderNumberLiteral');
        if (senderNumberLiteral) {
            senderNumberLiteral.innerHTML = senderNumber || "Not provided";
        } else {
            console.error("SenderNumberLiteral not found");
        }
        
        // Transaction Date
        var transactionDateLiteral = modal.querySelector('#TransactionDateLiteral');
        if (transactionDateLiteral) {
            transactionDateLiteral.innerHTML = transactionDate || "-";
        } else {
            console.error("TransactionDateLiteral not found");
        }
        
        // Transaction Status
        var transactionStatusLiteral = modal.querySelector('#TransactionStatusLiteral');
        if (transactionStatusLiteral) {
            transactionStatusLiteral.innerHTML = transactionStatus || "Pending Verification";
        } else {
            console.error("TransactionStatusLiteral not found");
        }
        
        console.log("Modal content updated successfully");
    } catch (err) {
        console.error("Error updating modal content:", err);
    }
}

// Function to trigger server-side actions
function triggerServerConfirmPayment(orderId, transactionId) {
    console.log("Triggering server confirm payment for Order ID:", orderId, "Transaction ID:", transactionId);
    
    try {
        // Create a hidden form to submit
        var form = document.createElement('form');
        form.method = 'post';
        form.action = window.location.href;
        
        // Set up the event target for ConfirmPaymentButton
        var eventTarget = document.createElement('input');
        eventTarget.type = 'hidden';
        eventTarget.name = '__EVENTTARGET';
        eventTarget.value = 'ConfirmPaymentButton';
        form.appendChild(eventTarget);
        
        // Add the order ID and transaction ID
        var orderIdInput = document.createElement('input');
        orderIdInput.type = 'hidden';
        orderIdInput.name = 'PaymentOrderId';
        orderIdInput.value = orderId;
        form.appendChild(orderIdInput);
        
        var transactionIdInput = document.createElement('input');
        transactionIdInput.type = 'hidden';
        transactionIdInput.name = 'PaymentTransactionId';
        transactionIdInput.value = transactionId;
        form.appendChild(transactionIdInput);
        
        // Get VIEWSTATE and any other hidden fields
        document.querySelectorAll('input[type="hidden"]').forEach(function(hiddenField) {
            if (hiddenField.name.startsWith('__')) {
                var clone = hiddenField.cloneNode(true);
                form.appendChild(clone);
            }
        });
        
        // Append the form to body, submit it, and remove it
        document.body.appendChild(form);
        form.submit();
    } catch (err) {
        console.error("Error triggering server confirm:", err);
        alert("Error confirming payment: " + err.message);
    }
}

function triggerServerRejectPayment(orderId, transactionId) {
    console.log("Triggering server reject payment for Order ID:", orderId, "Transaction ID:", transactionId);
    
    try {
        // Create a hidden form to submit
        var form = document.createElement('form');
        form.method = 'post';
        form.action = window.location.href;
        
        // Set up the event target for RejectPaymentButton
        var eventTarget = document.createElement('input');
        eventTarget.type = 'hidden';
        eventTarget.name = '__EVENTTARGET';
        eventTarget.value = 'RejectPaymentButton';
        form.appendChild(eventTarget);
        
        // Add the order ID and transaction ID
        var orderIdInput = document.createElement('input');
        orderIdInput.type = 'hidden';
        orderIdInput.name = 'PaymentOrderId';
        orderIdInput.value = orderId;
        form.appendChild(orderIdInput);
        
        var transactionIdInput = document.createElement('input');
        transactionIdInput.type = 'hidden';
        transactionIdInput.name = 'PaymentTransactionId';
        transactionIdInput.value = transactionId;
        form.appendChild(transactionIdInput);
        
        // Get VIEWSTATE and any other hidden fields
        document.querySelectorAll('input[type="hidden"]').forEach(function(hiddenField) {
            if (hiddenField.name.startsWith('__')) {
                var clone = hiddenField.cloneNode(true);
                form.appendChild(clone);
            }
        });
        
        // Append the form to body, submit it, and remove it
        document.body.appendChild(form);
        form.submit();
    } catch (err) {
        console.error("Error triggering server reject:", err);
        alert("Error rejecting payment: " + err.message);
    }
}

// Make functions globally available
window.updateModalContent = updateModalContent;
window.getOrderDataFromDOM = getOrderDataFromDOM;
window.ensureHiddenFields = ensureHiddenFields;
window.createFallbackModal = createFallbackModal;
window.triggerServerConfirmPayment = triggerServerConfirmPayment;
window.triggerServerRejectPayment = triggerServerRejectPayment;

// Set up event listeners when the document is ready
document.addEventListener('DOMContentLoaded', function() {
    // Add styles to ensure visibility
    var style = document.createElement('style');
    style.textContent = `
        .btn-verify-direct {
            display: inline-block !important;
            visibility: visible !important;
            opacity: 1 !important;
            padding: 8px 16px !important;
            margin: 10px 10px 10px 0 !important;
            background-color: #4CAF50 !important;
            color: white !important;
            border: none !important;
            border-radius: 4px !important;
            cursor: pointer !important;
            font-weight: bold !important;
            font-size: 14px !important;
        }
        
        .gcash-verification-buttons {
            display: flex !important;
            visibility: visible !important;
            opacity: 1 !important;
            margin-top: 10px !important;
        }
        
        #PaymentVerificationModal {
            z-index: 9999 !important;
        }
    `;
    document.head.appendChild(style);
    
    // Run ensureHiddenFields as soon as possible
    ensureHiddenFields();
    
    // Add inline click handlers to all verification buttons
    document.querySelectorAll('.btn-verify-direct').forEach(function(btn) {
        btn.setAttribute('onclick', "try { window.showVerificationModal(this.getAttribute('data-order-id'), this.getAttribute('data-transaction-id')); return false; } catch(e) { alert('Error: ' + e.message); return false; }");
    });
}); 