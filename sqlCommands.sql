-- setup
show databases;
use mydb;
show tables;
insert into Menus(Cuisine) values ("good");
insert into MenuItems(MenuID, Dish, CourseType, Price) values (1, "eggs", "all", 1.0), (1, "potato", "all", 1.5);
insert into Employees(EmployeeID, Name, Role, Salary, Address, PhoneNumber, Email) values (1, "jacob", "manager", 1000.0, "42 Wallabee Way", "(111) 222-3333", "me@email.com");
insert into Customers(CustomerID, Name, PhoneNumber, Email) values (1, "leah", "(444) 555-6666", "you@email.com");
insert into Bookings(BookingsID, BookingDate, CustomerID, EmployeeID) values (3, "2024-08-10", 1, 1);
insert into DeliveryStatus(DeliveryID, Status, DeliveryDate) values (3, "pending", "2024-08-10");
insert into Orders(BookingID, TotalCost, DeliveryStatusID) values (1, 10.0, 1),  (2, 20.0, 2), (3, 30.0, 3);
insert into OrderItems(OrderID, MenuItemID) values (10, 4);

-- joins task 1 create view
create view OrdersView as select OrderID, count(OrderID) as Quantity, sum(MenuItems.Price) as Cost from OrderItems inner join MenuItems on OrderItems.MenuItemID = MenuItems.MenutItemID group by OrderID;
select * from OrdersView;

-- joins task 2 get orders > 250
select Customers.CustomerID, Customers.Name, Orders.OrderID, Orders.TotalCost, Menus.Cuisine 
from Orders inner join Bookings on Orders.BookingID = Bookings.BookingsID
inner join Customers on Bookings.CustomerID = Customers.CustomerID 
inner join OrderItems on OrderItems.OrderID = Orders.OrderID 
inner join MenuItems on MenuItems.MenutItemID = OrderItems.MenuItemID 
inner join Menus on Menus.MenuID = MenuItems.MenuID
where Orders.TotalCost > 250;

-- joins task 3 get menus which have had >2 orders
select Menus.Cuisine from Menus inner join MenuItems on Menus.MenuID = MenuItems.MenuID where MenuItems.MenutItemID = ANY (select CountResult.MenuItemID from (select OrderItems.MenuItemID, count(OrderItems.MenuItemID) as count from OrderItems group by OrderItems.MenuItemID) as CountResult where CountResult.count > 2);

-- optimized queries task 1 get max quantity
create procedure GetMaxQuantity() select count(OrderID) as OrderCount from OrderItems group by OrderID order by OrderCount desc limit 1;
call GetMaxQuantity();

-- optimized queries task 2 get order detail
prepare GetOrderDetail from 'select OrderID, count(OrderID) as OrderCount, sum(MenuItems.Price) as Quantity from OrderItems inner join MenuItems on OrderItems.MenuItemID = MenuItems.MenutItemID where OrderItems.OrderID = ? group by OrderItems.OrderID';
set @id = 10;
execute GetOrderDetail using @id;

-- optimize queries task 3 cancel order
delimiter //
create procedure CancelOrder(in orderID_ToDelete int) begin
delete from Orders where OrderID = orderID_ToDelete;
select concat("Order ", orderID_ToDelete, " is cancelled");
end//
delimiter ;

call CancelOrder(10);