#!/usr/bin/env bash
# Assembles the PUBLIC demo site for Vercel.
# Deliberately excludes internal files: HR JOBS.docx, the Requirements
# Specification .docx, the Security Plan and the Backup & Recovery Runbook.
set -euo pipefail

OUT=public_site
rm -rf "$OUT"
mkdir -p "$OUT"

cp index.html "$OUT/"
cp hr-portal-blueprint.html \
   hr-portal-architecture.html \
   hr-portal-prototype.html \
   hr-portal-gap-analysis.html \
   hr-portal-roadmap.html \
   hr-portal-brief.html \
   "$OUT/"
cp test-cv.docx "$OUT/" 2>/dev/null || true

# Banner on the hub explaining why some links are absent on the public site
sed -i 's|<div class="wrap">|<div class="wrap"><div style="background:#fbf0d8;border:1px solid #eed9ab;border-radius:9px;padding:12px 16px;margin-top:18px;font-size:14px"><b>Public demo site:</b> internal documents (source job scopes, requirements specification, security plan, backup runbook) are intentionally not published here — those links will not work. Prototype data is synthetic.</div>|' "$OUT/index.html"

echo "Public site assembled ($(ls "$OUT" | wc -l) files):"
ls "$OUT"
