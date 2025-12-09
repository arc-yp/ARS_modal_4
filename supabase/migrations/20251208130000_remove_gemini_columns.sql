/*
  # Remove Legacy Gemini Columns

  This migration removes the old gemini_api_key and gemini_model columns
  since all data has been migrated to the unified ai_api_key and ai_model fields.

  IMPORTANT: Only run this AFTER:
  1. The previous migration (20251208120000) has been applied
  2. You've verified all data was copied correctly
  3. The new code is deployed and working

  1. Changes
    - Drop gemini_api_key column
    - Drop gemini_model column

  2. Safety
    - This is irreversible - make a backup first!
    - Run the verification query below before executing
*/

-- VERIFICATION QUERY (Run this first to confirm migration was successful)
-- SELECT 
--   COUNT(*) as total_cards,
--   COUNT(ai_api_key) as cards_with_ai_key,
--   COUNT(gemini_api_key) as cards_with_gemini_key
-- FROM review_cards;

-- Remove legacy Gemini columns
ALTER TABLE review_cards DROP COLUMN IF EXISTS gemini_api_key;
ALTER TABLE review_cards DROP COLUMN IF EXISTS gemini_model;

-- Log completion
DO $$
BEGIN
  RAISE NOTICE 'Legacy Gemini columns removed successfully';
END $$;
