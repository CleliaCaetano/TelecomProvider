-- #############################################################
-- # TelecommunicationsProvider Assignment SQL Script
-- #############################################################

-- ------------------------------------------------------------------------------------
-- Task 1: Create Database and Tables
-- Create the TelecommunicationsProvider database and five InnoDB tables with 
-- appropriate defaults and foreign keys.
-- ------------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS telecomprovider_updated;
USE telecomprovider_updated;

-- Table: Customer
-- Purpose: Stores basic customer information, including the customer's name and join date.

CREATE TABLE Customer (
  CustomerID    INT            AUTO_INCREMENT PRIMARY KEY,
  CustomerName  VARCHAR(100)   NOT NULL,
  Email         VARCHAR(100)   CHECK (Email LIKE '%@%.%') NOT NULL,
  Phone         VARCHAR(15),
  Address       VARCHAR(255),
  JoinDate      DATE           NOT NULL
) ENGINE=InnoDB;

-- Prevent duplicate emails from being inserted. 
ALTER TABLE Customer
ADD CONSTRAINT unique_email UNIQUE (Email);

-- Table: Plan
-- Purpose: Stores information about service plans.

CREATE TABLE Plan (
    PlanID INT AUTO_INCREMENT PRIMARY KEY,
    PlanName VARCHAR(100) NOT NULL,
    Type ENUM('Call', 'SMS', 'Data', 'Mixed'),
    MonthlyCost DECIMAL(10 , 2 ) NOT NULL,
    Description TEXT
)  ENGINE=INNODB;

-- Table: Subscription
-- Purpose: Records which customer is subscribed to which plan, including billing and status details.

CREATE TABLE Subscription (
    SubscriptionID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    PlanID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE,
    BillingMonth VARCHAR(10) NOT NULL,
    TotalAmount DECIMAL(10 , 2 ) NOT NULL,
    PaymentStatus ENUM('Paid', 'Unpaid') NOT NULL,
    FOREIGN KEY (CustomerID)
        REFERENCES Customer (CustomerID)
        ON DELETE RESTRICT,
    FOREIGN KEY (PlanID)
        REFERENCES Plan (PlanID)
        ON DELETE RESTRICT
)  ENGINE=INNODB;  -- InnoDB enables ACID, transactions, FK enforcement in MySQL.

-- Add a UNIQUE constraint for future protection
ALTER TABLE Subscription
ADD CONSTRAINT uc_unique_subscription UNIQUE (CustomerID, PlanID, BillingMonth);

-- Table: UsageRecord
-- Purpose: Logs detailed usage activity (calls, SMS, data) linked to a specific subscription.

CREATE TABLE UsageRecord (
    UsageID INT AUTO_INCREMENT PRIMARY KEY,
    SubscriptionID INT NOT NULL,
    UsageType ENUM('Call', 'SMS', 'Data') NOT NULL,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME,
    DataUsedMB DECIMAL(10 , 2 ),
    Duration INT,
    MessageLength INT,
    DestinationNumber VARCHAR(20) NOT NULL,
    FOREIGN KEY (SubscriptionID)
        REFERENCES Subscription (SubscriptionID)
        ON DELETE RESTRICT
)  ENGINE=INNODB;

-- Table: SupportTicket
-- Purpose: Stores customer support tickets and their resolution status.

CREATE TABLE SupportTicket (
    TicketID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    CreatedAt DATETIME NOT NULL,
    IssueType VARCHAR(100) NOT NULL,
    Status ENUM('Open', 'Resolved', 'Escalated') NOT NULL,
    ResolutionNote TEXT,
    FOREIGN KEY (CustomerID)
        REFERENCES Customer (CustomerID)
        ON DELETE RESTRICT
)  ENGINE=INNODB;

-- ------------------------------------------------------------------------------------
-- Task 2: Populate Sample Data
-- Purpose: Insert sample data into core tables to demonstrate database functionality.
-- Action: Insert 20 sample customers, 5 sample plans, 10 subscription records with 
-- mixed plans and related usage/activity (calls, SMS, data).
-- ------------------------------------------------------------------------------------

-- Note: CustomerID and PlanID are AUTO_INCREMENT, so we do NOT manually specify IDs here.
-- The database will automatically assign unique IDs to each new record.

