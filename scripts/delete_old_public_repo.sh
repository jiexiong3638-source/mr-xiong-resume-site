#!/usr/bin/env bash
set -euo pipefail

OLD_REPO="${OLD_GITHUB_REPO:-}"

if [ -z "$OLD_REPO" ]; then
  echo "Set OLD_GITHUB_REPO to the old repository name before running this script."
  exit 2
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "GitHub CLI is not logged in. Run: gh auth login -h github.com"
  exit 2
fi

OWNER="$(gh api user --jq .login)"

if ! gh repo view "${OWNER}/${OLD_REPO}" >/dev/null 2>&1; then
  echo "Old repo not found: ${OWNER}/${OLD_REPO}"
  exit 0
fi

echo "Deleting old public repo that exposes the real-name URL: ${OWNER}/${OLD_REPO}"
gh repo delete "${OWNER}/${OLD_REPO}" --yes
echo "Deleted: ${OWNER}/${OLD_REPO}"
