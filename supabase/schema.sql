-- ============================================================
-- 特寶寶旅遊助手 Schema（自動產生，請勿手動編輯）
-- 更新時間：2026-05-14T04:36:51.266Z
-- ============================================================

-- attractions
CREATE TABLE attractions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL,
  category text NOT NULL DEFAULT '自然景觀'::text,
  name text NOT NULL,
  description text,
  map_url text,
  created_at timestamp with time zone DEFAULT now()
);

-- currencies
CREATE TABLE currencies (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL,
  code text NOT NULL,
  name text NOT NULL,
  rate_to_twd numeric NOT NULL DEFAULT 1,
  is_default boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now()
);

-- expenses
CREATE TABLE expenses (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL,
  category text NOT NULL DEFAULT '飲食'::text,
  name text NOT NULL,
  amount numeric NOT NULL,
  currency_id uuid NOT NULL,
  amount_twd numeric NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  date date
);

-- packing_items
CREATE TABLE packing_items (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL,
  name text NOT NULL,
  is_packed boolean DEFAULT false,
  sort_order integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now()
);

-- profiles
CREATE TABLE profiles (
  id uuid NOT NULL,
  username text NOT NULL,
  created_at timestamp with time zone DEFAULT now()
);

-- restaurants
CREATE TABLE restaurants (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL,
  category text NOT NULL DEFAULT '正餐'::text,
  name text NOT NULL,
  description text,
  map_url text,
  created_at timestamp with time zone DEFAULT now()
);

-- schedule_items
CREATE TABLE schedule_items (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL,
  date date NOT NULL,
  time time without time zone NOT NULL,
  title text NOT NULL,
  notes text,
  map_url text,
  photo_url text,
  sort_order integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now()
);

-- stays
CREATE TABLE stays (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL,
  date date NOT NULL,
  name text NOT NULL,
  room_type text,
  check_in_time text,
  check_out_time text,
  breakfast boolean DEFAULT false,
  phone text,
  map_url text,
  booking_url text,
  created_at timestamp with time zone DEFAULT now()
);

-- transport_details
CREATE TABLE transport_details (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  group_id uuid NOT NULL,
  date date NOT NULL,
  from_location text,
  to_location text,
  depart_time time without time zone,
  arrive_time time without time zone,
  operator text,
  vehicle_no text,
  vehicle_sub text,
  seat_info text,
  booking_url text,
  platform text,
  store_map_url text,
  phone text,
  notes text,
  return_date date,
  return_time time without time zone,
  created_at timestamp with time zone DEFAULT now()
);

-- transport_groups
CREATE TABLE transport_groups (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL,
  type text NOT NULL,
  created_at timestamp with time zone DEFAULT now()
);

-- trip_collaborators
CREATE TABLE trip_collaborators (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL,
  user_id uuid NOT NULL,
  role text NOT NULL DEFAULT 'editor'::text,
  joined_at timestamp with time zone DEFAULT now()
);

-- trip_day_photos
CREATE TABLE trip_day_photos (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL,
  date date NOT NULL,
  photo_url text NOT NULL,
  sort_order integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now()
);

-- trips
CREATE TABLE trips (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  owner_id uuid NOT NULL,
  title text NOT NULL,
  emoji text,
  start_date date NOT NULL,
  end_date date NOT NULL,
  share_token text DEFAULT (gen_random_uuid())::text,
  created_at timestamp with time zone DEFAULT now(),
  destination text
);