INSERT INTO Customer (CustomerName, Email, Phone, Address, JoinDate)
VALUES
  ('Mariana Noronha', 'mari.noronha@example.com', '1111111111', '12 Elm St, Chicago, IL', '2023-01-05'),
  ('Daniela Sacani', 'dani.sacani@example.com', '1111111112', '88 Lakeview Dr, Miami, FL', '2023-01-10'),
  ('Ana Brasileiro', 'ana.brasileiro@example.com', '1111111113', '101 Rose Ave, Dallas, TX', '2023-01-15'),
  ('John Foley', 'john.foley@example.com', '1111111114', '67 Pine St, Denver, CO', '2023-01-20'),
  ('David Camargo', 'david.camargo@example.com', '1111111115', '14 Ocean Blvd, LA, CA', '2023-01-25'),
  ('Claudia Caetano', 'claudia.caetano@example.com', '1111111116', '210 Maple St, Boston, MA', '2023-02-01'),
  ('Vitor Sales', 'vitor.sales@example.com', '1111111117', '300 Hill Rd, Atlanta, GA', '2023-02-07'),
  ('Sophia Kim', 'sophia.kim@example.com', '1111111118', '87 Creek Rd, Portland, OR', '2023-02-12'),
  ('Benjamin Lopez', 'benjamin.lopez@example.com', '1111111119', '42 Bay St, Seattle, WA', '2023-02-15'),
  ('Isabella Baker', 'isabella.baker@example.com', '1111111120', '133 Pearl Ave, Austin, TX', '2023-02-20'),
  ('Lucas Murphy', 'lucas.murphy@example.com', '1111111121', '55 Grove St, Nashville, TN', '2023-03-01'),
  ('Mia Long', 'mia.long@example.com', '1111111122', '190 Sunset Blvd, Phoenix, AZ', '2023-03-06'),
  ('Henry Diaz', 'henry.diaz@example.com', '1111111123', '73 Windy Hill, Raleigh, NC', '2023-03-10'),
  ('Amelia Green', 'amelia.green@example.com', '1111111124', '200 Oak Rd, Madison, WI', '2023-03-15'),
  ('Alexander Ross', 'alex.ross@example.com', '1111111125', '900 Birch St, Fargo, ND', '2023-03-20'),
  ('Charlotte Ward', 'charlotte.ward@example.com', '1111111126', '444 Rain St, Boise, ID', '2023-03-25'),
  ('Ethan Bennett', 'ethan.bennett@example.com', '1111111127', '32 Riverbend, Tulsa, OK', '2023-04-01'),
  ('Harper Brooks', 'harper.brooks@example.com', '1111111128', '390 Lakehouse Dr, Omaha, NE', '2023-04-05'),
  ('Daniel Nguyen', 'daniel.nguyen@example.com', '1111111129', '58 Coral St, Reno, NV', '2023-04-10'),
  ('Abigail Foster', 'abigail.foster@example.com', '1111111130', '121 Sunrise Way, Mobile, AL', '2023-04-15');

-- Populate Plan Table with 5 plan records. 

INSERT INTO Plan (PlanName, Type, MonthlyCost, Description)
VALUES
  ('Basic Call Plan', 'Call', 9.99, 'Unlimited calls within the network'),
  ('SMS Saver', 'SMS', 4.99, '1000 SMS messages per month'),
  ('Data Plus', 'Data', 19.99, '5GB high-speed data'),
  ('Mixed Value Plan', 'Mixed', 29.99, 'Includes calls, SMS, and 3GB data'),
  ('Unlimited Plan', 'Mixed', 49.99, 'Unlimited calls, SMS, and data');
  
-- Populate Subscription table with 10 records linking Customers to Plans.
-- SubscriptionID is AUTO_INCREMENT; values are generated automatically.
-- ON DELETE RESTRICT constraints are respected (no referenced Customer or Plan can be deleted).

