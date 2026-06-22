-- Create  database --
Create database	Online_Books_Store;
Use Online_Books_Store;

-- Create tables --
Drop table if exists books;
Create table Books(
  Book_ID Serial Primary key,
  Title varchar(100),
  Author varchar(50),
  Genre Varchar(50),
  Published_Year Int,
  Price numeric(10,2),
  Stock int
  );
  
Drop table if exists Customers;
Create table Customers ( 
   Customer_ID Serial Primary Key,
   Name Varchar(50),
   Email Varchar(100),
   Phone varchar(15),
   City Varchar(50),
   Country varchar(50)
   );
   
Drop table if exists Orders;
Create table Orders (
   Order_ID Serial Primary key,
   Customer_ID Int References Customers(Customer_ID),
   Book_ID Int references books(Book_ID),
   Order_date date,
   Quantity Int,
   Total_Amount Numeric(10,2)
   );
-- Data Imported Using Import wizard function --

-- Question 1. Retrieve all books in the "Fiction" genre --
Select * from books where genre = "Fiction";

-- Question 2. Find books published after the year 1950 --
Select * from books where Published_Year > 1950;

-- Question 3. List all customers from the Canada --
Select * from  customers where Country = "Canada";

-- Question.4 Show orders placed in November 2023 --
Select * from orders where Order_date between '2023-11-01' and '2023-11-30';

-- Question.5 Retrieve the total stock of books available --
Select sum(Stock) as Total_stock from Books; 

-- Question.6 Find the details of the most expensive book --
Select * from books order by price limit 1;

-- Question.7 Show all customers who ordered more than 1 quantity of a book --
Select customer_id,Quantity from orders where Quantity > 1;

-- Question.8 Retrieve all orders where the total amount exceeds $20 --
Select * from orders where Total_Amount > 20;

-- Question.9 List all genres available in the Books table --
Select Genre from books;

-- Question.10 Find the book with the lowest stock --
Select * from books order by Stock limit 1;

-- Question.11 Calculate the total revenue generated from all orders --
Select sum(Total_Amount) as Total_Revenue from orders;

-- Advance Queries --

-- Question.1 Retrieve the total number of books sold for each genre --
Select b.Genre,sum(o.Quantity) As Quantity_Sold 
from orders o 
join books b on b.book_ID = o.book_ID 
group by b.genre;

-- Question.2 Find the average price of books in the "Fantasy" genre --
Select avg(price) as Average_price from books where genre = 'Fantasy';

-- Question.3 List customers who have placed at least 2 orders --
SELECT c.customer_ID,c.name,COUNT(o.order_ID) AS total_orders
FROM customers c
join orders o on c.customer_ID = o.customer_ID
GROUP BY o.customer_ID
HAVING total_orders > 1;

-- Question.4 Find the most frequently ordered book --
Select b.book_id,b.title,count(order_id) as total_order from books b
join orders o on b.book_ID = o.book_ID 
group by o.book_ID
order by total_order Desc limit 1;

-- Question.5 Show the top 3 most expensive books of 'Fantasy' Genre --
Select * from books where genre = 'Fantasy' order by price desc limit 3;

-- Question.6 Retrieve the total quantity of books sold by each author --
Select b.book_id,b.author,sum(o.quantity) as Total_quantity from books b
join orders o on b.book_ID = o.book_ID
group by o.book_ID;

-- Question.7 List the cities where customers who spent over $30 are located --
Select c.customer_ID,c.city,o.total_amount from customers c 
join orders o on c.customer_ID = o.customer_ID 
where Total_amount > 30;

--  Question.8 Find the customer who spent the most on orders --
Select c.customer_ID,C.name,sum(o.total_amount) as Total_Spent from customers c
join orders o on c.customer_id = o.customer_id
group by o.customer_ID
order by Total_Spent desc limit 1;

-- Question.9 Calculate the stock remaining after fulfilling all orders --
SELECT 
    b.Book_ID,
    b.Title,
    b.Stock - IFNULL(SUM(o.Quantity), 0) AS Stock_Remaining
FROM books b
LEFT JOIN orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock;