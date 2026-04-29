
CREATE TABLE IF NOT EXISTS agentsam_sessions (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  user_id TEXT,
  session_title TEXT DEFAULT 'Dashboard Assistant',
  route_path TEXT,
  mode TEXT DEFAULT 'ask',
  status TEXT DEFAULT 'active',
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT
);

CREATE TABLE IF NOT EXISTS agentsam_messages (
  id TEXT PRIMARY KEY,
  session_id TEXT NOT NULL,
  tenant_id TEXT NOT NULL DEFAULT 'tenant_companionscpas',
  role TEXT NOT NULL,
  content TEXT NOT NULL,
  metadata_json TEXT DEFAULT '{}',
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY(session_id) REFERENCES agentsam_sessions(id)
);

INSERT OR IGNORE INTO agentsam_ai_models
(id, provider, model_key, display_name, role, runtime, base_url, is_local, is_enabled, priority, notes)
VALUES
('model_workers_gemma_4_26b','workers_ai','@cf/google/gemma-4-26b-a4b-it','Workers AI Gemma 4 26B','fallback','cloudflare_workers_ai',NULL,0,1,20,'Low-cost/free-tier dashboard assistant fallback.'),
('model_openai_gpt_4_1_mini','openai','gpt-4.1-mini','GPT-4.1 Mini','fast_reasoning','openai_responses',NULL,0,1,40,'Fast assistant, CMS, email, and dashboard support.'),
('model_openai_gpt_4_1','openai','gpt-4.1','GPT-4.1','long_context','openai_responses',NULL,0,1,50,'Long-context planning and structured analysis.'),
('model_openai_gpt_5_4_nano','openai','gpt-5.4-nano','GPT-5.4 Nano','fast_reasoning','openai_responses',NULL,0,1,35,'Fast low-cost OpenAI fallback.'),
('model_openai_gpt_5_4_pro','openai','gpt-5.4-pro','GPT-5.4 Pro','agent','openai_responses',NULL,0,1,80,'Heavy agent/debug workflow when approved.'),
('model_openai_gpt_image_2','openai','gpt-image-2','GPT Image 2','image_generation','openai_images',NULL,0,1,70,'Campaign, social, and website image generation.'),
('model_anthropic_haiku_4_5','anthropic','claude-haiku-4.5','Claude Haiku 4.5','fast_reasoning','anthropic',NULL,0,1,45,'Fast drafting/planning fallback.'),
('model_anthropic_opus_4_7','anthropic','claude-opus-4.7','Claude Opus 4.7','deep_reasoning','anthropic',NULL,0,1,90,'High-quality reasoning when explicitly enabled.'),
('model_gemini_flash_lite','google','gemini-3.1-flash-lite','Gemini 3.1 Flash Lite','fast_reasoning','google',NULL,0,1,30,'Fast lightweight fallback.'),
('model_gemini_flash','google','gemini-3-flash','Gemini 3 Flash','fast_reasoning','google',NULL,0,1,42,'General assistant fallback.'),
('model_gemini_pro','google','gemini-3.1-pro','Gemini 3.1 Pro','deep_reasoning','google',NULL,0,1,75,'Long-context planning/test model.'),
('model_local_ollama_qwen','ollama','qwen2.5-coder:7b','Local Qwen 2.5 Coder 7B','local_dev','local_ollama','http://127.0.0.1:11434',1,1,10,'Local dev/coding assistant when bridge is available.');

INSERT OR IGNORE INTO agentsam_commands
(id, tenant_id, command_key, command_name, command_category, description, prompt_template, provider_strategy, default_model, safety_level, sort_order)
VALUES
('cmd_cpas_review_applications','tenant_companionscpas','review_foster_applications','Review Foster Applications','applications','Summarize new foster applications, flag follow-ups, and draft professional responses.','Review the latest CPAS foster applications and recommend next actions.','auto','gpt-4.1-mini','standard',10),
('cmd_cpas_write_campaign','tenant_companionscpas','write_fundraising_campaign','Write Fundraising Campaign','fundraising','Create donor-facing campaign copy, email copy, and social content.','Create a fundraising campaign for Companions of CPAS.','auto','gpt-4.1-mini','standard',20),
('cmd_cpas_update_website','tenant_companionscpas','update_website_content','Update Website Content','cms','Help edit CMS-driven website copy and page sections.','Help update the Companions of CPAS website content.','auto','gpt-4.1','approval_required',30),
('cmd_cpas_generate_social','tenant_companionscpas','generate_social_post','Generate Social Post','social','Generate captions and image prompts for Facebook/Instagram.','Generate social media content for Companions of CPAS.','auto','gpt-4.1-mini','standard',40);

INSERT OR IGNORE INTO agentsam_mcp_workflows
(id, tenant_id, workflow_key, workflow_name, description, steps_json, trigger_type, allowed_roles, model_policy_json, budget_policy_json, safety_level, max_estimated_cost_usd, requires_human_approval)
VALUES
('wf_cpas_application_response','tenant_companionscpas','foster_application_response','Foster Application Response','Review a foster application, create internal notes, and draft a Resend email response.',
 '[{"step_key":"summarize_application","tool_key":"db.read.cpas_foster_applications"},{"step_key":"draft_email","tool_key":"email.resend.draft"},{"step_key":"log_event","tool_key":"db.write.cpas_application_events"}]',
 'manual','["owner","developer","admin"]',
 '{"default":"gpt-4.1-mini","fallback":["@cf/google/gemma-4-26b-a4b-it","gpt-5.4-nano"]}',
 '{"max_estimated_cost_usd":0.05,"max_total_tokens":8000,"max_workers_ai_neurons":200000}',
 'standard',0.05,0),

('wf_cpas_campaign_assistant','tenant_companionscpas','campaign_assistant','Campaign Assistant','Generate fundraiser copy, donor email, and social post drafts.',
 '[{"step_key":"analyze_need","tool_key":"db.read.fundraising_campaigns"},{"step_key":"write_copy","tool_key":"llm.generate"},{"step_key":"save_todo","tool_key":"db.write.agentsam_todo"}]',
 'manual','["owner","developer","admin"]',
 '{"default":"gpt-4.1-mini","fallback":["@cf/google/gemma-4-26b-a4b-it"]}',
 '{"max_estimated_cost_usd":0.05,"max_total_tokens":8000}',
 'standard',0.05,0);
