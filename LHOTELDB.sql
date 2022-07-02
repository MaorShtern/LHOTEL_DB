

----  יצירת משתמש
--CREATE USER MyLogin FOR LOGIN MyLogin
--ALTER ROLE db_owner ADD MEMBER MyLogin
--GO

SET DATEFORMAT dmy;  
GO


create table Employees_Types
(
	Worker_Code int NOT NULL,
	Description NVARCHAR(30)
	CONSTRAINT [PK_Worker_Code] PRIMARY KEY (Worker_Code)

)
go


create table Tasks_Types
(
	Task_Number int NOT NULL,
	Task_Name NVARCHAR(30) NOT NULL,
	CONSTRAINT [PK_Task_Number] PRIMARY KEY (Task_Number)
)
go


create table Customers_Types
(
	Customers_Type int NOT NULL,
	Description NVARCHAR(30),
	CONSTRAINT [PK_Customers_Type] PRIMARY KEY (Customers_Type)


)
go


create table Rooms
(
	Room_Number int identity(1,1),
	Room_Type NVARCHAR(30) NOT NULL,
	Price_Per_Night int NOT NULL,
	CONSTRAINT [PK_Room_Number] PRIMARY KEY (Room_Number)
)
go



create table Products
(
	Product_Code int identity(1,1),
	Description NVARCHAR(30),
	Price_Per_Unit int NOT NULL,
	Discount_Percentage int NOT NULL,
	CONSTRAINT [PK_Product_Code] PRIMARY KEY (Product_Code)
)
go


create table Bill_Details
(
	Bill_Number int NOT NULL,
	Product_Code int NOT NULL,
	Amount int NOT NULL,
	CONSTRAINT [PK_Bill_Number] PRIMARY KEY (Bill_Number),
	CONSTRAINT [Fk_Product_Code] FOREIGN KEY 
          (Product_Code) REFERENCES Products (Product_Code)
)
go



create table Employees
(
	Employee_ID int NOT NULL,
	Employee_Name nvarchar(30) NOT NULL,
	Phone_Number nvarchar(30) ,
    Birth_Date Date,
	Worker_Code int NOT NULL,
	Hourly_Wage int,
	Address nvarchar(30),
	CONSTRAINT [PK_Employee_ID] PRIMARY KEY (Employee_ID),
   CONSTRAINT [Fk_Worker_Code] FOREIGN KEY 
  (Worker_Code) REFERENCES Employees_Types (Worker_Code)
)
go

create table Employees_Tasks
(
	Employee_ID int NOT NULL,
	Task_Number int,
	Start_Date Date  NOT NULL,
    Start_Time Time  NOT NULL,
	End_Date Date  NOT NULL,
	Task_Status nvarchar(30),
	Description NVARCHAR(30),
	CONSTRAINT [PK_Employee_ID2] PRIMARY KEY (Employee_ID,Task_Number,Start_Date,Start_Time),
	CONSTRAINT [Fk_Employee_ID] FOREIGN KEY 
          (Employee_ID) REFERENCES Employees (Employee_ID),
		  	CONSTRAINT [Fk_Task_Number] FOREIGN KEY 
          (Task_Number) REFERENCES Tasks_Types (Task_Number)
)
go



create table Customers
(
	Customer_ID int NOT NULL,
	Customer_Type int NOT NULL,
	First_Name nvarchar(30) NOT NULL,
	Last_Name nvarchar(30),
	Mail nvarchar(100),
	Phone_Number nvarchar(30) ,
	Card_Holder_Name  nvarchar(30) NOT NULL,
	Credit_Card_Date Date NOT NULL,
	Three_Digit int NOT NULL,
	CONSTRAINT [PK_Customer_ID] PRIMARY KEY (Customer_ID),
	CONSTRAINT [Fk_Customer_Type] FOREIGN KEY 
          (Customer_Type) REFERENCES Customers_Types (Customers_Type)
)
go



create table Customers_Rooms
(
	Customer_ID int NOT NULL,
	Room_Number int NOT NULL,
	Entry_Date Date NOT NULL,
	Exit_Date Date NOT NULL,
	Amount_Of_People int NOT NULL,
	Bill_Number int NOT NULL,
	CONSTRAINT [PK_Customer_ID2] PRIMARY KEY (Customer_ID,Room_Number,Entry_Date),
	CONSTRAINT [Fk_Room_Number] FOREIGN KEY 
    (Room_Number) REFERENCES Rooms (Room_Number)
)
go


