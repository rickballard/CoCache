# Supplemental Advisory for InSeed Site Integration

1. **Hero Banner Integration**
   - The ZIP assumes you already have the hero graphic asset in-repo.  
   - Update the `hero_image` field in the page frontmatter if your path differs.  
   - Do not re-insert the old hero tagline text — it’s baked into the graphic now.  

2. **Custom CSS**
   - All styles are scoped under IDs/classes (`#dictionary`, `.matrix`, `.quote`, etc.) to reduce risk of collisions with the site’s theme.  
   - If anything renders oddly (especially on dark mode), adjust in `assets/css/inseed-dropin.css` instead of hacking global styles.  

3. **Navigation**
   - Add the new page(s) to your site’s navigation (`mkdocs.yml`, Docusaurus sidebar, or Jekyll nav include).  
   - Suggest placing **Living Policy Framework** under a “Solutions” or “Why InSeed” menu.  
   - Competitor matrix page can be linked inline only (optional in nav).  

4. **Preview First**
   - Open `preview/preview.html` locally before pushing — ensures CSS and layout are correct.  
   - Then cross-check staging (GitHub Pages, Netlify, Vercel) in both mobile + desktop views.  

5. **Content Editing**
   - Testimonials are anonymized, but descriptors are already swapped to accurate roles (President & Board Chair, President, CEO).  
   - These can be re-labeled later in-repo without touching structure.  

6. **Competitor Matrix**
   - Currently uses **archetypes** (e.g., “Global strategy major”) to avoid calling out named firms.  
   - Replace with real firm names only if you’re prepared for competitive sensitivity.  

7. **Resources Section**
   - Bio, map, and contact placeholders are in place. Wire them to existing assets in the repo.  
   - If your site auto-pulls footer info, you may hide/merge this section.  

8. **Tone / Trust**
   - The page is designed to feel transparent and “service-first,” not like a hard sell.  
   - Keep competitor comparisons neutral. Don’t add red Xs — only ticks or dashes.  

---

⚡ **Recommendation:** integrate the page “as is,” then only adjust text tone once you’ve seen it live with your theme. Don’t over-edit in staging; test first.
