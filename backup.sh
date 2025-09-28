#!/bin/sh
set -e

echo "==== Start Backup $(date) ===="

BACKUP_DIR="/backups/$(date +%F)"
MINIO_DIR="$BACKUP_DIR/minio"
mkdir -p "$BACKUP_DIR"
mkdir -p "$MINIO_DIR"


# --------------------
# InfluxDB Data v2 backup
# --------------------
echo "Backing up InfluxDB Data ..."
influx backup "$BACKUP_DIR/influxData" \
  --host "$INFLUX_DATA_HOST" \
  -t "$INFLUX_TOKEN" \
  -o "$INFLUX_ORG"

# --------------------
# InfluxDB Logs v2 backup
# --------------------

echo "Backing up InfluxDB Logs ..."
influx backup "$BACKUP_DIR/influxLog" \
  --host "$INFLUX_LOGS_HOST" \
  -t "$INFLUX_TOKEN" \
  -o "$INFLUX_ORG"

# --------------------
# MongoDB backup
# --------------------
echo "Backing up MongoDB..."
mongodump \
  --host "$MONGO_HOST" \
  --port "$MONGO_PORT" \
  --username "$MONGO_USER" \
  --password "$MONGO_PASS" \
  --authenticationDatabase admin \
  --out "$BACKUP_DIR/mongo" \
  --numParallelCollections=1 \
  --readPreference=secondaryPreferred

# --------------------
# MinIO mirror
# --------------------
echo "Mirroring to MinIO..."
mc alias set minio "$MINIO_HOST" "$MINIO_ACCESS_KEY" "$MINIO_SECRET_KEY"
mc mirror minio "$MINIO_DIR"


### ===============================
### Cleanup old backups
### ===============================
echo "[Cleanup] Removing backups older than "$RETENTION" days..."
find "$(dirname "$BACKUP_DIR")"/* -maxdepth 0 -type d -mtime "+$RETENTION" -exec rm -rf {} \;
echo "[Cleanup] Done."

echo "==== Backup Finished ===="
