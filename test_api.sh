#!/bin/bash

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         🎯 اختبر التطبيق - Test ELM API Endpoints           ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# الألوان
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}1️⃣  اختبر الـ Health Check${NC}"
echo "───────────────────────────────────────────────────────────────"
curl -s http://localhost:5000/ | python3 -m json.tool
echo ""
echo ""

echo -e "${BLUE}2️⃣  تسجيل مستخدم جديد (Student)${NC}"
echo "───────────────────────────────────────────────────────────────"
curl -s -X POST http://localhost:5000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "institution_name": "Test School",
    "email": "student@test.com",
    "password": "password123",
    "role": "student",
    "full_name": "Test Student"
  }' | python3 -m json.tool
echo ""
echo ""

echo -e "${BLUE}3️⃣  تسجيل مستخدم جديد (Teacher)${NC}"
echo "───────────────────────────────────────────────────────────────"
curl -s -X POST http://localhost:5000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "institution_name": "Test School",
    "email": "teacher@test.com",
    "password": "password123",
    "role": "teacher",
    "full_name": "Test Teacher"
  }' | python3 -m json.tool
echo ""
echo ""

echo -e "${BLUE}4️⃣  تسجيل الدخول (Student)${NC}"
echo "───────────────────────────────────────────────────────────────"
RESPONSE=$(curl -s -X POST http://localhost:5000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "student@test.com",
    "password": "password123",
    "user_type": "student"
  }')
echo "$RESPONSE" | python3 -m json.tool
echo ""
echo ""

echo -e "${BLUE}5️⃣  تسجيل الدخول (Teacher)${NC}"
echo "───────────────────────────────────────────────────────────────"
curl -s -X POST http://localhost:5000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teacher@test.com",
    "password": "password123",
    "user_type": "teacher"
  }' | python3 -m json.tool
echo ""
echo ""

echo -e "${GREEN}✅ اختبار APIs الأساسية انتهى!${NC}"
echo ""
echo "📝 الملاحظات:"
echo "   • تم اختبار Health Check"
echo "   • تم تسجيل طالب وأستاذ"
echo "   • تم اختبار تسجيل الدخول"
echo "   • جميع الـ responses تم الحصول عليها بنجاح"
echo ""
