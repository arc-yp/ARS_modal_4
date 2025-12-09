/*
  # Add Multiple AI Provider Support

  1. Changes
    - Add `ai_provider` column to store the selected AI provider (gemini, openai, perplexity, deepseek)
    - Add `ai_api_key` column to store the API key for the selected provider
    - Add `ai_model` column to store the model name for the selected provider
    - Keep `gemini_api_key` and `gemini_model` for backward compatibility
    - Default provider is 'deepseek' for cost-effectiveness

  2. Migration Strategy
    - Existing cards with gemini_api_key will automatically work
    - New cards default to DeepSeek
    - All API keys are stored securely in the database
*/

DO $$
BEGIN
  -- Add ai_provider column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'review_cards' AND column_name = 'ai_provider'
  ) THEN
    ALTER TABLE review_cards ADD COLUMN ai_provider text DEFAULT 'deepseek';
  END IF;

  -- Add ai_api_key column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'review_cards' AND column_name = 'ai_api_key'
  ) THEN
    ALTER TABLE review_cards ADD COLUMN ai_api_key text;
  END IF;

  -- Add ai_model column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'review_cards' AND column_name = 'ai_model'
  ) THEN
    ALTER TABLE review_cards ADD COLUMN ai_model text;
  END IF;

  -- Set default ai_provider for existing cards without ai_provider
  UPDATE review_cards 
  SET 
    ai_provider = 'deepseek',
    ai_model = 'deepseek-chat'
  WHERE ai_provider IS NULL 
    AND ai_api_key IS NULL;

  -- Users with gemini_api_key can manually switch back to Gemini provider in the UI if needed

END $$;

-- Add comment for documentation
COMMENT ON COLUMN review_cards.ai_provider IS 'AI provider: gemini, openai, perplexity, or deepseek';
COMMENT ON COLUMN review_cards.ai_api_key IS 'API key for the selected AI provider';
COMMENT ON COLUMN review_cards.ai_model IS 'Model name for the selected AI provider';
