-- VACUUM
-- Creating a table to test vacuuming
CREATE TABLE vacuum_test (
    integer_column integer
);

-- Determining the size of vacuum_test
SELECT pg_size_pretty(
           pg_total_relation_size('vacuum_test')
       );

-- optional: Determine database size   
SELECT pg_size_pretty(
           pg_database_size('analysis')
       );

-- Inserting 500,000 rows into vacuum_test
INSERT INTO vacuum_test
SELECT * FROM generate_series(1,500000);

-- Test its size again
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );

-- Updating all rows in vacuum_test
UPDATE vacuum_test
SET integer_column = integer_column + 1;

-- Test its size again (35 MB)
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );

-- Viewing autovacuum statistics for vacuum_test
SELECT relname,
       last_vacuum,
       last_autovacuum,
       vacuum_count,
       autovacuum_count
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';

-- To see all columns available
SELECT *
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';

-- Running VACUUM manually
VACUUM vacuum_test;

VACUUM; -- vacuums the whole database

VACUUM VERBOSE; -- provides messages

-- Using VACUUM FULL to reclaim disk space
VACUUM FULL vacuum_test;

-- Test its size again
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );
       
-- SETTINGS
-- Showing the location of postgresql.conf
SHOW config_file;

-- Show the location of the data directory
SHOW data_directory;

-- reload settings
-- Mac and Linux: pg_ctl reload -D '/path/to/data/directory/'
-- Windows: pg_ctl reload -D "C:\path\to\data\directory\"

-- pg_dump: error: connection to server at "localhost" (::1), port 5432 failed: FATAL:  password authentication failed for user "thami82d"
-- BACKUP AND RESTORE

-- Backing up the analysis database with pg_dump
pg_dump -d analysis -U thami82d -Fc > analysis_backup.sql

-- Back up just a table
pg_dump -t 'train_rides' -d analysis -U [user_name] -Fc > train_backup.sql 

-- Restoring the analysis database with pg_restore

pg_restore -C -d postgres -U postgres analysis_backup_custom.sql
