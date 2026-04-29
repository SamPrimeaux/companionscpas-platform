INSERT OR REPLACE INTO animal_profiles
(id,name,species,breed,sex,age_label,status,location,intake_date,photo_url,bio)
VALUES
('animal_rocky','Rocky','Dog','Lab Mix','Male','2 years','available','Kennel A2','2026-04-10','/logo.png','Friendly, energetic, loves walks.'),
('animal_luna','Luna','Cat','Domestic Shorthair','Female','1 year','foster','Foster Home','2026-04-12','/logo.png','Quiet, sweet, great with calm homes.'),
('animal_bella','Bella','Dog','Pit Mix','Female','4 years','medical_watch','Medical Room','2026-04-18','/logo.png','Recovering well and needs follow-up care.');

INSERT OR REPLACE INTO volunteer_records
(id,full_name,email,role,status,hours_month)
VALUES
('vol_lori','Lori S.','ljmusland@gmail.com','owner','active',18),
('vol_krystal','Krystal Leboeuf','keleboeuf26@gmail.com','admin','active',12),
('vol_sam','Sam Primeaux','meauxbility@gmail.com','developer','active',24);

INSERT OR REPLACE INTO adoption_applications_demo
(id,applicant_name,applicant_email,animal_id,animal_name,status)
VALUES
('app_001','David Champagne','david@example.com','animal_rocky','Rocky','submitted'),
('app_002','Sherri Mercier','sherri@example.com','animal_luna','Luna','reviewing'),
('app_003','Megan Landry','megan@example.com','animal_bella','Bella','follow_up');

INSERT OR REPLACE INTO fundraising_campaigns_demo
(id,title,goal_cents,raised_cents,status,starts_at,ends_at)
VALUES
('camp_medical','Emergency Medical Fund',300000,124000,'active','2026-04-01','2026-05-31'),
('camp_food','Feed the Shelter',150000,82000,'active','2026-04-01','2026-05-15'),
('camp_transport','Transport Support',100000,37000,'active','2026-04-15','2026-06-01');

INSERT OR REPLACE INTO dashboard_calendar_events
(id,title,event_type,starts_at,platform,content,status)
VALUES
('evt_001','Volunteer Orientation','volunteer','2026-04-30T18:00:00','email','Invite new volunteers','scheduled'),
('evt_002','Rocky Adoption Post','social_post','2026-05-01T10:00:00','facebook,instagram','Post Rocky adoption spotlight','scheduled'),
('evt_003','Medical Fund Push','fundraising','2026-05-03T09:00:00','facebook,email','Campaign reminder','scheduled');
