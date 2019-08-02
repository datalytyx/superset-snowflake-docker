set -ex

echo "[WARNING] this entrypoint creates an admin/admin user"
echo "[WARNING] it should only be used for lightweight testing/validation"

# Create an admin user (you will be prompted to set username, first and last name before setting a password)
fabmanager create-admin \
    --app superset \
    --username admin \
    --firstname admin \
    --lastname admin \
    --email admin@admin.com \
    --password admin

# Initialize the database
superset db upgrade

# Loading examples
superset load_examples

# Create default roles and permissions
superset init

FLASK_ENV=development FLASK_APP=superset:app \
flask run -p 8088 --with-threads --reload --debugger --host=0.0.0.0
