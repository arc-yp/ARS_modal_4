/*
  # Migrate Existing Gemini API Keys to Unified Fields

  This migration preserves existing Gemini API keys by copying them to the new unified fields.
  Run this BEFORE deploying the new code to prevent data loss.

  1. Changes
    - Copy gemini_api_key to ai_api_key for existing cards
    - Set ai_provider to 'gemini' for cards with Gemini keys
    - Copy gemini_model to ai_model (or use default)
    - Preserves existing Gemini configurations

  2. Safety
    - Only updates rows that have gemini_api_key set
    - Does not delete or modify old columns
    - Can be rolled back if needed
*/

-- Migrate existing Gemini API keys to unified fields
UPDATE review_cards 
SET 
  ai_api_key = gemini_api_key,
  ai_provider = 'gemini',
  ai_model = COALESCE(gemini_model, 'gemini-2.0-flash')
WHERE gemini_api_key IS NOT NULL 
  AND gemini_api_key != ''
  AND (ai_api_key IS NULL OR ai_api_key = '');

-- Log migration results
DO $$
DECLARE
  migrated_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO migrated_count
  FROM review_cards
  WHERE ai_provider = 'gemini' AND ai_api_key IS NOT NULL;
  
  RAISE NOTICE 'Migration complete: % cards migrated to unified Gemini fields', migrated_count;
END $$;
