import { createClient } from "@supabase/supabase-js";

/**
 * Client-safe Supabase client. Only uses the public anon key.
 * Safe to import into "use client" components.
 */
export function getSupabaseBrowserClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL!;
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;
  return createClient(url, anonKey);
}
