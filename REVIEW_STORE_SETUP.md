# Review Store (અલગ Supabase DB) Setup

> આ ડૉક્યૂમેન્ટ ગુજરાતી ભાષામાં અલગ નવી Supabase instance (Generated Reviews Archive) માટે માર્ગદર્શન આપે છે

## 1. હેતુ

CompactReviewCardView માં user દ્વારા જનરેટ થતી દરેક AI/Fallback review ને **મુખ્ય હાલના DB થી અલગ** નવા Supabase પ્રોજેક્ટમાં સંગ્રહિત કરવી. પછી `/review` રૂટ પર બધાં business/category મુજબ આ reviews જોઈ શકાય.

## 2. Environment Variables ઉમેરો

`.env` ફાઇલમાં (પહેલેથી placeholders ઉમેરવામાં આવ્યા છે):

```
VITE_REVIEWSTORE_URL=https://YOUR_NEW_REVIEW_STORE_PROJECT_ID.supabase.co
VITE_REVIEWSTORE_ANON_KEY=YOUR_NEW_REVIEW_STORE_ANON_PUBLIC_KEY
```

## 3. Supabase માં નવું Project બનાવો

1. https://supabase.com → New Project
2. Project name: `review-store` (ઇચ્છા મુજબ)
3. DB password સાચવી રાખો.
4. Project Settings → API → `Project URL` અને `anon public` key કોપી કરી `.env` માં મૂકો.

## 4. Table Schema બનાવો

SQL Editor માં નીચેની સ્ક્રિપ્ટ ચલાવો:

```sql
create table if not exists generated_reviews (
  id uuid primary key default uuid_generate_v4(),
  business_name text not null,
  category text not null,
  rating int not null check (rating between 1 and 5),
  language text not null,
  tone text,
  services text[] default array[]::text[],
  review_text text not null,
  is_fallback boolean default false,
  created_at timestamptz default now()
);

-- Optional indexes
create index if not exists idx_generated_reviews_business on generated_reviews(business_name);
create index if not exists idx_generated_reviews_category on generated_reviews(category);
create index if not exists idx_generated_reviews_created_at on generated_reviews(created_at desc);
```

## 5. RLS (Row Level Security)

જો private access જોઈએ:

```sql
alter table generated_reviews enable row level security;

create policy "Allow read" on generated_reviews
for select using ( true );

create policy "Allow insert" on generated_reviews
for insert with check ( true );
```

(અહીં simple public insert/read policy છે. જરૂર પડે તો role પ્રમાણે કસ્ટમાઇઝ કરો.)

## 6. Code Changes (આ રેપોમાં ઉમેરાઈ ગયા છે)

- `src/utils/reviewStore.ts` → નવી client + helper functions (`saveReview`, `getAllReviews`, `getReviewsByBusiness`).
- `CompactReviewCardView.tsx` → દરેક જનરેશન પછી `reviewStore.saveReview(...)` કૉલ.
- Fallback review પણ save થાય છે `isFallback: true` સાથે.
- `ReviewArchivePage.tsx` → `/review` રૂટ પર લિસ્ટ + સર્ચ + કેટેગરી ફિલ્ટર.
- `App.tsx` માં નવો રૂટ ઉમેરાયો.

## 7. Development Checklist

- `.env` માં નવા REVIEWSTORE વેરિયેબલ ભર્યા?
- Vite dev સર્વર રીસ્ટાર્ટ કર્યો? (`npm run dev`)
- Supabase project માં table અને policies લાગુ કર્યા?

## 8. જો Production માટે Hardening જોઈએ

- Insert rate limit (Edge Function / throttling)
- Moderation (inappropriate શબ્દો filter)
- Export / backup automation (pg_dump schedule)

## 9. Sample Query (Business પ્રમાણે)

```ts
const auraReviews = await reviewStore.getReviewsByBusiness("Aura Hospital");
```

## 10. Troubleshooting

| Issue                 | Cause                 | Fix                          |
| --------------------- | --------------------- | ---------------------------- |
| Warning: env missing  | Variables નહિ ઉમેર્યા | `.env` ભરો + restart         |
| 401 Unauthorized      | Wrong anon key        | API Key ફરીથી કોપી કરો       |
| Reviews not appearing | Table schema mismatch | Column names ચેક કરો         |
| Fallback only         | AI API error          | Gemini API key / quota તપાસો |

## 11. Security Notes

- `VITE_REVIEWSTORE_ANON_KEY` public હોય તો insert policies વાંચી સુરક્ષિત કરો.
- Sensitive admin actions માટે service role key UI માં exposed ન કરશો.

---

કોઈ વધુ ફેરફાર જોઈએ તો કહી શકો.
