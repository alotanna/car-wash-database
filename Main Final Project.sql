-- Create a database named car wash with the following tables :
-- customers, vehicles[vehicleid(primary key), customerId, make, model,year, lincense plate, color], 
-- services[service id(primary key),serviceName, description,price], appointments[appointmentId,customerId,Vehicleid,ServiceId,Appointment Date,Appointment time, status(scheduled, completed and cancelled)]
-- employees[employeeid, firstName, lastName,email, phone number,Role or roleId] , employee roles[roleId,roleName, roleDescription], transactions[transactionID, appointmentid,customerid,vehicle id,service id,transaction date, total ammount, payment method
-- Feedback [ feedback id, CustomerId, appointment id, serviceid, rating, comments, feedback date]
-- inventory[itemId, itemName, description, quantity, unitprice, supplierid]
-- Suppliers [SupplierId, supplierName, ContactName, ContactEmail, ContactPhone, Address]
-- Employeeschedules[scheduleId, EmployeeID,  WorkDate, StartTime, EndTime
-- Memberships[membership id,CustomerID, Membershiptype(Basic, Premium, Unlimited), Start Date, Endate, Fee
-- Loyalty programs[program id, customerId, PointsAccumulated, rewardDescription, membership id]
-- Equipment[equipmentID, Equipment Name , Description, purchase date, last maintenance, next maintenance date, status(active, inactive, under maintenance)]

-- Database Creation
DROP DATABASE IF EXISTS CarWash;
CREATE DATABASE CarWash;
USE CarWash;

-- Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL
);

-- Vehicles table
CREATE TABLE Vehicles (
    VehicleID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    Make VARCHAR(255) NOT NULL,
    Model VARCHAR(255) NOT NULL,
    Year INT NOT NULL,
    LicensePlate VARCHAR(20) UNIQUE NOT NULL,
    Color VARCHAR(30) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


-- Services table
CREATE TABLE Services (
    ServiceID INT PRIMARY KEY AUTO_INCREMENT,
    ServiceName VARCHAR(100) UNIQUE NOT NULL,
    Description TEXT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL CHECK (Price > 0)
);

-- Appointments table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    VehicleID INT NOT NULL,
    ServiceID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Status ENUM('Scheduled', 'Completed', 'Cancelled') NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);

-- EmployeeRoles table
CREATE TABLE EmployeeRoles (
    RoleID INT PRIMARY KEY AUTO_INCREMENT,
    RoleName VARCHAR(255) UNIQUE NOT NULL,
    RoleDescription TEXT NOT NULL
);

-- Create the Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
    Password VARCHAR(225) NOT NULL,
    RoleID INT NOT NULL,
    FOREIGN KEY (RoleID) REFERENCES EmployeeRoles(RoleID)
);

-- Create the Employee Appointment table
CREATE TABLE EmployeeAppointments (
    EmployeeAppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL,
    AppointmentID INT NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

-- Create the Transactions table
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    AppointmentID INT NOT NULL,
    CustomerID INT NOT NULL,
    VehicleID INT NOT NULL,
    ServiceID INT NOT NULL,
    TransactionDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL CHECK (TotalAmount >= 0),
    PaymentMethod VARCHAR(20) NOT NULL,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);

-- Create the Feedback table
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    AppointmentID INT NOT NULL,
    ServiceID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5) NOT NULL,
    Comments TEXT,
    FeedbackDate DATE NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);

-- Create the Suppliers table
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierName VARCHAR(100) UNIQUE NOT NULL,
    ContactName VARCHAR(255) NOT NULL,
    ContactEmail VARCHAR(100) UNIQUE NOT NULL,
    ContactPhone VARCHAR(15) UNIQUE NOT NULL,
    Address TEXT NOT NULL
);

