#!/bin/bash

# 入力されたバケット名を取得
BUCKET_NAME=$1

# バケット名が入力されていない場合はエラーを返す
if [ -z "$BUCKET_NAME" ]; then
  echo "Error: Please provide an S3 bucket name."
  exit 1
fi

# S3 バケットの存在確認
RESULT=$(aws s3api head-bucket --bucket "$BUCKET_NAME" 2>&1)
STATUS=$?

# 結果に応じて出力
if [ $STATUS -eq 0 ]; then
  # 200 OK: バケットが存在し、アクセス可能
  echo "{\"exists\": \"true\", \"status\": \"200\"}"
elif echo "$RESULT" | grep -q 'Forbidden'; then
  # 403 Forbidden: バケットは存在するが、アクセス権がない
  echo "{\"exists\": \"true\", \"status\": \"403\"}"
elif echo "$RESULT" | grep -q 'Not Found'; then
  # 404 Not Found: バケットは存在しない
  echo "{\"exists\": \"false\", \"status\": \"404\"}"
else
  # その他のエラー
  echo "{\"exists\": \"false\", \"status\": \"255\", \"message\": \"AWS CLI error. Check your credentials or AWS configuration.\"}"
fi
