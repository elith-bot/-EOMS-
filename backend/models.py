from datetime import datetime
from backend.app import db


class Institution(db.Model):
    __tablename__ = "institutions"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False, unique=True)
    logo_url = db.Column(db.String(1024))
    theme_color = db.Column(db.String(32))
    system_type = db.Column(db.String(64), nullable=False, default="classic")
    is_active = db.Column(db.Boolean, nullable=False, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    users = db.relationship("User", backref="institution", lazy=True)
    courses = db.relationship("Course", backref="institution", lazy=True)
    subscriptions = db.relationship("Subscription", backref="institution", lazy=True)


class User(db.Model):
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True)
    institution_id = db.Column(db.Integer, db.ForeignKey("institutions.id"), nullable=False)
    email = db.Column(db.String(255), nullable=True, unique=True)
    phone = db.Column(db.String(32), nullable=True, unique=True)
    full_name = db.Column(db.String(255), nullable=False)
    role = db.Column(db.String(64), nullable=False, default="student")
    password_hash = db.Column(db.String(255), nullable=False)
    is_active = db.Column(db.Boolean, nullable=False, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    enrollments = db.relationship("Enrollment", backref="student", lazy=True)
    sections = db.relationship("CourseSection", backref="teacher", lazy=True, foreign_keys="CourseSection.teacher_id")


class Course(db.Model):
    __tablename__ = "courses"
    id = db.Column(db.Integer, primary_key=True)
    institution_id = db.Column(db.Integer, db.ForeignKey("institutions.id"), nullable=False)
    name = db.Column(db.String(255), nullable=False)
    code = db.Column(db.String(100), nullable=False)
    credit_hours = db.Column(db.Integer, default=0)
    system_type = db.Column(db.String(64), nullable=False, default="classic")
    description = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    sections = db.relationship("CourseSection", backref="course", lazy=True)


class CourseSection(db.Model):
    __tablename__ = "course_sections"
    id = db.Column(db.Integer, primary_key=True)
    course_id = db.Column(db.Integer, db.ForeignKey("courses.id"), nullable=False)
    teacher_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=True)
    name = db.Column(db.String(255), nullable=False)
    term = db.Column(db.String(64))
    capacity = db.Column(db.Integer, default=0)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    schedule_entries = db.relationship("ScheduleEntry", backref="section", lazy=True)
    enrollments = db.relationship("Enrollment", backref="section", lazy=True)


class ScheduleEntry(db.Model):
    __tablename__ = "schedule_entries"
    id = db.Column(db.Integer, primary_key=True)
    section_id = db.Column(db.Integer, db.ForeignKey("course_sections.id"), nullable=False)
    day_of_week = db.Column(db.String(20), nullable=False)
    start_time = db.Column(db.String(16), nullable=False)
    end_time = db.Column(db.String(16), nullable=False)
    room = db.Column(db.String(100))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class Enrollment(db.Model):
    __tablename__ = "enrollments"
    id = db.Column(db.Integer, primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    section_id = db.Column(db.Integer, db.ForeignKey("course_sections.id"), nullable=False)
    status = db.Column(db.String(64), nullable=False, default="active")
    enrolled_at = db.Column(db.DateTime, default=datetime.utcnow)


class Subscription(db.Model):
    __tablename__ = "subscriptions"
    id = db.Column(db.Integer, primary_key=True)
    institution_id = db.Column(db.Integer, db.ForeignKey("institutions.id"), nullable=False)
    plan = db.Column(db.String(128), nullable=False, default="starter")
    status = db.Column(db.String(64), nullable=False, default="active")
    started_at = db.Column(db.DateTime, default=datetime.utcnow)
    expires_at = db.Column(db.DateTime)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
