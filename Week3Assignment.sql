--BASIC QUERIES

--1. List all customers with their full name and city.

select concat(first_name, ' ', last_name) as full_name, city
from luxclass.customers;

--2. Show all books priced above 2000.

select title, price
from luxclass.books
where price > 2000;

--3. List customers who live in 'Nairobi'.

select first_name, city
from luxclass.customers
where city = 'Nairobi';

--4. Retrieve all book titles that were published in 2023

select title, published_date
from luxclass.books
where published_date > '2023-01-01';

--FILTERING AND SORTING

--5. Show all orders placed after March 1st, 2025.

select order_id, order_date
from luxclass.orders
where order_date > '2025-01-03';

--6. List all books ordered, sorted by price (descending).

select title, price
from luxclass.books
order by price desc;

--7. Show all customers whose names start with 'J'.

select first_name
from luxclass.customers
where first_name like 'J%';

--8. List books with prices between 1500 and 3000.

select title, price
from luxclass.books
where price between 1500 and 3000;

--AGGREGATE FUNCTIONS AND GROUPING

--9. Count the number of customers in each city.

select city, count(*)
from luxclass.customers
group by city;

--10. Show the total number of orders per customer.

select customer_id, count(order_id)
from luxclass.orders
group  by customer_id ;

--11. Find the average price of books in the store.

select avg(price) as avg_price
from luxclass.books;

--12. List the book title and total quantity ordered for each book.

select book_id ,quantity
from luxclass.orders 
group by book_id ,quantity ;

--SUBQUERIES

--13. Show customers who have placed more orders than customer with ID = 1.

select first_name,customer_id  
from luxclass.customers
where customer_id in (
select order_id 
from luxclass.orders
where order_id > 1);

--14. List books that are more expensive than the average book price.

select title, 
       price,
       (select AVG(price) from luxclass.books) as average_price
from luxclass.books
where price > (select AVG(price) from luxclass.books);

--15. Show each customer and the number of orders they placed using a subquery in SELECT.

select first_name, 
       last_name,
       (select count(order_id) from luxclass.orders) as num_orders
from luxclass.customers;

--JOINS

--16. Show full name of each customer and the titles of books they ordered.

select concat(first_name, ' ', last_name) as full_name, title 
from luxclass.customers
inner join luxclass.orders
	on customers.customer_id = orders.customer_id
inner join luxclass.books
	on orders.book_id = books.book_id;

--17. List all orders including book title, quantity, and total cost (price × quantity).

select title, price, quantity, (price * quantity ) as total_cost 
from luxclass.customers
inner join luxclass.orders
	on customers.customer_id = orders.customer_id
inner join luxclass.books
	on orders.book_id = books.book_id;

--18. Show customers who haven't placed any orders (LEFT JOIN).

select first_name, last_name, orders.book_id
from luxclass.customers
inner join luxclass.orders
	on customers.customer_id = orders.customer_id
inner join luxclass.books
	on orders.book_id = books.book_id
where books.book_id is null;

--19. List all books and the names of customers who ordered them, if any (LEFT JOIN).

select first_name, last_name, title
from luxclass.customers
inner join luxclass.orders
	on customers.customer_id = orders.customer_id
inner join luxclass.books
	on orders.book_id = books.book_id;

--20. Show customers who live in the same city (SELF JOIN).

select A.first_name as customer, B.city as city
from luxclass.customers A
join luxclass.customers B
	on B.customer_id = A.customer_id;

--COMBINED LOGIC

--21. Show all customers who placed more than 2 orders for books priced over 2000.

select first_name, last_name, order_id
from luxclass.customers
inner join luxclass.orders
	on customers.customer_id = orders.customer_id
inner join luxclass.books
	on orders.book_id = books.book_id
where price > 2000 and order_id > 2;

--22. List customers who ordered the same book more than once.

select distinct order_id, first_name
from luxclass.customers
inner join luxclass.orders
	on customers.customer_id = orders.customer_id;

--23. Show each customer's full name, total quantity of books ordered, and total amount spent.

select concat(first_name, ' ' ,last_name) as full_name, quantity ,price , (quantity*price) as total_expenditure
from luxclass.customers
inner join luxclass.orders
	on customers.customer_id = orders.customer_id
inner join luxclass.books
	on orders.book_id = books.book_id
group by full_name, quantity,price  ;

--24. List books that have never been ordered.

select distinct book_id 
from luxclass.orders;

--25. Find the customer who has spent the most in total (JOIN + GROUP BY + ORDER BY + LIMIT).

select concat(first_name, ' ' ,last_name) as full_name, quantity ,price , (quantity*price) as total_expenditure
from luxclass.customers
inner join luxclass.orders
	on customers.customer_id = orders.customer_id
inner join luxclass.books
	on orders.book_id = books.book_id
group by full_name, quantity,price 
order by total_expenditure  desc;  --Paul Otieno

--26. Write a query that shows, for each book, the number of different customers who have ordered it.

select title, orders.customer_id, count(*)
from luxclass.customers
inner join luxclass.orders
	on customers.customer_id = orders.customer_id
inner join luxclass.books
	on orders.book_id = books.book_id
group by title, orders.customer_id ;

--27. Using a subquery, list books whose total order quantity is above the average order quantity.

select title, 
       price,
       (select sum(quantity) from luxclass.orders) as total_order,
       (select avg(quantity) from luxclass.orders) as average_order
from luxclass.books
where (select sum(quantity) from luxclass.orders) > (select avg(quantity) from luxclass.orders);

--28. Show the top 3 customers with the highest number of orders and the total amount they spent.

select concat(first_name, ' ' ,last_name) as full_name, quantity ,price , (quantity*price) as total_expenditure
from luxclass.customers
inner join luxclass.orders
	on customers.customer_id = orders.customer_id
inner join luxclass.books
	on orders.book_id = books.book_id
group by full_name, quantity,price 
order by total_expenditure  desc;  --Paul Otieno(3, 7500) ,John Doe(2, 6000), Mary Okello(2, 4400) 




