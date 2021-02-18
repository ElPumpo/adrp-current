USE `essentialmode`;

CREATE TABLE IF NOT EXISTS `vending_items` (
	`label` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_bin',
	`item` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_bin',
	`price` INT(11) NOT NULL,

	PRIMARY KEY (`item`)
)

COLLATE='utf8mb4_bin'