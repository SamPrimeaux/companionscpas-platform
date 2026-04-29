CREATE TABLE IF NOT EXISTS animal_profiles (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  name TEXT NOT NULL,
  species TEXT NOT NULL,
  breed TEXT,
  sex TEXT,
  age_label TEXT,
  status TEXT DEFAULT 'available',
  location TEXT,
  intake_date TEXT,
  photo_url TEXT,
  bio TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS foster_records (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  animal_id TEXT,
  foster_name TEXT,
  foster_email TEXT,
  status TEXT DEFAULT 'active',
  start_date TEXT,
  notes TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS volunteer_records (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  full_name TEXT NOT NULL,
  email TEXT,
  role TEXT DEFAULT 'volunteer',
  status TEXT DEFAULT 'active',
  hours_month INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS adoption_applications_demo (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  applicant_name TEXT NOT NULL,
  applicant_email TEXT,
  animal_id TEXT,
  animal_name TEXT,
  status TEXT DEFAULT 'submitted',
  submitted_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS fundraising_campaigns_demo (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  title TEXT NOT NULL,
  goal_cents INTEGER DEFAULT 0,
  raised_cents INTEGER DEFAULT 0,
  status TEXT DEFAULT 'active',
  starts_at TEXT,
  ends_at TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS dashboard_calendar_events (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  title TEXT NOT NULL,
  event_type TEXT DEFAULT 'general',
  starts_at TEXT,
  platform TEXT,
  content TEXT,
  status TEXT DEFAULT 'scheduled',
  created_at TEXT DEFAULT (datetime('now'))
);
