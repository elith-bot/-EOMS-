from flask import Blueprint, request, jsonify, current_app
from backend.app import db
from backend.models import User, Institution
from werkzeug.security import generate_password_hash, check_password_hash
import jwt
import datetime

auth_bp = Blueprint("auth", __name__)


def _user_json(user):
    display_email = "" if (user.email or "").endswith("@phone.elm.local") else (user.email or "")
    return {"id": user.id, "email": display_email, "phone": user.phone or "", "full_name": user.full_name, "role": user.role, "institution_id": user.institution_id}


@auth_bp.route("/login", methods=["POST"])
def login():
    data = request.json or {}
    identifier = (data.get("identifier") or data.get("email") or data.get("phone") or "").strip()
    password = data.get("password") or ""
    if not identifier or not password:
        return jsonify({"error": "رقم الهاتف أو البريد الإلكتروني وكلمة المرور مطلوبة."}), 400
    user = User.query.filter((User.email == identifier) | (User.phone == identifier)).first()
    if not user or not check_password_hash(user.password_hash, password):
        return jsonify({"error": "بيانات الدخول غير صحيحة."}), 401
    token = jwt.encode({"user_id": user.id, "institution_id": user.institution_id, "role": user.role, "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=8)}, current_app.config["SECRET_KEY"], algorithm="HS256")
    response = jsonify({"access_token": token, "user": _user_json(user)})
    response.set_cookie("elm_session", token, httponly=True, secure=False, samesite="Lax")
    return response


@auth_bp.route("/register", methods=["POST"])
def register():
    data = request.json or {}
    institution_name = (data.get("institution_name") or "مؤسسة ELM").strip()
    email = (data.get("email") or "").strip() or None
    phone = (data.get("phone") or "").strip() or None
    password = data.get("password") or ""
    role = data.get("role", "student")
    full_name = (data.get("full_name") or "").strip()
    if not full_name or not (email or phone) or not password:
        return jsonify({"error": "الاسم، البريد الإلكتروني أو الهاتف، وكلمة المرور مطلوبة."}), 400
    if role not in {"student", "teacher"}:
        return jsonify({"error": "نوع الحساب غير صالح."}), 400
    if email and User.query.filter_by(email=email).first():
        return jsonify({"error": "البريد الإلكتروني مستخدم مسبقاً."}), 409
    if phone and User.query.filter_by(phone=phone).first():
        return jsonify({"error": "رقم الهاتف مستخدم مسبقاً."}), 409
    if phone and not email:
        email = f"{phone}@phone.elm.local"
    institution = Institution.query.filter_by(name=institution_name).first()
    if institution is None:
        institution = Institution(name=institution_name)
        db.session.add(institution)
        db.session.commit()
    user = User(institution_id=institution.id, email=email, phone=phone, full_name=full_name, role=role, password_hash=generate_password_hash(password))
    db.session.add(user)
    db.session.commit()
    return jsonify({"message": "تم إنشاء الحساب بنجاح.", "user_id": user.id}), 201
