CREATE TABLE animal_type ( 
	id bigserial, 
	species VARCHAR(50), 
	nick_name VARCHAR(50)
	);
CREATE TABLE animal_details (
	id bigserial,
	habitat VARCHAR(50),
	gender VARCHAR(10), 
	age INT, 
	weight FLOAT
);
	
INSERT INTO animal_type (species, nick_name) 
VALUES ('Lion', 'African Lion'), 
	   ('Hippo', 'seekoei a.k.a (sea cow)'), 
	   ('Elephant', 'African Elephant');
	   
INSERT INTO animal_details (habitat, gender, age, weight)
VALUES ('Grasslands', 'Male', 7, 300),
	   ('Mangrove Swamps', 'Female', 5, 2500),
	   ('Savannas', 'Male', 10, 6000);
	   
SELECT * FROM animal_type, animal_details;

	
