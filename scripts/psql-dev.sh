#!/bin/bash
PGPASSWORD=$RAILS_DB_PASSWORD psql -h $RAILS_DB_HOST -U $RAILS_DB_USER railstest_development
