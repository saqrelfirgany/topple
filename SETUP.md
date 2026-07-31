# Topple — repo setup & deploy

One-time steps to put Topple on your GitHub and live under `saqrelfirgany.github.io/topple/`.
Run on your Mac (needs Flutter + your GitHub auth). The path has a space — keep the quotes.

## 1) Complete the project + first commit

```bash
cd "$HOME/Desktop/work_space/Personal Branding/games/topple"
flutter create .           # generates android/ios/web/macos shells around lib/
flutter pub get
git init
git add -A
git commit -m "Day 1: Forge2D world + settling tower + drag-to-fling"
```

## 2) Create the repo on your GitHub + push

With GitHub CLI (simplest — creates it under saqrelfirgany and pushes):

```bash
gh repo create topple --public --source=. --remote=origin --push
```

Without `gh` — create an empty public repo named `topple` at github.com/new, then:

```bash
git remote add origin https://github.com/saqrelfirgany/topple.git
git branch -M main
git push -u origin main
```

## 3) Deploy the web build → saqrelfirgany.github.io/topple/

```bash
flutter build web --release --base-href /topple/
cd build/web
git init && git add -A && git commit -m "Deploy Topple web (Day 1)"
git branch -M gh-pages
git remote add origin https://github.com/saqrelfirgany/topple.git
git push -f origin gh-pages
```

Then on GitHub: repo → **Settings → Pages → Source = `gh-pages` branch, `/ (root)`**.
~1 minute later it's live at **https://saqrelfirgany.github.io/topple/**

## 4) Link it in the hub

The Topple card is already added to `../hub/index.html` (Play → the URL above, Source → the repo).
Once the Play link works, publish the updated hub to your `saqrelfirgany.github.io` repo — or ask me to push it via the browser.

## Notes

- Commit as **you** — no AI co-author trailer (this is a portfolio piece).
- After setup, every change = a normal commit; re-run step 3 to refresh the live build.
- `topple` is the suggested repo name (→ the `/topple/` URL). Tell me if you want a different name and I'll adjust the hub links.