create table Bill
(
	Bill_Number int NOT NULL,
	Employee_ID int NOT NULL,
	Customer_ID int NOT NULL,
	Room_Number int NOT NULL,
	Credit_Card_Number nvarchar(12) NOT NULL,
	Purchase_Date Date NOT NULL,
	Bill_Status nvarchar(30) NOT NULL,
	CONSTRAINT [PK_Bill_Number1] PRIMARY KEY (Bill_Number),
	CONSTRAINT [Fk_Bill_Number] FOREIGN KEY (Bill_Number) REFERENCES [dbo].[Bill_Details]([Bill_Number]) ,
	CONSTRAINT [Fk_Employee_ID2] FOREIGN KEY (Employee_ID) REFERENCES Employees (Employee_ID),
	CONSTRAINT [Fk_Customer_ID] FOREIGN KEY (Customer_ID) REFERENCES Customers (Customer_ID),
	CONSTRAINT [Fk_Room_Number1] FOREIGN KEY (Room_Number) REFERENCES [dbo].[Rooms] ([Room_Number])
)
go


select * from [dbo].[Employees_Types]
insert [dbo].[Employees_Types] values(1,'Management')
insert [dbo].[Employees_Types] values(2,'Receptionist')
insert [dbo].[Employees_Types] values(3,'Room service worker')
select * from [dbo].[Tasks_Types]
insert [dbo].[Tasks_Types] values(1,'Room cleaning')
insert [dbo].[Tasks_Types] values(2,'Mini bar filling')
select * from [dbo].[Customers_Types]
insert [dbo].[Customers_Types] values(1,'Common')
insert [dbo].[Customers_Types] values(2,'Regular')
insert [dbo].[Customers_Types] values(3,'VIP')



--select
--    'data source=' + @@servername +
--    ';initial catalog=' + db_name() +
--    case type_desc
--        when 'WINDOWS_LOGIN' 
--            then ';trusted_connection=true'
--        else
--            ';user id=' + suser_name()
--    end
--from sys.server_principals
--where name = suser_name()

--declare @FromDate date = '12-06-2001'
--declare @ToDate date = '12-06-2022'

--select FORMAT(dateadd(day, 
--               rand(checksum(newid()))*(1+datediff(day, @FromDate, @ToDate)), 
--               @FromDate),'dd/MM/yyyy')



-- פרוצדורות עובדים
create proc GetAllEmployees
as
	select * from [dbo].[Employees]
go
--exec GetAllEmployees

exec 

create proc GetEmployeeById
@id int
as
select * from [dbo].[Employees] where [Employee_ID] = @id
go
--exec GetEmployeeById 111


create proc InsertEmployee 
@id int, 
@name nvarchar(30),
@phoneNumber nvarchar(30),
@birthDate date, 
@worker_Code int, 
@hourly_Wage int, 
@address nvarchar(30)
as
	insert  [dbo].[Employees] values (@id,@name,@phoneNumber,@birthDate,@worker_Code,@hourly_Wage,@address)
go
--exec InsertEmployee 111,'aaa','0526211881','23/02/1999',1,40,'aaa'


create proc AlterEmployee
@id int, 
@name nvarchar(30),
@phoneNumber nvarchar(30),
@birthDate date, 
@worker_Code int, 
@hourly_Wage int, 
@address nvarchar(30)
as
	UPDATE [dbo].[Employees]
	SET [Employee_Name] = @name ,[Phone_Number]= @phoneNumber,[Birth_Date]=@birthDate
	,[Worker_Code]=@worker_Code,[Hourly_Wage]=@hourly_Wage,[Address]=@address
	WHERE [Employee_ID] = @id
go
--exec AlterEmployee 111,'aaa','0526211881','23/02/1999',1,40,'bbb'


create proc DeleteEmployeeById
@id int
as
	DELETE FROM [dbo].[Employees] WHERE [Employee_ID] = @id
go
--exec DeleteEmployeeById 111



-- פרוצדורות לקוחות
create proc GetAllCustomers
as
	select * from [dbo].[Customers]
