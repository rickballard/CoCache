# Move into your repo root
cd "C:/Users/Chris/Documents/GitHub/Civium-Constitution"

# Move deprecated or to-be-orphaned files to backups (edit this list if needed)
mkdir -p backups/deprecated
git mv old_intro.md backups/deprecated/ 2>/dev/null || echo "old_intro.md not found"
git mv ancient_scroll_draft.md backups/deprecated/ 2>/dev/null || echo "ancient_scroll_draft.md not found"

# Add the new files
git add README_FOR_HUMANS.md README_HARMONICS.md

# Commit and push
git commit -m "Split README into practical and harmonics: human onboarding and metaphysical resonance"
git push origin main
