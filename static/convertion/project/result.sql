<?xml version="1.0"?>
<root><ddl>
                DROP TABLE IF EXISTS Customers;
              
                CREATE TABLE Customers(
Customers_id INT NOT NULL AUTO_INCREMENT, 
CompanyName VARCHAR2 (*),
ContactName VARCHAR2 (*),
ContactTitle VARCHAR2 (*),
Phone VARCHAR2 (*),
Fax VARCHAR2 (*),
Address VARCHAR2 (*),
City VARCHAR2 (*),
Region VARCHAR2 (*),
PostalCode VARCHAR2 (*),
Country VARCHAR2 (*),

                PRIMARY KEY(Customers_id ) );
                


                DROP TABLE IF EXISTS Orders;
              
                CREATE TABLE Orders(
Orders_id INT NOT NULL AUTO_INCREMENT, 
CustomerID VARCHAR2 (*),
EmployeeID VARCHAR2 (*),
OrderDate DATETIME,
RequiredDate DATETIME,
ShipVia INTEGER (10,0),
Freight DECIMAL(30,15),
ShipName VARCHAR2 (*),
ShipAddress VARCHAR2 (*),
ShipCity VARCHAR2 (*),
ShipRegion VARCHAR2 (*),
ShipPostalCode VARCHAR2 (*),
ShipCountry VARCHAR2 (*),

                PRIMARY KEY(Orders_id ) );
                

</ddl>

<dml>
<table name="Customers">
<attributes>
<attribute>CompanyName</attribute>
<attribute>ContactName</attribute>
<attribute>ContactTitle</attribute>
<attribute>Phone</attribute>
<attribute>Fax</attribute>
<attribute>Address</attribute>
<attribute>City</attribute>
<attribute>Region</attribute>
<attribute>PostalCode</attribute>
<attribute>Country</attribute>
</attributes>
</table>
<table name="Orders">
<attributes>
<attribute>CustomerID</attribute>
<attribute>EmployeeID</attribute>
<attribute>OrderDate</attribute>
<attribute>RequiredDate</attribute>
<attribute>ShipVia</attribute>
<attribute>Freight</attribute>
<attribute>ShipName</attribute>
<attribute>ShipAddress</attribute>
<attribute>ShipCity</attribute>
<attribute>ShipRegion</attribute>
<attribute>ShipPostalCode</attribute>
<attribute>ShipCountry</attribute>
</attributes>
</table>
</dml></root>
