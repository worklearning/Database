/usr/local/mysql/5.7/bin/mysql -S /db/data-300/mysql.sock  -uroot -prootroot -vvv -n < sql/part/warehouse_part.sql &
/usr/local/mysql/5.7/bin/mysql -S /db/data-300/mysql.sock  -uroot -prootroot -vvv -n < sql/part/customer_part.sql &
/usr/local/mysql/5.7/bin/mysql -S /db/data-300/mysql.sock  -uroot -prootroot -vvv -n < sql/part/district_part.sql &
/usr/local/mysql/5.7/bin/mysql -S /db/data-300/mysql.sock  -uroot -prootroot -vvv -n < sql/part/history_part.sql & 
/usr/local/mysql/5.7/bin/mysql -S /db/data-300/mysql.sock  -uroot -prootroot -vvv -n < sql/part/item_part.sql &
/usr/local/mysql/5.7/bin/mysql -S /db/data-300/mysql.sock  -uroot -prootroot -vvv -n < sql/part/new_order_part.sql &
/usr/local/mysql/5.7/bin/mysql -S /db/data-300/mysql.sock  -uroot -prootroot -vvv -n < sql/part/oorder_part.sql &
/usr/local/mysql/5.7/bin/mysql -S /db/data-300/mysql.sock  -uroot -prootroot -vvv -n < sql/part/order_line_part.sql &
/usr/local/mysql/5.7/bin/mysql -S /db/data-300/mysql.sock  -uroot -prootroot -vvv -n < sql/part/stock_part.sql &

