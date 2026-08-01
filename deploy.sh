#!/usr/bin/env bash
set -euo pipefail

# Ship Topple: commit the source, then refresh the live build.
#   bash "$HOME/Desktop/work_space/Personal Branding/games/topple/deploy.sh"
#
# Needs Flutter + your GitHub auth. Takes about a minute.
# Live at https://saqrelfirgany.github.io/topple/

cd "$(dirname "$0")"

MSG="${1:-polish: fix web glyphs, arrow wording, bow title screen}"

echo "==> analyze (errors only)"
flutter analyze --no-fatal-infos --no-fatal-warnings

# a crashed or sandboxed git can leave this behind and block every later run
rm -f .git/index.lock

if [[ -n "$(git status --porcelain)" ]]; then
  echo "==> commit + push source"
  git add -A
  git -c user.name="Ahmed ElFirgany" -c user.email="saqrelfirgany@gmail.com" \
      commit -qm "$MSG"
  git push -q origin main
else
  echo "==> source already clean, nothing to commit"
fi

echo "==> build web"
flutter build web --release --base-href /topple/

echo "==> push gh-pages"
cd build/web
rm -rf .git
git init -q
git checkout -qb gh-pages
git add -A
git -c user.name="Ahmed ElFirgany" -c user.email="saqrelfirgany@gmail.com" \
    commit -qm "Deploy Topple web ($(date +%Y-%m-%d))"
git remote add origin https://github.com/saqrelfirgany/topple.git
git push -f -q origin gh-pages

echo ""
echo "Done. Live in about a minute:"
echo "  https://saqrelfirgany.github.io/topple/"
echo "(hard-refresh once with Cmd+Shift+R — the old service worker caches the build)"
