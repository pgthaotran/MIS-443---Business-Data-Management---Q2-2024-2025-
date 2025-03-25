/*
Question 1 (10 marks):
Task: Create a database named BankingDB and the four tables Customers, Accounts, Transactions, and Branches using SQL statements. 
Ensure each table includes appropriate primary and foreign keys, and data types. Submit the SQL script as part of your answer.
Output: Provide the SQL statements used to create the database and tables.
*/

-- Check tables and attributes
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

/*
Question 2 (10 marks):
Task: List all transactions that occurred in the year 2024 displaying the TransactionID, CustomerID, AccountID, and TransactionDate. 
Arrange the results by TransactionDate in ascending order.
*/

select TransactionID, CustomerID, AccountID, TransactionDate from transactions 
where extract(year from transactiondate) = '2024'
order by transactiondate asc; 

/*
Question 3 (20 marks):
Task: Calculate the total number of transactions made by each customer. Show the customer's ID, name, and their total number of transactions. 
Display the top 5 customers with the highest number of transactions. 
Order the results by the total number of transactions in descending order.
*/

select c.customerid, firstname, lastname, count(t.customerid) as number_of_transactions
from customers c
join transactions t on c.customerid = t.customerid 
group by c.customerid, firstname, lastname
ORDER BY number_of_transactions DESC
LIMIT 5;

/*
Question 4 (20 marks):
Taks: Display the top 5 customers who made the most recent transactions. 
Include the customer's ID, name, and the date of their most recent transaction. 
For customers who haven't made any transactions, their last transaction date should be shown as NULL. 
Order the list by the date of the last transaction in descending order. 
Notes: Using a Common Table Expression (CTE)
*/

with cte as
(
select customerid, max(transactiondate) recent_transaction
from transactions
group by customerid
)
select c.customerid, c.firstname, c.lastname, cte.recent_transaction
from customers c
left join cte 
on c.customerid = cte.customerid
order by cte.recent_transaction desc
limit 5;

/*
Question 5 (20 marks):
Task: List each transaction, including the customer's ID, name, account type, amount, and the transaction date. 
Order the results by transaction date in descending order.
*/

select c.customerid, c.firstname, c.lastname, ac.accounttype, t.amount, t.transactiondate
from customers c
join transactions t
on c.customerid = t.customerid
join accounts ac
on t.accountid = ac.accountid
order by transactiondate desc;

/*
Question 6 (20 marks):
Task: Rank the branches based on the total amount of transactions handled. Display the branch name, total transaction amount, and its rank. 
Branches with the same transaction amount should share the same rank.
*/