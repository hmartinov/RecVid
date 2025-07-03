#!/bin/bash

# Папки и имена
INSTALL_DIR="$HOME/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
SCRIPT_FILE="recvid.sh"
DESKTOP_FILE="recvid.desktop"

echo "== Инсталация на RecVid =="
echo

# Зависимости (включително бъдещи за ъпдейти и ffmpeg)
REQUIRED=("ffmpeg" "zenity" "xdg-open" "curl" "xdpyinfo" "pulseaudio")
for pkg in "${REQUIRED[@]}"; do
    if ! command -v "$pkg" >/dev/null 2>&1; then
        echo "📦 Липсва: $pkg – ще бъде инсталиран..."
        sudo apt update
        sudo apt install -y "$pkg"
    else
        echo "✅ Наличен: $pkg"
    fi
done

# Копиране на файловете
echo
echo "📂 Копиране на файловете..."
mkdir -p "$INSTALL_DIR" "$DESKTOP_DIR"

cp "$SCRIPT_FILE" "$INSTALL_DIR/"
cp "$DESKTOP_FILE" "$DESKTOP_DIR/"

chmod +x "$INSTALL_DIR/$SCRIPT_FILE"
chmod +x "$DESKTOP_DIR/$DESKTOP_FILE"

# По избор: икона на десктопа
read -p "🖥️ Искаш ли икона на десктопа? (y/n): " ANSWER
if [[ "$ANSWER" == "y" || "$ANSWER" == "Y" ]]; then
    cp "$DESKTOP_FILE" "$HOME/Desktop/"
    chmod +x "$HOME/Desktop/$DESKTOP_FILE"
    echo "✅ Икона е добавена на десктопа."
fi

# Финално съобщение
echo
echo "✅ RecVid е инсталиран успешно!"
echo "🎬 Стартирай го от менюто или с двоен клик."
read -p "Натисни Enter за изход..."
