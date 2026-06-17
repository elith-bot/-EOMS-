from flask import Blueprint, request, jsonify
from backend.app import db
from backend.models import Institution, User
from backend.utils import jwt_required

institution_bp = Blueprint("institution", __name__)


@institution_bp.route("/me", methods=["GET"])
@jwt_required
def get_current_user():
    user_payload = request.user
    user = User.query.get(user_payload["user_id"])
    if not user:
        return jsonify({"error": "User not found."}), 404

    return jsonify({
        "id": user.id,
        "email": user.email,
        "full_name": user.full_name,
        "role": user.role,
        "institution_id": user.institution_id,
    })


@institution_bp.route("/settings", methods=["GET"])
@jwt_required
def get_institution_settings():
    institution = Institution.query.get(request.user["institution_id"])
    if not institution:
        return jsonify({"error": "Institution not found."}), 404

    return jsonify({
        "id": institution.id,
        "name": institution.name,
        "logo_url": institution.logo_url,
        "theme_color": institution.theme_color,
        "system_type": institution.system_type,
        "created_at": institution.created_at.isoformat(),
    })


@institution_bp.route("/settings", methods=["PUT"])
@jwt_required
def update_institution_settings():
    data = request.json or {}
    institution = Institution.query.get(request.user["institution_id"])
    if not institution:
        return jsonify({"error": "Institution not found."}), 404

    institution.logo_url = data.get("logo_url", institution.logo_url)
    institution.theme_color = data.get("theme_color", institution.theme_color)
    institution.system_type = data.get("system_type", institution.system_type)
    db.session.commit()

    return jsonify({"message": "Institution settings updated successfully."})
