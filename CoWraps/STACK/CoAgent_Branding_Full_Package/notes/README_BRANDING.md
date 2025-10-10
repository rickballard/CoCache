# CoAgent Branding Package

This package contains branding assets for **CoAgent** (a CoCivium module).

## Structure
- `light/` — assets for **light backgrounds** (white/off-white docs, websites).
- `dark/` — assets for **dark backgrounds** (dark mode UIs, tray icons, GitHub dark theme).

## Files
- **logo-square** — main CoAgent identity (head + torso + 3 halos).
- **logo-wide** — paired icons facing each other. Two variants:
  - with bolt (active transmission)
  - without bolt (static brand identity)
- **splash** — full-size splash screen with title/subline.
- **favicons** — 16, 32, 64 px versions (minimal mode, head + arcs only).
- **palette.json** — color palette.

## Usage Guidance
- **Default identity:** monochrome arcs, transparent background.
- **Rainbow arcs:** reserved for docs, splash, marketing.
- **Bolt:**  
  - Static bolt for splash/marketing.  
  - Animated bolt only for dynamic states (active sync, handshake).  
  - Omit bolt for favicons and static branding.

## Brand Relationship
- **CoCivium (grayscale master brand):** anchor of credibility.  
- **CoAgent:** rainbow-accented variant of the same geometry.  
- **Other CoModules:** reuse geometry, add distinct accent glyphs/colors.  
