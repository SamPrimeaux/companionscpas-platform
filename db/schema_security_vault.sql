CREATE TABLE IF NOT EXISTS secret_vault_items (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  owner_user_id TEXT,
  secret_key TEXT NOT NULL,
  display_name TEXT NOT NULL,
  secret_type TEXT NOT NULL DEFAULT 'api_key',
  provider TEXT,
  encrypted_value TEXT NOT NULL,
  encryption_key_version TEXT DEFAULT 'v1',
  masked_preview TEXT,
  status TEXT DEFAULT 'active',
  last_used_at TEXT,
  rotated_at TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  UNIQUE(tenant_id, secret_key)
);

CREATE TABLE IF NOT EXISTS secret_vault_access_log (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  secret_item_id TEXT,
  actor_user_id TEXT,
  action TEXT NOT NULL,
  allowed INTEGER DEFAULT 0,
  ip_address TEXT,
  user_agent TEXT,
  metadata_json TEXT DEFAULT '{}',
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS password_reset_tokens (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  user_id TEXT NOT NULL,
  token_hash TEXT NOT NULL UNIQUE,
  requested_by_ip TEXT,
  user_agent TEXT,
  expires_at TEXT NOT NULL,
  used_at TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS user_security_events (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  user_id TEXT,
  event_type TEXT NOT NULL,
  severity TEXT DEFAULT 'info',
  ip_address TEXT,
  user_agent TEXT,
  metadata_json TEXT DEFAULT '{}',
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS agentsam_secret_bindings (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  binding_key TEXT NOT NULL UNIQUE,
  secret_item_id TEXT,
  purpose TEXT,
  allowed_tools_json TEXT DEFAULT '[]',
  allowed_workflows_json TEXT DEFAULT '[]',
  status TEXT DEFAULT 'active',
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_vault_tenant ON secret_vault_items(tenant_id);
CREATE INDEX IF NOT EXISTS idx_vault_access_tenant ON secret_vault_access_log(tenant_id);
CREATE INDEX IF NOT EXISTS idx_reset_user ON password_reset_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_security_events_user ON user_security_events(user_id);
