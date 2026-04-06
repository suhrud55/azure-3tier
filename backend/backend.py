from flask import Flask
import sqlite3

app = Flask(__name__)

@app.route('/')
def home():
    conn = sqlite3.connect('test.db')
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = cursor.fetchall()
    conn.close()

    return f"Backend connected! Tables: {tables}"

app.run(host='0.0.0.0', port=5000)