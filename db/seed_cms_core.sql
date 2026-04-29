INSERT OR IGNORE INTO cms_brand_settings
(id, brand_name, logo_url)
VALUES
('brand_companionscpas', 'Companions of CPAS', '/logo.png');

INSERT OR IGNORE INTO cms_pages
(id, route_path, slug, title, status, seo_title, meta_description)
VALUES
('page_home', '/', 'home', 'Home', 'published', 'Companions of CPAS', 'Community animal rescue support, adoption, fostering, donations, and volunteer programs.'),
('page_about', '/about', 'about', 'About', 'published', 'About Companions of CPAS', 'Learn about the mission behind Companions of CPAS.'),
('page_adopt', '/adopt', 'adopt', 'Adopt', 'published', 'Adoptable Animals', 'Meet animals available for adoption.'),
('page_services', '/services', 'services', 'Services', 'published', 'Services', 'Pet support services and community resources.'),
('page_donate', '/donate', 'donate', 'Donate', 'published', 'Donate', 'Support Companions of CPAS.');

INSERT OR IGNORE INTO cms_sections
(id, page_id, section_key, section_type, eyebrow, title, body, image_url, cta_label, cta_href, sort_order)
VALUES
('section_home_hero', 'page_home', 'hero', 'hero', 'Community Animal Support', 'Striving to keep family and pets together', 'Companions of CPAS walks alongside local families with practical help and deep compassion — so pets can stay healthy, safe, and at home where they belong.', '/logo.png', 'Support Our Mission', '/donate', 10),
('section_home_story', 'page_home', 'story', 'content', 'Our Story', 'A small rescue with big-heart impact in your community.', 'Compassion first. Prevention over crisis. Local support for animals and families who need it most.', '/logo.png', 'Learn More', '/about', 20);

INSERT OR IGNORE INTO cms_navigation_items
(id, label, href, sort_order)
VALUES
('nav_home', 'Home', '/', 10),
('nav_about', 'About', '/about', 20),
('nav_adopt', 'Adopt', '/adopt', 30),
('nav_services', 'Services', '/services', 40),
('nav_donate', 'Donate', '/donate', 50);
