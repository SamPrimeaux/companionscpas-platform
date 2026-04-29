CREATE TABLE IF NOT EXISTS contact_requests_v2 (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  request_type TEXT DEFAULT 'general',
  message TEXT NOT NULL,
  status TEXT DEFAULT 'new',
  source_path TEXT,
  user_agent TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_contact_requests_v2_status ON contact_requests_v2(status);
CREATE INDEX IF NOT EXISTS idx_contact_requests_v2_created ON contact_requests_v2(created_at);