go
--exec GetAllCustomers


create proc GetCustomerById 
@id int
as
	select * from [dbo].[Customers] where [Customer_ID] = @id
go
--exec GetCustomerById 111

create proc AddNewCustomer
@id int,
@Customer_Type int,
@First_Name nvarchar(30),
@Last_Name nvarchar(30),
@Mail nvarchar(100),
@Phone_Number nvarchar(30) ,
@Card_Holder_Name  nvarchar(30),
@Credit_Card_Date Date,
@Three_Digit int
as
	insert [dbo].[Customers] values (@id ,@Customer_Type,@First_Name,@Last_Name,@Mail,@Phone_Number
	,@Card_Holder_Name,@Credit_Card_Date,@Three_Digit)
go
--exec AddNewCustomer 111,1,'AAA','BBB','CCC','0526211881','AAA','02/02/2025',569

create proc AlterCustomerById
@id int,
@Customer_Type int,
@First_Name nvarchar(30),
@Last_Name nvarchar(30),
@Mail nvarchar(100),
@Phone_Number nvarchar(30) ,
@Card_Holder_Name  nvarchar(30),
@Credit_Card_Date Date,
@Three_Digit int
as
	UPDATE [dbo].[Customers]
	SET  [Customer_Type] = @Customer_Type, 
	[First_Name]=@First_Name,
	[Last_Name]=@Last_Name,
	[Mail] = @Mail,
	[Phone_Number] =@Phone_Number, 
	[Card_Holder_Name] =@Card_Holder_Name, 
	[Credit_Card_Date]=@Credit_Card_Date,
	[Three_Digit]=@Three_Digit
	WHERE [Customer_ID] = @id
go
--exec AlterCustomerById 111,1,'AAA','BBB','CCC','0526211881','AAA','02/02/2025',888

create proc DeleteCustomerById
@id int
as
	DELETE FROM [dbo].[Customers] WHERE [Customer_ID] = @id
go
--exec DeleteCustomerById 111 


-- פרוצדורות מוצרים
create proc GetAllProducts
as
	select * from [dbo].[Products]
go
--exec GetAllProducts

create proc GetProductById
@id int
as
	select * from dbo.Products where Products.Product_Code = @id
go
--exec GetProductById 111

create proc AddNewProduct
@Description nvarchar(30) ,
@Price_Per_Unit int ,
@Discount_Percentage int
as
	Insert [dbo].[Products] Values (@Description,@Price_Per_Unit,@Discount_Percentage)
go
--exec AddNewProduct 'AAA',15,0

create proc AlterProductById
@id int,
@Description nvarchar(30) ,
@Price_Per_Unit int ,
@Discount_Percentage int
as
	UPDATE [dbo].[Products]
	SET [Description] = @Description,
	[Price_Per_Unit]=@Price_Per_Unit,
	[Discount_Percentage] = @Discount_Percentage
	WHERE [Product_Code] = @id
go
-- exec AlterProductById 1,'BBB',15,0


create proc DeleteProductById
@id int
as
	DELETE FROM [dbo].[Products] WHERE [Product_Code] = @id
go
-- exec DeleteProductById 2


--  פרוצדורות חדרים 
create proc GetAllRooms
as
	select * from [dbo].[Rooms]
go 
-- exec GetAllRooms

create proc GetRoomById
@id int
as
	select * from [dbo].[Rooms] where [Room_Number] = @id
go
-- exec GetRoomById 111


create proc AddNewRoom
@Room_Type nvarchar(30),
@Price_Per_Night int
as
	Insert [dbo].[Rooms] Values (@Room_Type,@Price_Per_Night)
go
-- exec AddNewRoom 'vila',500


create proc AlterRoomById
@Room_Number int,
@Room_Type nvarchar(30),
@Price_Per_Night int
as
	UPDATE [dbo].[Rooms]
	SET  [Room_Type] = @Room_Type , [Price_Per_Night] = @Price_Per_Night
	WHERE [Room_Number] = @Room_Number
go
-- exec AlterRoomById 1,'SSG',400

create proc DeleteRoomById
@Room_Number int
as
	DELETE FROM [dbo].[Rooms] WHERE [Room_Number] = @Room_Number
go
-- exec DeleteRoomById 1


