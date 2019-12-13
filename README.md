# innodb_fix

## What it does
This .bat script will help you back up mysql database instance directory in your datadir and help you fix corrupted  
1. innodb_index_stats
2. innodb_table_stats
3. slave_master_info
4. slave_relay_log_info
5. slave_worker_info

The batch script make assumption of your file structure are store as below:  
- datadir: <drive letter>:/mysql/data/
- innodb_fix dir: <drive letter>:/innodb_fix/
- restore_innodb dir: <drive letter>:/innodb_fix/restore_innodb

## Pre-run setup
put your innodb "mysql" .frm .ibd files in innodb_fix/restore_innodb directory 

## How to use
Command: innodb.bat <drive letter> <mysql db username> <mysql db password>   

## Disclaimer
Use at your own risk
