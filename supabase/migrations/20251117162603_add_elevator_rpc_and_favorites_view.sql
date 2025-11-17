-- Add PostGIS RPC function for nearby elevators
-- Uses ST_DWithin for efficient spatial queries

CREATE OR REPLACE FUNCTION get_elevators_near(
  lat DOUBLE PRECISION,
  lng DOUBLE PRECISION,
  radius_km DOUBLE PRECISION DEFAULT 50.0,
  max_results INTEGER DEFAULT 25
)
RETURNS TABLE (
  id BIGINT,
  name TEXT,
  company TEXT,
  address TEXT,
  location GEOGRAPHY,
  capacity_tonnes NUMERIC,
  grain_types TEXT[],
  railway TEXT,
  elevator_type TEXT,
  car_spots TEXT,
  created_at TIMESTAMP WITH TIME ZONE,
  distance_km DOUBLE PRECISION
)
LANGUAGE sql
STABLE
AS $$
  SELECT
    e.id,
    e.name,
    e.company,
    e.address,
    e.location,
    e.capacity_tonnes,
    e.grain_types,
    e.railway,
    e.elevator_type,
    e.car_spots,
    e.created_at,
    -- Calculate distance in kilometers using ST_Distance
    ROUND(
      (ST_Distance(
        e.location,
        ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography
      ) / 1000.0)::numeric,
      2
    ) AS distance_km
  FROM elevators_import e
  WHERE
    -- Use ST_DWithin for efficient spatial filtering (meters)
    ST_DWithin(
      e.location,
      ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography,
      radius_km * 1000.0  -- Convert km to meters
    )
  ORDER BY
    -- Order by distance (nearest first)
    e.location <-> ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography
  LIMIT max_results;
$$;

-- Add comment explaining the function
COMMENT ON FUNCTION get_elevators_near IS
'Find grain elevators within a specified radius of a lat/lng point. Returns elevators ordered by distance with calculated distance_km column.';


-- Create favorites view with is_favorite flag
-- This view joins elevators_import with favorite_elevators for the current user

CREATE OR REPLACE VIEW elevators_with_favorites AS
SELECT
  e.id,
  e.name,
  e.company,
  e.address,
  e.location,
  e.capacity_tonnes,
  e.grain_types,
  e.railway,
  e.elevator_type,
  e.car_spots,
  e.created_at,
  -- Check if this elevator is favorited by current user
  CASE
    WHEN f.elevator_id IS NOT NULL THEN true
    ELSE false
  END AS is_favorite,
  -- Include favorite metadata if exists
  f.created_at AS favorited_at,
  f.notes AS favorite_notes
FROM elevators_import e
LEFT JOIN favorite_elevators f
  ON e.id = f.elevator_id
  AND f.user_id = auth.uid();

-- Add comment explaining the view
COMMENT ON VIEW elevators_with_favorites IS
'Elevators with is_favorite flag for the current authenticated user. Left join ensures all elevators are shown regardless of favorite status.';

-- Grant access to authenticated users
GRANT SELECT ON elevators_with_favorites TO authenticated;
GRANT SELECT ON elevators_with_favorites TO anon;
