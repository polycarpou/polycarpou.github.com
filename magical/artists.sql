CREATE TABLE artists(
	name TEXT,
	age INTEGER,
	genre TEXT,
	sales, INTEGER,
	weight, REAL
);

ALTER TABLE artists ADD COLUMN language TEXT;
ALTER TABLE artists ADD COLUMN description TEXT;

DROP TABLE musicians;
CREATE TABLE artists(
	name TEXT,
	age INTEGER,
	genre TEXT,
	sales INTEGER,
	language TEXT,
	description TEXT
);


ALTER TABLE artists RENAME TO musicians;
DROP TABLE musicians;