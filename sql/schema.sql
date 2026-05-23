-- ============================================================
-- 🧨 CLEAN RESET (DEV ONLY)
-- Drops all app tables, functions, and enums
-- ============================================================

-- Drop dependent tables first (due to foreign keys)
drop table if exists messages cascade;
drop table if exists matches cascade;
drop table if exists connections cascade;
drop table if exists verifications cascade;
drop table if exists subscriptions cascade;
drop table if exists contact_details cascade;
drop table if exists partner_preferences cascade;
drop table if exists family_details cascade;
drop table if exists horoscopes cascade;
drop table if exists photos cascade;
drop table if exists profiles cascade;

-- Drop functions (triggers depend on these)
drop function if exists handle_new_user cascade;
drop function if exists set_updated_at cascade;
drop function if exists create_match_on_accept cascade;
drop function if exists handle_new_profile_contacts cascade;

-- Drop enums (must be dropped after tables)
drop type if exists gender_type cascade;
drop type if exists marital_status_type cascade;
drop type if exists family_type_enum cascade;
drop type if exists family_values_enum cascade;
drop type if exists family_status_type cascade;
drop type if exists diet_type cascade;
drop type if exists habit_type cascade;
drop type if exists profile_status_type cascade;
drop type if exists connection_status cascade;
drop type if exists verification_status cascade;
drop type if exists plan_status_type cascade;
drop type if exists plan_name_type cascade;
drop type if exists contact_type cascade;
drop type if exists education_type cascade;
drop type if exists occupation_type cascade;

-- ============================================================
-- EXTENSIONS
-- ============================================================

-- UUID generation + fuzzy search
create extension if not exists "uuid-ossp";
create extension if not exists "pg_trgm";

-- ============================================================
-- ENUM TYPES (STRICT VALUE CONTROL)
-- ============================================================

create type gender_type as enum ('Male', 'Female', 'Other');
create type marital_status_type as enum ('Never Married', 'Divorced', 'Widowed', 'Separated', 'Awaiting Divorce');
create type family_type_enum as enum ('Nuclear', 'Joint', 'Extended');
create type family_values_enum as enum ('Traditional', 'Moderate', 'Liberal');
create type family_status_type as enum ('Upper Class', 'Upper-Middle Class', 'Middle Class', 'Lower-Middle Class', 'Lower Class');
create type diet_type as enum ('Vegetarian', 'Non Vegetarian', 'Vegan', 'Eggetarian');
create type habit_type as enum ('No', 'Occasionally', 'Yes');
create type profile_status_type as enum ('Active', 'Inactive', 'Suspended', 'Deleted');
create type connection_status as enum ('Pending', 'Accepted', 'Rejected', 'Blocked');
create type verification_status as enum ('Pending', 'Verified', 'Rejected');
create type plan_status_type as enum ('Active', 'Expired', 'Cancelled');
create type plan_name_type as enum ('Free', 'Silver', 'Gold', 'Platinum');
create type contact_type as enum ('Phone', 'Email');
create type education_type as enum ('High School', 'Diploma', 'Bachelor''s Degree', 'Master''s Degree', 'PhD / Doctorate', 'Professional Degree (CA / MBBS / LLB)');
create type occupation_type as enum ('Engineering / IT', 'Doctor / Medical', 'Business / Entrepreneur', 'Government / PSU', 'Finance / Banking', 'Law', 'Teaching / Academia', 'Arts / Design / Media', 'Other');

-- ============================================================
-- PROFILES (CORE USER DATA)
-- Minimal required fields to avoid trigger failure
-- ============================================================

