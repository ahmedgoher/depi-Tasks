use StoreDB
/*1. Customer Spending Analysis*/
declare @custumerid int =1
if @custumerid in (select o.customer_id from sales.order_items oi join sales.orders o on oi.order_id=o.order_id where (oi.list_price)>5000)
BEGIN
print 'vip'
end
else 
print 'reguler'


/*2. Product Price Threshold Report#
Create a query using variables to count how many products cost more than $1500.
Store the threshold price in a variable and display both the threshold and count in a formatted message.*/

declare @countproduct int 
declare @threshold int = 1500
SELECT @countproduct = COUNT(*)
FROM sales.order_items
WHERE list_price > @threshold;
SELECT 
    'Number of products with price greater than $' + CAST(@threshold AS VARCHAR) + 
    ' is: ' + CAST(@countproduct AS VARCHAR) AS Result;

    /*3. Staff Performance Calculator#
Write a query that calculates the total sales for staff member ID 2 in the year 2017.
Use variables to store the staff ID, year, and calculated total. 
Display the results with appropriate labels.*/

declare @staffId int =2
declare @year int =2023
declare @totalsales decimal(10,2)

select @totalsales= count(oi.list_price) from sales.orders o join sales.order_items oi on o.order_id=oi.order_id where year(order_date) =@year and staff_id=@staffId

SELECT 
    'Total sales for Staff ID ' + CAST(@staffId AS VARCHAR) +
    ' in year ' + CAST(@year AS VARCHAR) +
    ' is: $' + CAST(@totalSales AS VARCHAR) AS Result;


/*4. Global Variables Information#
Create a query that displays the current server name, SQL Server version, and the number of rows affected by the last statement.
Use appropriate global variables.*/
select @@SERVERNAME as"the current server name",@@VERSION as "SQL Server version",@@ROWCOUNT as "the number of rows affected"

/*5.Write a query that checks the inventory level for product ID 1 in store ID 1. Use IF statements to display different messages based on stock levels:#
If quantity > 20: Well stocked
If quantity 10-20: Moderate stock
If quantity < 10: Low stock - reorder needed*/

declare @productid int =1
declare @storeid int =1
 declare @stocklevel int
 select @stocklevel = quantity from production.stocks where product_id=@productid and store_id=@storeid
if @stocklevel > 20
print 'Well stocked'
else if @stocklevel between 10 and 20 
print 'moderate stock'
else if @stocklevel <10 
print 'low stock'


/*6.Create a WHILE loop that updates low-stock items (quantity < 5) in batches of 3 products at a time. 
Add 10 units to each product and display progress messages after each batch.*/
DECLARE @batch_size INT = 3;

DECLARE @rows_updated INT = 1;



WHILE @rows_updated > 0

BEGIN

    UPDATE TOP (@batch_size) production.stocks

    SET quantity = quantity + 10

    WHERE quantity < 5;

    SET @rows_updated = @@ROWCOUNT;

    PRINT 'Updated ' + CAST(@rows_updated AS VARCHAR(10)) + ' records';

END


/*7. Product Price Categorization#
Write a query that categorizes all products using CASE WHEN based on their list price:
Under $300: Budget
$300-$800: Mid-Range
$801-$2000: Premium
Over $2000: Luxury
*/

select *,
case 
when list_price<300 then 'budget'
when list_price between 300 and 800 then 'mid-range'
when list_price between 801 and 2000 then 'premium'
when list_price >2000 then 'Luxury'
end as categorizes
from production.products


/*8.Create a query that checks if customer ID 5 exists in the database. 
If they exist, show their order count. If not, display an appropriate message.*/

declare @customerID int =5
if @customerID in (select customer_id from sales.customers)
begin
    select c.customer_id,count(c.customer_id) as "Count of orders" from sales.customers c join sales.orders o on o.customer_id =c.customer_id
    where c.customer_id=@customerID
    group by c.customer_id
end
else 
    print 'not exists'


/*9Create a scalar function named CalculateShipping that takes an order total as input and returns shipping cost:

Orders over $100: Free shipping ($0)
Orders $50-$99: Reduced shipping ($5.99)
Orders under $50: Standard shipping ($12.99)*/

