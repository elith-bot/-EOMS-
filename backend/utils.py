import jwt
from flask import current_app, request, jsonify
from functools import wraps


def generate_jwt(payload):
    return jwt.encode(payload, current_app.config["SECRET_KEY"], algorithm=current_app.config["JWT_ALGORITHM"])


def decode_jwt(token):
    return jwt.decode(token, current_app.config["SECRET_KEY"], algorithms=[current_app.config["JWT_ALGORITHM"]])


def jwt_required(view_func):
    @wraps(view_func)
    def wrapped(*args, **kwargs):
        token = None
        auth_header = request.headers.get("Authorization")
        if auth_header and auth_header.startswith("Bearer "):
            token = auth_header.split(" ", 1)[1].strip()
        else:
            token = request.cookies.get("elm_session")

        if not token:
            return jsonify({"error": "Authentication token is missing."}), 401

        try:
            payload = decode_jwt(token)
            request.user = payload
        except Exception as exc:
            return jsonify({"error": "Invalid or expired token.", "details": str(exc)}), 401

        return view_func(*args, **kwargs)

    return wrapped
