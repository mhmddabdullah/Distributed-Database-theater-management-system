Create database Theater;

CREATE TABLE Theater (
    theater_id      INT IDENTITY(1,1) PRIMARY KEY,
    theater_name    NVARCHAR(100) NOT NULL,
    location        NVARCHAR(200) NOT NULL,
    phone           VARCHAR(20),
    email           NVARCHAR(100),
    opening_time    TIME,
    closing_time    TIME
);


CREATE TABLE Hall (
    hall_id         INT IDENTITY(1,1) PRIMARY KEY,
    theater_id      INT NOT NULL,
    hall_name       NVARCHAR(50) NOT NULL,
    total_capacity  INT NOT NULL,
    screen_type     NVARCHAR(50),
    sound_system    NVARCHAR(50),
    CONSTRAINT FK_Hall_Theater
        FOREIGN KEY (theater_id) REFERENCES Theater(theater_id)
);


CREATE TABLE Seat (
    seat_id         INT IDENTITY(1,1) PRIMARY KEY,
    hall_id         INT NOT NULL,
    seat_row        NVARCHAR(5) NOT NULL,
    seat_number     INT NOT NULL,
    seat_type       NVARCHAR(20),      
    price_category  NVARCHAR(20),
    CONSTRAINT FK_Seat_Hall
        FOREIGN KEY (hall_id) REFERENCES Hall(hall_id)
        ON DELETE CASCADE,
    CONSTRAINT UQ_Seat_HallRowNumber
        UNIQUE (hall_id, seat_row, seat_number)
);


CREATE TABLE Movie (
    movie_id        INT IDENTITY(1,1) PRIMARY KEY,
    title           NVARCHAR(200) NOT NULL,
    genre           NVARCHAR(100),
    duration_min    INT,             
    release_date    DATE,
    description     NVARCHAR(MAX),
    director        NVARCHAR(100),
    language        NVARCHAR(50),
    age_rating      NVARCHAR(20),
    poster_url      NVARCHAR(300)
);


CREATE TABLE Customer (
    customer_id         INT IDENTITY(1,1) PRIMARY KEY,
    first_name          NVARCHAR(50) NOT NULL,
    last_name           NVARCHAR(50) NOT NULL,
    phone               VARCHAR(20),
    email               NVARCHAR(100),
    date_of_birth       DATE,
    registration_date   DATE NOT NULL DEFAULT GETDATE(),
    loyalty_points      INT NOT NULL DEFAULT 0
);

CREATE TABLE Distributor (
    distributor_id  INT IDENTITY(1,1) PRIMARY KEY,
    company_name    NVARCHAR(150) NOT NULL,
    contact_person  NVARCHAR(100),
    phone           VARCHAR(20),
    email           NVARCHAR(100),
    address         NVARCHAR(200)
);


CREATE TABLE Movie_Distributor (
    movie_id        INT NOT NULL,
    distributor_id  INT NOT NULL,
    contract_start  DATE NULL,
    contract_end    DATE NULL,
    CONSTRAINT PK_Movie_Distributor
        PRIMARY KEY (movie_id, distributor_id),
    CONSTRAINT FK_MD_Movie
        FOREIGN KEY (movie_id) REFERENCES Movie(movie_id)
        ON DELETE CASCADE,
    CONSTRAINT FK_MD_Distributor
        FOREIGN KEY (distributor_id) REFERENCES Distributor(distributor_id)
        ON DELETE CASCADE
);


CREATE TABLE [Role] (
    role_id     INT IDENTITY(1,1) PRIMARY KEY,
    role_name   NVARCHAR(50) NOT NULL,
    description NVARCHAR(200)
);


CREATE TABLE Employee (
    employee_id  INT IDENTITY(1,1) PRIMARY KEY,
    theater_id   INT NOT NULL,
    role_id      INT NOT NULL,
    first_name   NVARCHAR(50) NOT NULL,
    last_name    NVARCHAR(50) NOT NULL,
    phone        VARCHAR(20),
    email        NVARCHAR(100),
    position     NVARCHAR(50),
    hire_date    DATE NOT NULL,
    salary       DECIMAL(10,2),
    CONSTRAINT FK_Employee_Theater
        FOREIGN KEY (theater_id) REFERENCES Theater(theater_id),
    CONSTRAINT FK_Employee_Role
        FOREIGN KEY (role_id) REFERENCES [Role](role_id)
);


