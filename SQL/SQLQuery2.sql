Create database Sub_Theater;

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


USE Sub_Theater;

INSERT INTO Theater (theater_name, location, phone, email, opening_time, closing_time)
VALUES
(N'REMOTE - Alex Sea View Cinema', N'Corniche, Alexandria', '01000000002', 'remote@subtheater.eg', '11:00', '01:00');

INSERT INTO Hall (theater_id, hall_name, total_capacity, screen_type, sound_system)
VALUES
(1, N'REMOTE - Hall B', 80, N'3D', N'Dolby Atmos');

INSERT INTO Customer (first_name, last_name, phone, email, date_of_birth, loyalty_points)
VALUES
(N'RemoteUser', N'Two', '01022222222', 'remote.two@example.com', '1998-11-02', 60);