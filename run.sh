#!/bin/bash
pkill -9 -f Xvfb 2>/dev/null || true
pkill -9 -f x11vnc 2>/dev/null || true
pkill -9 -f websockify 2>/dev/null || true
pkill -9 -f chrome 2>/dev/null || true
pkill -9 -f openbox 2>/dev/null || true
pkill -9 -f tint2 2>/dev/null || true

echo "[1/4] Starting 720p HD Virtual Display..."
Xvfb :99 -screen 0 1280x720x24 +extension GLX +render -noreset &
sleep 1

echo "[2/4] Starting Window Manager & Taskbar..."
DISPLAY=:99 openbox &
DISPLAY=:99 tint2 &
DISPLAY=:99 pcmanfm --desktop &

echo "[3/4] Launching 64-bit Chrome (Windows Disguise)..."
DISPLAY=:99 google-chrome-stable \
  --no-sandbox \
  --disable-dev-shm-usage \
  --test-type \
  --disable-session-crashed-bubble \
  --start-maximized \
  --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36" \
  https://www.roblox.com/download &
sleep 2

echo "[4/4] Starting Video Stream on Port 6080..."
x11vnc -display :99 -forever -nopw -shared -rfbport 5900 -bg
websockify --web /usr/share/novnc 6080 localhost:5900
