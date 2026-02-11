from flask import Flask, request, jsonify
from datetime import datetime

app = Flask(__name__)

@app.route('/', methods=['GET'])
def hello():
    dt=datetime.now()
    dt_str = dt.strftime("%Y-%m-%d %H:%M:%S")
    return f"<h1>Hello, World! The current time is {dt_str} </h1>", 200
    #return jsonify({"message": "Hello, World!"}), 200

@app.route('/api/data', methods=['POST'])
def process_data():
    data = request.json
    # Process the data as needed
    return jsonify({"message": "Data processed successfully", "data": data}), 200

#if __name__ == '__main__':
#    app.run(debug=True)
