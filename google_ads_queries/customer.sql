SELECT
	customer.id as account_id,
	customer.descriptive_name as account_name,
	customer.currency_code as currency
FROM customer
