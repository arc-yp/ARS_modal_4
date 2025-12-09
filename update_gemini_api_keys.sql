-- Update all Gemini cards with a new backup API key
-- Run this ONLY after getting a new key from: https://aistudio.google.com/app/apikey

UPDATE review_cards 
SET ai_api_key = 'YOUR_NEW_GEMINI_API_KEY_HERE'
WHERE ai_provider = 'gemini';

-- Verify the update
SELECT 
  business_name,
  ai_provider,
  ai_model,
  SUBSTRING(ai_api_key, 1, 15) || '...' as api_key_preview
FROM review_cards
WHERE ai_provider = 'gemini'
LIMIT 10;