CREATE TABLE User_Account (
    user_id        INT IDENTITY(1,1) PRIMARY KEY,
    employee_id    INT NOT NULL,
    role_id        INT NOT NULL,
    username       NVARCHAR(50) NOT NULL UNIQUE,
    password_hash  NVARCHAR(255) NOT NULL,
    email          NVARCHAR(100),
    last_login     DATETIME NULL,
    CONSTRAINT FK_UserAccount_Employee
        FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
        ON DELETE CASCADE,
    CONSTRAINT FK_UserAccount_Role
        FOREIGN KEY (role_id) REFERENCES [Role](role_id)
);



CREATE TABLE [Show] (
    show_id      INT IDENTITY(1,1) PRIMARY KEY,
    movie_id     INT NOT NULL,
    hall_id      INT NOT NULL,
    show_date    DATE NOT NULL,
    start_time   TIME NOT NULL,
    end_time     TIME NOT NULL,
    status       NVARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    CONSTRAINT FK_Show_Movie
        FOREIGN KEY (movie_id) REFERENCES Movie(movie_id),
    CONSTRAINT FK_Show_Hall
        FOREIGN KEY (hall_id) REFERENCES Hall(hall_id)
);

CREATE TABLE Booking (
    booking_id      INT IDENTITY(1,1) PRIMARY KEY,
    show_id         INT NOT NULL,
    customer_id     INT NOT NULL,
    booking_date    DATETIME NOT NULL DEFAULT GETDATE(),
    total_amount    DECIMAL(10,2) NOT NULL DEFAULT 0,
    booking_status  NVARCHAR(20) NOT NULL DEFAULT 'Pending',    
	payment_status  NVARCHAR(20) NOT NULL DEFAULT 'Unpaid',     
    CONSTRAINT FK_Booking_Show
        FOREIGN KEY (show_id) REFERENCES [Show](show_id),
    CONSTRAINT FK_Booking_Customer
        FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);


CREATE TABLE Booking_Seat (
    booking_id   INT NOT NULL,
    seat_id      INT NOT NULL,
    price        DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_Booking_Seat
        PRIMARY KEY (booking_id, seat_id),
    CONSTRAINT FK_BS_Booking
        FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
        ON DELETE CASCADE,
    CONSTRAINT FK_BS_Seat
        FOREIGN KEY (seat_id) REFERENCES Seat(seat_id)
);


CREATE TABLE Payment (
    payment_id      INT IDENTITY(1,1) PRIMARY KEY,
    booking_id      INT NOT NULL,
    amount          DECIMAL(10,2) NOT NULL,
    payment_method  NVARCHAR(50) NOT NULL,   
    transaction_id  NVARCHAR(100),
    payment_date    DATETIME NOT NULL DEFAULT GETDATE(),
    payment_gateway NVARCHAR(50),
    discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    payment_status  NVARCHAR(20) NOT NULL DEFAULT 'Completed',
    CONSTRAINT FK_Payment_Booking
        FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
        ON DELETE CASCADE
);


CREATE TABLE Feedback (
    feedback_id   INT IDENTITY(1,1) PRIMARY KEY,
    customer_id   INT NOT NULL,
    rating        INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    feedback_text NVARCHAR(MAX),
    feedback_date DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Feedback_Customer
        FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
        ON DELETE CASCADE
);


CREATE TABLE Maintenance_Request (
    request_id    INT IDENTITY(1,1) PRIMARY KEY,
    theater_id    INT NOT NULL,
    employee_id   INT NOT NULL,
    request_date  DATETIME NOT NULL DEFAULT GETDATE(),
    description   NVARCHAR(MAX) NOT NULL,
    status        NVARCHAR(20) NOT NULL DEFAULT 'Open',   
    CONSTRAINT FK_MR_Theater
        FOREIGN KEY (theater_id) REFERENCES Theater(theater_id),
    CONSTRAINT FK_MR_Employee
        FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);


CREATE TABLE Snack (
    snack_id        INT IDENTITY(1,1) PRIMARY KEY,
    theater_id      INT NOT NULL,
    snack_name      NVARCHAR(100) NOT NULL,
    category        NVARCHAR(50),      
    price           DECIMAL(10,2) NOT NULL,
    stock_quantity  INT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Snack_Theater
        FOREIGN KEY (theater_id) REFERENCES Theater(theater_id)
        ON DELETE CASCADE
);


