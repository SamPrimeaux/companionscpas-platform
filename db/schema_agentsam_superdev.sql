CREATE TABLE IF NOT EXISTS agentsam_superdev_grants (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  user_id TEXT NOT NULL,
  grant_key TEXT NOT NULL,
  allowed INTEGER DEFAULT 1,
  expires_at TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  UNIQUE(tenant_id, user_id, grant_key)
);

CREATE TABLE IF NOT EXISTS agentsam_bridge_connections (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  bridge_key TEXT NOT NULL UNIQUE,
  bridge_name TEXT NOT NULL,
  bridge_type TEXT NOT NULL DEFAULT 'local_pty',
  base_url TEXT,
  auth_secret_name TEXT DEFAULT 'AGENTSAM_BRIDGE_TOKEN',
  status TEXT DEFAULT 'inactive',
  capabilities_json TEXT DEFAULT '[]',
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS agentsam_dev_runs (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  user_id TEXT,
  bridge_key TEXT,
  command_key TEXT,
  requested_command TEXT,
  cwd TEXT,
  status TEXT DEFAULT 'queued',
  stdout TEXT,
  stderr TEXT,
  exit_code INTEGER,
  started_at TEXT DEFAULT (datetime('now')),
  completed_at TEXT
);
