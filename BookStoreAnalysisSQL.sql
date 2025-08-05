-- create database
CREATE DATABASE BookStore;

USE BookStore;

-- create tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books ( 
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10,2),
    Stock INT
    );
    
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
	Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(50)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
Order_ID SERIAL PRIMARY KEY,
Customer_ID INT REFERENCES Customers(Customer_ID),
Book_ID INT REFERENCES Books(Book_ID),
Order_Data DATE,
Quantity INT,
Total_Amount NUMERIC(10,2)
);

Select * from Books;
Select * from Customers;
Select * from Orders;

-- 1. Retrieve all books in "Fiction" genre
SELECT * FROM Books 
WHERE Genre="Fiction";

-- 2. Find books pyblised after 1950
SELECT * FROM Books
WHERE Published_Year>1950;

-- 3. List all the customers from canada
SELECT * FROM Customers
WHERE Country="Canada";

-- 4. Show orders placed in November 2023
SELECT * FROM Orders;
SELECT * FROM Orders
WHERE Order_Data BETWEEN '2023-11-01' AND '2023-11-30';

-- 5. Change Order_Data column name in orders table to Order_Date
ALTER TABLE Orders
RENAME COLUMN Order_Data TO Order_Date;

-- 6. Retrieve the total stock of books available
SELECT SUM(Stock) AS Total_Stock from Books;

-- 7. Find the details of most expensive book
SELECT * FROM books
WHERE Price=(SELECT MAX(Price) AS Max_Amount FROM Books);

SELECT * FROM Books ORDER BY Price DESC LIMIT 1;

-- 8. Show all customers who have ordered more than 1 book
SELECT * FROM Orders 
WHERE Quantity>1;

-- 9. Retrieve all the orders where the total amt exceed $20
SELECT * FROM Orders
WHERE Total_Amount>20;

-- 10. List all the genre available in books table
SELECT Genre FROM Books
GROUP BY Genre;

SELECT DISTINCT Genre FROM Books;

-- 11. Find the book with lowest stcok
SELECT * FROM Books 
ORDER BY STOCK 
LIMIT 1;

-- 12. Calculate the total revenue generated from all orders
SELECT SUM(Total_Amount) FROM Orders AS Total_Revenue;

-- 13. Retrive the total number of books sold for each genre
SELECT B.Genre, SUM(O.Quantity) AS Total_Books_Sold 
FROM Books B
JOIN Orders O ON B.Book_ID = O.Book_ID
GROUP BY B.Genre;

-- 14. Find the average price of book in Fantasy genre
SELECT AVG(Price) AS Average_Price FROM books 
WHERE Genre="Fantasy";

-- 15. List Customers who have place at least 2 orders
SELECT O.Customer_ID, C.Name, COUNT(O.Order_ID)  AS Order_Count
From Orders O 
JOIN Customers C ON O.Customer_ID=C.Customer_ID;

-- 16. Find the most frequent ordered book
SELECT O.Book_ID, B.Title, COUNT(O.Order_ID) AS Order_Count
FROM Orders O
JOIN Books B ON B.Book_id=O.Book_ID
GROUP BY O.Book_ID, Title
ORDER BY Order_Count DESC
LIMIT 1;


-- 17.  Show top 3 most expensive fantasy books
SELECT * FROM books 
WHERE Genre="Fantasy"
ORDER BY Price DESC LIMIT 3;

-- 18. Retrieve the total quantity of book sold by eac author
SELECT B.Author, SUM(O.Quantity) AS Total_books_sold
FROM Orders O 
JOIN Books B ON B.Book_ID=O.Book_ID
GROUP BY B.Author;

-- 19. List the city where customer who purchase more than $30 are located
SELECT DISTINCT C.City, Total_Amount
FROM Orders O 
JOIN Customers C ON O.Customer_ID=C.Customer_ID
WHERE O.Total_Amount>30;

-- 20. Find the customers who spend most on order
SELECT C.Customer_ID, C.Name, SUM(O.Total_Amount) AS Total_Spent
FROM Orders O 
JOIN Customers C ON C.Customer_ID=O.Customer_ID
GROUP BY C.Customer_ID, C.Name
ORDER BY Total_Spent DESC LIMIT 1;

-- 21. Calculate the stock remaining after fullfilling all the orders
SELECT B.Book_ID, B.Title, B.Stock, COALESCE(SUM(O.Quantity),0) AS Order_Quantity,
B.Stock - COALESCE(SUM(O.Quantity),0) AS Remaining_Quantity
FROM Books B
LEFT JOIN Orders O ON O.Book_ID=B.Book_ID
GROUP BY B.Book_ID;

Select * from Orders;