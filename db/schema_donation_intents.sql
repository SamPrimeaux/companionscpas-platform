CREATE TABLE IF NOT EXISTS donation_intents (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  donor_name TEXT NOT NULL,
  donor_email TEXT NOT NULL,
  amount_cents INTEGER NOT NULL,
  frequency TEXT NOT NULL DEFAULT 'one_time',
  campaign_id TEXT DEFAULT 'general',
  note TEXT,
  provider TEXT DEFAULT 'stripe',
  provider_checkout_id TEXT,
  provider_checkout_url TEXT,
  status TEXT DEFAULT 'demo_created',
  resend_receipt_status TEXT DEFAULT 'pending_after_payment',
  metadata_json TEXT DEFAULT '{}',
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_donation_intents_email ON donation_intents(donor_email);
CREATE INDEX IF NOT EXISTS idx_donation_intents_status ON donation_intents(status);
CREATE INDEX IF NOT EXISTS idx_donation_intents_campaign ON donation_intents(campaign_id);
