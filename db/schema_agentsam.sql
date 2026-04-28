-- Agent Sam foundation tables for Companions CPAS
-- Tracks commands, tools, providers, local llama / Workers AI usage, and execution analytics.

CREATE TABLE IF NOT EXISTS agentsam_commands (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  command_key TEXT NOT NULL UNIQUE,
  command_name TEXT NOT NULL,
  command_category TEXT NOT NULL DEFAULT 'general',
  description TEXT,
  prompt_template TEXT,
  input_schema TEXT DEFAULT '{}',
  output_schema TEXT DEFAULT '{}',
  allowed_roles TEXT DEFAULT '["owner","developer","admin"]',
  allowed_modes TEXT DEFAULT '["ask","plan","agent","debug"]',
  provider_strategy TEXT DEFAULT 'auto',
  default_model TEXT,
  is_enabled INTEGER NOT NULL DEFAULT 1,
  safety_level TEXT NOT NULL DEFAULT 'standard',
  sort_order INTEGER DEFAULT 50,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS agentsam_mcp_tools (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  tool_key TEXT NOT NULL UNIQUE,
  tool_name TEXT NOT NULL,
  display_name TEXT NOT NULL,
  tool_category TEXT NOT NULL DEFAULT 'mcp',
  description TEXT,
  input_schema TEXT DEFAULT '{}',
  output_schema TEXT DEFAULT '{}',
  intent_tags TEXT DEFAULT '[]',
  modes_json TEXT DEFAULT '["auto","agent","debug"]',
  handler_type TEXT NOT NULL DEFAULT 'http',
  handler_config TEXT DEFAULT '{}',
  provider TEXT,
  requires_auth INTEGER DEFAULT 0,
  requires_secret_keys TEXT DEFAULT '[]',
  safety_level TEXT DEFAULT 'standard',
  is_enabled INTEGER DEFAULT 1,
  sort_order INTEGER DEFAULT 50,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS agentsam_analytics (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  user_id TEXT,
  session_id TEXT,
  run_group_id TEXT,
  command_key TEXT,
  tool_key TEXT,
  provider TEXT NOT NULL,
  model_key TEXT,
  runtime_location TEXT DEFAULT 'cloudflare',
  mode TEXT DEFAULT 'ask',
  status TEXT NOT NULL DEFAULT 'started',
  prompt_tokens INTEGER DEFAULT 0,
  completion_tokens INTEGER DEFAULT 0,
  total_tokens INTEGER DEFAULT 0,
  estimated_cost_usd REAL DEFAULT 0,
  latency_ms INTEGER DEFAULT 0,
  input_chars INTEGER DEFAULT 0,
  output_chars INTEGER DEFAULT 0,
  safety_flags TEXT DEFAULT '[]',
  metadata_json TEXT DEFAULT '{}',
  error_message TEXT,
  started_at TEXT DEFAULT (datetime('now')),
  completed_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_agentsam_commands_tenant ON agentsam_commands(tenant_id);
CREATE INDEX IF NOT EXISTS idx_agentsam_tools_tenant ON agentsam_mcp_tools(tenant_id);
CREATE INDEX IF NOT EXISTS idx_agentsam_analytics_tenant ON agentsam_analytics(tenant_id);
CREATE INDEX IF NOT EXISTS idx_agentsam_analytics_provider ON agentsam_analytics(provider, model_key);
CREATE INDEX IF NOT EXISTS idx_agentsam_analytics_run_group ON agentsam_analytics(run_group_id);