INSERT INTO Subscription (CustomerID, PlanID, StartDate, EndDate, BillingMonth, TotalAmount, PaymentStatus)
VALUES
  (1, 1, '2024-01-01', NULL, 'January', 9.99, 'Paid'),
  (12, 2, '2024-01-15', '2024-05-15', 'February', 4.99, 'Unpaid'),
  (3, 3, '2024-02-01', NULL, 'February', 19.99, 'Paid'),
  (4, 4, '2024-02-10', NULL, 'March', 29.99, 'Paid'),
  (15, 5, '2024-03-01', NULL, 'March', 49.99, 'Paid'),
  (6, 1, '2024-03-15', NULL, 'April', 9.99, 'Unpaid'),
  (7, 3, '2024-04-01', NULL, 'April', 19.99, 'Paid'),
  (18, 2, '2024-04-10', NULL, 'April', 4.99, 'Paid'),
  (9, 4, '2024-05-01', NULL, 'May', 29.99, 'Unpaid'),
  (10, 5, '2024-05-10', NULL, 'May', 49.99, 'Paid');

  -- Inserting 15 mixed usage records for various subscriptions

INSERT INTO UsageRecord (SubscriptionID, UsageType, StartTime, EndTime, DataUsedMB, Duration, MessageLength, DestinationNumber)
VALUES
-- Call records
(1, 'Call', '2024-06-01 10:00:00', '2024-06-01 10:05:00', NULL, 300, NULL, '5551234567'),
(2, 'Call', '2024-06-01 14:30:00', '2024-06-01 14:45:00', NULL, 900, NULL, '5552345678'),
(3, 'Call', '2024-06-02 08:15:00', '2024-06-02 08:25:00', NULL, 600, NULL, '5553456789'),

-- SMS records
(4, 'SMS', '2024-06-01 09:00:00', NULL, NULL, NULL, 120, '5554567890'),
(5, 'SMS', '2024-06-02 12:00:00', NULL, NULL, NULL, 80, '5555678901'),
(6, 'SMS', '2024-06-03 13:45:00', NULL, NULL, NULL, 200, '5556789012'),

-- Data usage records
(7, 'Data', '2024-06-01 07:00:00', '2024-06-01 07:20:00', 150.75, NULL, NULL, 'N/A'), -- 'N/A' used as placeholder for DestinationNumber when UsageType = 'Data'.
(8, 'Data', '2024-06-02 15:30:00', '2024-06-02 15:50:00', 300.50, NULL, NULL, 'N/A'),
(9, 'Data', '2024-06-03 16:00:00', '2024-06-03 16:25:00', 100.25, NULL, NULL, 'N/A'),

-- Mixed types to fill remaining 6
(10, 'Call', '2024-06-04 10:00:00', '2024-06-04 10:07:00', NULL, 420, NULL, '5557890123'),
(1, 'SMS', '2024-06-04 11:00:00', NULL, NULL, NULL, 50, '5558901234'),
(2, 'Data', '2024-06-04 13:00:00', '2024-06-04 13:30:00', 500.00, NULL, NULL, 'N/A'),
(3, 'Call', '2024-06-04 14:15:00', '2024-06-04 14:30:00', NULL, 900, NULL, '5559012345'),
(4, 'Data', '2024-06-04 15:45:00', '2024-06-04 16:00:00', 75.20, NULL, NULL, 'N/A'),
(5, 'SMS', '2024-06-04 17:00:00', NULL, NULL, NULL, 160, '5550123456');

-- Insert 5 SupportTicket records tied to existing customers.
-- Simulates real-world customer support scenarios using ENUM status values.
-- ON DELETE RESTRICT ensures support records remain protected from accidental customer deletions.

INSERT INTO SupportTicket (CustomerID, CreatedAt, IssueType, Status, ResolutionNote)
VALUES
  (3, '2024-06-01 10:30:00', 'Billing Discrepancy', 'Resolved', 'Refund issued for overcharge.'),
  (7, '2024-06-02 09:45:00', 'Service Interruption', 'Open', NULL),
  (15, '2024-06-03 14:20:00', 'Plan Change Request', 'Resolved', 'Customer upgraded to Unlimited Plan.'),
  (9, '2024-06-04 11:10:00', 'Network Coverage Issue', 'Escalated', 'Escalated to technical team for investigation.'),
  (12, '2024-06-05 08:50:00', 'App Login Problem', 'Open', NULL);

-- ------------------------------------------------------------------------------------
-- Task 3: Advanced SQL Query Demonstrations
-- Purpose: Perform joins, aggregations, transaction control, and complex analysis 
-- using the populated telecom schema.
-- ------------------------------------------------------------------------------------

