import os
from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from dotenv import load_dotenv
from config import Config
from routes.auth_routes import auth_blueprint
from models.user_model import db, User
from flask_cors import CORS 
from routes.predict_routes import predict_blueprint
from routes.auth_routes import auth_blueprint


load_dotenv()  

app = Flask(__name__)
CORS(app)


app.config.from_object(Config)
#db = SQLAlchemy(app)
db.init_app(app)
jwt = JWTManager(app)

app.register_blueprint(predict_blueprint, url_prefix="/")
app.register_blueprint(auth_blueprint, url_prefix="/auth")

@app.route('/', methods=['GET'])
def hi():
    return jsonify("hi,Allu"), 200




if __name__ == "__main__":
    with app.app_context():
        db.create_all() 
    app.run(debug=True)
