#!/usr/bin/env bash
set -euo pipefail

SITE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE_DIR="$(cd "$SITE_DIR/.." && pwd)"
PROFILE_JSON="$WORKSPACE_DIR/job-automation/config/profile.json"
REPO_NAME="${GITHUB_PAGES_REPO:-mr-xiong-resume-site}"

cd "$SITE_DIR"

if ! gh auth status >/dev/null 2>&1; then
  echo "GitHub CLI is not logged in. Run: gh auth login"
  exit 2
fi

OWNER="$(gh api user --jq .login)"
SITE_URL="https://${OWNER}.github.io/${REPO_NAME}/"
REMOTE_URL="https://github.com/${OWNER}/${REPO_NAME}.git"

if [ ! -d .git ]; then
  git init
  git branch -M main
fi

if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

git add .
if git diff --cached --quiet; then
  echo "No site changes to commit."
else
  git commit -m "Publish personal resume site"
fi

if ! gh repo view "${OWNER}/${REPO_NAME}" >/dev/null 2>&1; then
  gh repo create "$REPO_NAME" --public
fi
git push --force-with-lease -u origin main

if ! gh api "repos/${OWNER}/${REPO_NAME}/pages" >/dev/null 2>&1; then
  gh api "repos/${OWNER}/${REPO_NAME}/pages" \
    -X POST \
    -F source.branch=main \
    -F source.path=/
fi

python3 - "$PROFILE_JSON" "$SITE_URL" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
site_url = sys.argv[2]
data = json.loads(path.read_text(encoding="utf-8"))
data["personal_site_url"] = site_url
path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
PY

echo "Published: ${SITE_URL}"
echo "Updated: ${PROFILE_JSON}"
