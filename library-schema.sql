-- Main tables creation

-- Table for library users
CREATE TABLE Members (
    MemberID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    RegistrationDate DATE NOT NULL,
    MemberStatus ENUM('Active', 'Suspended', 'Expired') DEFAULT 'Active',
    LastRenewalDate DATE NOT NULL
);

-- Table for books
CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    ISBN VARCHAR(13) UNIQUE NOT NULL,
    Title VARCHAR(200) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    Publisher VARCHAR(100),
    PublicationYear INT,
    Category VARCHAR(50),
    Location VARCHAR(20),
    AvailableCopies INT DEFAULT 1,
    TotalCopies INT DEFAULT 1
);

-- Table for loans
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    BookID INT,
    LoanDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    Status ENUM('Active', 'Returned', 'Overdue') DEFAULT 'Active',
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Table for reservations
CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    BookID INT,
    ReservationDate DATE NOT NULL,
    Status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Table for fines
CREATE TABLE Fines (
    FineID INT PRIMARY KEY AUTO_INCREMENT,
    LoanID INT,
    Amount DECIMAL(10,2) NOT NULL,
    FineDate DATE NOT NULL,
    PaymentStatus ENUM('Unpaid', 'Paid') DEFAULT 'Unpaid',
    PaymentDate DATE,
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);

-- Stored Procedure for borrowing a book
DELIMITER //
CREATE PROCEDURE BorrowBook(
    IN p_MemberID INT,
    IN p_BookID INT,
    IN p_LoanDate DATE
)
BEGIN
    DECLARE v_AvailableCopies INT;
    
    -- Check availability
    SELECT AvailableCopies INTO v_AvailableCopies
    FROM Books WHERE BookID = p_BookID;
    
    IF v_AvailableCopies > 0 THEN
        -- Insert loan record
        INSERT INTO Loans (MemberID, BookID, LoanDate, DueDate)
        VALUES (p_MemberID, p_BookID, p_LoanDate, DATE_ADD(p_LoanDate, INTERVAL 30 DAY));
        
        -- Update available copies
        UPDATE Books 
        SET AvailableCopies = AvailableCopies - 1
        WHERE BookID = p_BookID;
        
        SELECT 'Loan successfully registered' as Message;
    ELSE
        SELECT 'Book not available' as Message;
    END IF;
END //
DELIMITER ;

-- Trigger for checking overdue books
DELIMITER //
CREATE TRIGGER CheckOverdue
AFTER UPDATE ON Loans
FOR EACH ROW
BEGIN
    IF NEW.ReturnDate IS NULL 
    AND CURRENT_DATE > NEW.DueDate 
    AND NEW.Status != 'Overdue' THEN
        
        UPDATE Loans 
        SET Status = 'Overdue'
        WHERE LoanID = NEW.LoanID;
        
        INSERT INTO Fines (LoanID, Amount, FineDate)
        VALUES (NEW.LoanID, 5.00, CURRENT_DATE);
    END IF;
END //
DELIMITER ;
