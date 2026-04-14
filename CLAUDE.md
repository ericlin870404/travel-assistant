# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**特寶寶助手** — A collaborative trip planning PWA. Pure frontend (vanilla JS + Tailwind CSS CDN) backed by Supabase (PostgreSQL + Auth + Storage). No build step; all code runs directly in the browser.

Three HTML entry points:
- [login.html](login.html) — Email/password auth via Supabase Auth, redirects to index on session
- [index.html](index.html) — Trip list with accordion UI (history / ongoing / shared trips), CRUD operations
- [detail.html](detail.html) — Six-tab trip dashboard: Schedule, Hotel, Transport, Food, Attraction, Expense

## Maintenance Scripts

```bash
# Manual database backup (saves to backups/backup_YYYY-MM-DD.json, keeps last 30)
SUPABASE_SECRET_KEY=<key> node scripts/backup.js

# Regenerate supabase/schema.sql and supabase/policies.sql from live DB
SUPABASE_SECRET_KEY=<key> node scripts/update-schema.js
```

GitHub Actions automate both weekly (backup) and daily (schema sync) and commit results to the repo.

## 開發前請先閱讀
- 需要了解資料表結構、欄位定義時 → 閱讀 `supabase/schema.sql`
- 需要了解權限設定、RLS 規則時 → 閱讀 `supabase/policies.sql`
- 這兩個檔案每日自動從 Supabase 同步，永遠反映最新狀態，請以此為準

## Architecture

### Supabase Client (inline in each HTML file)

```js
const db = createClient(
    'https://lcdugmmnjfrvfdbzpwma.supabase.co',
    '<publishable_anon_key>'   // safe to expose; RLS enforces access
);
```

Security is enforced entirely by **Row-Level Security policies** in PostgreSQL — see [supabase/policies.sql](supabase/policies.sql). Two key RPC helpers drive most policies:
- `can_edit_trip(trip_id)` — user is owner OR editor collaborator
- `has_trip_access(trip_id)` — user is owner, editor, or viewer

### Database Tables

| Table | Purpose |
|-------|---------|
| `trips` | Trip metadata (owner_id, title, emoji, start_date, end_date, destination, share_token) |
| `trip_collaborators` | role = `'editor'` or `'viewer'` |
| `profiles` | Mirrors `auth.users` (username) |
| `schedule_items` | Daily itinerary entries |
| `stays` | Accommodation per date |
| `transport_groups` + `transport_details` | Transport is two-level: group (type) → details (legs) |
| `restaurants` | category: `'正餐'` / `'前菜'` / `'甜點'` |
| `attractions` | category: `'自然景觀'` / others |
| `expenses` | amount + currency_id; `amount_twd` stores the converted value |
| `currencies` | Per-trip exchange rates to TWD; one marked `is_default` |
| `trip_day_photos` | Max 5 photos per day; stored as path strings, accessed via signed URLs (365-day validity) |

Schema DDL is auto-generated at [supabase/schema.sql](supabase/schema.sql).

### Photo Handling

Uploads are compressed client-side (max 1600 px / 1 MB JPEG) before being sent to Supabase Storage bucket `trip-photos`. The stored value in `trip_day_photos.photo_url` is the **storage path** (not a full URL); signed URLs are generated on read.

### detail.html Internals

The 6 tabs are rendered by a single `router()` function that swaps content and fetches data per-tab. Data is cached in JS variables to avoid redundant Supabase calls on tab switches. Long-press gesture (500 ms) triggers delete on mobile.

## Key Constraints

- Trip title and destination: max 15 characters
- Schedule notes: max 40 characters
- Photos: max 5 per day
- All monetary amounts convert to TWD for display