INSERT OR REPLACE INTO cms_page_sections
(id, page_route, section_key, section_type, eyebrow, heading, subheading, body, primary_asset_id, cta_label, cta_href, sort_order, config_json)
VALUES
('sec_home_hero', '/', 'hero', 'hero', 'Community Animal Support',
 'Striving to keep family and pets together',
 'Your community trusted resource for pet support services.',
 'Companions of CPAS walks alongside local families with practical help and deep compassion — so pets can stay healthy, safe, and at home where they belong.',
 'asset_home_hero_current', 'Support Our Mission', '/donate', 10,
 '{"layout":"split","theme":"warm_rescue"}'),

('sec_home_story', '/', 'story', 'content', 'Our Story',
 'A small rescue with big-heart impact in your community.',
 NULL,
 'Compassion first. Prevention over crisis. Local support for animals and families who need it most.',
 'asset_logo_companions', 'Learn More', '/about', 20,
 '{"layout":"centered"}'),

('sec_about_mission', '/about', 'mission', 'content', 'Mission',
 'Built around compassion, prevention, and community care.',
 NULL,
 'Companions of CPAS supports animals, families, fosters, volunteers, and rescue partners through practical services and clear communication.',
 'asset_about_feature', NULL, NULL, 10,
 '{"layout":"feature_grid"}'),

('sec_adopt_intro', '/adopt', 'adopt_intro', 'content', 'Adopt',
 'Find the right companion and support their journey home.',
 NULL,
 'Browse available animals, review adoption requirements, and submit applications directly through the platform.',
 'asset_adopt_feature', 'View Animals', '/adopt', 10,
 '{"layout":"split"}'),

('sec_donate_intro', '/donate', 'donate_intro', 'fundraising', 'Donate',
 'Every gift supports care, food, transport, and second chances.',
 NULL,
 'Donations help Companions of CPAS support animals in need and keep rescue operations moving.',
 'asset_about_feature', 'Donate Now', '/donate', 10,
 '{"layout":"donation"}');
