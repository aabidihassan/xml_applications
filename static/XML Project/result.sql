DROP TABLE IF EXISTS Root;              
                CREATE TABLE Root(Root_id INT NOT NULL, 
                PRIMARY KEY(Root_id ) );
                
                DROP TABLE IF EXISTS Customers;              
                CREATE TABLE Customers(Customers_id INT NOT NULL, CompanyName VARCHAR2 (*),ContactName VARCHAR2 (*),ContactTitle VARCHAR2 (*),Phone VARCHAR2 (*),Fax VARCHAR2 (*),Address VARCHAR2 (*),City VARCHAR2 (*),Region VARCHAR2 (*),PostalCode VARCHAR2 (*),Country VARCHAR2 (*),
                PRIMARY KEY(Customers_id ) );
                
                DROP TABLE IF EXISTS Orders;              
                CREATE TABLE Orders(Orders_id INT NOT NULL, CustomerID VARCHAR2 (*),EmployeeID VARCHAR2 (*),OrderDate DATETIME,RequiredDate DATETIME,ShipVia INTEGER (10,0),Freight DECIMAL(30,15),ShipName VARCHAR2 (*),ShipAddress VARCHAR2 (*),ShipCity VARCHAR2 (*),ShipRegion VARCHAR2 (*),ShipPostalCode VARCHAR2 (*),ShipCountry VARCHAR2 (*),
                PRIMARY KEY(Orders_id ) );
                
