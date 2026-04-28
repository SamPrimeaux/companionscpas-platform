INSERT OR REPLACE INTO cms_assets
(id, asset_key, label, url, alt_text, source_provider, source_id, usage_context, metadata_json)
VALUES
('asset_logo_companions', 'brand.logo', 'Companions of CPAS Logo',
 'https://companionscpas-platform.samprimeauxwork.workers.dev/logo.png',
 'Companions of CPAS logo', 'static', '/logo.png', 'brand',
 '{"canonical":true}'),

('asset_signature_iam', 'signature.inneranimalmedia', 'InnerAnimalMedia Signature Logo',
 'https://imagedelivery.net/g7wf09fCONpnidkRnR_5vw/87aac7e9-d6c7-4a53-df89-605e8020e000/avatar',
 'InnerAnimalMedia logo', 'cloudflare_images', '87aac7e9-d6c7-4a53-df89-605e8020e000', 'site_footer',
 '{"keep":true,"note":"developer signature"}'),

('asset_home_hero_current', 'home.hero.current', 'Current Hero Image',
 'https://imagedelivery.net/g7wf09fCONpnidkRnR_5vw/6031db3a-f82a-4334-ac87-12de5640cb00/public',
 'Rescue dog walking outside', 'cloudflare_images', '6031db3a-f82a-4334-ac87-12de5640cb00', 'home.hero',
 '{"replace_later":true,"variants":{"small":"https://imagedelivery.net/g7wf09fCONpnidkRnR_5vw/6031db3a-f82a-4334-ac87-12de5640cb00/small","medium":"https://imagedelivery.net/g7wf09fCONpnidkRnR_5vw/6031db3a-f82a-4334-ac87-12de5640cb00/medium","public":"https://imagedelivery.net/g7wf09fCONpnidkRnR_5vw/6031db3a-f82a-4334-ac87-12de5640cb00/public"}}'),

('asset_home_gallery_1', 'home.gallery.1', 'Gallery Image 1',
 'https://imagedelivery.net/g7wf09fCONpnidkRnR_5vw/887a9870-e801-4758-2dc9-665639246500/public',
 'Animal rescue gallery image', 'cloudflare_images', '887a9870-e801-4758-2dc9-665639246500', 'home.gallery',
 '{"replace_later":true}'),

('asset_home_gallery_2', 'home.gallery.2', 'Gallery Image 2',
 'https://imagedelivery.net/g7wf09fCONpnidkRnR_5vw/293577cc-2219-497a-ad86-709552f27100/public',
 'Animal rescue gallery image', 'cloudflare_images', '293577cc-2219-497a-ad86-709552f27100', 'home.gallery',
 '{"replace_later":true}'),

('asset_home_gallery_3', 'home.gallery.3', 'Gallery Image 3',
 'https://imagedelivery.net/g7wf09fCONpnidkRnR_5vw/02930113-3440-49e9-7d32-21faf5497600/public',
 'Animal rescue gallery image', 'cloudflare_images', '02930113-3440-49e9-7d32-21faf5497600', 'home.gallery',
 '{"replace_later":true}'),

('asset_about_feature', 'about.feature', 'About Feature Image',
 'https://imagedelivery.net/g7wf09fCONpnidkRnR_5vw/7290332f-2348-4ce3-a5c4-b8fceb2d6100/medium',
 'Rescue animal support feature image', 'cloudflare_images', '7290332f-2348-4ce3-a5c4-b8fceb2d6100', 'about.feature',
 '{"replace_later":true}'),

('asset_adopt_feature', 'adopt.feature', 'Adoption Feature Image',
 'https://imagedelivery.net/g7wf09fCONpnidkRnR_5vw/8b18c136-c1d8-43cf-08a1-e2ab9ddb4100/public',
 'Available animal adoption feature image', 'cloudflare_images', '8b18c136-c1d8-43cf-08a1-e2ab9ddb4100', 'adopt.feature',
 '{"replace_later":true}');
