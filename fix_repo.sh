#!/usr/bin/env bash
set -euo pipefail

# Fixes the first-run mess:
#  - the inline "# comments" in the pasted commands became arguments to
#    `flutter create` under interactive zsh, so platforms (web/…) were never
#    generated. Running this as a bash script makes comments real comments.
#  - platforms get generated, build junk stops being tracked, git identity is
#    set to Ahmed ElFirgany, the branch is normalised to main, and the stray
#    source branches (master, the source-only gh-pages) are removed.

cd "$HOME/Desktop/work_space/Personal Branding/games/topple"

# proper commit identity (portfolio piece)
git config user.name  "Ahmed ElFirgany"
git config user.email "saqrelfirgany@gmail.com"

# normalise the local branch name to main (it got renamed to gh-pages earlier)
git branch -M main

# THE actual fix: generate web/android/ios/macos shells + a real .gitignore
flutter create .
flutter pub get

# stop tracking build junk that slipped into the first commit
git rm -r --cached .dart_tool >/dev/null 2>&1 || true

# fold everything into one clean, correctly-authored commit
git add -A
git commit --amend --reset-author -m "Day 1: Forge2D world + tower + drag-to-fling"

# publish a clean main and make it the default; drop the stray source branches
git push -f origin main
gh repo edit saqrelfirgany/topple --default-branch main || true
git push origin --delete master   2>/dev/null || true
git push origin --delete gh-pages 2>/dev/null || true

echo ""
echo "=================================================================="
echo " Repo cleaned. Now run it locally and send me a screenshot/errors:"
echo "     flutter run -d chrome"
echo " (deploy to saqrelfirgany.github.io/topple/ comes AFTER we confirm"
echo "  it looks/plays right — that step is in SETUP.md, section 3.)"
echo "=================================================================="
