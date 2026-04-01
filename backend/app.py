import os
import pyodbc

# Read database connection info from environment variables
DB_HOST = os.environ.get("DB_HOST", "localhost")
DB_USER = os.environ.get("DB_USER", "sa")
DB_PASSWORD = os.environ.get("DB_PASSWORD", "")
DB_NAME = "SampleDB"

# Build connection string
conn_str = f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={DB_HOST};UID={DB_USER};PWD={DB_PASSWORD};DATABASE={DB_NAME}"

try:
    # Connect to the database
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()
    print(f"Connected to database {DB_NAME} at {DB_HOST}")

    # Insert some sample data
    cursor.execute("INSERT INTO Users (Id, Name, Email) VALUES (?, ?, ?)", (1, "Alice", "alice@example.com"))
    cursor.execute("INSERT INTO Users (Id, Name, Email) VALUES (?, ?, ?)", (2, "Bob", "bob@example.com"))
    conn.commit()
    print("Sample data inserted successfully!")

    # Read back the data
    cursor.execute("SELECT * FROM Users")
    rows = cursor.fetchall()
    print("Users in DB:")
    for row in rows:
        print(row)

except Exception as e:
    print(f"Error connecting to database: {e}")

finally:
    if 'conn' in locals():
        conn.close()
        print("Connection closed")