create table profiles (
  id uuid primary key default uuid_generate_v4(),

  -- Linked to Supabase auth user
  auth_user_id uuid references auth.users(id) on delete cascade unique not null,

  -- Basic identity
  full_name text not null default 'New User',

  -- Personal info (optional → filled later)
  date_of_birth date,
  gender gender_type,
  religion text,
  caste text,
  subcaste text,
  mother_tongue text,
  marital_status marital_status_type default 'Never Married',
  children_count int default 0,

  -- Physical attributes
  height_cm int,
  weight_kg int,
  complexion text,
  physical_status text,

  -- Location
  country text,
  state text,
  city text,
  citizenship text,
  willing_to_relocate bool default false,

  -- Career
  education education_type,
  institution text,
  occupation occupation_type,
  employer text,
  annual_income int,

  -- Lifestyle
  diet diet_type,
  smoking habit_type default 'No',
  drinking habit_type default 'No',

  -- App state
  profile_status profile_status_type default 'Active',

  -- Auth flags
  is_google_login bool default false,   -- true if signed up via Google OAuth
  name_changed bool default false,      -- tracks if user has used their one-time name change

  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Indexes for faster filtering/search
create index idx_profiles_city on profiles(city);
create index idx_profiles_gender on profiles(gender);
create index idx_profiles_dob on profiles(date_of_birth);
create index idx_profiles_name_trgm on profiles using gin(full_name gin_trgm_ops);

-- ============================================================
-- PHOTOS (PROFILE IMAGES)
-- ============================================================

create table photos (
  id uuid primary key default uuid_generate_v4(),
  profile_id uuid references profiles(id) on delete cascade,
  storage_path text not null,  -- Supabase storage path
  is_primary bool default false,
  sort_order int default 0,
  uploaded_at timestamptz default now()
);

-- ============================================================
-- HOROSCOPES (IMPORTANT FOR MATRIMONY)
-- ============================================================

create table horoscopes (
  id uuid primary key default uuid_generate_v4(),
  profile_id uuid references profiles(id) on delete cascade unique,
  birth_time time,
  birth_place text,
  rashi text,
  nakshatra text,
  is_manglik bool default false,
  gotra text,
  horoscope_doc_path text
);

-- ============================================================
-- FAMILY DETAILS
-- ============================================================

create table family_details (
  id uuid primary key default uuid_generate_v4(),
  profile_id uuid references profiles(id) on delete cascade unique,
  father_name text,
  father_occupation text,
  mother_name text,
  mother_occupation text,
  siblings_count int default 0,
  family_type family_type_enum,
  family_values family_values_enum,
  family_status family_status_type
);

-- ============================================================
-- PARTNER PREFERENCES (MATCH FILTERS)
-- ============================================================

create table partner_preferences (
  id uuid primary key default uuid_generate_v4(),
  profile_id uuid references profiles(id) on delete cascade unique,

  age_min int,
  age_max int,
  height_min_cm int,
  height_max_cm int,

  religion text,
  caste text,
  education education_type,
  occupation occupation_type,
  income_min int,
  location text,

  diet diet_type,
  marital_status marital_status_type,
  smoking habit_type,
  drinking habit_type
);

-- ============================================================
-- CONNECTIONS (INTEREST REQUESTS)
-- ============================================================

create table connections (
  id uuid primary key default uuid_generate_v4(),
  sender_id uuid references profiles(id) on delete cascade,
  receiver_id uuid references profiles(id) on delete cascade,

  status connection_status default 'Pending',
  message text,

  created_at timestamptz default now(),
  updated_at timestamptz default now(),

  -- Prevent self-request
  constraint no_self check (sender_id <> receiver_id),

  -- Prevent duplicate requests
  constraint unique_connection unique (sender_id, receiver_id)
);

-- ============================================================
-- MATCHES (MUTUAL ACCEPTANCE)
-- ============================================================

create table matches (
  id uuid primary key default uuid_generate_v4(),
  profile_a_id uuid references profiles(id) on delete cascade,
  profile_b_id uuid references profiles(id) on delete cascade,

  compatibility_score int,
  matched_at timestamptz default now(),

  constraint unique_match unique (profile_a_id, profile_b_id)
);

-- ============================================================
-- MESSAGES (CHAT SYSTEM)
-- ============================================================

create table messages (
  id uuid primary key default uuid_generate_v4(),
  match_id uuid references matches(id) on delete cascade,
  sender_id uuid references profiles(id) on delete cascade,
  content text not null,
  is_read bool default false,
  sent_at timestamptz default now()
);

-- ============================================================
-- SUBSCRIPTIONS (MONETIZATION)
-- ============================================================

create table subscriptions (
  id uuid primary key default uuid_generate_v4(),
  profile_id uuid references profiles(id) on delete cascade,
  plan_name plan_name_type default 'Free',
  status plan_status_type default 'Active',
  starts_at timestamptz default now(),
  expires_at timestamptz,
  payment_ref text
);

-- ============================================================
-- VERIFICATIONS (TRUST SYSTEM)
-- ============================================================

create table verifications (
  id uuid primary key default uuid_generate_v4(),
  profile_id uuid references profiles(id) on delete cascade,
  type text, -- aadhaar, passport, etc.
  doc_path text,
  status verification_status default 'Pending',
  verified_at timestamptz,
  notes text
);

-- ============================================================
-- CONTACT DETAILS (PHONE NUMBERS & EMAILS)
-- ============================================================

create table contact_details (
  id uuid primary key default uuid_generate_v4(),
  profile_id uuid references profiles(id) on delete cascade not null,
  contact_type contact_type not null,
  value text not null,           -- phone number or email address
  is_primary bool default false,
  is_verified bool default false,
  created_at timestamptz default now()
);

create index idx_contact_details_profile on contact_details(profile_id);
create index idx_contact_details_type on contact_details(contact_type);

-- ============================================================
-- SHORTLISTED PROFILES (USER FAVORITES)
-- ============================================================

create table shortlisted_profiles (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references profiles(id) on delete cascade not null,
  profile_id uuid references profiles(id) on delete cascade not null,
  
  notes text,
  
  created_at timestamptz default now(),
  updated_at timestamptz default now(),

  -- Prevent duplicate shortlists
  constraint unique_shortlist unique (user_id, profile_id),
  
  -- Prevent self-shortlist
  constraint no_self_shortlist check (user_id <> profile_id)
);

create index idx_shortlisted_user on shortlisted_profiles(user_id);
create index idx_shortlisted_profile on shortlisted_profiles(profile_id);
create index idx_shortlisted_created on shortlisted_profiles(created_at);

-- ============================================================
-- SKIPPED PROFILES (USER REJECTIONS)
-- ============================================================

create table skipped_profiles (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references profiles(id) on delete cascade not null,
  profile_id uuid references profiles(id) on delete cascade not null,
  
  reason text,  -- optional: why they skipped (not interested, no match, etc.)
  
  created_at timestamptz default now(),

  -- Prevent duplicate skips
  constraint unique_skip unique (user_id, profile_id),
  
  -- Prevent self-skip
  constraint no_self_skip check (user_id <> profile_id)
);

create index idx_skipped_user on skipped_profiles(user_id);
create index idx_skipped_profile on skipped_profiles(profile_id);
create index idx_skipped_created on skipped_profiles(created_at);

-- ============================================================
-- TRIGGERS
-- ============================================================

-- Auto-update updated_at column
create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger trg_profiles_updated
before update on profiles
for each row execute function set_updated_at();

create trigger trg_connections_updated
before update on connections
for each row execute function set_updated_at();

-- ============================================================
-- AUTO INSERT CONTACT DETAILS ON PROFILE CREATION
-- ============================================================

create or replace function handle_new_profile_contacts()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_email text;
  v_phone text;
begin
  -- Fetch email and phone from auth.users
  select email, phone
  into v_email, v_phone
  from auth.users
  where id = new.auth_user_id;

  -- Insert email if present
  if v_email is not null and v_email <> '' then
    insert into contact_details (profile_id, contact_type, value, is_primary)
    values (new.id, 'Email', v_email, true);
  end if;

  -- Insert phone if present
  if v_phone is not null and v_phone <> '' then
    insert into contact_details (profile_id, contact_type, value, is_primary)
    values (new.id, 'Phone', v_phone, true);
  end if;

  return new;

exception
  when others then
    raise warning 'Contact insert failed for profile %: %', new.id, sqlerrm;
    return new;
end;
$$;

create trigger trg_new_profile_contacts
after insert on profiles
for each row execute function handle_new_profile_contacts();

-- ============================================================
-- SAFE AUTH → PROFILE CREATION (CRITICAL)
-- ============================================================

create or replace function handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  full_name_val text;
  is_google_val bool;
begin
  -- Extract full_name from user_metadata, default to 'New User'
  full_name_val := coalesce(new.raw_user_meta_data ->> 'full_name', 'New User');
  
  -- Check if provider is 'google' in app_metadata
  is_google_val := coalesce(new.raw_app_meta_data ->> 'provider', '') = 'google';

  insert into public.profiles (auth_user_id, full_name, is_google_login)
  values (new.id, full_name_val, is_google_val)
  on conflict (auth_user_id) do nothing;

  return new;

exception
  when others then
    -- Log the error for debugging
    raise warning 'Profile creation failed for user %: %', new.id, sqlerrm;
    return new;
end;
$$;

create trigger trg_auth_user_created
after insert on auth.users
for each row execute function handle_new_user();

-- ============================================================
-- AUTO MATCH CREATION
-- ============================================================

create or replace function create_match_on_accept()
returns trigger language plpgsql as $$
begin
  if new.status = 'Accepted' then
    insert into matches (profile_a_id, profile_b_id)
    values (
      least(new.sender_id, new.receiver_id),
      greatest(new.sender_id, new.receiver_id)
    )
    on conflict do nothing;
  end if;
  return new;
end;
$$;

create trigger trg_match
after update on connections
for each row execute function create_match_on_accept();

-- ============================================================
-- ✅ END OF SCHEMA
-- ============================================================

this is the table schema in the supabase.