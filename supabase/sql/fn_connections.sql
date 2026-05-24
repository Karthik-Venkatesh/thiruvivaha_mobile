-- ============================================================
-- FUNCTION: get_connections
-- Returns connections for the current user, filtered by type:
--   'received' – others who sent to me (Pending only)
--   'sent'     – I sent to others  (Pending only)
--   'accepted' – mutually accepted
--   'rejected' – rejected requests
--
-- Client usage:
--   supabase.rpc('get_connections', params: {'p_type': 'received'})
-- ============================================================

drop function if exists get_connections(text);

create or replace function get_connections(p_type text default 'received')
returns table (
  connection_id  uuid,
  profile_id     uuid,
  full_name      text,
  date_of_birth  date,
  occupation     text,
  city           text,
  state          text,
  primary_photo  text,
  message        text,
  created_at     timestamptz,
  is_sender      boolean   -- true if current user sent the request
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_caller_profile_id uuid;
begin
  select p.id into v_caller_profile_id
  from   profiles p
  where  p.auth_user_id = auth.uid();

  if v_caller_profile_id is null then
    raise exception 'Profile not found for current user' using errcode = 'P0001';
  end if;

  return query
  select
    c.id          as connection_id,
    p.id          as profile_id,
    p.full_name,
    p.date_of_birth,
    p.occupation::text,
    p.city,
    p.state,
    ph.storage_path as primary_photo,
    c.message,
    c.created_at,
    (c.sender_id = v_caller_profile_id) as is_sender
  from   connections c
  join   profiles p on (
    -- always join the OTHER person's profile
    p.id = case
      when p_type = 'received' then c.sender_id
      when p_type = 'sent'     then c.receiver_id
      -- accepted / rejected: pick whichever side is NOT the caller
      when c.sender_id = v_caller_profile_id then c.receiver_id
      else c.sender_id
    end
  )
  left join lateral (
    select storage_path from photos
    where  photos.profile_id = p.id and photos.is_primary = true
    limit  1
  ) ph on true
  where
    case p_type
      when 'received' then c.receiver_id = v_caller_profile_id and c.status = 'Pending'
      when 'sent'     then c.sender_id   = v_caller_profile_id and c.status = 'Pending'
      when 'accepted' then (c.sender_id = v_caller_profile_id or c.receiver_id = v_caller_profile_id)
                       and c.status = 'Accepted'
      when 'rejected' then (c.sender_id = v_caller_profile_id or c.receiver_id = v_caller_profile_id)
                       and c.status = 'Rejected'
      else false
    end
  order by c.created_at desc;
end;
$$;

grant execute on function get_connections(text) to authenticated;

-- ============================================================
-- FUNCTION: respond_to_connection
-- Accept or reject a received connection request.
--
-- Client usage:
--   supabase.rpc('respond_to_connection',
--     params: {'p_connection_id': '...', 'p_accept': true})
-- ============================================================

drop function if exists respond_to_connection(uuid, boolean);

create or replace function respond_to_connection(
  p_connection_id uuid,
  p_accept        boolean
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_caller_profile_id uuid;
begin
  select p.id into v_caller_profile_id
  from   profiles p
  where  p.auth_user_id = auth.uid();

  if v_caller_profile_id is null then
    raise exception 'Profile not found for current user' using errcode = 'P0001';
  end if;

  update connections
  set    status = case when p_accept then 'Accepted'::connection_status
                       else               'Rejected'::connection_status
                  end
  where  id          = p_connection_id
    and  receiver_id = v_caller_profile_id   -- can only respond to requests sent TO me
    and  status      = 'Pending';

  if not found then
    raise exception 'Connection not found or not actionable' using errcode = 'P0002';
  end if;
end;
$$;

grant execute on function respond_to_connection(uuid, boolean) to authenticated;