create function CalculateShipping (@ordertotal decimal(10,2))
returns decimal (5,2)
as 
begin
    declare @ShippingCost DECIMAL(5,2)
     IF @ordertotal > 100
        SET @ShippingCost = 0
    ELSE IF @ordertotal >= 50
        SET @ShippingCost = 5.99
    ELSE
        SET @ShippingCost = 12.99

    RETURN @ShippingCost
end


/*10-Create an inline table-valued function named GetProductsByPriceRange 
that accepts minimum and maximum price parameters and returns all products
within that price range with their brand and category information.*/

create function GetProductsByPriceRange(@min decimal(10,2),@max decimal(10,2))
returns table 
as
return(
select p.product_id,p.product_name,b.brand_name,c.category_name from production.products p join production.brands b 
on p.brand_id=b.brand_id join production.categories c on c.category_id=p.category_id
where p.list_price between @min and @max
)


/*11.Create a multi-statement function named GetCustomerYearlySummary
that takes a customer ID and returns a table with
yearly sales data including total orders, total spent, and average order value for each year.*/
CREATE FUNCTION GetCustomerYearlySummary(@customerID INT)
RETURNS @t TABLE (
    year INT,
    total_orders INT,
    total_spent DECIMAL(10, 2),
    avg_order_value DECIMAL(10, 2)
)
AS
BEGIN
    INSERT INTO @t
    SELECT 
        YEAR(o.order_date) AS year,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS total_spent,
        SUM(oi.list_price * oi.quantity * (1 - oi.discount)) / COUNT(DISTINCT o.order_id) AS avg_order_value
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = @customerID
    GROUP BY YEAR(o.order_date)

    RETURN
END


/*12.Write a scalar function named CalculateBulkDiscount that determines discount percentage based on quantity:

1-2 items: 0% discount
3-5 items: 5% discount
6-9 items: 10% discount
10+ items: 15% discount*/

create function CalculateBulkDiscount(@quantity int)
returns DECIMAL(4,2)
as
begin
declare @discount DECIMAL(4,2)
        SET @discount=
case 
when @quantity between 1 and 2 then 0.00
when @quantity between 3 and 5 then 0.05
when @quantity between 6 and 9 then 0.10
when @quantity >=10 then 0.15
else 0.00  
end
return @discount
end

/*13.Create a stored procedure named sp_GetCustomerOrderHistory that accepts a customer ID and optional start/end dates.
Return the customer's order history with order totals calculated.*/

CREATE PROCEDURE sp_GetCustomerOrderHistory
    @CustomerID INT,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL
AS
BEGIN
    SELECT 
        o.order_id,
        o.order_date,
        SUM(od.list_price * od.quantity * (1 - od.Discount)) AS OrderTotal
    FROM Sales.Orders o
    JOIN Sales.Order_Items od ON o.order_id = od.order_id
    WHERE o.Customer_ID = @CustomerID
      AND (@StartDate IS NULL OR o.order_date >= @StartDate)
      AND (@EndDate IS NULL OR o.order_date <= @EndDate)
    GROUP BY o.order_id, o.order_date
    ORDER BY o.order_date DESC
END

/*14.Write a stored procedure named sp_RestockProduct with input parameters for store ID, product ID, and restock quantity.
Include output parameters for old quantity, new quantity, and success status.*/

CREATE PROCEDURE sp_RestockProduct
    @StoreID INT,
    @ProductID INT,
    @RestockQty INT,
    @OldQty INT OUTPUT,
    @NewQty INT OUTPUT,
    @Success BIT OUTPUT
AS
BEGIN
    SET @Success = 0;
    SET @OldQty = NULL;
    SET @NewQty = NULL;

    IF EXISTS (
        SELECT 1 
        FROM production.stocks 
        WHERE store_id = @StoreID AND product_id = @ProductID
    )
    BEGIN
        SELECT @OldQty = quantity 
        FROM production.stocks 
        WHERE store_id = @StoreID AND product_id = @ProductID;

        UPDATE production.stocks
        SET quantity = quantity + @RestockQty
        WHERE store_id = @StoreID AND product_id = @ProductID;

        SELECT @NewQty = quantity 
        FROM production.stocks 
        WHERE store_id = @StoreID AND product_id = @ProductID;

        SET @Success = 1;
    END
END

/*15.Create a stored procedure named sp_ProcessNewOrder that handles complete order creation with proper transaction control and error handling.
Include parameters for customer ID, product ID, quantity, and store ID.*/

