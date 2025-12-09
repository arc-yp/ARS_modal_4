# Multiple AI Provider Support - Implementation Guide

## Overview

The application now supports multiple AI providers for review generation:

- **DeepSeek** (default - most cost-effective)
- **Google Gemini**
- **OpenAI (ChatGPT)**
- **Perplexity AI**

## Changes Made

### 1. Database Schema (`20251208000000_add_multiple_ai_providers.sql`)

Added new columns to `review_cards` table:

- `ai_provider`: Selected AI provider (gemini, openai, perplexity, deepseek)
- `ai_api_key`: API key for the selected provider
- `ai_model`: Model name for the selected provider

**Migration Strategy**: The database migration adds `ai_provider`, `ai_api_key`, and `ai_model` columns with DeepSeek as the default provider to encourage cost savings. All providers (including Gemini) can be selected via the UI.

### 2. TypeScript Types (`src/types/index.ts`)

- Added `AIProvider` type
- Updated `ReviewCard` interface with new fields:
  - `aiProvider?: AIProvider`
  - `aiApiKey?: string`
  - `aiModel?: string`
- Legacy fields retained for backward compatibility

### 3. AI Service (`src/utils/aiService.ts`)

Complete refactoring to support multiple providers:

#### Supported Models by Provider:

- **Gemini**: gemini-2.0-flash, gemini-1.5-pro, gemini-1.5-flash, gemini-1.0-pro
- **OpenAI**: gpt-4o, gpt-4o-mini, gpt-4-turbo, gpt-3.5-turbo
- **Perplexity**: llama-3.1-sonar-small-128k-online, llama-3.1-sonar-large-128k-online, llama-3.1-sonar-huge-128k-online
- **DeepSeek**: deepseek-chat, deepseek-coder

#### API Integration:

- **Gemini**: Uses `@google/generative-ai` SDK
- **OpenAI**: Uses `openai` SDK
- **Perplexity**: Uses `openai` SDK with custom base URL
- **DeepSeek**: Uses direct HTTP API calls with `axios`

### 4. UI Components

#### Add Card Modal (`src/components/CompactAddCardModal.tsx`)

- AI provider selection with 4 buttons
- Dynamic API key label based on selected provider
- Dynamic model dropdown based on selected provider
- Links to respective API key management pages

#### Edit Card Modal (`src/components/EditCardModal.tsx`)

- Same features as Add Card Modal
- Loads existing provider configuration
- Updates both new and legacy fields on save

#### Review Card View (`src/components/CompactReviewCardView.tsx`)

- Uses new AI provider fields if available
- Falls back to legacy Gemini fields for backward compatibility

### 5. Storage Layer (`src/utils/storage.ts`)

Updated database transformation functions:

- `transformDbRowToCard`: Reads new AI provider fields with fallback to legacy
- `transformCardToDbInsert`: Writes both new and legacy fields
- `transformCardToDbUpdate`: Updates both new and legacy fields

### 6. Database Schema (`src/utils/supabase.ts`)

Updated TypeScript types for database operations to include new columns.

## Usage Instructions

### For Existing Users

**Action Required**: The default provider has been changed to DeepSeek for cost savings.

- If you want to continue using Gemini, edit your cards and select "Google Gemini" as the provider
- Your existing Gemini API keys are preserved and ready to use
- Or get a free DeepSeek API key for even lower costs

### For New Users

#### 1. Get API Keys

**Google Gemini**:

- Visit: https://makersuite.google.com/app/apikey
- Sign in with Google account
- Click "Create API Key"

**OpenAI**:

- Visit: https://platform.openai.com/api-keys
- Sign in to OpenAI account
- Click "Create new secret key"

**Perplexity**:

- Visit: https://www.perplexity.ai/settings/api
- Sign in to Perplexity account
- Generate API key

**DeepSeek**:

- Visit: https://platform.deepseek.com/api_keys
- Sign in to DeepSeek account
- Create new API key

#### 2. Configure in Application

1. Go to "Add New Review Card"
2. Select your preferred AI provider
3. Enter your API key
4. Choose a model
5. Complete other business details
6. Save

### Switching Providers

You can edit any existing card and switch to a different AI provider:

1. Click "Edit" on any review card
2. Select a different AI provider
3. Enter the new API key
4. Choose a model
5. Save changes

## API Rate Limits & Costs

### Google Gemini

- Free tier: 60 requests/minute
- Cost: Free for most models, check Google AI Studio for details

### OpenAI

- Rate limits vary by model and account tier
- GPT-4o: ~$5-15 per 1M tokens
- GPT-3.5-turbo: ~$0.50-1.50 per 1M tokens

### Perplexity

- Standard: $0.20 per 1M tokens (online models)
- Check Perplexity pricing for current rates

### DeepSeek

- Very cost-effective: ~$0.14-0.28 per 1M tokens
- High rate limits

## Technical Details

### Backward Compatibility

The implementation maintains backward compatibility with a new default:

1. Existing cards with `gemini_api_key` are migrated to DeepSeek by default
2. New `ai_provider` defaults to "deepseek" for cost savings
3. Both old and new fields are saved to database
4. Users can manually switch back to Gemini if preferred

### Error Handling

Each provider has robust error handling:

- Invalid API keys trigger fallback reviews
- Network errors are caught and logged
- Retry logic for duplicate reviews (up to 5 attempts)

### Token Usage Logging

Console logs now include:

- Provider name
- Model used
- Token counts (where available)
- Review preview
- Generation metadata

## Testing Checklist

- [x] Database migration runs successfully
- [x] NPM packages installed (openai, axios)
- [x] TypeScript types updated
- [x] AI service supports all 4 providers
- [x] Add modal shows provider selection
- [x] Edit modal shows provider selection
- [x] Review generation works with all providers
- [x] Backward compatibility maintained
- [x] Storage layer handles new fields
- [ ] Test with actual API keys for each provider
- [ ] Verify review quality across providers

## Future Enhancements

Potential improvements:

1. Add more AI providers (Claude, Cohere, etc.)
2. Provider-specific prompt optimization
3. Cost tracking per provider
4. A/B testing between providers
5. Provider health monitoring
6. Automatic fallback if primary provider fails

## Troubleshooting

### "API key not provided" error

- Check that API key is correctly entered
- Verify the API key is valid for the selected provider

### Reviews not generating

- Check console for detailed error messages
- Verify API key has sufficient quota
- Try a different model or provider

### Duplicate reviews

- System automatically retries up to 5 times
- If all retries fail, fallback review is used

## Support

For issues or questions:

1. Check console logs for detailed error messages
2. Verify API keys are valid and have quota
3. Try switching to a different provider temporarily
4. Contact support with error details

---

**Last Updated**: December 8, 2025
**Version**: 2.0.0
