#!/usr/bin/env bash
set -euo pipefail
mkdir -p src db scripts docs public/admin

cat > package.json <<'JSON'
{
  "name": "companionscpas-platform",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "wrangler dev",
    "deploy": "wrangler deploy",
    "check:brand": "grep -RInEi \"pawlove|pawloverescue|meauxbility|g7wf09f|22963db|Grant Parish|Sissyj\" src public || true"
  },
  "devDependencies": { "wrangler": "latest" }
}
JSON

cat > .gitignore <<'EOF2'
node_modules
.dev.vars
.env
.wrangler
dist
.DS_Store
r2-source
EOF2

echo "backend scaffold ready"
