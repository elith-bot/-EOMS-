from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_cors import CORS
from dotenv import load_dotenv

load_dotenv()

from backend.config import Config


db = SQLAlchemy()
migrate = Migrate()


def create_app():
    app = Flask(__name__, instance_relative_config=False)
    app.config.from_object(Config)

    CORS(app, supports_credentials=True)
    db.init_app(app)
    migrate.init_app(app, db)

    from backend.models import User, Institution, Course, CourseSection, ScheduleEntry, Enrollment, Subscription
    from backend.blueprints.auth import auth_bp
    from backend.blueprints.admin import admin_bp
    from backend.blueprints.institution import institution_bp
    from backend.blueprints.academic import academic_bp

    app.register_blueprint(auth_bp, url_prefix="/auth")
    app.register_blueprint(admin_bp, url_prefix="/admin")
    app.register_blueprint(institution_bp, url_prefix="/institution")
    app.register_blueprint(academic_bp, url_prefix="/academic")

    @app.route("/")
    def index():
        return {"message": "Welcome to ELM SaaS educational management system."}

    return app
