USE `essentialmode`;

CREATE TABLE jail (
	identifier VARCHAR(22) NOT NULL,
	time_jail int(10) NOT NULL,
	time_remaining int(10) NOT NULL,

	PRIMARY KEY (identifier)
);