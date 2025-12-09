-- Fix existing cards to use Gemini instead of OpenAI
-- Run this in Supabase SQL Editor

-- Update all cards to use Gemini (you have Gemini API key in .env)
UPDATE review_cards 
SET 
  ai_provider = 'gemini',
  ai_model = 'gemini-2.0-flash'
WHERE ai_provider = 'openai' OR ai_provider IS NULL;

-- Verify the update
SELECT 
  business_name, 
  ai_provider, 
  ai_model,
  SUBSTRING(ai_api_key, 1, 20) || '...' as api_key_preview
FROM review_cards
LIMIT 10;
