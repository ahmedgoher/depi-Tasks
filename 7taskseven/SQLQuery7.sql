-- Customer activity log
CREATE TABLE sales.customer_log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    action VARCHAR(50),
    log_date DATETIME DEFAULT GETDATE()
);

-- Price history tracking
CREATE TABLE production.price_history (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT,
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    change_date DATETIME DEFAULT GETDATE(),
    changed_by VARCHAR(100)
);

-- Order audit trail
CREATE TABLE sales.order_audit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    customer_id INT,
    store_id INT,
    staff_id INT,
    order_date DATE,
    audit_timestamp DATETIME DEFAULT GETDATE()
);



/*1.Create a non-clustered index on the email column in the sales.customers table to improve search performance when looking up customers by email.*/
create nonclustered index index_customer 
on sales.customers (email)
/*2.Create a composite index on the production.products table that includes category_id and brand_id columns to optimize searches that filter by both category and brand.*/
create nonclustered index idx_products_category_brand
on production.products (category_id ,brand_id)

/*3.Create an index on sales.orders table for the order_date column and include customer_id, store_id, and order_status as included columns to improve reporting queries.*/
create nonclustered index idx_orders_orderdate
on sales.orders (order_date)
include (customer_id,store_id,order_status);

/*4.Create a trigger that automatically inserts a welcome record into a customer_log table whenever a new customer is added to sales.customers. (First create the log table, then the trigger)*/


create trigger welcome_trigger
on sales.customer_log
after insert
as
begin
insert into customer_log (customer_id,action)
select i.customer_id,'welcome new customer' from inserted i
end


/*5.Create a trigger on production.
products that logs any changes to the list_price column into a price_history table, storing the old price, new price, and change date.*/

create trigger trg_TrackPriceChange
on production.products
after update 
as 
begin
    insert into price_history (product_id,old_price,new_price)
    select d.product_id,
           d.list_price,
           i.list_price
    from deleted d join inserted i on d.product_id=i.product_id
    WHERE d.list_price <> i.list_price;
end

/*6.Create an INSTEAD OF DELETE trigger on production.
categories that prevents deletion of categories that have associated products. Display an appropriate error message.*/

create trigger trg_PreventCategoryDelete
on production.categories
instead of delete
as
begin
 if exists(
 select 1 from deleted d join production.products p on d.category_id=p.category_id
  )
  begin
  print error_message();
  end

   DELETE FROM production.categories
    WHERE category_id IN (SELECT category_id FROM deleted);
end

/*7.Create a trigger on sales.order_items that automatically reduces the quantity in production.
stocks when a new order item is inserted.
*/
create trigger trg_reducesQuantity
on sales.order_items 
after insert
as
begin
insert into production.stocks (store_id,product_id,quantity)
    select o.store_id,i.product_id,i.quantity from inserted i join sales.orders o on i.order_id =o.order_id
end
 
 /*8.Create a trigger that logs all new orders into an order_audit table,
 capturing order details and the date/time when the record was created.
*/

create trigger trg_orderToaudit
on sales.orders
after insert 
as 
begin
insert into sales.order_audit (order_id,customer_id,store_id,staff_id,order_date)
select i.order_id,i.customer_id,i.store_id,i.staff_id,GETDATE() from inserted i
end 