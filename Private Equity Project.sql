-- =========================================
-- PRIVATE EQUITY FUND DATA ANALYSIS (FULL)
-- =========================================

-- 1. TOTAL CAPITAL INVESTMENT PER FUND
SELECT 
    Fund,
    SUM(Capital_Call) AS total_investment
FROM fund_data
GROUP BY Fund
ORDER BY total_investment DESC;

-- 2. TOTAL DISTRIBUTIONS PER FUND
SELECT 
    Fund,
    SUM(Distribution) AS total_returns
FROM fund_data
GROUP BY Fund;

-- 3. TOTAL NAV PER FUND
SELECT 
    Fund,
    SUM(NAV) AS total_nav
FROM fund_data
GROUP BY Fund;

-- 4. FUND PROFITABILITY (IMPORTANT)
SELECT 
    Fund,
    SUM(Distribution + NAV - Capital_Call) AS profit
FROM fund_data
GROUP BY Fund
ORDER BY profit DESC;

-- 5. INVESTOR-LEVEL ANALYSIS
SELECT 
    Investor,
    SUM(Capital_Call) AS total_invested,
    SUM(Distribution) AS total_received
FROM fund_data
GROUP BY Investor
ORDER BY total_invested DESC;

-- 6. MONTHLY CAPITAL CALL TREND
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS month,
    SUM(Capital_Call) AS monthly_capital
FROM fund_data
GROUP BY month
ORDER BY month;

-- 7. TOP PERFORMING FUND (RETURN RATIO)
SELECT 
    Fund,
    SUM(Distribution) / SUM(Capital_Call) AS return_ratio
FROM fund_data
GROUP BY Fund
ORDER BY return_ratio DESC
LIMIT 1;

-- =========================================
-- DATA VALIDATION CHECKS (VERY IMPORTANT)
-- =========================================

-- 8. CHECK FOR NEGATIVE VALUES
SELECT *
FROM fund_data
WHERE Capital_Call < 0 
   OR Distribution < 0 
   OR NAV < 0;

-- 9. CHECK FOR MISSING VALUES
SELECT *
FROM fund_data
WHERE Fund IS NULL 
   OR Investor IS NULL 
   OR NAV IS NULL;

-- 10. CHECK FOR INCONSISTENT NAV
SELECT *
FROM fund_data
WHERE NAV < Capital_Call;

-- 11. DUPLICATE RECORD CHECK
SELECT 
    Fund, Investor, Date, COUNT(*) AS duplicate_count
FROM fund_data
GROUP BY Fund, Investor, Date
HAVING COUNT(*) > 1;

-- =========================================
-- ADVANCED ANALYSIS (BONUS)
-- =========================================

-- 12. RANK FUNDS BY PROFIT
SELECT 
    Fund,
    SUM(Distribution + NAV - Capital_Call) AS profit,
    RANK() OVER (ORDER BY SUM(Distribution + NAV - Capital_Call) DESC) AS rank_position
FROM fund_data
GROUP BY Fund;

-- 13. RUNNING TOTAL OF CAPITAL CALLS
SELECT 
    Fund,
    Date,
    SUM(Capital_Call) OVER (PARTITION BY Fund ORDER BY Date) AS running_capital
FROM fund_data;

-- 14. AVERAGE INVESTMENT PER INVESTOR
SELECT 
    Investor,
    AVG(Capital_Call) AS avg_investment
FROM fund_data
GROUP BY Investor;

-- =========================================
-- END OF PROJECT
-- =========================================