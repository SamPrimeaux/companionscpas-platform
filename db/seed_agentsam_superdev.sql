INSERT OR IGNORE INTO agentsam_superdev_grants
(id, user_id, grant_key, allowed)
VALUES
('grant_sam_superdev_all', 'usr_sam_primeaux', 'superdev.*', 1),
('grant_sam_shell_exec', 'usr_sam_primeaux', 'shell.exec', 1),
('grant_sam_wrangler', 'usr_sam_primeaux', 'wrangler.*', 1),
('grant_sam_git', 'usr_sam_primeaux', 'git.*', 1),
('grant_sam_mcp', 'usr_sam_primeaux', 'mcp.*', 1),
('grant_sam_pty', 'usr_sam_primeaux', 'pty.*', 1);

INSERT OR IGNORE INTO agentsam_bridge_connections
(id, bridge_key, bridge_name, bridge_type, base_url, status, capabilities_json)
VALUES
('bridge_local_pty_001', 'local.pty', 'Sam Local PTY Bridge', 'local_pty', 'http://127.0.0.1:8789', 'inactive',
 '["shell.exec","git.status","git.commit","wrangler.deploy","wrangler.d1","npm.run","mcp.call"]');
