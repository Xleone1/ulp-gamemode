#!/bin/bash

mkdir -p /server/logs

echo "=== Syncing scriptfiles from image defaults ==="
if [ -d "/server/scriptfiles-default" ]; then
    rsync -a --update /server/scriptfiles-default/ /server/scriptfiles/
    echo "=== Scriptfiles sync done ==="
fi

MYSQL_INI="/server/mysql.ini"

cat > "$MYSQL_INI" << EOF
hostname = ${MYSQL_HOST:-mysql}
username = ${MYSQL_USER:-samp}
password = ${MYSQL_PASSWORD:-samppass}
database = ${MYSQL_DATABASE:-database_samp}
server_port = ${MYSQL_PORT:-3306}
EOF

echo "=== mysql.ini generated ==="
cat "$MYSQL_INI"
echo "==========================="

echo "Waiting for MySQL..."
for i in $(seq 1 60); do
    if timeout 1 bash -c "echo > /dev/tcp/${MYSQL_HOST:-mysql}/${MYSQL_PORT:-3306}" 2>/dev/null; then
        echo "MySQL reachable on $MYSQL_HOST:$MYSQL_PORT"
        sleep 1
        break
    fi
    if [ $((i % 5)) -eq 0 ]; then
        echo "Still waiting for MySQL ($i/60)..."
    fi
    sleep 1
done

exec "$@"
