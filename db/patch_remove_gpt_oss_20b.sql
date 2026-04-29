DELETE FROM agentsam_ai_models
WHERE provider = 'ollama'
  AND model_key = 'gpt-oss:20b';

UPDATE agentsam_ai_models
SET priority = 10,
    role = 'local_coder',
    notes = 'Only local model for now. Use for shell help, SQL drafts, small code patches, and low-cost local dev support.',
    updated_at = datetime('now')
WHERE model_key = 'qwen2.5-coder:7b';
