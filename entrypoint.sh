#!/usr/bin/env bash
set -eo pipefail

# Create mount directory for service
mkdir -p $MNT_DIR

echo "Bucket:" $BUCKET
echo "Mounting GCS Fuse."
gcsfuse --debug_gcs --debug_fuse $BUCKET $MNT_DIR 
echo "Mounting completed."

export FAVA_PORT=$PORT
exec fava --debug $* &

# Exit immediately when one of the background processes terminate.
wait -n
