# Library-management-SQL
# Library Management System

A comprehensive SQL-based library management system designed to efficiently handle book loans, user management, and related operations.

## 📚 Key Features

- Complete member management system
- Book catalog with multiple copies tracking
- Loan system with automatic due dates
- Reservation system for unavailable books
- Automatic fine system for overdue books
- Statistical reports and analysis
- Stored Procedures for common operations
- Triggers for process automation

## 🛠 Technologies Used

- MySQL 8.0
- Stored Procedures
- Triggers
- Views
- Foreign Keys and Constraints

## 📋 Database Schema

The database consists of the following main tables:

### Members
- User information management
- Membership status tracking
- Renewal history

### Books
- Complete catalog
- Multiple copies management
- Physical location tracking
- Categorization

### Loans
- Active and historical loan records
- Automatic due dates
- Return status tracking

### Reservations
- Waiting list for books
- Priority management
- Availability notifications

### Fines
- Automatic calculation
- Payment tracking
- Penalty history

## 💻 Installation

1. Clone the repository
```bash
git clone https://github.com/[your-username]/library-management-system.git
```

2. Import the database schema
```bash
mysql -u [username] -p [database_name] < schema.sql
```

3. Import sample data (optional)
```bash
mysql -u [username] -p [database_name] < sample_data.sql
```

## 📝 Usage Examples

### Register a new loan
```sql
CALL BorrowBook(1, 100, CURRENT_DATE);
```

### Check overdue books
```sql
SELECT m.FirstName, m.LastName, b.Title, l.DueDate
FROM Loans l
JOIN Members m ON l.MemberID = m.MemberID
JOIN Books b ON l.BookID = b.BookID
WHERE l.Status = 'Overdue';
```

## 📊 Available Reports

1. **Loan Analysis**
   - Most requested books
   - Most active members
   - Overdue rate

2. **Inventory Management**
   - Available books
   - Books on loan
   - Active reservations

3. **Financial Reports**
   - Generated fines
   - Received payments
   - Pending fines

## 🤝 How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

