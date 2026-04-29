INSERT OR REPLACE INTO cms_brand_settings
(id, tenant_id, brand_name, logo_url, logo_light_url, logo_dark_url, footer_logo_light_url, footer_logo_dark_url,
 site_domain, primary_color, secondary_color, accent_color,
 navigation_json, footer_json, socials_json, organization_json, seo_defaults_json, updated_at)
VALUES
(
 'brand_companionscpas_home_truth',
 'tenant_companionscpas',
 'Companions of CPAS',
 '/logo.png',
 '/logo.png',
 '/logo.png',
 '/logo.png',
 '/logo.png',
 'https://companionscpas-platform.samprimeauxwork.workers.dev',
 '#ee2336',
 '#7c3aed',
 '#f59e0b',
 '[{"label":"Home","href":"/","sort_order":10},{"label":"About","href":"/about","sort_order":20},{"label":"Adopt","href":"/adopt","sort_order":30},{"label":"Services","href":"/services","sort_order":40},{"label":"Donate","href":"/donate","sort_order":50}]',
 '{"tagline":"Companions of CPAS is a volunteer-run nonprofit helping dogs at Caddo Parish Animal Services receive medical care, transport support, and second chances.","developer":"InnerAnimalMedia","admin_href":"/admin/login"}',
 '{"facebook":"https://www.facebook.com/people/Companions-of-CPAS/100069291576354/?mibextid=hu50Ix","instagram":"https://www.instagram.com/companionscpas"}',
 '{"name":"Companions of CPAS","tax_status":"501(c)(3) Tax-Exempt","ein":"88-4156327","location":"Shreveport, LA 71106","email":"companionsCPAS@gmail.com","parish_served":"Caddo","sector":"Animals","operating_budget":"Under $100,000"}',
 '{"title":"Companions of CPAS","description":"Volunteer-powered support for dogs at Caddo Parish Animal Services."}',
 datetime('now')
);

DELETE FROM cms_navigation_items WHERE tenant_id = 'tenant_companionscpas';

INSERT INTO cms_navigation_items
(id, tenant_id, label, href, sort_order, is_visible)
VALUES
('nav_home','tenant_companionscpas','Home','/',10,1),
('nav_about','tenant_companionscpas','About','/about',20,1),
('nav_adopt','tenant_companionscpas','Adopt','/adopt',30,1),
('nav_services','tenant_companionscpas','Services','/services',40,1),
('nav_donate','tenant_companionscpas','Donate','/donate',50,1);