create proc sp_ProcessNewOrder 
        @CustomerID	int,
        @ProductID	int,
        @Quantity	int,
        @StoreID	int
    as
    begin
    DECLARE @OrderID INT;
    DECLARE @ItemID INT = 1;
    DECLARE @Price DECIMAL(10,2);
    DECLARE @AvailableQty INT;

    begin try
    begin TRANSACTION

    select @AvailableQty= quantity from production.stocks
     WHERE store_id = @StoreID AND product_id = @ProductID;

     if @AvailableQty is null or @AvailableQty<@Quantity
     begin
     print'NOT AVAILABLE'
     end

     select @Price=list_price from production.products
     where product_id=@ProductID
     if @Price is null 
     print 'NOT AVAILABLE'


     insert into sales.orders (customer_id,order_status,order_date,required_date,store_id,staff_id)
     values (@CustomerID,1,GETDATE(),GETDATE(),@StoreID,1)

     SET @OrderID = SCOPE_IDENTITY();


     INSERT INTO sales.order_items (order_id, item_id, product_id, quantity, list_price, discount)
        VALUES (@OrderID, @ItemID, @ProductID, @Quantity, @Price, 0);

        UPDATE production.stocks
        SET quantity = quantity - @Quantity
        WHERE store_id = @StoreID AND product_id = @ProductID;
   
    commit ;
    end try
    begin catch
    rollback;
    print error_message();
    end catch
    end






/*16.Write a stored procedure named sp_SearchProducts that builds dynamic SQL based on optional parameters:
product name search term, category ID, minimum price, maximum price, and sort column.*/

CREATE PROCEDURE sp_SearchProducts
    @ProductName VARCHAR(100) = NULL,
    @CategoryID INT = NULL,
    @MinPrice DECIMAL(10,2) = NULL,
    @MaxPrice DECIMAL(10,2) = NULL,
    @SortColumn VARCHAR(50) = 'product_name'
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX)

    SET @SQL = '
    SELECT 
        p.product_id,
        p.product_name,
        p.list_price,
        p.model_year,
        c.category_name
    FROM production.products p
    JOIN production.categories c ON p.category_id = c.category_id
    WHERE 1 = 1'

    IF @ProductName IS NOT NULL
        SET @SQL += ' AND p.product_name LIKE ''%' + @ProductName + '%'''

    IF @CategoryID IS NOT NULL
        SET @SQL += ' AND p.category_id = ' + CAST(@CategoryID AS VARCHAR)

    IF @MinPrice IS NOT NULL
        SET @SQL += ' AND p.list_price >= ' + CAST(@MinPrice AS VARCHAR)

    IF @MaxPrice IS NOT NULL
        SET @SQL += ' AND p.list_price <= ' + CAST(@MaxPrice AS VARCHAR)

    SET @SQL += ' ORDER BY ' + QUOTENAME(@SortColumn)

    EXEC sp_executesql @SQL
END



/*17.Create a complete solution that calculates quarterly bonuses for all staff members.
Use variables to store date ranges and bonus rates.
Apply different bonus percentages based on sales performance tiers.*/

DECLARE 
    @StartDate DATE = '2023-01-01',
    @EndDate DATE = '2023-03-31',  
    @HighTierRate DECIMAL(5,2) = 0.10,
    @MidTierRate DECIMAL(5,2) = 0.07,
    @LowTierRate DECIMAL(5,2) = 0.04;

SELECT 
    s.staff_id,
    s.first_name + ' ' + s.last_name AS StaffName,
    
    SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS TotalSales,

    CASE 
        WHEN SUM(oi.list_price * oi.quantity * (1 - oi.discount)) >= 100000 
            THEN SUM(oi.list_price * oi.quantity * (1 - oi.discount)) * @HighTierRate
        WHEN SUM(oi.list_price * oi.quantity * (1 - oi.discount)) BETWEEN 50000 AND 99999.99 
            THEN SUM(oi.list_price * oi.quantity * (1 - oi.discount)) * @MidTierRate
        ELSE 
            SUM(oi.list_price * oi.quantity * (1 - oi.discount)) * @LowTierRate
    END AS BonusAmount,

    CASE 
        WHEN SUM(oi.list_price * oi.quantity * (1 - oi.discount)) >= 100000 
            THEN 'High Performer'
        WHEN SUM(oi.list_price * oi.quantity * (1 - oi.discount)) BETWEEN 50000 AND 99999.99 
            THEN 'Medium Performer'
        ELSE 
            'Low Performer'
    END AS PerformanceTier

