:: innodb.bat <drive letter> <db_user> <db_password>
:: assume that datadir will be <drive letter>:\mysql\data\
:: assume that fixes script will be in <drive letter>:\innodb_fix\
:: assume that the .ibd to restore is inside <drive letter>:\innodb_fix\restore_innodb

:: backup mysql folder .frm and .ibd files into <drive letter>:\innodb_fix\bakup
XCOPY %1:\mysql\data\mysql %1:\innodb_fix\bakup\mysql\data\mysql /s /i

:: del the mysql folder
:: RMDIR /Q/S %1:\mysql\data\mysql
DEL %1:\mysql\data\mysql\innodb_index_stats.frm
DEL %1:\mysql\data\mysql\innodb_index_stats.ibd
DEL %1:\mysql\data\mysql\innodb_table_stats.frm
DEL %1:\mysql\data\mysql\innodb_table_stats.ibd
DEL %1:\mysql\data\mysql\slave_master_info.frm
DEL %1:\mysql\data\mysql\slave_master_info.ibd
DEL %1:\mysql\data\mysql\slave_relay_log_info.frm
DEL %1:\mysql\data\mysql\slave_relay_log_info.ibd
DEL %1:\mysql\data\mysql\slave_worker_info.frm
DEL %1:\mysql\data\mysql\slave_worker_info.ibd

:: run drop innodb table in mysql database to clear ghost table
::mysql -u %2 -p%3 mysql < %1:\innodb_fix\innodb_drop_table.sql
mysql -u %2 -p%3 mysql -e "DROP TABLE `mysql`.`innodb_index_stats`;"
mysql -u %2 -p%3 mysql -e "DROP TABLE `mysql`.`innodb_table_stats`;"
mysql -u %2 -p%3 mysql -e "DROP TABLE `mysql`.`slave_master_info`;"
mysql -u %2 -p%3 mysql -e "DROP TABLE `mysql`.`slave_relay_log_info`;"
mysql -u %2 -p%3 mysql -e "DROP TABLE `mysql`.`slave_worker_info`;"

:: create new innodb table in mysql database
mysql -u %2 -p%3 mysql < %1:\innodb_fix\innodb_create_table.sql

:: discard table space
mysql -u %2 -p%3 mysql < %1:\innodb_fix\innodb_discard_tablespace.sql

:: copy .ibd file from the restore folder
::XCOPY %1:\innodb_fix\restore_innodb\*.ibd %1:\mysql\data\mysql\
XCOPY %1:\innodb_fix\restore_innodb\innodb_index_stats.ibd %1:\mysql\data\mysql\
XCOPY %1:\innodb_fix\restore_innodb\innodb_table_stats.ibd %1:\mysql\data\mysql\
XCOPY %1:\innodb_fix\restore_innodb\slave_master_info.ibd %1:\mysql\data\mysql\
XCOPY %1:\innodb_fix\restore_innodb\slave_relay_log_info.ibd %1:\mysql\data\mysql\
XCOPY %1:\innodb_fix\restore_innodb\slave_worker_info.ibd %1:\mysql\data\mysql\

:: import table space
mysql -u %2 -p%3 mysql < %1:\innodb_fix\innodb_import_tablespace.sql