SELECT 
    c.CustomerID, c.CustomerName
FROM
    Customer c
        LEFT JOIN
    Subscription s ON c.CustomerID = s.CustomerID
WHERE
    s.SubscriptionID IS NULL;
-- ------------------------------------------------------------------------------------

SELECT 
    p.PlanName,
    p.MonthlyCost,
    COUNT(DISTINCT c.CustomerID) AS TotalCustomersOnLowCostPlan,
    SUM(s.TotalAmount) AS RevenueFromLowCostPlans
FROM
    Subscription s
        JOIN
    Plan p ON s.PlanID = p.PlanID
        JOIN
    Customer c ON s.CustomerID = c.CustomerID
WHERE
    p.MonthlyCost < 10.00
GROUP BY p.PlanName , p.MonthlyCost
ORDER BY TotalCustomersOnLowCostPlan DESC;
-- ------------------------------------------------------------------------------------

SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(CASE
        WHEN u.UsageType = 'Call' THEN u.Duration
        ELSE 0
    END) AS TotalCallDuration,
    SUM(CASE
        WHEN u.UsageType = 'SMS' THEN u.MessageLength
        ELSE 0
    END) AS TotalSMSLength,
    SUM(CASE
        WHEN u.UsageType = 'Data' THEN u.DataUsedMB
        ELSE 0
    END) AS TotalDataMB,
    SUM(COALESCE(u.Duration, 0) + COALESCE(u.MessageLength, 0) + COALESCE(u.DataUsedMB, 0)) AS OverallUsageScore
FROM
    UsageRecord u
        JOIN
    Subscription s ON u.SubscriptionID = s.SubscriptionID
        JOIN
    Customer c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID , c.CustomerName
ORDER BY OverallUsageScore DESC
LIMIT 3;-- Top 3 only
-- ------------------------------------------------------------------------------------

SELECT DISTINCT
    c.CustomerID,
    c.CustomerName,
    c.Email,
    c.Phone,
    s.SubscriptionID,
    s.BillingMonth,
    s.TotalAmount,
    s.PaymentStatus
FROM
    Customer c
        JOIN
    Subscription s ON c.CustomerID = s.CustomerID
WHERE
    s.PaymentStatus = 'Unpaid'
ORDER BY s.BillingMonth DESC , s.TotalAmount DESC;      -- Prioritize most recent and highest unpaid amounts
-- ------------------------------------------------------------------------------------

-- 3.3.2 Transactions & ACID Control (Atomicity, Consistency, Isolation, Durability)
-- Purpose: Apply a negotiated 25% discount safely to an unpaid customer’s subscription bill following billing department outreach.
-- The discount incentivizes payment and strengthens customer retention.
-- The payment status update is managed carefully, allowing rollback if needed to maintain accurate billing records.
-- This process protects revenue tracking and supports effective customer account management through controlled transactional updates.

ALTER TABLE Subscription                               -- Add DiscountApplied flag (Run once during setup).
ADD COLUMN DiscountApplied BOOLEAN DEFAULT FALSE;

START TRANSACTION;                                     -- Controlled Transaction to Apply Discount Once & Optionally Mark as Paid.

UPDATE Subscription 
SET 
    TotalAmount = 29.99,
    DiscountApplied = FALSE
WHERE
    SubscriptionID = 9
        AND DiscountApplied = TRUE                      -- Reverts if previously discounted

UPDATE Subscription 
SET 
    TotalAmount = TotalAmount * 0.75,
    DiscountApplied = TRUE
WHERE
    SubscriptionID = 9
        AND DiscountApplied = FALSE                     -- Prevents repeated discount

SAVEPOINT BeforeStatusUpdate;                           -- Savepoint before marking as paid

UPDATE Subscription 
SET 
    PaymentStatus = 'Paid'
WHERE
    SubscriptionID = 9

ROLLBACK TO SAVEPOINT BeforeStatusUpdate;           -- Roll back the payment status change only (discount remains)

COMMIT;  -- Finalize all changes (discount + optional status)
-- ------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW SubscriptionStatus AS
    SELECT 
        SubscriptionID,
        CustomerID,
        TotalAmount,
        PaymentStatus,
        BillingMonth
    FROM
        Subscription
    WHERE
        SubscriptionID = 9

