from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/api/hello', methods=['GET'])
def hello():
    return "<h1>Hello, World!</h1>", 200
    #return jsonify({"message": "Hello, World!"}), 200

@app.route('/api/data', methods=['POST'])
def process_data():
    data = request.json
    # Process the data as needed
    return jsonify({"message": "Data processed successfully", "data": data}), 200

if __name__ == '__main__':
    app.run(debug=True)