CREATE TABLE Snack_Order (
    snack_order_id  INT IDENTITY(1,1) PRIMARY KEY,
    customer_id     INT NOT NULL,
    order_date      DATETIME NOT NULL DEFAULT GETDATE(),
    total_amount    DECIMAL(10,2) NOT NULL DEFAULT 0,
    payment_method  NVARCHAR(50) NOT NULL,
    CONSTRAINT FK_SnackOrder_Customer
        FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Snack_Order_Item (
    snack_order_id  INT NOT NULL,
    snack_id        INT NOT NULL,
    quantity        INT NOT NULL,
    subtotal        DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_Snack_Order_Item
        PRIMARY KEY (snack_order_id, snack_id),
    CONSTRAINT FK_SOI_Order
        FOREIGN KEY (snack_order_id) REFERENCES Snack_Order(snack_order_id)
        ON DELETE CASCADE,
    CONSTRAINT FK_SOI_Snack
        FOREIGN KEY (snack_id) REFERENCES Snack(snack_id)
);



/* RECORDS INSERTIONS */
/* RECORDS INSERTIONS */
/* RECORDS INSERTIONS */


INSERT INTO Theater (theater_name, location, phone, email, opening_time, closing_time)
VALUES
(N'Cairo Grand Cinema', N'Nasr City, Cairo', '01000000001', 'info@cairogrand.eg', '10:00', '02:00'),
(N'Alex Sea View Cinema', N'Corniche, Alexandria', '01000000002', 'contact@alexsea.eg', '11:00', '01:00'),
(N'Mall of Egypt IMAX', N'6th of October City, Giza', '01000000003', 'support@moeimax.eg', '09:30', '02:30');


INSERT INTO Hall (theater_id, hall_name, total_capacity, screen_type, sound_system)
VALUES
(1, N'Hall 1 – Regular', 120, N'2D', N'Dolby Digital'),
(1, N'Hall 2 – VIP', 60, N'3D', N'Dolby Atmos'),
(2, N'Sea View Hall', 80, N'2D', N'Surround 7.1'),
(3, N'IMAX Hall', 220, N'IMAX', N'IMAX Sound');


INSERT INTO Seat (hall_id, seat_row, seat_number, seat_type, price_category)
VALUES
(1, 'A', 1, N'Regular', N'Standard'),
(1, 'A', 2, N'Regular', N'Standard'),
(2, 'B', 5, N'VIP', N'Premium'),
(4, 'C', 10, N'VIP', N'IMAX');


INSERT INTO Movie (title, genre, duration_min, release_date, description, director, language, age_rating, poster_url)
VALUES
(N'El-Feel El-Azraq 3', N'Thriller', 130, '2025-07-15', N'Part three of the famous Egyptian thriller.', N'Marwan Hamed', N'Arabic', N'+16', NULL),
(N'Cairo Nights', N'Romance', 115, '2024-12-01', N'Romantic drama set in Downtown Cairo.', N'Sara Hassan', N'Arabic', N'+12', NULL),
(N'Alexandria by the Sea', N'Drama', 105, '2025-03-20', N'Family story in Alexandria corniche.', N'Youssef Adel', N'Arabic', N'PG', NULL),
(N'Mission Nile', N'Action', 125, '2025-05-10', N'Action movie about a mission on the Nile river.', N'Omar Fathy', N'Arabic/English', N'+15', NULL);


INSERT INTO Customer (first_name, last_name, phone, email, date_of_birth, loyalty_points)
VALUES
(N'Ahmed', N'Sherif', '01111111111', 'ahmed.sherif@example.com', '2004-08-18', 120),
(N'Hanan', N'Abou-Elfotouh', '01022222222', 'hanan.abo@example.com', '1990-05-10', 250),
(N'Menna', N'Adel', '01033333333', 'menna.adel@example.com', '1998-11-02', 60),
(N'Youssef', N'Khaled', '01244444444', 'youssef.khaled@example.com', '2002-01-25', 30);


INSERT INTO Distributor (company_name, contact_person, phone, email, address)
VALUES
(N'Masr Films Distribution', N'Khaled Samir', '0223456789', 'info@masrfilms.eg', N'Mohandessin, Giza'),
(N'Nile Pictures', N'Rania Fathy', '0225678912', 'contact@nilepictures.eg', N'Heliopolis, Cairo'),
(N'Alex Cinema Supply', N'Mostafa Hassan', '0345678901', 'sales@alexcinema.eg', N'Sidi Gaber, Alexandria');


INSERT INTO Movie_Distributor (movie_id, distributor_id, contract_start, contract_end)
VALUES
(1, 1, '2025-06-01', '2026-06-01'),
(2, 2, '2024-10-01', '2025-10-01'),
(3, 3, '2025-02-01', '2026-02-01'),
(4, 1, '2025-04-01', '2026-04-01');


INSERT INTO [Role] (role_name, description)
VALUES
(N'Manager', N'Overall theater management'),
(N'Cashier', N'Ticketing and payments'),
(N'Snack Seller', N'Snack bar operations'),
(N'Maintenance', N'Technical and cleaning support');


INSERT INTO Employee (theater_id, role_id, first_name, last_name, phone, email, position, hire_date, salary)
VALUES
(1, 1, N'Mohamed', N'Fouad', '01055500001', 'm.fouad@cairogrand.eg', N'General Manager', '2021-01-10', 18000),
(1, 2, N'Salma', N'Hesham', '01055500002', 'salma.h@cairogrand.eg', N'Head Cashier', '2022-06-15', 9000),
(2, 3, N'Ali', N'Gamal', '01055500003', 'ali.g@alexsea.eg', N'Snack Supervisor', '2023-03-01', 7500),
(3, 4, N'Nour', N'Yehia', '01055500004', 'nour.y@moeimax.eg', N'Maintenance Engineer', '2020-09-20', 9500);


INSERT INTO User_Account (employee_id, role_id, username, password_hash, email)
VALUES
(1, 1, N'manager_cairo', N'hashed_pw_1', 'm.fouad@cairogrand.eg'),
(2, 2, N'cashier_cairo', N'hashed_pw_2', 'salma.h@cairogrand.eg'),
(3, 3, N'snack_alex', N'hashed_pw_3', 'ali.g@alexsea.eg'),
(4, 4, N'maint_moe', N'hashed_pw_4', 'nour.y@moeimax.eg');


INSERT INTO [Show] (movie_id, hall_id, show_date, start_time, end_time, status)
VALUES
(1, 2, '2025-12-20', '19:00', '21:10', N'Scheduled'),
(2, 1, '2025-12-20', '21:30', '23:25', N'Scheduled'),
(3, 3, '2025-12-21', '18:00', '19:45', N'Scheduled'),
(4, 4, '2025-12-21', '20:00', '22:05', N'Scheduled');


INSERT INTO Booking (show_id, customer_id, booking_date, total_amount, booking_status, payment_status)
VALUES
(1, 1, '2025-12-18 14:30', 260.00, N'Confirmed', N'Paid'),
(2, 2, '2025-12-18 15:10', 130.00, N'Confirmed', N'Paid'),
(3, 3, '2025-12-19 11:00', 90.00,  N'Pending',   N'Unpaid'),
(4, 4, '2025-12-19 12:15', 220.00, N'Confirmed', N'Paid');


INSERT INTO Booking_Seat (booking_id, seat_id, price)
VALUES
(1, 1, 130.00),
(1, 2, 130.00),
(2, 3, 130.00),
(4, 4, 220.00);


INSERT INTO Payment (booking_id, amount, payment_method, transaction_id, payment_gateway, discount_amount, payment_status)
VALUES
(1, 260.00, N'Card', N'TRX-CAIRO-0001', N'Fawry', 0.00, N'Completed'),
(2, 130.00, N'Cash', N'TRX-CAIRO-0002', N'OnSite', 0.00, N'Completed'),
(4, 220.00, N'Card', N'TRX-GIZA-0003', N'VodafoneCash', 20.00, N'Completed');


INSERT INTO Feedback (customer_id, rating, feedback_text)
VALUES
(1, 5, N'excellent cinema and very good service.'),
(2, 4, N'Chair are comfy but the sound was very loud.'),
(3, 3, N'normal expectations but they need more organization at the gate.'),
(4, 5, N'very good!');


INSERT INTO Maintenance_Request (theater_id, employee_id, request_date, description, status)
VALUES
(1, 4, '2025-12-10 10:00', N'burnt lamp in hall 1 row B', N'Open'),
(2, 3, '2025-12-11 11:30', N'leakage in main hall', N'In Progress'),
(3, 4, '2025-12-11 13:15', N'problem with sound in IMAX hall', N'Open');


INSERT INTO Snack (theater_id, snack_name, category, price, stock_quantity)
VALUES
(1, N'Popcorn Large', N'Popcorn', 90.00, 200),
(1, N'Pepsi Can', N'Drink', 35.00, 300),
(2, N'Nachos Cheese', N'Snack', 80.00, 120),
(3, N'Caramel Popcorn', N'Popcorn', 95.00, 150);


INSERT INTO Snack_Order (customer_id, order_date, total_amount, payment_method)
VALUES
(1, '2025-12-20 18:40', 160.00, N'Card'),
(2, '2025-12-20 21:00', 35.00,  N'Cash'),
(3, '2025-12-21 17:45', 175.00, N'Card');


INSERT INTO Snack_Order_Item (snack_order_id, snack_id, quantity, subtotal)
VALUES
(1, 1, 1, 90.00),
(1, 2, 2, 70.00),
(2, 2, 1, 35.00),
(3, 3, 1, 80.00),
(3, 4, 1, 95.00);


/* FRAGMENTATIONS */
/* FRAGMENTATIONS */
/* FRAGMENTATIONS */


 /*  Movie split by info type */
SELECT movie_id, title, genre, duration_min
INTO Movie_BasicInfo_B1
FROM Movie;

SELECT movie_id, release_date, director, language, age_rating
INTO Movie_Details_B1
FROM Movie;

SELECT * FROM Movie_BasicInfo_B1;
SELECT * FROM Movie_Details_B1;

/* Customer personal vs contact */
SELECT customer_id, first_name, last_name, date_of_birth
INTO Customer_Personal_B2
FROM Customer;

SELECT customer_id, phone, email, loyalty_points
INTO Customer_Contact_B2
FROM Customer;

SELECT * FROM Customer_Personal_B2;
SELECT * FROM Customer_Contact_B2;


/* Movie Arabic or international */
SELECT *
INTO Movie_Arabic_B3
FROM Movie
WHERE language LIKE '%Arabic%';

SELECT *
INTO Movie_International_B3
FROM Movie
WHERE language NOT LIKE '%Arabic%';

SELECT * FROM Movie_Arabic_B3;
SELECT * FROM Movie_International_B3;


/* Movie Arabic + only key columns */
SELECT movie_id, title, genre, duration_min
INTO Movie_ArabicBasic_B4
FROM Movie
WHERE language LIKE '%Arabic%';


SELECT * FROM Movie_ArabicBasic_B4;


/*  on Movie by duration */

SELECT *
INTO Movie_HF_Short
FROM Movie
WHERE duration_min <= 90;

SELECT *
INTO Movie_HF_Medium
FROM Movie
WHERE duration_min > 90 AND duration_min <= 120;

SELECT *
INTO Movie_HF_Long
FROM Movie
WHERE duration_min > 120;


SELECT * FROM Movie_HF_Short;
SELECT * FROM Movie_HF_Medium;
SELECT * FROM Movie_HF_Long;


/* Customer by age & loyalty */

SELECT *
INTO Customer_HF6_YoungLoyal
FROM Customer
WHERE DATEDIFF(YEAR, date_of_birth, GETDATE()) < 25
  AND loyalty_points >= 100;

SELECT *
INTO Customer_HF6_Other
FROM Customer
WHERE NOT (
    DATEDIFF(YEAR, date_of_birth, GETDATE()) < 25
    AND loyalty_points >= 100
);

SELECT * FROM Customer_HF6_YoungLoyal;
SELECT * FROM Customer_HF6_Other;


/* Show prime-time shows) */

SELECT show_id, movie_id, hall_id, show_date, start_time, end_time
INTO Show_HY7_PrimeTime
FROM [Show]
WHERE show_date >= CAST(GETDATE() AS DATE)      
  AND start_time BETWEEN '18:00' AND '23:00';

  select* from Show_HY7_PrimeTime;


/* Employee: high-salary staff) */

SELECT employee_id, first_name, last_name, position,
       theater_id, salary
INTO Employee_HY8_HighSalary
FROM Employee
WHERE salary >= 12000;  


select* from Employee_HY8_HighSalary;


/* Theaters in/out Cairo */
SELECT *
INTO Theater_HF9_Cairo
FROM Theater
WHERE location LIKE '%Cairo%';

SELECT *
INTO Theater_HF9_NonCairo
FROM Theater
WHERE NOT (location LIKE '%Cairo%' OR location LIKE N'%???????%');



/* Is the snack a drink ot no */

SELECT *
INTO Snack_HF10_Drinks
FROM Snack
WHERE category LIKE '%Drink%';


SELECT *
INTO Snack_HF10_NonDrinks
FROM Snack
WHERE NOT category LIKE '%Drink%' ;

select* from Snack_HF10_Drinks;
select* from Snack_HF10_NonDrinks;



/* Confirmed & Paid bookings */ 
SELECT booking_id,
       show_id,
       customer_id,
       total_amount,
       booking_status,
       payment_status
INTO Booking_HY11_ConfirmedPaid
FROM Booking
WHERE booking_status = 'Confirmed'
  AND payment_status = 'Paid';

  select* from Booking_HY11_ConfirmedPaid;


  /* Active distribution contracts only, with selected columns */ 
SELECT movie_id,
       distributor_id,
       contract_start,
       contract_end
INTO MovieDistributor_HY12_ActiveContracts
FROM Movie_Distributor
WHERE contract_start <= CAST(GETDATE() AS DATE)
  AND (contract_end IS NULL OR contract_end >= CAST(GETDATE() AS DATE));

  select* from MovieDistributor_HY12_ActiveContracts;



 --- DESKTOP-KUM30MN\MSSQLSERVER01---


 ---------------------------------Distrubuted query---------------------------


SELECT customer_id, first_name, last_name
FROM Theater.dbo.Customer
UNION
SELECT customer_id, first_name, last_name
FROM [DESKTOP-KUM30MN\MSSQLSERVER01].Theater_Copy.dbo.Customer;



SELECT booking_id, show_id, customer_id, booking_date, total_amount, booking_status, payment_status
FROM Theater.dbo.Booking
WHERE booking_date >= '2025-12-01' AND booking_date < '2026-01-01'
UNION ALL
SELECT booking_id, show_id, customer_id, booking_date, total_amount, booking_status, payment_status
FROM [DESKTOP-KUM30MN\MSSQLSERVER01].Theater_Copy.dbo.Booking
WHERE booking_date >= '2025-12-01' AND booking_date < '2026-01-01';



SELECT customer_id
FROM Theater.dbo.Customer
EXCEPT
SELECT customer_id
FROM [DESKTOP-KUM30MN\MSSQLSERVER01].Theater_Copy.dbo.Customer;



SELECT customer_id
FROM [DESKTOP-KUM30MN\MSSQLSERVER01].Theater_Copy.dbo.Customer
EXCEPT
SELECT customer_id
FROM Theater.dbo.Customer;

SELECT customer_id
FROM Theater.dbo.Customer
INTERSECT
SELECT customer_id
FROM [DESKTOP-KUM30MN\MSSQLSERVER01].Theater_Copy.dbo.Customer;


SELECT movie_id, title
FROM Theater.dbo.Movie
INTERSECT
SELECT movie_id, title
FROM [DESKTOP-KUM30MN\MSSQLSERVER01].Theater_Copy.dbo.Movie;


SELECT payment_id, booking_id, amount, payment_method, payment_date, 'LOCAL' AS source_side
FROM Theater.dbo.Payment
WHERE amount >= 150
UNION
SELECT payment_id, booking_id, amount, payment_method, payment_date, 'REMOTE' AS source_side
FROM [DESKTOP-KUM30MN\MSSQLSERVER01].Theater_Copy.dbo.Payment
WHERE amount >= 150;


SELECT seat_id, hall_id, seat_row, seat_number, seat_type, price_category
FROM Theater.dbo.Seat
WHERE seat_type = N'VIP'
EXCEPT
SELECT seat_id, hall_id, seat_row, seat_number, seat_type, price_category
FROM [DESKTOP-KUM30MN\MSSQLSERVER01].Theater_Copy.dbo.Seat
WHERE seat_type = N'VIP';