SELECT 
    *
FROM
    SubscriptionStatus
-- ------------------------------------------------------------------------------------

-- 3.3.4 Revenue Insights Using Aggregates & Window Functions
-- Purpose: Analyze customer spending behavior, subscription trends, and cumulative revenue for financial monitoring.

SELECT                                       -- Total amount spent by each customer (paid only)
    CustomerID, 
    SUM(TotalAmount) AS TotalSpent           -- Total revenue from each customer
FROM 
    Subscription
WHERE 
    PaymentStatus = 'Paid'
GROUP BY 
    CustomerID;

SELECT                                      -- Subscription trends: compare current vs. previous amounts and track cumulative spending
    CustomerID,                             -- Customer ID for reference
    BillingMonth,                           -- Month of the bill
    TotalAmount,                            -- Current month's billed amount
    LAG(TotalAmount) OVER (                 -- Lag: Show subscription history per customer
        PARTITION BY CustomerID 
        ORDER BY StartDate
    ) AS PreviousMonthAmount,              -- Previous month’s bill for comparison
    SUM(TotalAmount) OVER (
        PARTITION BY CustomerID 
        ORDER BY StartDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS CumulativeSpent                   -- Running total per customer across months
FROM 
    Subscription
WHERE 
    PaymentStatus = 'Paid'                 -- Only include successful payments
ORDER BY 
    CustomerID, StartDate;                 -- Sorted by customer and chronological order
-- ------------------------------------------------------------------------------------

-- 3.4 Customer Service Department:
-- 3.4.1 Control Flow Using Loops in Stored Procedure
-- Purpose: Simulate bulk ticket creation using a WHILE loop to stress-test or batch-generate support entries.
-- This technique can help automate initial logging of recurring issues (e.g., mass service outages).
-- Wrap insert logic in a handler to demonstrate failure handling in more advanced use cases.

DELIMITER $$

CREATE PROCEDURE simulate_loop()
BEGIN
  DECLARE i INT DEFAULT 1;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION         -- Basic error handling example
  BEGIN 
    SELECT CONCAT('Error occurred at CustomerID = ', i) AS ErrorMessage;
  END;

  loop_label: WHILE i <= 5 DO
    INSERT INTO SupportTicket (CustomerID, CreatedAt, IssueType, Status)
    VALUES (i, NOW(), 'Loop Test - Auto Ticket', 'Open');
    SET i = i + 1;
  END WHILE;
END $$

DELIMITER ;

CALL simulate_loop();                              -- Run the procedure
-- ------------------------------------------------------------------------------------

-- 3.4.2 Ticket Creation Procedure
-- Purpose: Enables agents to safely create a support ticket
-- for a valid customer. Validates customer existence first.

DROP FUNCTION IF EXISTS CustomerExists;
DELIMITER $$

CREATE FUNCTION CustomerExists(custID INT)          -- Function: Check if a customer exists
RETURNS BOOLEAN                                     -- Returns TRUE (1) or FALSE (0)
DETERMINISTIC                                       -- Same input always gives the same output
READS SQL DATA                                      -- The function reads data but doesn't modify it
BEGIN
    DECLARE exists_flag BOOLEAN;                    -- Variable to store the result of the check
    SELECT COUNT(*) > 0 INTO exists_flag            -- Set flag to TRUE if customer exists
    FROM Customer
    WHERE CustomerID = custID;
    RETURN exists_flag;                             -- Return result to caller
END $$

DELIMITER $$

CREATE PROCEDURE CreateSupportTicket (
    IN in_CustomerID INT,
    IN in_IssueType VARCHAR(100),
    IN in_Status VARCHAR(20),
    IN in_ResolutionNote TEXT
)
BEGIN
    -- Check if the customer exists using a CustomerExists function.
    -- Ensure CustomerExists is a pre-defined function that returns a boolean (1 or 0).
    IF CustomerExists(in_CustomerID) THEN
        INSERT INTO SupportTicket (
            CustomerID, CreatedAt, IssueType, Status, ResolutionNote
        )
        VALUES (
            in_CustomerID, NOW(), in_IssueType, in_Status, in_ResolutionNote
        );
    ELSE
        -- If the customer does not exist, signal an SQL error.
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Customer does not exist.';
    END IF;                                               -- Close the IF statement
END $$                                                    -- Close the PROCEDURE block

DELIMITER ;

CALL CreateSupportTicket(                                 -- Create a valid support ticket
    3,                                                    -- Existing CustomerID
    'Billing Issue',                                      -- IssueType
    'Open',                                               -- Status
    'Customer reported incorrect charge'                  -- Optional resolution note
);
-- ------------------------------------------------------------------------------------

-- 3.4.3 Trigger: Auto-fill Resolution Note
-- Purpose: Ensure all resolved support tickets contain a resolution note.
-- This improves data completeness for reporting and customer follow-up.

DELIMITER $$

CREATE TRIGGER trg_AutoFillResolutionNote
BEFORE UPDATE ON SupportTicket
FOR EACH ROW
BEGIN
    -- If status is being changed to 'Resolved' and ResolutionNote is NULL or empty
    IF NEW.Status = 'Resolved' AND (NEW.ResolutionNote IS NULL OR TRIM(NEW.ResolutionNote) = '') THEN
        SET NEW.ResolutionNote = 'Resolved without additional notes';
    END IF;
END $$

DELIMITER ;
-- ------------------------------------------------------------------------------------

-- Additional Query 1: Create a "dashboard" view using SQL
-- Purpose: Provide key business indicators to support general oversight and performance tracking.
-- Includes customer count, open support tickets, unpaid subscriptions, and total revenue collected.

CREATE OR REPLACE VIEW BusinessKeyMetrics AS
SELECT 
    (SELECT COUNT(*) FROM Customer) AS TotalCustomers,
    (SELECT COUNT(*) FROM SupportTicket WHERE Status = 'Open') AS OpenTickets,
    (SELECT COUNT(*) FROM Subscription WHERE PaymentStatus = 'Unpaid') AS UnpaidSubscriptions,
    (SELECT SUM(TotalAmount) FROM Subscription WHERE PaymentStatus = 'Paid') AS TotalRevenueCollected;

SELECT * FROM BusinessKeyMetrics;
-- ------------------------------------------------------------------------------------

-- Additional Query 2: Subscription Plan Performance Overview
-- Purpose: Track how many customers are subscribed to each plan and the total revenue generated by each.
-- Useful for product and marketing teams to assess plan popularity and financial impact.

CREATE OR REPLACE VIEW PlanPerformanceSummary AS
SELECT 
    p.PlanName,
    p.MonthlyCost,
    COUNT(DISTINCT s.CustomerID) AS Subscribers,
    SUM(CASE WHEN s.PaymentStatus = 'Paid' THEN s.TotalAmount ELSE 0 END) AS Revenue
FROM 
    Subscription s
JOIN 
    Plan p ON s.PlanID = p.PlanID
GROUP BY 
    p.PlanName, p.MonthlyCost
ORDER BY 
    Revenue DESC;

SELECT * FROM PlanPerformanceSummary; 		-- View results
-- ------------------------------------------------------------------------------------

-- Additional Query 3: Support Ticket Resolution Trends
-- Purpose: Monitor how support tickets are being resolved over time.
-- Helps customer service managers track resolution efficiency and workload trends.

CREATE OR REPLACE VIEW SupportTicketResolutionTrends AS
SELECT
    DATE_FORMAT(CreatedAt, '%Y-%m') AS YearMonth,                             -- Group by year and month
    COUNT(*) AS TotalTickets,                                                 -- Total tickets created in the month
    SUM(CASE WHEN Status = 'Resolved' THEN 1 ELSE 0 END) AS ResolvedTickets,  -- Tickets resolved
    SUM(CASE WHEN Status = 'Open' THEN 1 ELSE 0 END) AS OpenTickets,          -- Tickets still open
    SUM(CASE WHEN Status = 'Escalated' THEN 1 ELSE 0 END) AS EscalatedTickets -- Tickets escalated
FROM 
    SupportTicket
GROUP BY 
    YearMonth
ORDER BY 
    YearMonth;

SELECT * FROM SupportTicketResolutionTrends;			-- View results
-- ------------------------------------------------------------------------------------





