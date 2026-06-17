from flask import Blueprint, request, jsonify
from backend.app import db
from backend.models import Course, CourseSection, ScheduleEntry, Enrollment, Institution
from backend.utils import jwt_required

academic_bp = Blueprint("academic", __name__)


@academic_bp.route("/systems", methods=["GET"])
def get_supported_systems():
    return jsonify([
        {"key": "credit_hours", "name": "Credit Hours / Bologna", "description": "Academic credit-based system for higher education."},
        {"key": "semester", "name": "Semester System", "description": "Standard academic semester-based system."},
        {"key": "course_based", "name": "Course-Based System", "description": "Flexible course and module management."},
        {"key": "classic", "name": "Classic Schools / Institutes", "description": "Traditional daily timetable and classroom management."},
    ])


@academic_bp.route("/courses", methods=["POST"])
@jwt_required
def create_course():
    data = request.json or {}
    institution_id = request.user["institution_id"]
    name = data.get("name")
    code = data.get("code")
    credit_hours = data.get("credit_hours", 0)
    system_type = data.get("system_type", "classic")

    if not name or not code:
        return jsonify({"error": "Course name and code are required."}), 400

    course = Course(
        institution_id=institution_id,
        name=name,
        code=code,
        credit_hours=credit_hours,
        system_type=system_type,
    )
    db.session.add(course)
    db.session.commit()

    return jsonify({"message": "Course created successfully.", "course_id": course.id}), 201


@academic_bp.route("/courses", methods=["GET"])
@jwt_required
def list_courses():
    institution_id = request.user["institution_id"]
    courses = Course.query.filter_by(institution_id=institution_id).all()
    return jsonify([
        {
            "id": course.id,
            "name": course.name,
            "code": course.code,
            "credit_hours": course.credit_hours,
            "system_type": course.system_type,
        }
        for course in courses
    ])


@academic_bp.route("/schedules", methods=["POST"])
@jwt_required
def create_schedule():
    data = request.json or {}
    section_id = data.get("section_id")
    day_of_week = data.get("day_of_week")
    start_time = data.get("start_time")
    end_time = data.get("end_time")
    room = data.get("room")

    if not section_id or not day_of_week or not start_time or not end_time:
        return jsonify({"error": "Section, day, start and end times are required."}), 400

    schedule = ScheduleEntry(
        section_id=section_id,
        day_of_week=day_of_week,
        start_time=start_time,
        end_time=end_time,
        room=room,
    )
    db.session.add(schedule)
    db.session.commit()

    return jsonify({"message": "Schedule entry created successfully.", "schedule_id": schedule.id}), 201


@academic_bp.route("/schedules", methods=["GET"])
@jwt_required
def list_schedules():
    institution_id = request.user["institution_id"]
    schedules = (
        db.session.query(ScheduleEntry)
        .join(CourseSection)
        .join(Course)
        .filter(Course.institution_id == institution_id)
        .all()
    )
    return jsonify([
        {
            "id": schedule.id,
            "section_id": schedule.section_id,
            "day_of_week": schedule.day_of_week,
            "start_time": schedule.start_time.strftime("%H:%M"),
            "end_time": schedule.end_time.strftime("%H:%M"),
            "room": schedule.room,
        }
        for schedule in schedules
    ])


@academic_bp.route("/enrollments", methods=["POST"])
@jwt_required
def enroll_student():
    data = request.json or {}
    student_id = data.get("student_id")
    section_id = data.get("section_id")

    if not student_id or not section_id:
        return jsonify({"error": "Student and section are required."}), 400

    enrollment = Enrollment(student_id=student_id, section_id=section_id)
    db.session.add(enrollment)
    db.session.commit()

    return jsonify({"message": "Student enrolled successfully.", "enrollment_id": enrollment.id}), 201