FROM sales.staffs s
JOIN sales.orders o ON s.staff_id = o.staff_id
JOIN sales.order_items oi ON o.order_id = oi.order_id

WHERE o.order_date BETWEEN @StartDate AND @EndDate

GROUP BY s.staff_id, s.first_name, s.last_name;

/*18. Smart Inventory Management#
Write a complex query with nested IF statements that manages inventory restocking. Check current stock levels and apply different reorder quantities based on product categories and current stock levels.*/

SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    s.quantity AS CurrentStock,

    CASE 
        WHEN c.category_name = 'Electronics' AND s.quantity < 10 THEN 50
        WHEN c.category_name = 'Clothing' AND s.quantity < 20 THEN 100
        WHEN c.category_name = 'Sports' AND s.quantity < 15 THEN 30
        WHEN s.quantity < 10 THEN 20
        ELSE 0  
    END AS ReorderQuantity,

    CASE 
        WHEN c.category_name = 'Electronics' AND s.quantity < 10 THEN 'Restock Needed (Electronics)'
        WHEN c.category_name = 'Clothing' AND s.quantity < 20 THEN 'Restock Needed (Clothing)'
        WHEN c.category_name = 'Sports' AND s.quantity < 15 THEN 'Restock Needed (Sports)'
        WHEN s.quantity < 10 THEN 'Restock Needed (Other)'
        ELSE 'Stock OK'
    END AS RestockStatus

FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id
JOIN production.stocks s ON p.product_id = s.product_id


  /*  19. Customer Loyalty Tier Assignment#
Create a comprehensive solution that assigns loyalty tiers to customers based on their total spending. Handle customers with no orders appropriately and use proper NULL checking.*/

SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS CustomerName,

    ISNULL(SUM(oi.list_price * oi.quantity * (1 - oi.discount)), 0) AS TotalSpending,

    CASE 
        WHEN SUM(oi.list_price * oi.quantity * (1 - oi.discount)) IS NULL THEN 'No Orders'
        WHEN SUM(oi.list_price * oi.quantity * (1 - oi.discount)) > 100000 THEN 'Platinum'
        WHEN SUM(oi.list_price * oi.quantity * (1 - oi.discount)) BETWEEN 50000 AND 100000 THEN 'Gold'
        WHEN SUM(oi.list_price * oi.quantity * (1 - oi.discount)) BETWEEN 10000 AND 49999.99 THEN 'Silver'
        ELSE 'Bronze'
    END AS LoyaltyTier

FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
LEFT JOIN sales.order_items oi ON o.order_id = oi.order_id

GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY TotalSpending DESC;

/*20. Product Lifecycle Management#
Write a stored procedure that handles product discontinuation including checking for pending orders, optional product replacement in existing orders, clearing inventory, and providing detailed status messages.*/
CREATE PROCEDURE sp_DiscontinueProduct
    @OldProductID INT,
    @ReplacementProductID INT = NULL, 
    @StatusMessage NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PendingOrders INT;

    SELECT @PendingOrders = COUNT(*)
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE oi.product_id = @OldProductID AND o.order_status IN (1, 2); -- 1: Pending, 2: Processing

    IF @PendingOrders > 0
    BEGIN
        IF @ReplacementProductID IS NOT NULL
        BEGIN
            UPDATE oi
            SET product_id = @ReplacementProductID
            FROM sales.order_items oi
            JOIN sales.orders o ON oi.order_id = o.order_id
            WHERE oi.product_id = @OldProductID AND o.order_status IN (1, 2);

            SET @StatusMessage = 'Pending orders found and replaced with alternative product.';
        END
        ELSE
        BEGIN
            SET @StatusMessage = 'Pending orders found. No replacement product provided.';
            RETURN;
        END
    END
    ELSE
    BEGIN
        SET @StatusMessage = 'No pending orders found.';
    END

    DELETE FROM production.stocks
    WHERE product_id = @OldProductID;

   
    SET @StatusMessage += ' Product stock cleared and marked as discontinued.';
END;




















