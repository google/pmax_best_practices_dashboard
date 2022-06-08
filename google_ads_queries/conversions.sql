SELECT
	conversion_action.name AS conversion_action,
	conversion_action.type AS conversion_type,
	customer.id AS account_id
FROM conversion_action