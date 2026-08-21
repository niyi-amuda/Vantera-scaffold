# Vantera — Premium Smartphone Pre-Order Platform

Phase 1 scaffold. Stack: Next.js (App Router) + TypeScript + Tailwind + Supabase + Resend.

## What's in this scaffold
- `app/` — Next.js App Router root, layout, placeholder homepage, global styles
- `lib/supabase-server.ts` — server-only Supabase client (service role key, never exposed to browser)
- `lib/supabase-browser.ts` — browser-safe Supabase client (anon key only)
- `supabase/schema.sql` — full database schema: products, customers, orders, order_items, RLS policies, 6 sample products
- `.env.example` — every environment variable you'll need, with no real values
- `.gitignore` — keeps `.env.local` and `node_modules` out of Git

## Your next steps (in order)

### 1. Push this to GitHub
Create a new repo on GitHub, then push this folder's contents to it as your first commit ("Initial project setup").

### 2. Run the database schema in Supabase
- Open your Supabase project → **SQL Editor**
- Paste the entire contents of `supabase/schema.sql`
- Run it. This creates all 4 tables, indexes, RLS policies, and inserts 6 sample Vantera products.

### 3. Collect your Supabase keys
Supabase Dashboard → **Settings → API**:
- `Project URL` → becomes `NEXT_PUBLIC_SUPABASE_URL`
- `anon public` key → becomes `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `service_role` key → becomes `SUPABASE_SERVICE_ROLE_KEY` (⚠️ keep secret, server-only)

### 4. Set up Resend
- Verify a sending domain in Resend (or use their test domain while developing)
- Create an API key → becomes `RESEND_API_KEY`
- Pick your sending address → becomes `RESEND_FROM_EMAIL`
- Decide which inbox gets new-order alerts → becomes `ADMIN_EMAIL`

### 5. Add environment variables to Vercel
Vercel → your project → **Settings → Environment Variables** → add all 6 keys from `.env.example` with real values. Do this for Production (and Preview if you want staging to work too).

### 6. Connect GitHub repo to Vercel
Vercel → **Add New Project** → import your GitHub repo → it will auto-detect Next.js → Deploy.

---

## What's next in the build (Phase 2)
Once steps 1–6 are done and confirmed working, the next phase is:
- Real homepage (hero, featured products, trust section, how pre-order works)
- `/shop` product grid pulling from Supabase
- `/product/[id]` detail page

Reply here once GitHub, Supabase, and Vercel are connected, and we'll move to Phase 2.
