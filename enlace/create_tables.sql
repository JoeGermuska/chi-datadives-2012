-- created using csvkit's csvsql, with minor modifications to column names
drop table crimes;
CREATE TABLE crimes (
	Case_Number VARCHAR(9), 
	crime_Date timestamp, 
	Block VARCHAR(35) NOT NULL, 
	IUCR VARCHAR(4) NOT NULL, 
	Primary_Type VARCHAR(32) NOT NULL, 
	Description VARCHAR(59) NOT NULL, 
	Location_Description VARCHAR(47), 
	Arrest BOOLEAN NOT NULL, 
	Domestic BOOLEAN NOT NULL, 
	Beat VARCHAR(4) NOT NULL, 
	Ward INTEGER, 
	FBI_Code VARCHAR(3) NOT NULL, 
	X_Coordinate INTEGER, 
	Y_Coordinate INTEGER, 
	Year INTEGER NOT NULL, 
	Latitude FLOAT, 
	Longitude FLOAT, 
	Location VARCHAR(40)
);
