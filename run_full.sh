#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="$SCRIPT_DIR/frontend"
BACKEND_DIR="$SCRIPT_DIR"
FLUTTER_SDK="$SCRIPT_DIR/flutter_sdk/bin/flutter"
BACKEND_PORT=5000

if [ ! -f "$BACKEND_DIR/.env" ]; then
  echo "❌ ملف .env غير موجود في دليل المشروع الرئيسي."
  exit 1
fi

if [ ! -d "$BACKEND_DIR/instance" ]; then
  mkdir -p "$BACKEND_DIR/instance"
  echo "✅ تم إنشاء مجلد instance"
fi

if [ ! -x "$FLUTTER_SDK" ]; then
  echo "❌ لم يتم العثور على flutter SDK في $FLUTTER_SDK"
  exit 1
fi

find_free_port() {
  local port=$1
  while ss -ltnp 2>/dev/null | grep -q ":$port\b"; do
    port=$((port + 1))
    if [ "$port" -gt 5100 ]; then
      echo "NO_PORT"
      return
    fi
  done
  echo "$port"
}

FREE_PORT=$(find_free_port "$BACKEND_PORT")
if [ "$FREE_PORT" = "NO_PORT" ]; then
  echo "❌ لم يتم العثور على بورت حر بين 5000 و5100."
  exit 1
fi
BACKEND_PORT=$FREE_PORT

echo "╔════════════════════════════════════════════════════════╗"
echo "║      تشغيل ELM Backend + Frontend معًا بأمر واحد     ║"
echo "╚════════════════════════════════════════════════════════╝"

if ss -ltnp | grep -q ':5000\b'; then
  echo "⚠️  بورت 5000 مشغول، سيتم استخدام بورت $BACKEND_PORT للباك اند."
else
  BACKEND_PORT=5000
fi

echo "📦 تشغيل Flask Backend على http://127.0.0.1:$BACKEND_PORT"
cd "$BACKEND_DIR"
FLASK_RUN_PORT=$BACKEND_PORT python3 -m flask --app "backend.app:create_app" run --host=0.0.0.0 --port=$BACKEND_PORT 2>&1 | tee backend.log &
BACKEND_PID=$!

echo "Backend PID: $BACKEND_PID"

echo "
🔎 انتظر حتى يصبح الباك اند جاهز ثم تشغيل الواجهة الأمامية..."

cleanup() {
  echo "\n🛑 إيقاف Backend..."
  kill "$BACKEND_PID" 2>/dev/null || true
}
trap cleanup EXIT

sleep 4

cd "$FRONTEND_DIR"
"$FLUTTER_SDK" clean
"$FLUTTER_SDK" run -d web-server --web-port=8080 --dart-define=API_BASE_URL="http://127.0.0.1:$BACKEND_PORT"
