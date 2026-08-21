-- ============================================================
-- Vantera Premium Smartphone Pre-Order Platform
-- Database Schema for Supabase (PostgreSQL)
-- Run this in Supabase Dashboard > SQL Editor
-- ============================================================

-- Enable UUID generation
create extension if not exists "pgcrypto";

-- ============================================================
-- PRODUCTS
-- ============================================================
create table if not exists products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  brand text not null,
  description text not null default '',
  price numeric(12,2) not null check (price >= 0),
  image_url text,
  specifications jsonb not null default '{}'::jsonb,
  available boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_products_available on products (available);
create index if not exists idx_products_brand on products (brand);

-- ============================================================
-- CUSTOMERS
-- ============================================================
create table if not exists customers (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  phone text not null,
  whatsapp text not null,
  email text not null,
  address text,
  created_at timestamptz not null default now()
);

create index if not exists idx_customers_email on customers (email);
create index if not exists idx_customers_phone on customers (phone);

-- ============================================================
-- ORDERS
-- ============================================================
create table if not exists orders (
  id uuid primary key default gen_random_uuid(),
  order_reference text not null unique,
  customer_id uuid not null references customers (id) on delete restrict,
  total_amount numeric(12,2) not null check (total_amount >= 0),
  fulfillment_method text not null check (fulfillment_method in ('delivery', 'pickup')),
  delivery_address text,
  status text not null default 'New' check (status in ('New', 'Completed', 'Cancelled')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_orders_customer on orders (customer_id);
create index if not exists idx_orders_status on orders (status);
create index if not exists idx_orders_reference on orders (order_reference);

-- ============================================================
-- ORDER ITEMS
-- ============================================================
create table if not exists order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references orders (id) on delete cascade,
  product_id uuid not null references products (id) on delete restrict,
  quantity integer not null check (quantity > 0),
  price numeric(12,2) not null check (price >= 0), -- price snapshot at time of order
  created_at timestamptz not null default now()
);

create index if not exists idx_order_items_order on order_items (order_id);
create index if not exists idx_order_items_product on order_items (product_id);

-- ============================================================
-- updated_at auto-touch trigger
-- ============================================================
create or replace function set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_products_updated_at on products;
create trigger trg_products_updated_at
  before update on products
  for each row execute function set_updated_at();

drop trigger if exists trg_orders_updated_at on orders;
create trigger trg_orders_updated_at
  before update on orders
  for each row execute function set_updated_at();

-- ============================================================
-- ROW LEVEL SECURITY
-- Public (anon) can only READ available products.
-- All writes (products, orders, customers) happen server-side
-- using the service_role key, which bypasses RLS entirely.
-- This keeps checkout logic, pricing, and admin writes safe
-- even though the anon key is exposed in the browser.
-- ============================================================
alter table products enable row level security;
alter table customers enable row level security;
alter table orders enable row level security;
alter table order_items enable row level security;

-- Anyone (anon) can view available products only
create policy "Public can view available products"
  on products for select
  using (available = true);

-- No public policies on customers, orders, or order_items.
-- These tables are only ever touched via the server-side
-- service_role client (checkout API, admin dashboard),
-- which bypasses RLS by design.

-- ============================================================
-- SAMPLE PRODUCTS (6 categories, safe placeholder images)
-- ============================================================
insert into products (name, brand, description, price, image_url, specifications, available)
values
  (
    'Vantera Prime X1', 'Vantera',
    'Our premium flagship. Titanium frame, pro-grade camera system, and the fastest chip we have ever built.',
    1250000, 'https://images.unsplash.com/photo-1592286927505-1def25115481?w=800',
    '{"display":"6.7\" LTPO OLED, 120Hz","chip":"Vantera A7 Pro","storage":"512GB","camera":"50MP Triple Array","battery":"5000mAh"}',
    true
  ),
  (
    'Vantera Aria 5G', 'Vantera',
    'A balanced mid-range phone with flagship-level display quality and all-day battery life.',
    620000, 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
    '{"display":"6.4\" AMOLED, 90Hz","chip":"Vantera A5","storage":"256GB","camera":"48MP Dual","battery":"4800mAh"}',
    true
  ),
  (
    'Vantera Lite S', 'Vantera',
    'Essential performance and premium design, made accessible.',
    320000, 'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=800',
    '{"display":"6.1\" IPS LCD, 60Hz","chip":"Vantera A3","storage":"128GB","camera":"12MP Single","battery":"4200mAh"}',
    true
  ),
  (
    'Vantera Lens Pro', 'Vantera',
    'Built for photographers. A pro-grade optical system in your pocket.',
    980000, 'https://images.unsplash.com/photo-1567581935884-3349723552ca?w=800',
    '{"display":"6.5\" OLED, 120Hz","chip":"Vantera A6","storage":"512GB","camera":"108MP Quad with Optical Zoom","battery":"5100mAh"}',
    true
  ),
  (
    'Vantera Velocity', 'Vantera',
    'Engineered for speed. Built for mobile gaming and heavy multitasking.',
    890000, 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
    '{"display":"6.7\" AMOLED, 165Hz","chip":"Vantera A7 Gaming Edition","storage":"512GB","camera":"50MP Dual","battery":"5500mAh + Turbo Charge"}',
    true
  ),
  (
    'Vantera Fold Signature', 'Vantera',
    'Our first foldable. Two screens, one seamless premium experience.',
    2100000, 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=800',
    '{"display":"7.6\" Foldable AMOLED + 6.2\" Cover","chip":"Vantera A7 Pro","storage":"1TB","camera":"50MP Triple","battery":"4400mAh"}',
    true
  )
on conflict do nothing;
