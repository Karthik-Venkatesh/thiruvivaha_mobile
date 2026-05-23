-- ============================================================
-- FUNCTION: get_filtered_profiles
-- Returns paginated profiles matching the caller's partner
-- preferences, excluding profiles the caller has already
-- skipped, shortlisted, or sent/received a connection with.
--
-- Parameters:
--   p_limit  – page size  (default 20)
--   p_offset – row offset (default 0)
--
-- Client usage (supabase-flutter):
--   supabase.rpc('get_filtered_profiles',
--     params: {'p_limit': 20, 'p_offset': 0})
-- ============================================================

drop function if exists get_filtered_profiles(int, int);

create or replace function get_filtered_profiles(
  p_limit  int default 20,
  p_offset int default 0
)
returns table (
  id             uuid,
  full_name      text,
  date_of_birth  date,
  gender         text,
  religion       text,
  caste          text,
  education      text,
  occupation     text,
  annual_income  int,
  city           text,
  state          text,
  country        text,
  height_cm      int,
  complexion     text,
  diet           text,
  marital_status text,
  primary_photo  text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_caller_profile_id uuid;
  v_prefs             partner_preferences%rowtype;
  v_user_gender       text;
  v_target_gender     text;
begin
  -- ── 0. Resolve caller ─────────────────────────────────────────────────────
  select p.id
  into   v_caller_profile_id
  from   profiles p
  where  p.auth_user_id = auth.uid();

  if v_caller_profile_id is null then
    raise exception 'Profile not found for current user' using errcode = 'P0001';
  end if;

  -- ── 1. Caller gender → derive target gender ───────────────────────────────
  select p.gender::text
  into   v_user_gender
  from   profiles p
  where  p.id = v_caller_profile_id;

  v_target_gender := case
    when v_user_gender = 'Male'   then 'Female'
    when v_user_gender = 'Female' then 'Male'
    else null
  end;

  -- ── 2. Partner preferences ────────────────────────────────────────────────
  select pp.*
  into   v_prefs
  from   partner_preferences pp
  where  pp.profile_id = v_caller_profile_id;

  -- ── 3. Paginated filtered profiles ────────────────────────────────────────
  return query
  select
    p.id,
    p.full_name,
    p.date_of_birth,
    p.gender::text,
    p.religion,
    p.caste,
    p.education::text,
    p.occupation::text,
    p.annual_income,
    p.city,
    p.state,
    p.country,
    p.height_cm,
    p.complexion,
    p.diet::text,
    p.marital_status::text,
    ph.storage_path as primary_photo
  from   profiles p
  left join lateral (
    select storage_path
    from   photos
    where  profile_id = p.id
      and  is_primary  = true
    limit 1
  ) ph on true
  where
    -- Exclude the caller
    p.id <> v_caller_profile_id

    -- Active profiles only (treat NULL status as Active)
    and (p.profile_status = 'Active' or p.profile_status is null)

    -- ── Gender ────────────────────────────────────────────────────────────
    and (v_target_gender is null or p.gender::text = v_target_gender)

    -- ── Age ───────────────────────────────────────────────────────────────
    and (
      v_prefs.age_min is null
      or p.date_of_birth is null
      or extract(year from age(current_date, p.date_of_birth)) >= v_prefs.age_min
    )
    and (
      v_prefs.age_max is null
      or p.date_of_birth is null
      or extract(year from age(current_date, p.date_of_birth)) <= v_prefs.age_max
    )

    -- ── Height ────────────────────────────────────────────────────────────
    and (v_prefs.height_min_cm is null or p.height_cm is null or p.height_cm >= v_prefs.height_min_cm)
    and (v_prefs.height_max_cm is null or p.height_cm is null or p.height_cm <= v_prefs.height_max_cm)

    -- ── Religion & Caste ──────────────────────────────────────────────────
    and (v_prefs.religion is null or p.religion is null or p.religion = v_prefs.religion)
    and (v_prefs.caste    is null or p.caste    is null or p.caste    = v_prefs.caste)

    -- ── Education & Occupation ────────────────────────────────────────────
    and (v_prefs.education  is null or p.education  is null or p.education::text  = v_prefs.education::text)
    and (v_prefs.occupation is null or p.occupation is null or p.occupation::text = v_prefs.occupation::text)

    -- ── Income ────────────────────────────────────────────────────────────
    and (v_prefs.income_min is null or p.annual_income is null or p.annual_income >= v_prefs.income_min)

    -- ── Location ──────────────────────────────────────────────────────────
    and (
      v_prefs.location is null
      or p.city  is null
      or lower(p.city)  = lower(v_prefs.location)
      or lower(p.state) = lower(v_prefs.location)
    )

    -- ── Lifestyle ─────────────────────────────────────────────────────────
    and (v_prefs.diet           is null or p.diet           is null or p.diet::text           = v_prefs.diet::text)
    and (v_prefs.marital_status is null or p.marital_status is null or p.marital_status::text = v_prefs.marital_status::text)
    and (v_prefs.smoking        is null or p.smoking        is null or p.smoking::text        = v_prefs.smoking::text)
    and (v_prefs.drinking       is null or p.drinking       is null or p.drinking::text       = v_prefs.drinking::text)

    -- ── Exclusions ────────────────────────────────────────────────────────
    -- Not already skipped
    and not exists (
      select 1 from skipped_profiles sp
      where  sp.user_id    = v_caller_profile_id
        and  sp.profile_id = p.id
    )
    -- Not already shortlisted
    and not exists (
      select 1 from shortlisted_profiles sl
      where  sl.user_id    = v_caller_profile_id
        and  sl.profile_id = p.id
    )
    -- No existing connection (any status, either direction)
    and not exists (
      select 1 from connections cn
      where (cn.sender_id   = v_caller_profile_id and cn.receiver_id = p.id)
         or (cn.receiver_id = v_caller_profile_id and cn.sender_id   = p.id)
    )

  order by p.created_at desc
  limit  p_limit
  offset p_offset;
end;
$$;

grant execute on function get_filtered_profiles(int, int) to authenticated;