--  פרוצדורות משימות
create proc GetAllTasks
as
	select*from [dbo].[Employees_Tasks] ORDER BY [Task_Status] DESC
go
-- exec GetAllTasks

create proc GetTaskById
@id int,
@Task_Number int,
@Start_Date date
as
	select * from [dbo].[Employees_Tasks] 
	where [Employee_ID] = @id and [Task_Number] = @Task_Number and [Start_Date] = @Start_Date
go
-- exec GetTaskById 111,1,'20/02/2000'


create proc AddNewTask
@Employee_ID int, 
@Task_Number int,
@Start_Date date,
@Start_Time time(7) ,
@End_Date date,
@Task_Status nvarchar(30),
@Description nvarchar(30)
as
	insert [dbo].[Employees_Tasks]
	values (@Employee_ID,@Task_Number,@Start_Date,@Start_Time,@End_Date,@Task_Status,@Description)
go

-- exec AddNewTask 111,1,'02/02/2022','15:00','03/02/2022','Open','bbb'


create proc AlterTask
@Employee_ID int, 
@Task_Number int,
@Start_Date date,
@Start_Time time(7) ,
@End_Date date,
@Task_Status nvarchar(30),
@Description nvarchar(30)
as
	UPDATE [dbo].[Employees_Tasks]
	SET [Start_Time]=@Start_Time,
	[End_Date]=@End_Date,[Task_Status]=@Task_Status,[Description]=@Description
	WHERE [Employee_ID] = @Employee_ID and [Task_Number]=@Task_Number and [Start_Date]=@Start_Date
go

-- exec AlterTask 111,1,'02/02/2022','20:00','30/01/2555','Close','vvv'


create proc DeleteTask
@Employee_ID int, 
@Task_Number int,
@Start_Date date
as
	delete from [dbo].[Employees_Tasks]
	where [Employee_ID] = @Employee_ID and [Task_Number]=@Task_Number and [Start_Date]=@Start_Date
go

-- exec DeleteTask 111,1,'02/02/2022'


create proc GetCustomersRooms
as
	select * from [dbo].[Customers_Rooms] order by [Entry_Date] DESC
go
-- exec GetCustomersRooms



create proc AddNewCustomerRooms
@Customer_ID int,
@Room_Number int,
@Entry_Date date,
@Exit_Date date,
@Amount_Of_People int,
@Bill_Number int
as
	insert [dbo].[Customers_Rooms] 
	values(@Customer_ID,@Room_Number,@Entry_Date,@Exit_Date,@Amount_Of_People,@Bill_Number)
go

-- exec AddNewCustomerRooms 111,2,'05/06/2021','07/06/2021',1,1


create proc DeleteCustomerRoom
@Customer_ID int,
@Room_Number int,
@Entry_Date date
as
	DELETE FROM [dbo].[Customers_Rooms] 
	WHERE [Customer_ID] = @Customer_ID and [Room_Number] = @Room_Number and [Entry_Date] = @Entry_Date
go

-- exec DeleteCustomerRoom 111,2,'2021-06-05'


create proc FindCustomerRoomByKeys
@Customer_ID int,
@Room_Number int,
@Entry_Date date
as
	select * from [dbo].[Customers_Rooms]
	where [Customer_ID] = @Customer_ID and [Room_Number] = @Room_Number and [Entry_Date] = @Entry_Date
go

-- exec FindCustomerRoomByKeys 111,2,'2022-09-08'


create proc AlterCustomerRoom
@Customer_ID int,
@Room_Number int,
@Entry_Date date,
@Exit_Date date,
@Amount_Of_People int,
@Bill_Number int
as
	UPDATE [dbo].[Customers_Rooms]
	SET [Room_Number] = 3,
	[Exit_Date]=@Exit_Date, 
	[Amount_Of_People] = @Amount_Of_People,
	[Bill_Number] = @Bill_Number
	WHERE [Customer_ID] = @Customer_ID and [Entry_Date] = @Entry_Date 
go

-- exec AlterCustomerRoom 111,2,'2022-09-08','2022-09-14',1,1

--  מביא את החדרים שתאריך היציאה שלהם גדול מהתאריך של היום
--  מצביא על חדרים תפוסים
create proc GetTakenRooms
as
	select * from [dbo].[Customers_Rooms]
	where Exit_Date >= GETDATE() order by [Entry_Date] DESC
