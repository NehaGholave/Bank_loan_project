create database bank_loan;
use bank_loan;
select*from financial_loan;
desc financial_loan;


UPDATE financial_loan
SET issue_date = STR_TO_DATE(next_payment_date, '%d-%m-%Y');

-- this query is use to change the datatype 
alter table financial_loan modify int_rate float; 

alter table financial_loan modify issue_date date; 


# this query use to add the primary key to the column 
alter table financial_loan add primary key(id);

-- first Dashboard sumary
-- To find out the total loan application 
select count(id) as Total_Loan_Application  from financial_loan;

-- To find the MTD loan_application
select count(id) as total_loan_application from financial_loan
where month(issue_date) = 12 ;

select count(id) as PMTD_Total_loan_Applications from financial_loan 
where month(issue_date) = 11 and year(issue_date) = 2021;

-- to find total funded amount
select sum(loan_amount) as Total_funded_amount from financial_loan 
where month(issue_date) = 12 and year(issue_date) = 2021;

-- To find the total amount is received 
select sum(total_payment) as Total_Amount_received from financial_loan
where  month(issue_date) = 11 and year(issue_date)=2021;

-- To find average interest rate 
select avg(int_rate)*100 as Avg_interest_rate from financial_loan;

-- or (same quetions)[use the round function to round of the value]

select round(avg(int_rate),4)*100 as Avg_interest_rate from financial_loan
where month(issue_date)=12 and year(issue_date)=2021;

-- To find the Average debt-to-income ratio(DTI)

select avg(dti)*100 as Avg_dti from financial_loan
where month(issue_date)=12 and year(issue_date)=2021;

-- calculate the previous month issue_date
select avg(dti)*100 as PMTD_avg_dti from financial_loan;

select round(avg(dti),4)*100 as PMTD_Avg_dti from financial_loan
where month(issue_date)=11 and year(issue_date)=2021;

-- To find out good loan v/s bad loan application
-- good means fully paid and current
-- bad loan means charged off 

-- Good loan application percentage
select(count(case when loan_status = 'Full_paid' OR loan_status = 'Current' then id end)*100)
/
count(id) as Good_loan_percentage
from financial_loan;

-- Good_loan_application
select count(id) as good_loan_applications from financial_loan
where loan_status = 'Fully Paid' OR loan_status ='Current';

-- Good loan funded Amount
select sum(loan_amount) as Good_loan_funded_amount from financial_loan
where loan_status ='Fully Paid' or loan_status ='Current';

-- Good loan recieved total amount
select sum(total_payment) as good_loan_recieved_amount from financial_loan
where loan_status ='Full Paid' OR loan_status ='Current';

-- Bad loan issued
-- to find the bad laon 
-- Total Bad loan application percentage
select (count(case when loan_status='Charged off' then id end)*100)/
count(id) as bad_loan_percentage from financial_loan;

-- count the total bad applications
select count(id) as Bad_loan_application from financial_loan
where loan_status ='Charged off';

-- Bad loan funded Amount
select sum(loan_amount) as Bad_loan_funded_amount from financial_loan
where loan_status ='charged off';

-- Bad loan recieved total amount
select sum(total_payment) as Bad_loan_amount_received from financial_loan
where loan_status='Charged off';

-- Loan Status
select
loan_status,
count(id) as Total_loan_application,
sum(loan_amount) as total_amount_received,
sum(total_payment) as total_funded_amount,
avg(int_rate*100) as Interest_rate,
avg(dti*100) as DTI
from financial_loan
group by loan_status;

-- 

SELECT 
  loan_status, 
  SUM(total_payment) AS MTD_Total_amount_Received, 
  SUM(loan_amount) AS MTD_Total_funded_Amount 
FROM financial_loan 
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status;

-- second dashboard overview
-- monthly Trends by issue date
select 
month(issue_date) as month_number,
monthname(issue_date) as month_name,
count(id) as total_loan_applications,
sum(loan_amount) as Total_amount_received,
sum(total_payment) as total_funded_amount
from financial_loan
group by month(issue_date),
monthname(issue_date)
order by month(issue_date);

-- 
select 
address_state,
count(id) as Total_loan_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_recevied_amount
from financial_loan 
group by address_state
order by count(id) desc;

-- loan Term Analysis 
select term,
count(id) as Total_loan_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as total_received_amount
from financial_loan
group by term 
order by term;

-- empolyee length analysis
select emp_length,
count(id) as Total_loan_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as total_received_amount
from financial_loan
group by emp_length 
order by emp_length;

-- loan Purpose breakdown 
select 
purpose,
count(id) as Total_Loan_applications,
sum(loan_amount) as total_Funded_amount,
sum(total_payment) as total_received_amount
from financial_loan
group by purpose
order by count(id) desc;

-- home ownership analysis 
select 
home_ownership,
count(id) as Total_Loan_applications,
sum(loan_amount) as total_Funded_amount,
sum(total_payment) as total_received_amount
from financial_loan
group by home_ownership
order by count(id) desc;


