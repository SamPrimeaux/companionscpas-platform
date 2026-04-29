INSERT OR REPLACE INTO cms_themes
(id, tenant_id, theme_key, theme_name, description, mode, is_active, tokens_json, updated_at)
VALUES
(
  'theme_midnight_companion_glass',
  'tenant_companionscpas',
  'midnight_companion_glass',
  'Midnight Companion Glass',
  'Dark glassmorphic admin/login theme with purple brand glow and blue-cyan wave accents.',
  'dark',
  1,
  '{
    "colors": {
      "bgCanvas": "#05080D",
      "bgCanvasAlt": "#101927",
      "surfaceGlass": "rgba(18,25,36,0.58)",
      "surfaceGlassStrong": "rgba(18,25,36,0.76)",
      "borderGlass": "rgba(255,255,255,0.13)",
      "textPrimary": "#F8F7FF",
      "textMuted": "rgba(255,255,255,0.62)",
      "brandPurple": "#6D5593",
      "brandPurpleSoft": "rgba(109,85,147,0.72)",
      "accentCyan": "#16BFD6",
      "accentBlue": "#2563EB",
      "danger": "#FF6B8A"
    },
    "effects": {
      "blur": "26px",
      "shadow": "0 40px 120px rgba(0,0,0,0.42)",
      "glowPurple": "0 0 80px rgba(109,85,147,0.28)"
    },
    "radius": {
      "card": "20px",
      "input": "14px"
    },
    "logo": {
      "url": "/logo.png",
      "webp": "/logo.webp"
    }
  }',
  datetime('now')
);
