INSERT OR REPLACE INTO cms_page_content_blocks
(id, page_route, section_key, block_key, block_type, title, body, asset_id, sort_order, config_json)
VALUES
('block_home_value_1', '/', 'story', 'compassion_first', 'value_card',
 'Compassion first', 'No judgment, just real support when things get hard.', NULL, 10, '{}'),

('block_home_value_2', '/', 'story', 'prevention_over_crisis', 'value_card',
 'Prevention over crisis', 'Spay/neuter, vaccines, food support, and practical help before emergencies grow.', NULL, 20, '{}'),

('block_home_gallery_1', '/', 'gallery', 'gallery_1', 'image',
 'Rescue support', NULL, 'asset_home_gallery_1', 10, '{}'),

('block_home_gallery_2', '/', 'gallery', 'gallery_2', 'image',
 'Foster care', NULL, 'asset_home_gallery_2', 20, '{}'),

('block_home_gallery_3', '/', 'gallery', 'gallery_3', 'image',
 'Community help', NULL, 'asset_home_gallery_3', 30, '{}');
