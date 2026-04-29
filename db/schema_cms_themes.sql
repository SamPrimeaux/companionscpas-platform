CREATE TABLE IF NOT EXISTS cms_themes (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  theme_key TEXT NOT NULL UNIQUE,
  theme_name TEXT NOT NULL,
  description TEXT,
  mode TEXT DEFAULT 'dark',
  is_active INTEGER DEFAULT 0,
  tokens_json TEXT NOT NULL DEFAULT '{}',
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);
