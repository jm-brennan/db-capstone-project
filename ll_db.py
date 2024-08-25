import mysql.connector as connector

connection = connector.connect(user="u1", password="pwd",db="LittleLemonDB")
cursor = connection.cursor()
show_tables_query = "show tables" 
cursor.execute(show_tables_query)
result = cursor.fetchall()
print("Tables in databse")
for row in result:
    print(row)

customers_with_order_over_sixty_query = """
select Customers.Name, Customers.PhoneNumber, Customers.Email from Orders inner join Bookings on Orders.BookingID = Bookings.BookingID inner join Customers on Bookings.CustomerID = Customers.CustomerID where Orders.TotalCost > 60;
"""

print("Customers who spent more than $60")
cursor.execute(customers_with_order_over_sixty_query)
result = cursor.fetchall()
for row in result:
    print(row)

