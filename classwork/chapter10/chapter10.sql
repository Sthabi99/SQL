-- Create Census 2011-2015 ACS 5-Year stats table and import data
CREATE TABLE acs_2011_2015_stats (
    geoid varchar(14) CONSTRAINT geoid_key PRIMARY KEY, -- unique geoid as PRIMARY KEY
    county varchar(50) NOT NULL, -- unique important data
    st varchar(20) NOT NULL, -- same as above
    pct_travel_60_min numeric(5,3) NOT NULL, -- working class travel_time > 60min
    pct_bachelors_higher numeric(5,3) NOT NULL, -- age >= 25 w/ degree
    pct_masters_higher numeric(5,3) NOT NULL, --age >= 25 w/ master's
    median_hh_income integer, 
    CHECK (pct_masters_higher <= pct_bachelors_higher) -- there's always more degrees than master's
);

COPY acs_2011_2015_stats
FROM 'C:\Users\user1\Documents\CodeCollegeZA\BootCamp_2023\SQL\classwork\chapter10\acs_2011_2015_stats.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

SELECT * FROM acs_2011_2015_stats;

-- Using corr(Y, X) to measure the relationship between 
-- education and income
SELECT corr(median_hh_income, pct_bachelors_higher)
    AS bachelors_income_r
FROM acs_2011_2015_stats;

-- Using corr(Y, X) on additional variables
SELECT
    round(
      corr(median_hh_income, pct_bachelors_higher)::numeric, 2
      ) AS bachelors_income_r, -- rounded value to 2 decimal places
    round(
      corr(pct_travel_60_min, median_hh_income)::numeric, 2
      ) AS income_travel_r,
    round(
      corr(pct_travel_60_min, pct_bachelors_higher)::numeric, 2
      ) AS bachelors_travel_r
FROM acs_2011_2015_stats;

-- Regression slope and intercept functions
SELECT
    round(
        regr_slope(median_hh_income, pct_bachelors_higher)::numeric, 2
        ) AS slope,
    round(
        regr_intercept(median_hh_income, pct_bachelors_higher)::numeric, 2
        ) AS y_intercept
FROM acs_2011_2015_stats;

-- Calculating the coefficient of determination, or r-squared
-- Explains the extent to which a variation in the x_variable explains the variation of the y_variable
SELECT round(
        regr_r2(median_hh_income, pct_bachelors_higher)::numeric, 3
        ) AS r_squared
FROM acs_2011_2015_stats;

-- Bonus: Additional stats functions.
-- Variance
SELECT var_pop(median_hh_income)
FROM acs_2011_2015_stats;

-- Standard deviation of the entire population
SELECT stddev_pop(median_hh_income)
FROM acs_2011_2015_stats;

-- Covariance
SELECT covar_pop(median_hh_income, pct_bachelors_higher)
FROM acs_2011_2015_stats;

-- The rank() and dense_rank() window functions
CREATE TABLE widget_companies (
    id bigserial,
    company varchar(30) NOT NULL,
    widget_output integer NOT NULL
);

INSERT INTO widget_companies (company, widget_output)
VALUES
    ('Morse Widgets', 125000),
    ('Springfield Widget Masters', 143000),
    ('Best Widgets', 196000),
    ('Acme Inc.', 133000),
    ('District Widget Inc.', 201000),
    ('Clarke Amalgamated', 620000),
    ('Stavesacre Industries', 244000),
    ('Bowers Widget Emporium', 201000);

SELECT
    company,
    widget_output,
    rank() OVER (ORDER BY widget_output DESC),
    dense_rank() OVER (ORDER BY widget_output DESC)
FROM widget_companies;

-- Applying rank() within groups using PARTITION BY
CREATE TABLE store_sales (
    store varchar(30),
    category varchar(30) NOT NULL,
    unit_sales bigint NOT NULL,
    CONSTRAINT store_category_key PRIMARY KEY (store, category)
);

INSERT INTO store_sales (store, category, unit_sales)
VALUES
    ('Broders', 'Cereal', 1104),
    ('Wallace', 'Ice Cream', 1863),
    ('Broders', 'Ice Cream', 2517),
    ('Cramers', 'Ice Cream', 2112),
    ('Broders', 'Beer', 641),
    ('Cramers', 'Cereal', 1003),
    ('Cramers', 'Beer', 640),
    ('Wallace', 'Cereal', 980),
    ('Wallace', 'Beer', 988);

SELECT
    category,
    store,
    unit_sales,
    rank() OVER (PARTITION BY category ORDER BY unit_sales DESC)
	-- PARTITION BY allows to rank values by departments
FROM store_sales;

-- Create and fill a 2015 FBI crime data table
CREATE TABLE fbi_crime_data_2015 (
    st varchar(20),
    city varchar(50),
    population integer,
    violent_crime integer,
    property_crime integer,
    burglary integer,
    larceny_theft integer,
    motor_vehicle_theft integer,
    CONSTRAINT st_city_key PRIMARY KEY (st, city)
);

COPY fbi_crime_data_2015
FROM 'C:\Users\user1\Documents\CodeCollegeZA\BootCamp_2023\SQL\classwork\chapter10\fbi_crime_data_2015.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

SELECT * FROM fbi_crime_data_2015
ORDER BY population DESC;

-- Find property crime rates per thousand in cities with 500,000
-- or more people
SELECT
    city,
    st,
    population,
    property_crime,
    round(
		-- finding the even distribution of data comparison
        (property_crime::numeric / population) * 1000, 1
        ) AS pc_per_1000
FROM fbi_crime_data_2015
WHERE population >= 500000
ORDER BY (property_crime::numeric / population) DESC;

--------------------------------------------------------------
-- Try it yourself
--------------------------------------------------------------

-- QUESTION 1.
-- The `r` for bachelors is higher than that of master's or higher
-- as obtaining a master's or higher comes with a higher increment in income
-- than obtaining a bachelor's
SELECT
    round(
      corr(median_hh_income, pct_bachelors_higher)::numeric, 2
      ) AS bachelors_income_r,
    round(
      corr(median_hh_income, pct_masters_higher)::numeric, 2
      ) AS masters_income_r
FROM acs_2011_2015_stats;


-- QUESTION 2. 
-- a) Milwaukee and Albuquerque had the two highest rates of motor
-- vehicle theft:
SELECT
    city,
    st,
    population,
    motor_vehicle_theft,
    round(
        (motor_vehicle_theft::numeric / population) * 100000, 1
        ) AS vehicle_theft_per_100000
FROM fbi_crime_data_2015
WHERE population >= 500000
ORDER BY vehicle_theft_per_100000 DESC;

-- b) Detroit and Memphis had the two highest rates of violent crime.
SELECT
    city,
    st,
    population,
    violent_crime,
    round(
        (violent_crime::numeric / population) * 100000, 1
        ) AS violent_crime_per_100000
FROM fbi_crime_data_2015
WHERE population >= 500000
ORDER BY violent_crime_per_100000 DESC;

-- QUESTION 3.
-- Cuyahoga County Public Library tops the rankings
SELECT
    libname,
    stabr,
    visits,
    popu_lsa,
    round(
        (visits::numeric / popu_lsa) * 1000, 0
        ) AS visits_per_1000,
    rank() OVER (ORDER BY (visits::numeric / popu_lsa) * 1000 DESC)
FROM pls_fy2014_pupld14a
WHERE popu_lsa >= 250000;



