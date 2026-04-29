PRAGMA foreign_keys = OFF;

INSERT OR REPLACE INTO cpas_application_forms
(id, tenant_id, form_key, title, description, status, intro_json, settings_json)
VALUES
('form_foster_application','companions_cpas','foster_application','Foster Application','Board demo foster application workflow.','active','{}','{}');

DELETE FROM animal_profiles
WHERE id IN ('animal_rocky','animal_luna','animal_bella')
   OR lower(name) IN ('rocky','luna','bella');

INSERT OR REPLACE INTO cpas_foster_applications
(id, form_id, tenant_id, status, review_status, source, first_name, last_name, email, phone, city, state_province, postal_code, answers_json, submitted_at, assigned_to, internal_notes)
VALUES
('cpas_app_001','form_foster_application','companions_cpas','submitted','approved','popup_application','Megan','Carter','megan@example.com','318-555-0144','Shreveport','LA','71106','{"interested_animal":"Blue","home_type":"Own Home","experience":"Experienced foster"}',datetime('now','-2 days'),'sam','Approved foster placement.'),
('cpas_app_002','form_foster_application','companions_cpas','submitted','under_review','popup_application','Jordan','Lee','jordan@example.com','318-555-0199','Shreveport','LA','71106','{"interested_animal":"Joy","home_type":"Rent Home/Apt/Condo","experience":"Some experience"}',datetime('now','-1 day'),'sam','Needs home visit follow-up.'),
('cpas_app_003','form_foster_application','companions_cpas','submitted','new','popup_application','Alyssa','Green','alyssa@example.com','318-555-0177','Bossier City','LA','71111','{"interested_animal":"Patches","home_type":"Own Home","experience":"First-time foster"}',datetime('now','-5 hours'),'sam','Good puppy foster candidate.'),
('cpas_app_004','form_foster_application','companions_cpas','submitted','under_review','popup_application','Chris','Morgan','chris@example.com','318-555-0130','Shreveport','LA','71106','{"interested_animal":"Chance","home_type":"Own Home","experience":"Medical foster"}',datetime('now','-3 hours'),'sam','Potential medical foster.');

INSERT OR REPLACE INTO cpas_application_events
(id, application_id, event_type, event_title, event_json, created_by, created_at)
VALUES
('evt_cpas_001','cpas_app_001','status_change','Application approved','{"from":"under_review","to":"approved"}','agentsam',datetime('now','-1 day')),
('evt_cpas_002','cpas_app_002','review_needed','Home visit needed','{"priority":"high"}','agentsam',datetime('now','-6 hours')),
('evt_cpas_003','cpas_app_004','medical_foster_candidate','Medical foster candidate flagged','{"animal":"Chance"}','agentsam',datetime('now','-2 hours'));

INSERT OR REPLACE INTO cpas_application_email_logs
(id, application_id, email_type, provider, from_email, to_email, subject, status, payload_json, created_at)
VALUES
('email_cpas_001','cpas_app_001','application_received','resend','applications@companionscpas.org','megan@example.com','We received your foster application','queued','{"template":"foster_application_received"}',datetime('now','-2 days')),
('email_cpas_002','cpas_app_002','review_followup','resend','applications@companionscpas.org','jordan@example.com','Next step for your foster application','queued','{"template":"home_visit_followup"}',datetime('now','-6 hours'));

DELETE FROM adoption_applications_demo
WHERE animal_id IN ('animal_rocky','animal_luna','animal_bella')
   OR lower(animal_name) IN ('rocky','luna','bella');

INSERT OR REPLACE INTO applications
(id, applicant_name, applicant_email, animal_name, status, created_at)
VALUES
('app_compat_001','Megan Carter','megan@example.com','Blue','approved',datetime('now','-2 days')),
('app_compat_002','Jordan Lee','jordan@example.com','Joy','under_review',datetime('now','-1 day')),
('app_compat_003','Alyssa Green','alyssa@example.com','Patches','submitted',datetime('now','-5 hours')),
('app_compat_004','Chris Morgan','chris@example.com','Chance','under_review',datetime('now','-3 hours'));

INSERT OR REPLACE INTO foster_records
(id, tenant_id, animal_id, foster_name, foster_email, status, start_date, notes)
VALUES
('foster_blue_001','tenant_companionscpas','animal_bluepit','Megan Carter','megan@example.com','active',date('now','-2 days'),'Blue is settling into foster care.'),
('foster_joy_002','tenant_companionscpas','animal_upclose','Jordan Lee','jordan@example.com','pending',date('now','+2 days'),'Pending home visit.'),
('foster_patches_003','tenant_companionscpas','animal_pup','Alyssa Green','alyssa@example.com','pending',date('now','+1 day'),'Puppy foster candidate.'),
('foster_mischief_004','tenant_companionscpas','animal_sus','Rachel Nguyen','rachel@example.com','active',date('now','-3 days'),'Mischief is playful and doing well.');

INSERT OR REPLACE INTO dashboard_calendar_events
(id, tenant_id, title, event_type, starts_at, platform, content, status)
VALUES
('cal_homevisit_001','tenant_companionscpas','Home visit with Jordan Lee','foster_review',datetime('now','+1 day'),'dashboard','Review foster application for Joy.','scheduled'),
('cal_vet_001','tenant_companionscpas','Medical check for Chance','medical',datetime('now','+2 days'),'dashboard','Nutrition and veterinary follow-up.','scheduled'),
('cal_transport_001','tenant_companionscpas','Transport partner follow-up','transport',datetime('now','+3 days'),'dashboard','Confirm rescue partner availability.','scheduled');

INSERT OR REPLACE INTO email_templates
(id, tenant_id, provider, template_key, subject, body_text, body_html, status)
VALUES
('tpl_foster_received','tenant_companionscpas','resend','foster_application_received','We received your foster application','Thank you for applying to foster with Companions of CPAS. Our team will review your application and follow up soon.','<p>Thank you for applying to foster with <strong>Companions of CPAS</strong>. Our team will review your application and follow up soon.</p>','active'),
('tpl_home_visit','tenant_companionscpas','resend','home_visit_followup','Next step for your foster application','Your foster application is moving forward. Our team would like to schedule a home visit or virtual visit.','<p>Your foster application is moving forward. Our team would like to schedule a home visit or virtual visit.</p>','active');

PRAGMA foreign_keys = ON;
