#!/bin/bash

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║           🚀 تشغيل تطبيق ELM - Flask Backend          ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# التحقق من .env
if [ ! -f .env ]; then
    echo "❌ ملف .env غير موجود!"
    exit 1
fi

echo "✅ .env موجود"
echo ""

# التحقق من instance folder
if [ ! -d instance ]; then
    mkdir -p instance
    echo "✅ تم إنشاء مجلد instance"
fi

echo ""
echo "📦 تشغيل Flask App..." 
echo "🌐 الرابط: http://localhost:5000"        
echo ""
echo "⏹️  اضغط Ctrl+C لإيقاف التطبيق"
echo ""

# تشغيل التطبيق
python3 -m flask --app "backend.app:create_app" run --host=0.0.0.0 --port=5000
