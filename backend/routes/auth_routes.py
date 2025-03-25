from flask import Blueprint, request, jsonify 
from flask_jwt_extended import create_access_token
from models.user_model import db, User

auth_blueprint = Blueprint("auth", __name__)

@auth_blueprint.route("/signup", methods=["POST"])
def signup():
    try:
        data = request.json
        if not data:
            return jsonify({"error": "Request body is missing"}), 400

        username = data.get("username")
        email = data.get("email")
        password = data.get("password")

        # Ensure all fields are provided
        if not username or not email or not password:
            return jsonify({"error": "All fields (username, email, password) are required"}), 400

        # Check if username or email already exists
        if User.query.filter_by(username=username).first():
            return jsonify({"error": "Username already exists"}), 400
        if User.query.filter_by(email=email).first():
            return jsonify({"error": "Email already registered"}), 400

        # Create and save new user
        new_user = User(username=username, email=email)
        new_user.set_password(password)

        db.session.add(new_user)
        db.session.commit()

        return jsonify({"message": "User registered successfully!"}), 201

    except Exception as e:
        print("Signup Error:", str(e))  # Debugging info
        return jsonify({"error": "Internal server error", "details": str(e)}), 500
