-- setup
show databases;
use LittleLemonDB;
show tables;
insert into Menus(Cuisine) values ("good");
insert into MenuItems(MenuID, Dish, CourseType, Price) values (1, "eggs", "all", 1.0), (1, "potato", "all", 1.5), (1, "ice cream", "dessert", 2.0);
insert into Employees(EmployeeID, Name, Role, Salary, Address, PhoneNumber, Email) values (1, "jacob", "manager", 1000.0, "42 Wallabee Way", "(111) 222-3333", "me@email.com");
insert into Customers(CustomerID, Name, PhoneNumber, Email) values (1, "me", "(111) 222-3333", "me@email.com"), (2, "you", "(444) 555-6666", "you@email.com"), (3, "striga", "(444) 555-6666", "me2@email.com");
insert into Bookings(BookingID, BookingDate, TableNumber, CustomerID, EmployeeID) values (1, "2022-10-10", 5, 1, 1), (2, "2022-11-12", 3, 3, 1), (3, "2022-10-11", 2, 2, 1), (4, "2022-10-13", 2, 1, 1);
insert into DeliveryStatus(DeliveryID, Status, DeliveryDate) values (1, "pending", "2024-08-10"), (2, "pending", "2024-08-10"), (3, "pending", "2024-08-10");
insert into Orders(BookingID, TotalCost, DeliveryStatusID) values (1, 10.0, 1),  (2, 20.0, 2), (3, 30.0, 3);
insert into OrderItems(OrderID, MenuItemID) values (1, 2);
insert into OrderItems(OrderID, MenuItemID) values (1, 2);
insert into OrderItems(OrderID, MenuItemID) values (1, 2);
insert into OrderItems(OrderID, MenuItemID) values (1, 2);
insert into OrderItems(OrderID, MenuItemID) values (1, 2);
insert into OrderItems(OrderID, MenuItemID) values (2, 2);

select * from Menus;
select * from MenuItems;
select * from Employees;
select * from Customers;
select * from Bookings;
select * from Orders;


-- joins task 1 create view
create view OrdersView as select OrderID, count(OrderID) as Quantity, sum(MenuItems.Price) as Cost from OrderItems inner join MenuItems on OrderItems.MenuItemID = MenuItems.MenuItemID group by OrderID;
select * from OrdersView;

-- joins task 2 get orders > 250
select Customers.CustomerID, Customers.Name, Orders.OrderID, Orders.TotalCost, Menus.Cuisine 
from Orders inner join Bookings on Orders.BookingID = Bookings.BookingID
inner join Customers on Bookings.CustomerID = Customers.CustomerID 
inner join OrderItems on OrderItems.OrderID = Orders.OrderID 
inner join MenuItems on MenuItems.MenuItemID = OrderItems.MenuItemID 
inner join Menus on Menus.MenuID = MenuItems.MenuID
where Orders.TotalCost > 250;

-- joins task 3 get menus which have had >2 orders
select Menus.Cuisine from Menus inner join MenuItems on Menus.MenuID = MenuItems.MenuID where MenuItems.MenuItemID = ANY (select CountResult.MenuItemID from (select OrderItems.MenuItemID, count(OrderItems.MenuItemID) as count from OrderItems group by OrderItems.MenuItemID) as CountResult where CountResult.count > 2);

-- optimized queries task 1 get max quantity
create procedure GetMaxQuantity() select count(OrderID) as OrderCount from OrderItems group by OrderID order by OrderCount desc limit 1;
call GetMaxQuantity();

-- optimized queries task 2 get order detail
prepare GetOrderDetail from 'select OrderID, count(OrderID) as OrderCount, sum(MenuItems.Price) as Quantity from OrderItems inner join MenuItems on OrderItems.MenuItemID = MenuItems.MenuItemID where OrderItems.OrderID = ? group by OrderItems.OrderID';
set @id = 4;
execute GetOrderDetail using @id;

-- optimize queries task 3 cancel order
delimiter //
create procedure CancelOrder(in orderID_ToDelete int) begin
delete from Orders where OrderID = orderID_ToDelete;
select concat("Order ", orderID_ToDelete, " is cancelled");
end//

