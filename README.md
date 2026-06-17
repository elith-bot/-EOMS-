# -EOMS- 

A starter scaffold for the ELM educational management system.

## Overview

This repository contains a minimal Flask backend with SQLAlchemy models, JWT login, and institution administration endpoints.

## Getting Started

1. Create a Python virtual environment:

   python3 -m venv .venv
   source .venv/bin/activate

2. Install dependencies:

   pip install -r requirements.txt

3. Configure environment variables:

   cp .env.example .env
   edit .env as needed

4. Run the Flask application:

   export FLASK_APP=backend.app:create_app
   flask run --host=0.0.0.0 --port=5000

## Docker

Build and start the app with:

   docker compose up --build

## Flutter frontend

A simple Flutter cross-platform frontend scaffold is available under `frontend/`.

To run the frontend, install Flutter on your machine, then navigate to `frontend/` and run:

   flutter pub get
   flutter run

> The current frontend scaffold contains a login screen and service layer that target the Flask backend.

## Notes

This scaffold is designed for easy migration from SQLite in development to MySQL in production by changing `SQLALCHEMY_DATABASE_URI` in the environment.
    
         