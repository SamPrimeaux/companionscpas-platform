INSERT OR IGNORE INTO tenants (id, slug, name, domain)
VALUES ('tenant_companionscpas', 'companionscpas', 'Companions of CPAS', 'companionscpas.org');

INSERT OR IGNORE INTO users (id, email, full_name, display_name, status)
VALUES
  ('usr_sam_primeaux', 'meauxbility@gmail.com', 'Sam Primeaux', 'Sam', 'active'),
  ('usr_krystal_lebeouf', 'keleboeuf26@gmail.com', 'Krystal Leboeuf', 'Krystal', 'active'),
  ('usr_lori_s', 'ljmusland@gmail.com', 'Lori S.', 'Lori', 'active');

INSERT OR IGNORE INTO tenant_memberships (id, tenant_id, user_id, role, status, accepted_at)
VALUES
  ('mem_sam_companionscpas', 'tenant_companionscpas', 'usr_sam_primeaux', 'developer', 'active', datetime('now')),
  ('mem_krystal_companionscpas', 'tenant_companionscpas', 'usr_krystal_lebeouf', 'admin', 'active', datetime('now')),
  ('mem_lori_companionscpas', 'tenant_companionscpas', 'usr_lori_s', 'owner', 'active', datetime('now'));

INSERT OR IGNORE INTO role_permissions (id, role, permission)
VALUES
  ('perm_owner_all', 'owner', '*'),
  ('perm_developer_all', 'developer', '*'),

  ('perm_admin_dashboard', 'admin', 'dashboard.read'),
  ('perm_admin_animals', 'admin', 'animals.manage'),
  ('perm_admin_apps', 'admin', 'applications.manage'),
  ('perm_admin_donations', 'admin', 'donations.read'),
  ('perm_admin_events', 'admin', 'events.manage'),
  ('perm_admin_cms', 'admin', 'cms.manage'),
  ('perm_admin_gallery', 'admin', 'gallery.manage'),

  ('perm_vol_dashboard', 'volunteer', 'dashboard.read'),
  ('perm_vol_animals_read', 'volunteer', 'animals.read'),
  ('perm_vol_apps_read', 'volunteer', 'applications.read'),
  ('perm_vol_contact_read', 'volunteer', 'contact_requests.read'),

  ('perm_viewer_dashboard', 'viewer', 'dashboard.read');
