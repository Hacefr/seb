#!/bin/bash
PORT="${PORT:-6080}"
echo "Starting Cloud PC on Port $PORT..."

# 1. Start Virtual Display
Xvfb :99 -screen 0 1280x720x24 +extension GLX +render -noreset &
sleep 1

# 2. Start Desktop, Taskbar, and File Manager
DISPLAY=:99 openbox &
DISPLAY=:99 tint2 &
DISPLAY=:99 pcmanfm --desktop &

# 3. Launch 64-bit Chrome with Windows Disguise
DISPLAY=:99 google-chrome-stable \
  --no-sandbox \
  --disable-dev-shm-usage \
  --test-type \
  --disable-session-crashed-bubble \
  --start-maximized \
  --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36" \
  https://google.com &

# 4. Attach Frame Grabber & Web Streamer on Render's Port
x11vnc -display :99 -forever -nopw -shared -rfbport 5900 -bg
exec websockify --web /usr/share/novnc "$PORT" localhost:5900
