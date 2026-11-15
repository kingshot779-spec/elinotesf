#!/usr/bin/env bash
# Run inside the empty GitHub repo folder that contains ELIOS_NOTES_v45.zip
set -euo pipefail
ZIP="$(ls ELIOS_NOTES_v45*.zip 2>/dev/null | head -n1 || true)"
[ -n "$ZIP" ] || { echo "ERROR: ELIOS_NOTES_v45.zip not found in $(pwd)"; exit 1; }

rm -rf _elios_tmp && mkdir _elios_tmp
unzip -q "$ZIP" -d _elios_tmp
shopt -s dotglob
mv _elios_tmp/ELIOS_NOTES/* .
rm -rf _elios_tmp "$ZIP"

for f in settings.gradle.kts app/build.gradle.kts .github/workflows/build-apk.yml; do
  [ -f "$f" ] || { echo "ERROR: missing $f"; exit 1; }
done

git add -A
git commit -m "ELIOS NOTES v45: project + CI" || true
git branch -M main
if git remote get-url origin >/dev/null 2>&1; then git push -u origin main; else echo "No remote 'origin' set: run git remote add origin <url> then git push -u origin main"; fi
echo "OK. Open GitHub -> Actions -> Build debug APK -> Artifacts -> ELIOS_NOTES-debug-apk"