go
-- exec GetTakenRooms



--  מביא את החדרים שכבר עשו צאק אווט או צריכים לעשות
-- drop proc GetAvailableRoomsByCurrentDate
--create proc GetAvailableRoomsByCurrentDate
--as
--	SELECT dbo.Rooms.Room_Number, dbo.Rooms.Room_Type, dbo.Rooms.Price_Per_Night, dbo.Customers_Rooms.Entry_Date, dbo.Customers_Rooms.Exit_Date
--	FROM dbo.Customers_Rooms INNER JOIN dbo.Rooms 
--	ON dbo.Customers_Rooms.Room_Number = dbo.Rooms.Room_Number
--	WHERE  (dbo.Customers_Rooms.Exit_Date < GETDATE())
--	GROUP BY dbo.Rooms.Room_Number, dbo.Rooms.Room_Type, dbo.Rooms.Price_Per_Night, dbo.Customers_Rooms.Entry_Date, dbo.Customers_Rooms.Exit_Date
--go
--  exec GetAvailableRoomsByCurrentDate


--  תביא לי את כול החדרים הפנויים
--  חדר פנוי  -->  חדר שתאריך היציאה שלו עבר כבר, חדר שלא מופיע ברשימה
create proc AvailableRooms
as
	SELECT t1.Room_Number,Room_Type, Price_Per_Night  
	FROM dbo.Rooms t1 LEFT JOIN  dbo.Customers_Rooms t2 
	ON t2.Room_Number = t1.Room_Number
	WHERE t2.Room_Number IS NULL or t2.Exit_Date < GETDATE()
go

-- exec AvailableRooms


create proc GetAllBill_Details
as
	select * from [dbo].[Bill_Details]
go
-- exec GetAllBill_Details


create proc GetAllBill_DetailsByNumber
@Bill_Number int
as
	select * from [dbo].[Bill_Details]
	where Bill_Number = @Bill_Number
go
-- exec GetAllBill_DetailsByNumber 1


-------------------------------------------
--  אי אפשר שלקוח יזמין יותר ממוצר אחד 
--  המפתח של "מספר החשבון לא מאפשר כפיליות 
--  יש צורך לשנות את שתי הטבלאות "חשבון" ן-"פרטי חשבון" י
--------------------------------------------
create proc AddNewBill_Detail
@Bill_Number int,
@Product_Code int,
@Amount int
as
	insert [dbo].[Bill_Details]
	values (@Bill_Number, @Product_Code, @Amount)
go
-- exec AddNewBill_Detail 1,2,6


create proc DeletBill_Detail
@Bill_Number int,
@Product_Code int,
@Amount int
as
	DELETE FROM [dbo].[Bill_Details] 
	WHERE Bill_Number = @Bill_Number and Product_Code = @Product_Code and @Amount = @Amount
go
-- exec DeletBill_Detail 1,1,100


create proc AlterBill_Detail
@Bill_Number int,
@Product_Code int,
@Amount int
as
	UPDATE [dbo].[Bill_Details]
	SET Bill_Number = @Bill_Number , Product_Code = @Product_Code, Amount = @Amount
	WHERE Bill_Number = @Bill_Number and Product_Code = @Product_Code
go
-- exec AlterBill_Detail 1,1,100



create proc GetAllBilles
as
	select * from [dbo].[Bill]
go
--exec GetAllBilles


--create proc AddNewBill
--@Employee_ID int,
--@Customer_ID int,
--@Room_Number int,
--@Credit_Card_Number nvarchar(12),
--@Purchase_Date date,
--@Bill_Status nvarchar(30)
--as
--	declare @Bill_Number as int
--	select @Bill_Number = COUNT(*) FROM Employees;
--	insert [dbo].[Bill] 
--	values(@Bill_Number,@Employee_ID, @Customer_ID,@Room_Number,@Credit_Card_Number,@Purchase_Date,@Bill_Status)
--go

--exec AddNewBill 111,111,1,'4580266514789456','01/01/2021','Open'

--exec GetAllCustomers
--exec GetAllEmployees
--SELECT COUNT(*) FROM Employees;

--select * from [dbo].[Bill]














