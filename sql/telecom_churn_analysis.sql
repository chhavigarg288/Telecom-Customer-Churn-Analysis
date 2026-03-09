-- Create Database 'telecom_churn_analysis':
CREATE DATABASE telecom_churn_analysis;

-- USE Database telecom_churn_analysis:
USE telecom_churn_analysis;

-- Create a table into a database telecom_churn_analysis:
CREATE TABLE telecom_churn(
customer_id VARCHAR(30),
gender VARCHAR(20),
age INT,
married VARCHAR(20),
number_of_dependent INT,
city VARCHAR(50),
zipcode INT,
latitude DECIMAL(12,2),
longitude DECIMAL(12,2),
referrals INT,
tenure_in_months INT,
offer VARCHAR(20),
phone_service VARCHAR(20),
avg_monthly_long_distance_charges DECIMAL(12,2),
multiple_lines VARCHAR(20),
internet_services VARCHAR(20),
internet_type VARCHAR(30),
avg_monthly_gb_downloaded DECIMAL(12,2),
online_security VARCHAR(30),
online_backup VARCHAR(30),
device_protection VARCHAR(30),
premium_tech_support VARCHAR(30),
streaming_tv VARCHAR(30),
streaming_movies VARCHAR(30),
streaming_music VARCHAR(30),
unlimited_data VARCHAR(30),
contract VARCHAR(100),
paperless_billing VARCHAR(30),
payment_method VARCHAR(50),
monthly_charge DECIMAL(10,2),
total_charges DECIMAL (10,2),
total_refunds DECIMAL(10,2),
total_extra_data_charges DECIMAL(10,2),
total_long_distance_charges DECIMAL(10,2),
total_revenue DECIMAL(12,2),
Customer_status VARCHAR(50),
churn_category VARCHAR(50),
churn_reason VARCHAR(200)
);

SELECT * FROM telecom_churn;

-- 1. Total Customers
SELECT COUNT(*) AS total_customers
FROM telecom_churn;

-- 2. Total churned customers
SELECT COUNT(*) AS total_churned
FROM telecom_churn
WHERE customer_status = 'Churned';

-- 3. What is the churned Rate
SELECT
	COUNT(CASE WHEN customer_status = 'Churned' THEN 1 END)
    / COUNT(*) * 100 AS churn_rate_percentage
FROM telecom_churn;

-- 4. Churn by contract type
SELECT
		contract,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
        ROUND(
			SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END)
            /COUNT(*) * 100, 2
		) AS churn_rate_percentage
FROM telecom_churn
GROUP BY contract
ORDER BY churn_rate_percentage DESC;
    
-- 5. What is the Average Monthly Charge by Customer Status?
SELECT ROUND(AVG(monthly_charge), 2) AS avg_monthly_charge,
customer_status
FROM telecom_churn
GROUP BY customer_status;  

-- 6. What is the Revenue Lost due to Churn?
SELECT
	ROUND(SUM(monthly_charge), 2) AS revenue_lost
FROM telecom_churn
WHERE Customer_status = 'churned';

-- 7. Which Internet type has the highest churn?
SELECT
	internet_type,
    COUNT(*) AS total,
    SUM(CASE WHEN customer_status = 'churned' THEN 1 ELSE 0 END) AS churned
FROM telecom_churn
GROUP BY internet_type;

-- 8. Tenure Group Analysis
SELECT
	CASE
		WHEN tenure_in_months <= 12 THEN '0-12 Months'
        WHEN tenure_in_months <= 24 THEN '12-24 Months'
        WHEN tenure_in_months <= 48 THEN '24-48 Months'
        ELSE '48+ Months'
	END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN customer_status = 'churned' THEN 1 ELSE 0 END) AS churned
FROM telecom_churn
GROUP BY tenure_group
ORDER BY total_customers DESC;

-- 9. Which Payment method has highest churn rate?
SELECT 
	payment_method,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN customer_status = 'churned' THEN 1 ELSE 0 END) AS churned,
    ROUND(
		SUM(CASE WHEN customer_status = 'churned' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS churned_rate
FROM telecom_churn
GROUP BY payment_method
ORDER BY churned_rate DESC;

-- 10. Which churn category has the highest number of churned customers?
SELECT 
	churn_category,
    COUNT(*) AS total_churned
FROM telecom_churn
WHERE customer_status = 'churned'
GROUP BY churn_category
ORDER BY total_churned DESC;

-- 11. Which Churn Reason is the most common?
SELECT
	churn_reason,
    COUNT(*) AS churn_count
FROM telecom_churn
WHERE customer_status = 'churned'
GROUP BY churn_reason
ORDER BY churn_count DESC;

-- 12. Which City has the highest churned?
SELECT
	city,
    COUNT(*) AS churn_customers
FROM telecom_churn
WHERE customer_status = 'churned'
GROUP BY city
ORDER BY churn_customers DESC;

-- 13. Which Age Group Churn the most?
SELECT 
	CASE 
		WHEN age < 30 THEN 'young'
        WHEN age BETWEEN 30 AND 50 THEN 'middle age'
        ELSE 'senior'
	END AS age_group,
    COUNT(*) AS churn_count
FROM telecom_churn
WHERE customer_status = 'churned'
GROUP BY age_group
ORDER BY churn_count DESC;

-- 14. Do Customers with Dependents churn less?
SELECT
	number_of_dependent,
    COUNT(*) AS churn_count
FROM telecom_churn
WHERE customer_status = 'churned'
GROUP BY number_of_dependent
ORDER BY churn_count DESC;

-- 15. What are the top 5 Churn Reasons?
SELECT
	churn_reason,
    COUNT(*) AS churn_count
FROM telecom_churn
WHERE customer_status = 'churned'
GROUP BY churn_reason
ORDER BY churn_count DESC
LIMIT 5;