# Quick Start: Using Multiple AI Providers

## What's New?

Your application now supports 4 AI providers with **DeepSeek as the default**:

- **DeepSeek** ⭐ (NEW DEFAULT - Most Cost-Effective)
- **Google Gemini** ✅ (Original, still available)
- **OpenAI (ChatGPT)** 🆕
- **Perplexity AI** 🆕

## Get API Keys (5 minutes)

### Option 1: DeepSeek (Cheapest!) ⭐ DEFAULT

1. Go to https://makersuite.google.com/app/apikey
2. Click "Create API Key"
3. Copy the key

### Option 3: OpenAI (Paid)

1. Go to https://platform.openai.com/api-keys
2. Create account and add payment method
3. Click "Create new secret key"
4. Copy the key

### Option 4: Perplexity (Paid)

1. Go to https://www.perplexity.ai/settings/api
2. Sign up and add payment
3. Generate API key
4. Copy the key

## How to Use

### Creating a New Review Card

1. Click "Add New Review Card"
2. **Select AI Provider** - Click one of the 4 buttons
3. **Enter API Key** - Paste your key
4. **Choose Model** - Pick from dropdown (auto-updates based on provider)
5. Fill in business details as usual
6. Click Save

### Editing Existing Cards

1. Click "Edit" on any card
2. Change the AI Provider if desired
3. Enter new API key
4. Choose model
5. Save

## Cost Comparison (per 1M tokens)

| Provider | Cost  | Speed  | Quality  |
| -------- | ----- | ------ | -------- |
| Gemini   | FREE  | ⚡⚡⚡ | ⭐⭐⭐⭐ |
| DeepSeek | $0.14 | ⚡⚡   | ⭐⭐⭐⭐ |

## Cost Comparison (per 1M tokens)

| Provider   | Cost      | Speed  | Quality    | Default |
| ---------- | --------- | ------ | ---------- | ------- |
| DeepSeek   | $0.14     | ⚡⚡   | ⭐⭐⭐⭐   | ⭐ YES  |
| Gemini     | FREE      | ⚡⚡⚡ | ⭐⭐⭐⭐   |         |
| Perplexity | $0.20     | ⚡⚡   | ⭐⭐⭐⭐   |         |
| OpenAI     | $0.50-$15 | ⚡⚡⚡ | ⭐⭐⭐⭐⭐ |         |

## Recommended Settings

### For Best Price (Default) ⭐

- Provider: **DeepSeek**
- Model: **deepseek-chat**

### For Best Quality

- Provider: **OpenAI**
- Model: **gpt-4o**

### For Free Usage

- Provider: **Gemini**
- Model: **gemini-2.0-flash**
- Model: **gemini-2.0-flash**

### For Online Research

- Provider: **Perplexity**
- Model: **llama-3.1-sonar-small-128k-online**

## Troubleshooting

**Issue**: "API key not provided"  
**Solution**: Make sure you pasted the full API key correctly

**Issue**: Reviews not generating  
**Solution**:

1. Check console for errors
2. Verify API key is valid
3. Check if you have quota/credits
4. Try a different provider

**Issue**: Getting generic fallback reviews  
**Solution**: Your API key may be invalid or out of quota

## Testing Your Setup

1. Create a test review card
2. Try generating a review
3. Check the console for logs showing:
   - ✅ Provider name
   - ✅ Model used
   - ✅ Token usage
   - ✅ Review preview

## Next Steps

1. Run the database migration: `npm run migrate` (if using Supabase)
2. Get at least one API key
3. Create a test review card
4. Generate a review
5. Enjoy multiple AI providers! 🎉

---

**Need Help?** Check `MULTIPLE_AI_PROVIDERS.md` for detailed documentation.
