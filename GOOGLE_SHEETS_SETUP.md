# Send new cards to Google Sheets (via Google Apps Script)

This project can push each newly created Review Card to a Google Sheet using a simple Google Apps Script Web App. Follow the steps below to set it up end‑to‑end.

## What you get

- On Create Card in `CompactAddCardModal`, the app makes a POST to your Apps Script Web App.
- The script appends a row into a target Google Sheet.
- Optional shared secret adds a basic verification layer.

## Is Apps Script possible? Is it free?

- Yes, this is 100% possible with a Google Apps Script Web App.
- Apps Script has a generous free quota for personal use. It’s free to use within quotas; Google Workspace accounts have higher limits. For heavy/production traffic, consider Google Sheets API with a backend service and proper credentials.

---

## 1) Create your target Google Sheet

1. Create a new Google Sheet (or open an existing one).
2. Add a sheet (tab) named `Cards` (or any name you prefer).
3. In row 1, add headers (one per column) to keep data organized. Suggested headers:

   - `id`
   - `businessName`
   - `category`
   - `type`
   - `description`
   - `location`
   - `services` (pipe-separated)
   - `slug`
   - `logoUrl`
   - `googleMapsUrl`
   - `aiProvider`
   - `aiModel`
   - `active`
   - `expiresAt`
   - `allowedLanguages` (pipe-separated)
   - `createdAt`
   - `updatedAt`

> You can rename or reorder columns, but then adjust the Apps Script mapping accordingly.

---

## 2) Create the Apps Script Web App

You can create a standalone script at https://script.google.com or from Extensions → Apps Script inside the Sheet.

Paste this code into the editor (Code.gs):

```javascript
// === Configure these ===
const SHEET_ID = "PUT_YOUR_SHEET_ID_HERE"; // or set to null to use bound sheet
const SHEET_NAME = "Cards";
const SHARED_SECRET = "optional_shared_secret"; // leave '' if you don't want to use it

function doPost(e) {
  try {
    if (!e || !e.postData || !e.postData.contents) {
      return _json({ ok: false, message: "No POST body" }, 400);
    }

    const body = JSON.parse(e.postData.contents);

    if (SHARED_SECRET && body.secret !== SHARED_SECRET) {
      return _json({ ok: false, message: "Unauthorized" }, 401);
    }

    const card = body.card || {};

    // Open the target sheet
    const ss = SHEET_ID
      ? SpreadsheetApp.openById(SHEET_ID)
      : SpreadsheetApp.getActiveSpreadsheet();
    const sheet = ss.getSheetByName(SHEET_NAME) || ss.insertSheet(SHEET_NAME);

    // Build a row (match your header order)
    const toRow = [
      card.id || "",
      card.businessName || "",
      card.category || "",
      card.type || "",
      card.description || "",
      card.location || "",
      (card.services || []).join("|"),
      card.slug || "",
      card.logoUrl || "",
      card.googleMapsUrl || "",
      card.aiProvider || "deepseek",
      card.aiModel || "deepseek-chat",
      card.active === false ? "FALSE" : "TRUE",
      card.expiresAt || "",
      (card.allowedLanguages || []).join("|"),
      card.createdAt || new Date().toISOString(),
      card.updatedAt || new Date().toISOString(),
    ];

    sheet.appendRow(toRow);

    return _json({ ok: true, message: "Row added" }, 200);
  } catch (err) {
    return _json({ ok: false, message: String(err) }, 500);
  }
}

function _json(obj, statusCode) {
  const output = ContentService.createTextOutput(
    JSON.stringify(obj)
  ).setMimeType(ContentService.MimeType.JSON);
  // Apps Script Web Apps generally allow cross-origin fetch for anonymous access.
  // Custom CORS headers are not required for typical use; leaving them out for simplicity.
  return output;
}
```

Then deploy as a Web App:

1. Click Deploy → Manage deployments → New deployment.
2. Deployment type: Web app.
3. Description: e.g., "Append Cards".
4. Execute as: Me.
5. Who has access: Anyone.
6. Click Deploy and copy the Web app URL (ends with `/exec`).

> Tip: If you created the script inside the Sheet (bound script), you can set `SHEET_ID` to `null` and it will use the active spreadsheet automatically.

---

## 3) Add environment variables to this project

Create or update `.env.local` in the project root:

```bash
VITE_SHEETS_WEBAPP_URL="https://script.google.com/macros/s/AKxxxxxxxxxxxxxxxx/exec"
VITE_SHEETS_SHARED_SECRET="optional_shared_secret"
```

Restart your dev server if it’s running.

---

## 4) What the frontend does

- We added `src/utils/googleSheets.ts` which exposes `sendReviewCardToSheet(card)`.
- In `CompactAddCardModal` after a card is created, the app calls this function in a try/catch. Failures won’t block the UI.
- Config is read from `src/utils/config.ts`.

If you want to disable sending to Sheets, remove `VITE_SHEETS_WEBAPP_URL` or leave it empty.

---

## 5) Testing

- Create a test card in the app (use Create Card).
- Check your Google Sheet → the new row should appear under the headers.
- Open DevTools console to see logs in case sending was skipped or failed.

---

## 6) Notes, limits, and security

- Apps Script has daily quotas (execution time, calls, etc.). For moderate usage this is fine and free. For high throughput, consider a small backend + Google Sheets API.
- The shared secret protects against random posts if someone guesses your URL. Don’t hardcode secrets in public repos.
- If you change columns or add new fields, update the Apps Script mapping accordingly.
- Web App access must be set to "Anyone" if you need the browser to POST without authentication.

---

## Where the code lives (in this repo)

- `src/utils/config.ts` → added `sheets.webAppUrl` and `sheets.sharedSecret`.
- `src/utils/googleSheets.ts` → sends POSTs to the Web App.
- `src/components/CompactAddCardModal.tsx` → calls `sendReviewCardToSheet(newCard)` after saving.
