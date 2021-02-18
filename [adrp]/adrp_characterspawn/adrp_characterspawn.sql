USE `essentialmode`;

CREATE TABLE `characters` (
	`networkID` INT(11) NOT NULL AUTO_INCREMENT,
	`characterID` INT(11) NULL DEFAULT NULL,
	`identifier` VARCHAR(22) NOT NULL COLLATE 'utf8mb4_bin',
	`license` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`bank` INT(11) NULL DEFAULT NULL,
	`money` INT(11) NULL DEFAULT NULL,
	`skin` LONGTEXT NULL COLLATE 'utf8mb4_bin',
	`job` VARCHAR(30) NULL DEFAULT 'unemployed' COLLATE 'utf8mb4_bin',
	`job_grade` INT(11) NULL DEFAULT '0',
	`gang` VARCHAR(30) NULL DEFAULT 'nogang' COLLATE 'utf8mb4_bin',
	`gang_grade` INT(11) NULL DEFAULT '0',
	`inventory` LONGTEXT NULL COLLATE 'utf8mb4_bin',
	`loadout` LONGTEXT NULL COLLATE 'utf8mb4_bin',
	`position` VARCHAR(255) NULL DEFAULT '{"x": -1038.7, "y": -2738.7, "z": 14.8}' COLLATE 'utf8mb4_bin',
	`firstname` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`lastname` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`fullname` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_bin',
	`dateofbirth` VARCHAR(25) NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`sex` VARCHAR(10) NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`height` VARCHAR(5) NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`last_property` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`phone_number` VARCHAR(8) NULL DEFAULT NULL,
	`status` LONGTEXT NULL COLLATE 'utf8mb4_bin',
	`jailtime` INT(11) NOT NULL DEFAULT '0',
	`items` TEXT NULL COLLATE 'utf8mb4_bin',
	`vehicles` TEXT NULL COLLATE 'utf8mb4_bin',
	`dirtymoney` INT(11) NULL DEFAULT '0',
	`tattoos` LONGTEXT NULL COLLATE 'utf8mb4_bin',
	`properties` TEXT NULL COLLATE 'utf8mb4_bin',
	`licenses` TEXT NULL COLLATE 'utf8mb4_bin',
	`animal` VARCHAR(15) NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`is_dead` TINYINT(1) NULL DEFAULT '0',
	`last_connected` VARCHAR(70) NULL DEFAULT NULL COLLATE 'utf8mb4_bin',

	PRIMARY KEY (`networkID`, `identifier`),

	INDEX `index_characters_identifier` (`identifier`),
	INDEX `index_characters_fullname` (`fullname`)
)
COLLATE='utf8mb4_bin'
;

ALTER TABLE `users` ADD
	`current_character` INT(11) NULL DEFAULT NULL,
	`current_network` INT(11) NOT NULL DEFAULT '-1',
	`last_connected` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`fullname` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_bin',
	`firstname` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`lastname` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`dateofbirth` VARCHAR(25) NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`sex` VARCHAR(10) NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`height` VARCHAR(5) NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`startup_money` MEDIUMINT(9) NOT NULL DEFAULT '111'
;