-- Create the Inventory table
CREATE TABLE Inventory (
    ItemID INT PRIMARY KEY AUTO_INCREMENT,
    ItemName VARCHAR(100) UNIQUE NOT NULL,
    Description TEXT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    UnitPrice DECIMAL(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    SupplierID INT NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Create the EmployeeSchedules table
CREATE TABLE EmployeeSchedules (
    ScheduleID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL,
    WorkDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Create the Memberships table
CREATE TABLE Memberships (
    MembershipID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    MembershipType ENUM('Basic', 'Premium', 'Unlimited') NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Fee DECIMAL(10, 2) NOT NULL CHECK (Fee >= 0),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create the LoyaltyPrograms table
CREATE TABLE LoyaltyPrograms (
    ProgramID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    PointsAccumulated INT NOT NULL CHECK (PointsAccumulated >= 0),
    RewardDescription TEXT,
    MembershipID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (MembershipID) REFERENCES Memberships(MembershipID)
);

-- Create the Equipment table
CREATE TABLE Equipment (
    EquipmentID INT PRIMARY KEY AUTO_INCREMENT,
    EquipmentName VARCHAR(100) UNIQUE NOT NULL,
    Specification TEXT NOT NULL,
    PurchaseDate DATE NOT NULL,
    LastMaintenance DATE NOT NULL,
    NextMaintenanceDate DATE NOT NULL,
    EquipmentStatus ENUM('Active', 'Inactive', 'Under Maintenance') NOT NULL
);

INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890'),
('Jane', 'Smith', 'jane.smith@example.com', '0987654321'),
('Alice', 'Johnson', 'alice.johnson@example.com', '1122334455'),
('Bob', 'Brown', 'bob.brown@example.com', '5566778899'),
('Charlie', 'Davis', 'charlie.davis@example.com', '6677889900');

INSERT INTO Vehicles (CustomerID, Make, Model, Year, LicensePlate, Color) VALUES
(1, 'Toyota', 'Camry', 2020, 'ABC123', 'Red'),
(2, 'Honda', 'Civic', 2019, 'XYZ789', 'Blue'),
(3, 'Ford', 'Focus', 2018, 'DEF456', 'Black'),
(4, 'Chevrolet', 'Malibu', 2021, 'GHI012', 'White'),
(5, 'Nissan', 'Altima', 2017, 'JKL345', 'Gray');

INSERT INTO Services (ServiceName, Description, Price) VALUES
('Basic Wash', 'Includes exterior wash and dry', 15.00),
('Deluxe Wash', 'Includes exterior wash, dry, and wax', 25.00),
('Premium Wash', 'Includes exterior wash, dry, wax, and interior cleaning', 35.00),
('Detailing', 'Full detailing including interior and exterior', 75.00),
('Oil Change', 'Includes oil and filter change', 40.00);

INSERT INTO EmployeeRoles (RoleName, RoleDescription) VALUES
('Manager', 'Oversees the operations of the car wash, manages staff, and ensures customer satisfaction.'),
('Technician', 'Handles the maintenance and repair of car wash equipment and systems.'),
('Cleaner', 'Performs general cleaning duties at the car wash facility, including sweeping and trash removal.'),
('Cashier', 'Handles customer payments and transactions'),
('Receptionist', 'Manages appointments and customer inquiries');

INSERT INTO Employees (FirstName, LastName, Email, PhoneNumber, Password, RoleID) VALUES
('Emily', 'Asante', 'emily.clark@example.com', '1231231234', 'Jahbless', 1),
('David', 'Osei', 'david.miller@example.com', '3213214321', 'wazaaH', 2),
('Sophia', 'Amoah', 'sophia.martinez@example.com', '1112223333', 'clapclapclap',  3),
('James', 'Cudjoe', 'james.garcia@example.com', '4445556666', 'eeishEeish', 4),
('Olivia', 'Yussif', 'olivia.rodriguez@example.com', '7778889999', 'BlessJah',  5);

INSERT INTO Suppliers (SupplierName, ContactName, ContactEmail, ContactPhone, Address) VALUES
('Supplier A', 'Alice Green', 'alice.green@example.com', '1231231234', '123 Main St'),
('Supplier B', 'Bob White', 'bob.white@example.com', '3213214321', '456 Elm St'),
('Supplier C', 'Charlie Black', 'charlie.black@example.com', '1112223333', '789 Oak St'),
('Supplier D', 'David Gray', 'david.gray@example.com', '4445556666', '101 Pine St'),
('Supplier E', 'Eve Brown', 'eve.brown@example.com', '7778889999', '202 Maple St');

INSERT INTO Appointments (CustomerID, VehicleID, ServiceID, AppointmentDate, AppointmentTime, Status) VALUES
(1, 1, 1, '2024-07-18', '10:00', 'Scheduled'),
(2, 2, 2, '2024-07-18', '11:00', 'Scheduled'),
(3, 3, 3, '2024-07-19', '12:00', 'Completed'),
(4, 4, 4, '2024-07-20', '13:00', 'Cancelled'),
(5, 5, 5, '2024-07-21', '14:00', 'Scheduled'),
(1, 2, 3, '2024-07-22', '15:00', 'Cancelled'),
(2, 3, 4, '2024-07-23', '16:00', 'Completed'),
(3, 4, 1, '2024-07-24', '17:00', 'Scheduled'),
(4, 5, 2, '2024-07-25', '18:00', 'Scheduled'),
(5, 1, 3, '2024-07-26', '19:00', 'Cancelled');

INSERT INTO EmployeeAppointments (EmployeeID, AppointmentID) VALUES
(1, 1),
(1,6),
(2, 2),
(2,7),
(3, 3),
(3,8),
(4, 4),
(4,9),
(5, 5),
(5,10);

INSERT INTO Transactions (AppointmentID, CustomerID, VehicleID, ServiceID, TransactionDate, TotalAmount, PaymentMethod) VALUES
(1, 1, 1, 1, '2024-07-18', 15.00, 'Credit Card'),
(2, 2, 2, 2, '2024-07-18', 25.00, 'Cash'),
(3, 3, 3, 3, '2024-07-19', 35.00, 'Credit Card'),
(4, 4, 4, 4, '2024-07-20', 75.00, 'Debit Card'),
(5, 5, 5, 5, '2024-07-21', 40.00, 'Credit Card'),
(6, 1, 2, 3, '2024-07-22', 35.00, 'Cash'),
(7, 2, 3, 4, '2024-07-23', 75.00, 'Debit Card'),
(8, 3, 4, 1, '2024-07-24', 15.00, 'Credit Card'),
(9, 4, 5, 2, '2024-07-25', 25.00, 'Cash'),
(10, 5, 1, 3, '2024-07-26', 35.00, 'Debit Card');

INSERT INTO Feedback (CustomerID, AppointmentID, ServiceID, Rating, Comments, FeedbackDate) VALUES
(1, 1, 1, 5, 'Excellent service!', '2024-07-18'),
(2, 2, 2, 4, 'Very good.', '2024-07-18'),
(3, 3, 3, 3, 'Average service.', '2024-07-19'),
(4, 4, 4, 2, 'Not satisfied.', '2024-07-20'),
(5, 5, 5, 1, 'Terrible experience.', '2024-07-21'),
(1, 6, 3, 4, 'Good service.', '2024-07-22'),
(2, 7, 4, 5, 'Excellent!', '2024-07-23'),
(3, 8, 1, 3, 'Okay service.', '2024-07-24'),
(4, 9, 2, 4, 'Very good.', '2024-07-25'),
(5, 10, 3, 5, 'Outstanding!', '2024-07-26');

INSERT INTO Inventory (ItemName, Description, Quantity, UnitPrice, SupplierID) VALUES
('Car Shamp', 'High quality car wash soap', 50, 10.00, 1),
('Wax', 'Car wax for shine', 30, 15.00, 2),
('Tire Cleaner', 'Cleaner for tires', 40, 12.00, 3),
('Air Freshener', 'Car air freshener', 100, 5.00, 4),
('Oil', 'Engine oil', 20, 25.00, 5),
('Microfiber Cloth', 'Cleaning cloth', 200, 2.00, 1),
('Wheel Cleaner', 'Cleaner for wheels', 60, 8.00, 2),
('Glass Cleaner', 'Cleaner for car windows', 80, 7.00, 3),
('Polish', 'Car polish', 50, 20.00, 4),
('Detailing Kit', 'Complete detailing kit', 10, 50.00, 5);

INSERT INTO EmployeeSchedules (EmployeeID, WorkDate, StartTime, EndTime) VALUES
(1, '2024-07-18', '08:00', '16:00'),
(2, '2024-07-18', '09:00', '17:00'),
(3, '2024-07-18', '10:00', '18:00'),
(4, '2024-07-19', '08:00', '16:00'),
(5, '2024-07-19', '09:00', '17:00');

INSERT INTO Memberships (CustomerID, MembershipType, StartDate, EndDate, Fee) VALUES
(1, 'Basic', '2024-01-01', '2024-12-31', 100.00),
(2, 'Premium', '2024-01-01', '2024-12-31', 200.00),
(3, 'Unlimited', '2024-01-01', '2024-12-31', 300.00),
(4, 'Basic', '2024-02-01', '2024-12-31', 100.00),
(5, 'Premium', '2024-02-01', '2024-12-31', 200.00),
(1, 'Unlimited', '2024-03-01', '2024-12-31', 300.00),
(2, 'Basic', '2024-03-01', '2024-12-31', 100.00),
(3, 'Premium', '2024-03-01', '2024-12-31', 200.00),
(4, 'Unlimited', '2024-04-01', '2024-12-31', 300.00),
(5, 'Basic', '2024-04-01', '2024-12-31', 100.00);

INSERT INTO LoyaltyPrograms (CustomerID, PointsAccumulated, RewardDescription, MembershipID) VALUES
(1, 100, 'Free Wash', 1),
(2, 200, 'Discount on Services', 2),
(3, 300, 'Free Oil Change', 3),
(4, 150, 'Discount on Products', 4),
(5, 250, 'Free Detailing', 5),
(1, 120, 'Free Wash', 6),
(2, 220, 'Discount on Services', 7),
(3, 320, 'Free Oil Change', 8),
(4, 170, 'Discount on Products', 9),
(5, 270, 'Free Detailing', 10);

INSERT INTO Equipment (EquipmentName, Specification, PurchaseDate, LastMaintenance, NextMaintenanceDate, EquipmentStatus) VALUES
('Pressure Washer', 'High-pressure washer for cleaning cars', '2023-01-01', '2024-01-01', '2025-01-01', 'Active'),
('Vacuum Cleaner', 'Vacuum for interior cleaning', '2023-02-01', '2024-02-01', '2025-02-01', 'Active'),
('Air Compressor', 'Compressor for tire inflation', '2023-03-01', '2024-03-01', '2025-03-01', 'Under Maintenance'),
('Water Tank', 'Tank for storing water', '2023-04-01', '2024-04-01', '2025-04-01', 'Active'),
('Polisher', 'Polishing machine for car surfaces', '2023-05-01', '2024-05-01', '2025-05-01', 'Inactive'),
('Tool Kit', 'Tools for general maintenance', '2023-06-01', '2024-06-01', '2025-06-01', 'Active'),
('Generator', 'Backup power generator', '2023-07-01', '2024-07-01', '2025-07-01', 'Active'),
('Steam Cleaner', 'Steam cleaner for detailing', '2023-08-01', '2024-08-01', '2025-08-01', 'Inactive'),
('Tire Balancer', 'Machine for balancing tires', '2023-09-01', '2024-09-01', '2025-09-01', 'Active'),
('Diagnostic Tool', 'Tool for vehicle diagnostics', '2023-10-01', '2024-10-01', '2025-10-01', 'Active');

-- Select all records from Customers table
SELECT * FROM Customers;

-- Select all records from Vehicles table
SELECT * FROM Vehicles;

-- Select all records from Services table
SELECT * FROM Services;

-- Select all records from EmployeeRoles table
SELECT * FROM EmployeeRoles;

-- Select all records from Employees table
SELECT * FROM Employees;

-- Select all records from Suppliers table
SELECT * FROM Suppliers;

-- Select all records from Appointments table
SELECT * FROM Appointments;

-- Select all records from Transactions table
SELECT * FROM Transactions;

-- Select all records from Feedback table
SELECT * FROM Feedback;

-- Select all records from Inventory table
SELECT * FROM Inventory;

-- Select all records from EmployeeSchedules table
SELECT * FROM EmployeeSchedules;

-- Select all records from Memberships table
SELECT * FROM Memberships;

-- Select all records from LoyaltyPrograms table
SELECT * FROM LoyaltyPrograms;

-- Select all records from Equipment table
SELECT * FROM Equipment;


-- --Select the most dominant mode of payment
Select PaymentMethod, count(*) as Count
from Transactions
group by PaymentMethod
order by count desc
limit 1;

-- --Order the customers according to the amount of money spent on transactions from the highest to the lowest
select CustomerID, Sum(TotalAmount) as TotalSpent
from Transactions
group by CustomerID
having count(*) > 1
order by TotalSpent desc;

-- Get the number of equipment spoil and which are available for use or are under maintenance
select EquipmentStatus, count(*) as EquipmentCount
from Equipment
group by EquipmentStatus;


-- Customers who are premium members that have accumulated more than 100 loyalty points
select c.customerid, c.firstname, c.lastname, lp.pointsaccumulated
from customers c
inner join memberships m on c.customerid = m.customerid
inner join loyaltyprograms lp on c.customerid = lp.customerid
where m.membershiptype = 'premium' and lp.pointsaccumulated > 100;

-- Find completed appointments for customers with last names starting with 'S'
select c.customerid, c.firstname, c.lastname, a.appointmentdate, a.status
from customers c
right join appointments a on c.customerid = a.customerid
where c.lastname like 'S%'
and a.status = 'completed';

-- Find all customers and their appointment details, including customers who do not have any appointments. USING OUTER JOIN
select c.customerid, c.firstname, c.lastname, a.appointmentid, a.appointmentdate, a.status
from customers c
left join appointments a on c.customerid = a.customerid
order by c.customerid, a.appointmentdate;

-- Find the number of transactions for each service, ordered by the number of transactions
select s.servicename, count(t.transactionid) as transaction_count
from services s
inner join transactions t on s.serviceid = t.serviceid
group by s.servicename
order by transaction_count desc;

-- Find suppliers with their total stock
select s.suppliername, sum(i.quantity) as total_stock
from suppliers s
left join inventory i on s.supplierid = i.supplierid
group by s.suppliername
having sum(i.quantity) is not null
order by total_stock desc;

#This CTE calculates the total amount spent by each customer and then returns customers who have spent more than $10
WITH CustomerSpending AS (
    SELECT CustomerID, SUM(TotalAmount) AS TotalSpent
    FROM Transactions
    GROUP BY CustomerID
)
SELECT c.CustomerID, c.FirstName, c.LastName, cs.TotalSpent
FROM Customers c
INNER JOIN CustomerSpending cs ON c.CustomerID = cs.CustomerID
WHERE cs.TotalSpent > 10;

#This CTE calculates the number of appointments for each service and retrieves services with more than 2 appointments.
WITH ServiceAppointmentCounts AS (
    SELECT ServiceID, COUNT(AppointmentID) AS AppointmentCount
    FROM Appointments
    GROUP BY ServiceID
)
SELECT s.ServiceName, sac.AppointmentCount
FROM Services s
INNER JOIN ServiceAppointmentCounts sac ON s.ServiceID = sac.ServiceID
WHERE sac.AppointmentCount > 2;

select * from Appointments