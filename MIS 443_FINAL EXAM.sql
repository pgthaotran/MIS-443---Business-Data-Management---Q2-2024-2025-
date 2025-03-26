/*
Question 1 (10 marks): Create a database named “yourfullname” (e.g: nguyenvana”) use PGAdmin, then create a schema name “cd” that has three tables: members, bookings and facilities 
using SQL statements. Ensure each table includes appropriate primary and foreign keys, and data types. 
Submit the SQL script as part of your answer.

*/
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'cd' 
ORDER BY table_name, ordinal_position;

/*
Question 2 (10 marks): Write an SQL query to count the total number of bookings for each facility, ordered by the highest number of bookings first.
Expected Output Columns:
	facid (Facility ID)
	total_bookings (Total number of times the facility has been booked)
*/
select cf.facid, count(cf.facid) as total_bookings 
from cd.bookings cb
join cd.facilities cf
on cb.facid = cf.facid 
group by cf.facid 
order by total_bookings desc;

/*
Question 3 (20 marks): Write an SQL query to display all bookings with the member ID and facility name, ordered by the booking start time.

Expected Output Columns:

	bookid (Booking ID)
	memid (Member ID)
	facility_name (Facility Name)
	starttime (Booking Start Time)
	slots (Number of Slots)

*/

select bookid, memid, name, starttime, slots
from cd.bookings cb
join cd.facilities cf
on cb.facid = cf.facid
order by starttime; 

/*
Question 4 (20 marks):  Write an SQL query to display each member and their total number of bookings, ensuring that members who have never made a booking are also included.

Expected Output Columns:
	memid (Member ID)
	member_name (Member Name)
	total_bookings (Total number of bookings)

Notes: Using a Common Table Expression (CTE) will get 100% (normal 90%)
*/

with memberbooking as (
select cm.memid, concat(cm.firstname, ' ', cm.surname) member_name, count(distinct cb.bookid) total_bookings
from cd.members cm
left join cd.bookings cb on cm.memid = cb.memid  
group by cm.memid, concat(cm.firstname, ' ', cm.surname) 
)
select memid, member_name, total_bookings
from memberbooking
order by total_bookings desc; 

/*
Question 5 (20 marks):   Write an SQL query to display all bookings made by guests (non-members), along with the facility name, ordered by the number of slots used in descending order.

Expected Output Columns:

	bookid (Booking ID)
	facility_name (Facility Name)
	starttime (Booking Start Time)
	slots (Number of Slots)
*/
select bookid, name facility_name, starttime, slots
from cd.bookings cb
join cd.facilities cf
on cb.facid = cf.facid 
where cb.memid = 0
order by slots desc;

/*
Question 6 (20 marks): Write an SQL query to rank members based on their largest single booking (most slots in one booking), displaying their rank alongside their largest booking. If multiple members have the same largest booking, they should have the same rank (use Window fuction)

Expected Output Columns:

	memid (Member ID)
	member_name (Member Name)
	max_slots (Largest Single Booking by Slots)
	rank (Rank Based on Max Slots)
*/
select cm.memid, concat (cm.firstname, ' ', cm.surname) member_name, max(cb.slots) max_slots,
dense_rank() over (order by max(cb.slots) desc) rank
from cd.members cm
join cd.bookings cb on cm.memid = cb.memid
group by cm.memid, member_name
order by rank;











