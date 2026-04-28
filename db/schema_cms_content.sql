CREATE TABLE IF NOT EXISTS cms_assets (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  asset_key TEXT NOT NULL UNIQUE,
  asset_type TEXT NOT NULL DEFAULT 'image',
  label TEXT,
  url TEXT NOT NULL,
  alt_text TEXT,
  source_provider TEXT DEFAULT 'static',
  source_id TEXT,
  usage_context TEXT,
  status TEXT DEFAULT 'active',
  metadata_json TEXT DEFAULT '{}',
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS cms_page_sections (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  page_route TEXT NOT NULL,
  section_key TEXT NOT NULL,
  section_type TEXT DEFAULT 'content',
  eyebrow TEXT,
  heading TEXT,
  subheading TEXT,
  body TEXT,
  primary_asset_id TEXT,
  secondary_asset_id TEXT,
  cta_label TEXT,
  cta_href TEXT,
  sort_order INTEGER DEFAULT 50,
  is_visible INTEGER DEFAULT 1,
  config_json TEXT DEFAULT '{}',
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  UNIQUE(tenant_id, page_route, section_key)
);

CREATE TABLE IF NOT EXISTS cms_page_content_blocks (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  page_route TEXT NOT NULL,
  section_key TEXT NOT NULL,
  block_key TEXT NOT NULL,
  block_type TEXT DEFAULT 'text',
  title TEXT,
  body TEXT,
  asset_id TEXT,
  href TEXT,
  sort_order INTEGER DEFAULT 50,
  config_json TEXT DEFAULT '{}',
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  UNIQUE(tenant_id, page_route, section_key, block_key)
);

CREATE INDEX IF NOT EXISTS idx_cms_assets_tenant ON cms_assets(tenant_id);
CREATE INDEX IF NOT EXISTS idx_cms_sections_route ON cms_page_sections(tenant_id, page_route);
CREATE INDEX IF NOT EXISTS idx_cms_blocks_section ON cms_page_content_blocks(tenant_id, page_route, section_key);