delimiter ;

call CancelOrder(10);

delimiter //
create procedure CancelBooking(in bookingID_ToDelete int) begin
delete from Bookings where BookingID = bookingID_ToDelete;
select concat("Booking ", bookingID_ToDelete, " is cancelled");
end//

delimiter ;

call CancelBooking(10);


-- check available bookings task 1 inserted bookings earlier

-- check available bookings task 2 check booking procedure
drop procedure if exists CheckBooking;
delimiter //
create procedure CheckBooking(in dateToCheck date, in tableToCheck int) begin
declare tableNumberBooked int;
select TableNumber into tableNumberBooked from Bookings where BookingDate = dateToCheck and TableNumber = tableToCheck limit 1;
if tableNumberBooked is null then
select concat("Table number ", tableToCheck, " is available") as "Booking Status";
else
select concat("Table number ", tableToCheck, " is already booked") as "Booking Status";
end if;
end//
delimiter ;
call CheckBooking("2022-11-12", 3);

drop procedure if exists AddValidBooking;
delimiter //
create procedure AddValidBooking(in dateToAdd date, in tableToAdd int) begin
declare tableNumberBooked int;
start transaction;
select TableNumber into tableNumberBooked from Bookings where BookingDate = dateToAdd and TableNumber = tableToAdd limit 1;
if tableNumberBooked is not null then
	rollback;
    select concat("Table ", tableToAdd, " was already booked, cannot create reservation") as ReservationResult;
else
	insert into Bookings(BookingDate, TableNumber) values (dateToAdd, tableToAdd);
	commit;
    select concat("Created reservation for table ", tableToAdd) as ReservationResult;
end if;
end//

delimiter ;
call AddValidBooking("2024-02-05", 1);

-- duplicate functionality of AddValidBooking because the grading page thinks it should be called ManageBooking
drop procedure if exists ManageBooking;
delimiter //
create procedure ManageBooking(in dateToAdd date, in tableToAdd int) begin
declare tableNumberBooked int;
start transaction;
select TableNumber into tableNumberBooked from Bookings where BookingDate = dateToAdd and TableNumber = tableToAdd limit 1;
if tableNumberBooked is not null then
	rollback;
    select concat("Table ", tableToAdd, " was already booked, cannot create reservation") as ReservationResult;
else
	insert into Bookings(BookingDate, TableNumber) values (dateToAdd, tableToAdd);
	commit;
    select concat("Created reservation for table ", tableToAdd) as ReservationResult;
end if;
end//

delimiter ;


-- Add/Update bookings task 1 AddBooking
drop procedure if exists AddBooking;
delimiter //
create procedure AddBooking(in bookingID_ToAdd int, in customerID_ToAdd int, in dateToAdd date, in tableToAdd int) 
begin
insert into Bookings(BookingID, BookingDate, TableNumber, CustomerID) values (bookingID_ToAdd, dateToAdd, tableToAdd, customerID_ToAdd);
select concat("Added booking for table ", tableToAdd) as result; 
end//
delimiter ;
call AddBooking(41, 2, "2024-05-05", 2);
select * from Bookings;

-- Add/Update bookings task 2 UpdateBooking
drop procedure if exists UpdateBooking;
delimiter //
create procedure UpdateBooking(in bookingID_ToUpdate int, in bookingDateToSet date)
begin
update Bookings set BookingDate = bookingDateToSet where BookingID = bookingID_toUpdate;
select concat("Updated booking id ", bookingID_ToUpdate) as result;
end //
delimiter ;
call UpdateBooking(41, "2023-05-05");

-- Add/Update bookings task 3 DeleteBooking
drop procedure if exists DeleteBooking;
delimiter //
create procedure DeleteBooking(in bookingID_ToDelete int)
begin
delete from Bookings where BookingID = bookingID_ToDelete;
select concat("Deleted booking id ", bookingID_ToDelete) as result;
end //
delimiter ;
call DeleteBooking(40);
select * from Bookings;