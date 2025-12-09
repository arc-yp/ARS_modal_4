# AI Review Generation – Simple Flow (Non‑Technical)

This guide explains, in plain language, how the system creates unique, ready‑to‑post Google reviews and what information is used. No technical knowledge needed.

---

## Who’s involved

- Business owner (Admin): sets up a “review card” for their business once.
- Customer: scans a QR code or opens a link to get a review they can post on Google.

---

## What information is used (User details)

- From the Business Owner (saved in the system):

  - Business name, category, and type (e.g., Salon, Restaurant, Clinic)
  - Short highlights/description and services (e.g., Haircut, Facial, Delivery)
  - Location (address or area) and Google Maps review link
  - Logo image (optional)
  - Allowed languages (English, Gujarati, Hindi)
  - Card settings: active/inactive, optional expiry date

- From the Customer (used only to create text, not stored as personal data):
  - Star rating (1–5)
  - Language choice (English / Gujarati in English letters / Hindi in English letters)
  - Optional services they want to mention (e.g., “Hair Spa”)

Note: The system increases a simple “view counter” when a card is opened. It does not collect customer names, phone numbers, or personal identities.

---

## The AI “brain” (aiservice) in simple words

Think of “AI Service” as the brain that writes the review text:

1. It combines: business details + customer’s choices (rating, language, services).
2. It asks Google’s Gemini AI to draft a review.
3. It checks the text against clear quality rules (see below).
4. If the text doesn’t pass, it tries again up to a few times; if AI isn’t available, it uses a safe fallback text.

Quality rules (kept simple):

- Length around 300–350 characters (short paragraph, not too long).
- No exclamation marks.
- Don’t say “5 stars” or mention star numbers in the text.
- Use only English letters, even for Gujarati/Hindi (example: “Hu khush chu.” / “Main khush hoon.”).
- Make every review feel fresh (avoid repeating the same wording).

Result: a natural‑sounding, unique review that matches the customer’s rating and language.

---

## Helpers behind the scenes (utils)

These are simple “helpers” that make things work smoothly:

- Storage helper: saves business cards locally and syncs with cloud (Supabase) so the owner’s data is safe and can be used on multiple devices. It also turns off cards automatically after their expiry date.
- View counter: counts how many times a review card is opened (one per visit). This helps owners see interest without tracking personal identities.
- Auth helper: protects the admin pages with a login so only the owner can add/edit cards.

---

## Step‑by‑step flows

### A) For Business Owners (one‑time setup)

1. Login to the admin page.
2. Add your business details (name, category, services, logo, Google Maps link).
3. Choose allowed languages and (optional) expiry date.
4. Save to create a “review card”.
5. Get a QR code or link and share it with customers.

### B) For Customers (every time they scan)

1. Scan the QR code or open the link.
2. Pick a star rating and a language.
3. (Optional) Select services to mention in the review.
4. The system generates a short, unique review automatically.
5. Tap “Copy & Post to Google” → it copies the text and opens the Google review page.
6. Paste the text on Google and submit.

---

## How unique reviews are ensured (without the tech jargon)

- The system asks the AI to write a fresh review.
- It checks the result against the rules (length, no “5 stars”, no “!” marks, correct language script).
- If it looks too similar to a previous one, it asks again.
- If the AI is temporarily unavailable, a safe, human‑sounding backup review is used.

Bottom line: customers see natural, varied reviews that fit their rating and language.

---

## What gets stored and where

- Business card info (provided by the owner): stored locally for speed and synced to secure cloud (Supabase) for safety.
- View count: a simple number stored to show how many times a card was opened.
- Customer personal data: not collected.

Privacy first: No names, phone numbers, or identities are required to generate reviews.

---

## Quick picture of the journey

Owner sets up card → Shares QR → Customer scans → Chooses rating & language → AI writes review → Customer copies → Google review opens → Customer pastes & submits

---

## Short FAQ (non‑technical)

• Can customers change the review text?  
Yes, they can edit the text before posting on Google.

• Is the text always different?  
It’s designed to be fresh and natural. If a draft feels repetitive, the system tries again.

• Do you store customer details?  
No. Only a simple view count is kept; no personal identities are collected.

• What if the internet or AI is down?  
The system uses a safe backup review so the customer can still post.

• Can I stop a card temporarily?  
Yes, you can switch a card off or set an expiry date; after expiry it becomes inactive automatically.
