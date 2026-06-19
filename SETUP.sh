#!/bin/bash
# 🚀 أول خطوات لبدء مشروع ELM
# First Steps to Start ELM Project

echo "╔════════════════════════════════════════════════════════╗"
echo "║     🎓 ELM - نظام إدارة الطلاب الذكي                ║"
echo "║     Educational Learning Management System            ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# الخطوة 1: إنشاء Python Virtual Environment
echo "📦 الخطوة 1: إنشاء بيئة Python العزلة..."
python3 -m venv venv
source venv/bin/activate

echo "✅ تم إنشاء Virtual Environment"
echo ""

# الخطوة 2: إنشاء requirements.txt
echo "📝 الخطوة 2: إنشاء ملف requirements.txt..."
cat > requirements.txt << 'EOF'
Flask==3.0.0
Flask-SQLAlchemy==3.1.1
SQLAlchemy==2.0.23
python-dotenv==1.0.0
PyJWT==2.8.1
Flask-Cors==4.0.0
Flask-Migrate==4.0.5
pymysql==1.1.0
Werkzeug==3.0.1
EOF

echo "✅ تم إنشاء requirements.txt"
echo ""

# الخطوة 3: تثبيت المكتبات
echo "📚 الخطوة 3: تثبيت المكتبات..."
pip install -r requirements.txt

echo "✅ تم تثبيت جميع المكتبات"
echo ""

# الخطوة 4: إنشاء ملف .env
echo "🔐 الخطوة 4: إنشاء ملف .env..."
cat > .env << 'EOF'
# قاعدة البيانات
SQLALCHEMY_DATABASE_URI=sqlite:///instance/elm.db

# المفاتيح السرية
SECRET_KEY=your_super_secret_key_change_this_in_production_12345
JWT_SECRET=your_jwt_secret_key_change_this_in_production_67890

# البيئة
FLASK_ENV=development
FLASK_DEBUG=True
EOF

echo "✅ تم إنشاء ملف .env"
echo ""

# الخطوة 5: إنشاء مجلد instance
echo "📁 الخطوة 5: إنشاء مجلد instance..."
mkdir -p instance

echo "✅ تم إنشاء مجلد instance"
echo ""

# الخطوة 6: عرض الملفات المُنشأة
echo "📂 الملفات المُنشأة:"
ls -la | grep -E "requirements.txt|\.env|venv"
echo ""

# الملخص النهائي
echo "╔════════════════════════════════════════════════════════╗"
echo "║              ✅ تم إكمال جميع الخطوات!               ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

echo "🎯 الخطوة التالية:"
echo ""
echo "1. اقرأ ملف PROJECT_PLAN.md:"
echo "   cat PROJECT_PLAN.md"
echo ""
echo "2. افتح ملف ELM-Complete-Plan.ipynb في VS Code"
echo "   وانسخ البرومبت الكامل"
echo ""
echo "3. أرسل البرومبت لـ AI:"
echo "   - ChatGPT"
echo "   - Claude"
echo "   - Google Gemini"
echo ""
echo "4. استقبل الأكواد وانسخها إلى المشروع"
echo ""
echo "💡 تذكر: Virtual Environment مفعل الآن ✓"
echo ""
echo "🚀 الآن أنت جاهز للبدء!"
echo ""
