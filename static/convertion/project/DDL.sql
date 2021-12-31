
                DROP TABLE IF EXISTS Customers;
              
                CREATE TABLE Customers(
Customers_id INT NOT NULL AUTO_INCREMENT, 
CompanyName VARCHAR (255),
ContactName VARCHAR (255),
ContactTitle VARCHAR (255),
Phone VARCHAR (255),
Fax VARCHAR (255),
Address VARCHAR (255),
City VARCHAR (255),
Region VARCHAR (255),
PostalCode VARCHAR (255),
Country VARCHAR (255),

                PRIMARY KEY(Customers_id ) );
                


                DROP TABLE IF EXISTS Orders;
              
                CREATE TABLE Orders(
Orders_id INT NOT NULL AUTO_INCREMENT, 
CustomerID VARCHAR (255),
EmployeeID VARCHAR (255),
OrderDate DATETIME,
RequiredDate DATETIME,
ShipVia INT(11) NULL,
Freight DECIMAL(30) NULL,
ShipName VARCHAR (255),
ShipAddress VARCHAR (255),
ShipCity VARCHAR (255),
ShipRegion VARCHAR (255),
ShipPostalCode VARCHAR (255),
ShipCountry VARCHAR (255),

                PRIMARY KEY(Orders_id ) );
                





