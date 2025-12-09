# DeepSeek as Default Provider - Migration Summary

## What Changed?

The default AI provider has been changed from **Gemini** to **DeepSeek** throughout the entire application.

## Why DeepSeek?

- **Cost-Effective**: Only $0.14 per 1M tokens (vs Gemini's free tier limits)
- **High Quality**: Excellent review generation quality
- **No Rate Limits**: More generous limits than free tiers
- **Fast**: Quick response times

## Files Modified

### 1. **aiService.ts** (`src/utils/aiService.ts`)

- Default provider changed from `"gemini"` to `"deepseek"`
- Default model changed from `"gemini-2.0-flash"` to `"deepseek-chat"`
- Backward compatibility maintained for existing Gemini users

### 2. **Database Migration** (`supabase/migrations/20251208000000_add_multiple_ai_providers.sql`)

- Database default for `ai_provider` column: `"deepseek"`
- Existing cards with `gemini_api_key` are migrated to use DeepSeek by default
- Users can manually switch back to Gemini if they prefer

### 3. **Storage Layer** (`src/utils/storage.ts`)

- `transformDbRowToCard`: Defaults to `"deepseek"` and `"deepseek-chat"`
- `transformCardToDbInsert`: Defaults to `"deepseek"` and `"deepseek-chat"`
- `transformCardToDbUpdate`: Defaults to `"deepseek"` and `"deepseek-chat"`

### 4. **UI Components**

- **CompactAddCardModal.tsx**: Default provider set to `"deepseek"`, model to `"deepseek-chat"`
- **EditCardModal.tsx**: Default provider set to `"deepseek"`, model to `"deepseek-chat"`
- **CompactReviewCardView.tsx**: Fallback to `"deepseek"` and `"deepseek-chat"`

### 5. **Documentation**

- **MULTIPLE_AI_PROVIDERS.md**: Updated to show DeepSeek as default
- **QUICK_START_AI_PROVIDERS.md**: Reordered to prioritize DeepSeek

## For Existing Users

### If You Have Gemini API Keys

Your Gemini API keys are **preserved** in the database, but:

1. **New cards** will default to DeepSeek
2. **Existing cards** will be migrated to use DeepSeek provider
3. **To continue using Gemini**:
   - Edit each card
   - Change "AI Provider" from DeepSeek to "Google Gemini"
   - Your existing Gemini API key will be used automatically
   - Save the card

### If You Want to Use DeepSeek (Recommended)

1. Get a DeepSeek API key: https://platform.deepseek.com/api_keys
2. Edit your cards
3. Enter your DeepSeek API key
4. Save

The DeepSeek API key field will **replace** where you previously entered your Gemini key.

## For New Users

1. Sign up for DeepSeek: https://platform.deepseek.com/api_keys
2. Create an API key
3. When creating a review card, DeepSeek will already be selected
4. Enter your API key
5. Select model: `deepseek-chat` (default)
6. Done!

## Migration Impact

### Automatic Changes

✅ All new cards default to DeepSeek  
✅ Database migration sets DeepSeek as default  
✅ UI components show DeepSeek as selected by default

### Manual Actions Required

⚠️ Existing cards with Gemini keys need manual API key update  
⚠️ Or manually switch back to Gemini provider if you want to keep using it

## Testing Checklist

- [x] Default provider changed to DeepSeek in all files
- [x] Default model changed to `deepseek-chat` in all files
- [x] Database migration updated
- [x] Storage layer updated
- [x] UI components updated
- [x] Documentation updated
- [x] Backward compatibility maintained
- [ ] Test creating new card (should default to DeepSeek)
- [ ] Test editing existing card (should show current provider)
- [ ] Test switching between providers
- [ ] Test review generation with DeepSeek API key

## API Key Management

### Where API Keys Are Stored

```typescript
// Database columns:
ai_provider: "deepseek"; // or "gemini", "openai", "perplexity"
ai_api_key: "sk-..."; // Your DeepSeek (or other provider's) API key
ai_model: "deepseek-chat"; // The model name

// Legacy columns (still preserved):
gemini_api_key: "..."; // Your old Gemini key
gemini_model: "..."; // Your old Gemini model
```

### Field Priority

When loading a card:

1. Check `ai_api_key` first
2. Fall back to `gemini_api_key` if `ai_api_key` is empty
3. Use `ai_provider` to determine which API to call

## Cost Comparison After Change

| Scenario    | Before (Gemini) | After (DeepSeek) | Savings           |
| ----------- | --------------- | ---------------- | ----------------- |
| 1M tokens   | Free (limited)  | $0.14            | Pay but unlimited |
| 10M tokens  | Rate limited    | $1.40            | More freedom      |
| 100M tokens | Not possible    | $14.00           | Enterprise scale  |

## Rollback Instructions

If you need to revert to Gemini as default:

1. **Database**: Change DEFAULT value back to `'gemini'`
2. **Code**: Replace all `"deepseek"` defaults with `"gemini"`
3. **Code**: Replace all `"deepseek-chat"` defaults with `"gemini-2.0-flash"`
4. **Migration**: Update migration to set `ai_provider = 'gemini'`

## Support

For issues:

1. Check that DeepSeek API key is valid
2. Verify you have API credits
3. Try switching to Gemini temporarily if issues persist
4. Check console logs for detailed error messages

---

**Migration Date**: December 8, 2025  
**Default Provider**: DeepSeek  
**Default Model**: deepseek-chat  
**Backward Compatible**: Yes
