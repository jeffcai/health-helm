DB_URI="postgresql+psycopg2://$DB_USERNAME:$DB_PASSWORD@$DB_HOST/$DB_NAME"

subunit2sql-db-manage --database-connection $DB_URI upgrade head
