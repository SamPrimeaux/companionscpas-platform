CREATE TABLE IF NOT EXISTS cms_pages (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  route_path TEXT NOT NULL,
  slug TEXT NOT NULL,
  title TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'draft',
  seo_title TEXT,
  meta_description TEXT,
  og_image_url TEXT,
  published_at TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  UNIQUE(tenant_id, route_path)
);

CREATE TABLE IF NOT EXISTS cms_sections (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  page_id TEXT NOT NULL,
  section_key TEXT NOT NULL,
  section_type TEXT NOT NULL DEFAULT 'content',
  title TEXT,
  eyebrow TEXT,
  body TEXT,
  image_url TEXT,
  cta_label TEXT,
  cta_href TEXT,
  sort_order INTEGER DEFAULT 50,
  is_visible INTEGER DEFAULT 1,
  config_json TEXT DEFAULT '{}',
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  UNIQUE(page_id, section_key)
);

CREATE TABLE IF NOT EXISTS cms_navigation_items (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  label TEXT NOT NULL,
  href TEXT NOT NULL,
  sort_order INTEGER DEFAULT 50,
  is_visible INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS cms_brand_settings (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  brand_name TEXT NOT NULL DEFAULT 'Companions of CPAS',
  logo_url TEXT DEFAULT '/logo.png',
  primary_color TEXT DEFAULT '#ee2336',
  secondary_color TEXT DEFAULT '#7c3aed',
  accent_color TEXT DEFAULT '#f59e0b',
  config_json TEXT DEFAULT '{}',
  updated_at TEXT DEFAULT (datetime('now'))
);
