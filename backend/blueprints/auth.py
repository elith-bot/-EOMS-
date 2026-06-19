from flask import Blueprint, request, jsonify, current_app
from backend.app import db
from backend.models import User, Institution
from werkzeug.security import generate_password_hash, check_password_hash
import jwt
import datetime

auth_bp = Blueprint("auth", __name__)


@auth_bp.route("/login", methods=["POST"])
def login():
    data = request.json or {}
    email = data.get("email")
    password = data.get("password")
    user_type = data.get("user_type")

    if not email or not password or not user_type:
        return jsonify({"error": "Email, password, and user_type are required."}), 400

    user = User.query.filter_by(email=email, role=user_type).first()
    if not user or not check_password_hash(user.password_hash, password):
        return jsonify({"error": "Invalid credentials."}), 401

    token = jwt.encode(
        {
            "user_id": user.id,
            "institution_id": user.institution_id,
            "role": user.role,
            "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=8),
        },
        current_app.config["SECRET_KEY"],
        algorithm="HS256",
    )

    response = jsonify({
        "access_token": token,
        "user": {
            "id": user.id,
            "email": user.email,
            "full_name": user.full_name,
            "role": user.role,
            "institution_id": user.institution_id,
        },
    })
    response.set_cookie(
        "elm_session",
        token,
        httponly=True,
        secure=False,
        samesite="Lax",
    )
    return response


@auth_bp.route("/register", methods=["POST"])
def register():
    data = request.json or {}
    institution_name = data.get("institution_name")
    email = data.get("email")
    password = data.get("password")
    role = data.get("role", "student")
    full_name = data.get("full_name", "")

    if not institution_name or not email or not password:
        return jsonify({"error": "institution_name, email, and password are required."}), 400

    institution = Institution.query.filter_by(name=institution_name).first()
    if institution is None:
        institution = Institution(name=institution_name)
        db.session.add(institution)
        db.session.commit()

    if User.query.filter_by(email=email).first():
        return jsonify({"error": "Email already exists."}), 409

    user = User(
        institution_id=institution.id,
        email=email,
        full_name=full_name,
        role=role,
        password_hash=generate_password_hash(password),
    )
    db.session.add(user)
    db.session.commit()

    return jsonify({"message": "User registered successfully.", "user_id": user.id}), 201
