-- Insert sample discounts for testing

-- First, clear any existing discounts (optional)
-- DELETE FROM discounts;

-- Sample percentage discount
INSERT INTO discounts (
    name, 
    description, 
    discount_type, 
    value, 
    applicable_products,
    start_date, 
    end_date, 
    min_order_amount, 
    status
) 
VALUES (
    'New Customer 15% OFF', 
    'Get 15% off your first order with us!', 
    1, -- 1 = percentage discount
    15.00, -- 15%
    NULL, -- Applies to all products
    GETDATE(), -- Starts today
    DATEADD(year, 1, GETDATE()), -- Valid for 1 year
    NULL, -- No minimum order amount
    1 -- Active
);

-- Sample fixed amount discount
INSERT INTO discounts (
    name, 
    description, 
    discount_type, 
    value, 
    applicable_products,
    start_date, 
    end_date, 
    min_order_amount, 
    status
) 
VALUES (
    'PHP 100 OFF Order', 
    'Get PHP 100 off your order when you spend PHP 500 or more!', 
    2, -- 2 = fixed amount discount
    100.00, -- PHP 100 off
    NULL, -- Applies to all products
    GETDATE(), -- Starts today
    DATEADD(month, 3, GETDATE()), -- Valid for 3 months
    500.00, -- Minimum order of PHP 500
    1 -- Active
);

-- Sample weekend special discount
INSERT INTO discounts (
    name, 
    description, 
    discount_type, 
    value, 
    applicable_products,
    start_date, 
    end_date, 
    min_order_amount, 
    status
) 
VALUES (
    'Weekend Special 20% OFF', 
    'Get 20% off your order on weekends!', 
    1, -- 1 = percentage discount
    20.00, -- 20%
    NULL, -- Applies to all products
    GETDATE(), -- Starts today
    DATEADD(month, 6, GETDATE()), -- Valid for 6 months
    300.00, -- Minimum order of PHP 300
    1 -- Active
);

PRINT 'Sample discounts added successfully.'; 