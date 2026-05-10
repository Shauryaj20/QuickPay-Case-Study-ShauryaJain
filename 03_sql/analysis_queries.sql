-- Q1
SELECT clean_status, COUNT(*) as transaction_count 
FROM cleaned_transactions 
GROUP BY clean_status;

-- Q2
SELECT clean_merchant_name, SUM(amount_usd) as total_captured_gmv 
FROM cleaned_transactions 
WHERE clean_status IN ('captured', 'success') 
GROUP BY clean_merchant_name;

-- Q3
SELECT clean_merchant_name, SUM(amount_usd) as total_captured_gmv 
FROM cleaned_transactions 
WHERE clean_status IN ('captured', 'success') 
GROUP BY clean_merchant_name 
ORDER BY total_captured_gmv DESC 
LIMIT 10;

-- Q4
SELECT transaction_date, SUM(amount_usd) as daily_gmv, COUNT(*) as success_count 
FROM cleaned_transactions 
WHERE clean_status IN ('captured', 'success') 
GROUP BY transaction_date 
ORDER BY transaction_date;

-- Q5
SELECT clean_merchant_name, 
       (SUM(CASE WHEN clean_status = 'chargeback' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) as chargeback_ratio
FROM cleaned_transactions 
GROUP BY clean_merchant_name 
HAVING (SUM(CASE WHEN clean_status = 'chargeback' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) > 1.0;

-- Q6
SELECT clean_region, AVG(clean_risk_score) as avg_risk_score, COUNT(*) as total_transactions 
FROM cleaned_transactions 
GROUP BY clean_region 
HAVING AVG(clean_risk_score) > 50 AND COUNT(*) > 20;

-- Q7
SELECT user_id, transaction_date, COUNT(*) as failed_chargeback_count 
FROM cleaned_transactions 
WHERE clean_status IN ('failed', 'chargeback') 
GROUP BY user_id, transaction_date 
HAVING COUNT(*) >= 3;

-- Q8
SELECT clean_merchant_name, 
       COUNT(*) as chargeback_count, 
       COUNT(DISTINCT user_id) as unique_users, 
       SUM(amount_usd) as chargeback_amount 
FROM cleaned_transactions 
WHERE clean_status = 'chargeback' 
GROUP BY clean_merchant_name;