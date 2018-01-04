#!/bin/bash
set -e

# ANUBIS_RELEASE_SLUG: example: puppetlabs-apache-2.3.0, no default
# ANUBIS_WEBHOOK_URI: full URI to post results back to, no default
# ANUBIS_WEBHOOK_TOKEN: unique token to authenticate webhook request, no default
# ANUBIS_RELEASE_URI: full URI to download release from, default to official forge

# Check for required env vars
: "${ANUBIS_RELEASE_SLUG:?Need to set ANUBIS_RELEASE_SLUG}"
: "${ANUBIS_WEBHOOK_URI:?Need to set ANUBIS_WEBHOOK_URI}"
: "${ANUBIS_WEBHOOK_TOKEN:?Need to set ANUBIS_WEBHOOK_TOKEN}"

# Check for custom download URI or use default
if [[ -z "${ANUBIS_RELEASE_URI}" ]]; then
  echo "NOTICE: ANUBIS_RELEASE_URI not set, using default..."
  download_uri="https://forgeapi.puppet.com/v3/files/${ANUBIS_RELEASE_SLUG}.tar.gz"
else
  download_uri=${ANUBIS_RELEASE_URI}
fi

pushd workspace

# Download and extract module release
wget "${download_uri}"
tar -xzvf "${ANUBIS_RELEASE_SLUG}.tar.gz" 

# Run strings and emit output to json document
puppet strings generate \
  --emit-json \
  strings-output.json \
  .

# Add token to output
jq \
  --arg token "${ANUBIS_WEBHOOK_TOKEN}" \
  --from-file ../response.jq \
  --compact-output \
  strings-output.json \
  > response.json

# Post results back to specified URI
curl \
  --fail \
  --progress-bar \
  -X POST \
  -H "Content-Type: application/json" \
  -d@response.json \
  "${ANUBIS_WEBHOOK_URI}"

popd

exit 0
