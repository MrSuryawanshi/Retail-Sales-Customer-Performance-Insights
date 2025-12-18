USE PROJECT2;

--Data imported directly using "import flat file" option.

--Fix Inconsistent 'gender' values

UPDATE customer_info
SET gender = CASE 
    WHEN LOWER(gender) LIKE 'fem%' THEN 'Female'
    WHEN LOWER(gender) LIKE 'mal%' THEN 'Male'
    ELSE 'Other'
END;

--Fix Inconsistent 'loyalty_tier' casing

UPDATE customer_info
SET loyalty_tier = UPPER(TRIM(loyalty_tier));

--Set NULL regions to 'Unknown'

UPDATE customer_info
SET region = 'Unknown'
WHERE region IS NULL;

--Handle Missing Financial Data

UPDATE sales_data
SET unit_price = 0.00
WHERE unit_price IS NULL;

UPDATE sales_data
SET quantity = 1
WHERE quantity IS NULL;


--VERIFICATION

SELECT DISTINCT gender FROM customer_info;

SELECT DISTINCT loyalty_tier FROM customer_info;

