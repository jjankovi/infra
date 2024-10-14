import os
import json
import boto3
# import psycopg2
import logging

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    # Database connection parameters
    db_host = os.environ['DB_HOST']
    db_name = os.environ['DB_NAME']
    db_user = os.environ['DB_USER']
    db_password = os.environ['DB_PASSWORD']

    # New schema and user information
    new_schema = event.get('schema_name')
    new_user = event.get('user_name')
    new_user_password = event.get('user_password')

    try:
        # Get information about the RDS instance
        rds_client = boto3.client('rds')
        response = rds_client.describe_db_instances(DBInstanceIdentifier=db_host)

        # Extract the relevant information
        db_instances = response.get('DBInstances', [])

        if not db_instances:
            logger.error(f"No DB instance found with identifier: {db_instance_identifier}")
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'DB instance not found'})
            }

        db_instance_info = db_instances[0]
        logger.info(f"DB Instance Info: {json.dumps(db_instance_info, default=str)}")

        return {
            'statusCode': 200,
            'body': json.dumps(db_instance_info)
        }

    except Exception as e:
        logger.error(f"Error retrieving RDS instance information: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})

        #     try:
        #         # Connect to the PostgreSQL database
        #         connection = psycopg2.connect(
        #             host=db_host,
        #             database=db_name,
        #             user=db_user,
        #             password=db_password
        #         )
        #         cursor = connection.cursor()
        #
        #         # Create a new schema
        #         cursor.execute(f"CREATE SCHEMA IF NOT EXISTS {new_schema};")
        #         logger.info(f"Schema '{new_schema}' created or already exists.")
        #
        #         # Create a new user
        #         cursor.execute(f"CREATE USER {new_user} WITH PASSWORD '{new_user_password}';")
        #         logger.info(f"User '{new_user}' created.")
        #
        #         # Grant permissions to the new user on the new schema
        #         cursor.execute(f"GRANT ALL PRIVILEGES ON SCHEMA {new_schema} TO {new_user};")
        #         logger.info(f"Granted all privileges on schema '{new_schema}' to user '{new_user}'.")
        #
        #         # Commit changes
        #         connection.commit()
        #
        #     except Exception as e:
        #         logger.error(f"An error occurred: {str(e)}")
        #         if connection:
        #             connection.rollback()
        #     finally:
        #         # Close the cursor and connection
        #         if cursor:
        #             cursor.close()
        #         if connection:
        #             connection.close()

    return {
        'statusCode': 200,
        'body': f'Schema "{new_schema}" and user "{new_user}" created successfully.'
    }
