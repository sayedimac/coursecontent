CREATE SCHEMA Data;
GO


CREATE TABLE Data.Membership (
    MemberID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    FirstName VARCHAR(100) MASKED WITH (FUNCTION = 'partial(1, "xxxxx", 1)') NULL,
    LastName VARCHAR(100) NOT NULL,
    Phone VARCHAR(12) MASKED WITH (FUNCTION = 'default()') NULL,
    Email VARCHAR(100) MASKED WITH (FUNCTION = 'email()') NOT NULL,
    DiscountCode SMALLINT MASKED WITH (FUNCTION = 'random(1, 100)') NULL,
    BirthDay DATETIME MASKED WITH (FUNCTION = 'default()') NULL
);



INSERT INTO Data.Membership (FirstName, LastName, Phone, Email, DiscountCode, BirthDay)
VALUES
('Roberto', 'Tamburello', '555.123.4567', 'RTamburello@contoso.com', 10, '1985-01-25 03:25:05'),
('Janice', 'Galvin', '555.123.4568', 'JGalvin@contoso.com.co', 5, '1990-05-14 11:30:00'),
('Shakti', 'Menon', '555.123.4570', 'SMenon@contoso.net', 50, '2004-02-29 14:20:10'),
('Zheng', 'Mu', '555.123.4569', 'ZMu@contoso.net', 40, '1990-03-01 06:00:00');
GO


CREATE SCHEMA Service;
GO


CREATE TABLE Service.Feedback (
    MemberID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    Feedback VARCHAR(100) MASKED WITH (FUNCTION = 'default()') NULL,
    Rating INT MASKED WITH (FUNCTION = 'default()'),
    Received_On DATETIME
);



INSERT INTO Service.Feedback (Feedback, Rating, Received_On)
VALUES
    ('Good', 4, '2022-01-25 11:25:05'),
    ('Excellent', 5, '2021-12-22 08:10:07'),
    ('Average', 3, '2021-09-15 09:00:00');



CREATE USER ServiceAttendant WITHOUT LOGIN;
GO
CREATE USER ServiceLead WITHOUT LOGIN;
GO
CREATE USER ServiceManager WITHOUT LOGIN;
GO
CREATE USER ServiceHead WITHOUT LOGIN;
GO



ALTER ROLE db_datareader ADD MEMBER ServiceAttendant;
ALTER ROLE db_datareader ADD MEMBER ServiceLead;
ALTER ROLE db_datareader ADD MEMBER ServiceManager;
ALTER ROLE db_datareader ADD MEMBER ServiceHead;



--Grant column level UNMASK permission to ServiceAttendant
GRANT UNMASK ON Data.Membership(FirstName) TO ServiceAttendant;
-- Grant table level UNMASK permission to ServiceLead
GRANT UNMASK ON Data.Membership TO ServiceLead;
-- Grant schema level UNMASK permission to ServiceManager
GRANT UNMASK ON SCHEMA::Data TO ServiceManager;
GRANT UNMASK ON SCHEMA::Service TO ServiceManager;
--Grant database level UNMASK permission to ServiceHead;
GRANT UNMASK TO ServiceHead;



EXECUTE AS USER = 'ServiceAttendant';
SELECT MemberID, FirstName, LastName, Phone, Email, BirthDay
FROM Data.Membership;
SELECT MemberID, Feedback, Rating
FROM Service.Feedback;
REVERT;



EXECUTE AS USER = 'ServiceManager';
SELECT MemberID, FirstName, LastName, Phone, Email, BirthDay
FROM Data.Membership;
SELECT MemberID, Feedback, Rating
FROM Service.Feedback;
REVERT;



EXECUTE AS USER = 'ServiceHead';
SELECT MemberID, FirstName, LastName, Phone, Email, BirthDay
FROM Data.Membership;
SELECT MemberID, Feedback, Rating
FROM Service.Feedback;
REVERT;