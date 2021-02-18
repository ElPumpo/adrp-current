USE `essentialmode`;

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('pickaxe', 'Pickaxe', 1, 0, 1),
	('fishingnet', 'Fishing Net', 1, 0, 1),

	('iron', 'Iron Bar', 100, 0, 1),
	('iron_ore', 'Iron Ore', 135, 0, 1),

	('gold', 'Gold Bar', 100, 0, 1),
	('gold_ore', 'Gold Ore', 135, 0, 1),

	('diamond', 'Diamond', 100, 0, 1),
	('diamond_uncut', 'Uncut Diamond', 150, 0, 1),

	('salema', 'Cooked Salema', 100, 0, 1),
	('salema_raw', 'Raw Salema', 150, 0, 1),

	('ornate', 'Cooked Ornate', 100, 0, 1),
	('ornate_raw', 'Raw Ornate', 150, 0, 1),

	('mackerel', 'Cooked Mackerel', 100, 0, 1),
	('mackerel_raw', 'Raw Mackerel', 150, 0, 1),

	('tuna', 'Cooked Tuna', 100, 0, 1),
	('tuna_raw', 'Raw Tuna', 150, 0, 1),

	('mullet', 'Cooked Mullet', 100, 0, 1),
	('mullet_raw', 'Raw Mullet', 150, 0, 1),

	('catshark', 'Cooked Catshark', 100, 0, 1),
	('catshark_raw', 'Raw Catshark', 150, 0, 1),

	('trash', 'Trash', 100, 0, 1)
;

INSERT INTO `licenses` (`type`, `label`) VALUES
	('iron_processing', 'Iron Processing License'),
	('gold_processing', 'Gold Processing License'),
	('diamond_processing', 'Diamond Processing License')
;