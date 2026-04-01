from flask import Flask, request, jsonify
app = Flask(__name__)

@app.route("/users", methods=["POST"])
def add_user():
    data = request.json
    # Here you would insert data into DB
    print(f"User added: {data}")
    return jsonify({"status": "success"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)