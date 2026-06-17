from flask import Blueprint, request, jsonify
from backend.app import db
from backend.models import Institution, User
from werkzeug.security import generate_password_hash

admin_bp = Blueprint("admin", __name__)


@admin_bp.route("/institutions", methods=["POST"])
def create_institution():
    data = request.json or {}
    name = data.get("name")
    logo_url = data.get("logo_url")
    theme_color = data.get("theme_color")
    system_type = data.get("system_type", "classic")

    if not name:
        return jsonify({"error": "Institution name is required."}), 400

    if Institution.query.filter_by(name=name).first():
        return jsonify({"error": "Institution already exists."}), 409

    institution = Institution(name=name, logo_url=logo_url, theme_color=theme_color, system_type=system_type)
    db.session.add(institution)
    db.session.commit()

    admin_user = User(
        institution_id=institution.id,
        email=data.get("admin_email", f"admin@{name.lower().replace(' ', '')}.local"),
        full_name=data.get("admin_name", "Institution Admin"),
        role="admin",
        password_hash=generate_password_hash(data.get("admin_password", "ChangeMe123!")),
    )
    db.session.add(admin_user)
    db.session.commit()

    subscription = Subscription(
        institution_id=institution.id,
        plan=data.get("plan", "starter"),
        status=data.get("subscription_status", "active"),
    )
    db.session.add(subscription)
    db.session.commit()

    return jsonify({
        "message": "Institution created successfully.",
        "institution_id": institution.id,
        "admin_user_id": admin_user.id,
        "subscription_id": subscription.id,
    }), 201


@admin_bp.route("/institutions", methods=["GET"])
def list_institutions():
    institutions = Institution.query.all()
    result = [
        {
            "id": inst.id,
            "name": inst.name,
            "logo_url": inst.logo_url,
            "theme_color": inst.theme_color,
            "system_type": inst.system_type,
            "created_at": inst.created_at.isoformat(),
        }
        for inst in institutions
    ]
    return jsonify(result)


@admin_bp.route("/institutions/<int:institution_id>/toggle", methods=["PUT"])
def toggle_institution():
    institution = Institution.query.get(institution_id)
    if not institution:
        return jsonify({"error": "Institution not found."}), 404

    institution.is_active = not institution.is_active
    db.session.commit()

    return jsonify({
        "message": "Institution status updated.",
        "institution_id": institution.id,
        "is_active": institution.is_active,
    })
