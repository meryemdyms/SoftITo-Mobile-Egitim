#!/usr/bin/env bash
# flutter-feature-scaffold generator script
# Usage: ./generate_feature.sh <feature_name>

set -e

if [ -z "$1" ]; then
  echo "Hata: Feature adı belirtilmedi."
  echo "Kullanım: ./generate_feature.sh <feature_name>"
  exit 1
fi

FEATURE_NAME=$1
TARGET_DIR="lib/features/${FEATURE_NAME}"

mkdir -p "${TARGET_DIR}/controllers"
mkdir -p "${TARGET_DIR}/models"
mkdir -p "${TARGET_DIR}/views"
mkdir -p "${TARGET_DIR}/widgets"

echo "Oluşturuldu: ${TARGET_DIR} (controllers, models, views, widgets)"
