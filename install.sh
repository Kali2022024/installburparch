#!/bin/bash

# [ ... Виправлений блок залежностей ... ]

# Cloning
git clone https://github.com/xiv3r/Burpsuite-Professional.git
cd Burpsuite-Professional

# =======================================================
# ➡️ КРОК 1: Завантаження та Очікування
# =======================================================

echo "Downloading Burp Suite Professional Latest..."
version=2025
DOWNLOAD_URL="https://portswigger.net/burp/releases/download?product=pro&type=Jar"
JAR_NAME="burpsuite_pro_v$version.jar"

# Запускаємо axel і ЧЕКАЄМО його завершення (видаляємо &)
axel -o "$JAR_NAME" "$DOWNLOAD_URL"

# =======================================================
# ➡️ КРОК 2: Створення Системних Файлів (ТЕПЕР, КОЛИ ЗАВАНТАЖЕНО)
# =======================================================

SHARE_DIR="/usr/local/share/burpsuitepro"
LAUNCHER_PATH="/usr/local/bin/burpsuitepro"
LOADER_NAME="loader.jar" # Припускаємо, що він знаходиться у склонованому репозиторії

echo "Copying application files to $SHARE_DIR..."
# Створюємо директорію та копіюємо файли
sudo mkdir -p "$SHARE_DIR"
sudo cp "$LOADER_NAME" "$SHARE_DIR/"
sudo cp "$JAR_NAME" "$SHARE_DIR/"

echo "Creating Burp Suite Launcher..."

# Створення лаунчера з коректним заголовком та статичними шляхами
sudo bash -c "cat << EOF > $LAUNCHER_PATH
#!/bin/bash
# Запуск Keygen у фоні (потрібен для зламаної версії)
java -jar $SHARE_DIR/$LOADER_NAME &

# Запуск Burp Suite (з необхідними прапорами Java)
java --add-opens=java.desktop/javax.swing=ALL-UNNAMED \
     --add-opens=java.base/java.lang=ALL-UNNAMED \
     --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED \
     --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED \
     --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED \
     -javaagent:$SHARE_DIR/$LOADER_NAME -noverify -jar $SHARE_DIR/$JAR_NAME
EOF"

# Надання прав на виконання
sudo chmod +x "$LAUNCHER_PATH"

# =======================================================
# ➡️ КРОК 3: Фінальний Запуск
# =======================================================

echo "Executing Burpsuite Professional..."
# Запускаємо через створений лаунчер
(sudo "$LAUNCHER_PATH") &

echo "✅ Встановлення завершено. Burp Suite має відкритися."
