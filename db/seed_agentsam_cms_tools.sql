INSERT OR REPLACE INTO agentsam_mcp_tools
(id, tenant_id, tool_key, tool_name, display_name, tool_category, description, input_schema, output_schema, intent_tags, modes_json, handler_type, handler_config, provider, requires_auth, requires_secret_keys, safety_level, is_enabled, sort_order)
VALUES
('tool_cms_update_section','tenant_companionscpas','cms_update_section','cms_update_section','Update CMS Section','cms','Updates editable CMS section content for a draft page.',
'{"type":"object","required":["page_route","section_key"],"properties":{"page_route":{"type":"string"},"section_key":{"type":"string"},"heading":{"type":"string"},"subheading":{"type":"string"},"body":{"type":"string"},"cta_label":{"type":"string"},"cta_href":{"type":"string"}}}',
'{"type":"object","properties":{"success":{"type":"boolean"}}}',
'["cms","website","section","edit"]','["agent","debug"]','http','{"method":"POST","path":"/api/cms/section/save"}','internal',1,'[]','standard',1,10),

('tool_cms_update_block','tenant_companionscpas','cms_update_block','cms_update_block','Update CMS Block','cms','Updates repeatable CMS blocks such as cards, stories, animals, or impact items.',
'{"type":"object","required":["page_route","section_key","block_key"],"properties":{"page_route":{"type":"string"},"section_key":{"type":"string"},"block_key":{"type":"string"},"title":{"type":"string"},"body":{"type":"string"},"image_url":{"type":"string"},"action_label":{"type":"string"},"action_value":{"type":"string"}}}',
'{"type":"object","properties":{"success":{"type":"boolean"}}}',
'["cms","website","block","edit"]','["agent","debug"]','http','{"method":"POST","path":"/api/cms/block/save"}','internal',1,'[]','standard',1,20),

('tool_cms_publish_page','tenant_companionscpas','cms_publish_page','cms_publish_page','Publish CMS Page','cms','Publishes a CMS page after human approval.',
'{"type":"object","required":["route_path"],"properties":{"route_path":{"type":"string"}}}',
'{"type":"object","properties":{"success":{"type":"boolean"},"preview_url":{"type":"string"}}}',
'["cms","website","publish"]','["agent","debug"]','http','{"method":"POST","path":"/api/cms/publish"}','internal',1,'[]','high',1,30);

INSERT OR REPLACE INTO agentsam_commands
(id, tenant_id, command_key, command_name, command_category, description, prompt_template, input_schema, output_schema, allowed_roles, allowed_modes, provider_strategy, default_model, is_enabled, safety_level, sort_order)
VALUES
('cmd_cms_rewrite_section','tenant_companionscpas','cms_rewrite_section','Rewrite CMS Section','cms','Improve a selected page section for clarity, warmth, and conversion without changing facts.',
'Rewrite this CMS section for Companions of CPAS. Keep it truthful, warm, local, and action-oriented. Preserve EIN/contact facts. Return draft copy only.',
'{"type":"object","properties":{"page_route":{"type":"string"},"section_key":{"type":"string"},"current_copy":{"type":"string"}}}',
'{"type":"object","properties":{"draft_copy":{"type":"string"}}}',
'["owner","developer","admin"]','["ask","plan","agent"]','auto',NULL,1,'standard',10),

('cmd_cms_conversion_review','tenant_companionscpas','cms_conversion_review','Review Page Conversion','cms','Reviews a public page for adoption, foster, and donation conversion improvements.',
'Review this page for nonprofit conversion. Suggest concise improvements for adoption, fostering, donations, trust, and accessibility.',
'{"type":"object","properties":{"page_route":{"type":"string"},"page_content":{"type":"string"}}}',
'{"type":"object","properties":{"recommendations":{"type":"array"}}}',
'["owner","developer","admin"]','["ask","plan","agent"]','auto',NULL,1,'standard',20);

INSERT OR REPLACE INTO agentsam_mcp_workflows
(id, tenant_id, workflow_key, workflow_name, description, steps_json, trigger_type, allowed_roles, execution_mode, retry_policy, safety_level, is_enabled, requires_human_approval, max_tool_calls, max_estimated_cost_usd)
VALUES
('wf_cms_assisted_edit','tenant_companionscpas','cms_assisted_edit','Assisted CMS Edit','Agent Sam drafts copy, saves it to a CMS section, and waits for human publish approval.',
'[{"step_key":"review_section","tool_key":"llm.generate"},{"step_key":"save_section","tool_key":"cms_update_section"},{"step_key":"request_approval","tool_key":"approval.request"}]',
'manual','["owner","developer","admin"]','sequential','{"retries":1}','standard',1,1,6,0.05),

('wf_cms_publish_after_approval','tenant_companionscpas','cms_publish_after_approval','Publish CMS Page After Approval','Publishes a CMS page only after a human approves the draft.',
'[{"step_key":"verify_page","tool_key":"cms_update_section"},{"step_key":"publish_page","tool_key":"cms_publish_page"}]',
'manual','["owner","developer","admin"]','sequential','{"retries":1}','high',1,1,4,0.03);
