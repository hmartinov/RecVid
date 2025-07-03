#!/bin/bash

VERSION="1.0"
REPO_URL="https://raw.githubusercontent.com/hmartinov/RecVid/main"
SCRIPT_URL="https://github.com/hmartinov/RecVid/releases/latest/download/recvid.sh"
SCRIPT_PATH="$HOME/bin/recvid.sh"
SAVE_DIR="$HOME/Videos"

# Проверка за нова версия
REMOTE_VERSION=$(curl -fs "$REPO_URL/version.txt" 2>/dev/null | tr -d '\r\n ')

version_is_newer() {
    local IFS=.
    local i ver1=($1) ver2=($2)
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do ver1[i]=0; done
    for ((i=${#ver2[@]}; i<${#ver1[@]}; i++)); do ver2[i]=0; done
    for ((i=0; i<${#ver1[@]}; i++)); do
        if ((10#${ver2[i]} > 10#${ver1[i]})); then return 0; fi
        if ((10#${ver2[i]} < 10#${ver1[i]})); then return 1; fi
    done
    return 1
}

if [[ -n "$REMOTE_VERSION" ]] && version_is_newer "$VERSION" "$REMOTE_VERSION"; then
    zenity --question \
        --title="Налична е нова версия" \
        --text="Имате версия $VERSION.\nНалична е нова версия: $REMOTE_VERSION\n\nИскате ли да я изтеглите сега?"
    if [[ $? -eq 0 ]]; then
        TMPFILE=$(mktemp)
        if curl -fsSL "$SCRIPT_URL" -o "$TMPFILE"; then
            mv "$TMPFILE" "$SCRIPT_PATH"
            chmod +x "$SCRIPT_PATH"
            zenity --info --title="Обновено" --text="Скриптът беше обновен успешно до версия $REMOTE_VERSION."
            exec "$SCRIPT_PATH" "$@"
            exit 0
        else
            zenity --error --title="Грешка" --text="Неуспешно изтегляне на новата версия."
            rm -f "$TMPFILE"
        fi
    fi
fi

# Проверка на зависимости
for cmd in ffmpeg zenity xdg-open xdpyinfo pulseaudio; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        zenity --error --text="Липсва: $cmd"
        exit 1
    fi
done

# Име на файл
mkdir -p "$SAVE_DIR"

BASENAME="recvid-$(date +%Y%m%d-%H%M%S)"
VIDEO_TEMP="$SAVE_DIR/${BASENAME}_video.mkv"
AUDIO_TEMP="$SAVE_DIR/${BASENAME}_audio.m4a"
FINAL_FILE="$SAVE_DIR/${BASENAME}.mp4"

# Резолюция
RESOLUTION=$(xdpyinfo | grep dimensions | awk '{print $2}')
if [[ -z "$RESOLUTION" ]]; then
    zenity --error --text="Не може да се определи резолюцията."
    exit 1
fi

# Потвърждение
zenity --question --text="Стартираме запис?\n\nРезолюция: $RESOLUTION\nФайл: $FINAL_FILE"
if [[ $? -ne 0 ]]; then exit 1; fi

# Записване на видео без звук
ffmpeg -y \
  -f x11grab -video_size "$RESOLUTION" -framerate 25 -i :0.0 \
  -an -c:v libx264 -preset ultrafast -crf 18 "$VIDEO_TEMP" &

VID_PID=$!

# Запис на аудио
ffmpeg -y \
  -f pulse -i default -c:a aac -b:a 128k "$AUDIO_TEMP" &

AUD_PID=$!

# Zenity – инфо
zenity --info --title="RecVid – Активен запис" \
       --text="🎥 Екранът и 🎙️ звукът се записват.\n\nЗатвори този прозорец, за да спреш."

# Спиране
kill -INT "$VID_PID" 2>/dev/null
kill -INT "$AUD_PID" 2>/dev/null
sleep 0.5
wait "$VID_PID"
wait "$AUD_PID"

# Сливане на видео + аудио
ffmpeg -y \
  -i "$VIDEO_TEMP" -i "$AUDIO_TEMP" \
  -c:v copy -c:a aac "$FINAL_FILE"

# Проверка
if [[ ! -f "$FINAL_FILE" ]]; then
    zenity --error --text="⚠️ Грешка при сливането на видео и звук."
    exit 1
fi

# Почистване
rm -f "$VIDEO_TEMP" "$AUDIO_TEMP"

# Финално меню
CHOICE=$(zenity --list \
  --title="RecVid – Готово!" \
  --text="✅ Записът приключи успешно!\nФайл: $FINAL_FILE" \
  --column="Действие" \
  "🎬 Пусни видеото" \
  "📂 Отвори папката")

if [[ "$CHOICE" == "🎬 Пусни видеото" ]]; then
    xdg-open "$FINAL_FILE"
elif [[ "$CHOICE" == "📂 Отвори папката" ]]; then
    xdg-open "$(dirname "$FINAL_FILE")"
fi
