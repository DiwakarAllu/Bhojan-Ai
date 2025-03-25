import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from dotenv import load_dotenv
from routes.auth_routes import auth_blueprint
from models.user_model import db, User
from flask_cors import CORS 
from routes.predict_routes import predict_blueprint
from routes.auth_routes import auth_blueprint


load_dotenv()  # Load environment variables from .env file

app = Flask(__name__)
CORS(app)


# Secret Key for JWT (store in .env file)
app.config["SECRET_KEY"] = os.getenv("SECRET_KEY")
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///users.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["JWT_SECRET_KEY"] = os.getenv("JWT_SECRET_KEY")  # JWT Secret Key

db = SQLAlchemy(app)
jwt = JWTManager(app)

app.register_blueprint(predict_blueprint, url_prefix="/")
app.register_blueprint(auth_blueprint, url_prefix="/auth")

if __name__ == "__main__":
    with app.app_context():
        db.create_all()  # Create database tables if they don't exist
    app.run(debug=True)
