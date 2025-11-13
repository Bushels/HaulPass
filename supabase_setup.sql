-- HaulPass Database Setup Script
-- Run this in your Supabase SQL Editor: https://supabase.com/dashboard/project/nwismkrgztbttlndylmu/sql

-- ============================================================================
-- STEP 1: Enable Extensions
-- ============================================================================

-- Enable PostGIS for location data
CREATE EXTENSION IF NOT EXISTS postgis;

-- ============================================================================
-- STEP 2: Create Tables
-- ============================================================================

-- User profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  truck_number TEXT,
  company TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Elevators table
CREATE TABLE IF NOT EXISTS elevators (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  company TEXT NOT NULL,
  location GEOGRAPHY(POINT, 4326) NOT NULL,
  address TEXT,
  phone_number TEXT,
  email TEXT,
  accepted_grains TEXT[],
  capacity_bushels INTEGER,
  dockage_rate DECIMAL(5,2),
  test_weight DECIMAL(5,2),
  operating_hours JSONB,
  contacts JSONB,
  amenities JSONB,
  is_active BOOLEAN DEFAULT true,
  last_updated TIMESTAMP DEFAULT NOW()
);

-- Elevator status table (for real-time updates)
CREATE TABLE IF NOT EXISTS elevator_status (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  elevator_id UUID REFERENCES elevators(id) ON DELETE CASCADE,
  current_lineup INTEGER DEFAULT 0,
  estimated_wait_time INTEGER DEFAULT 0,
  average_unload_time INTEGER DEFAULT 15,
  daily_capacity INTEGER DEFAULT 0,
  daily_processed INTEGER DEFAULT 0,
  current_grain_type TEXT,
  dockage_rate DECIMAL(5,2),
  status TEXT CHECK (status IN ('open', 'full', 'closed', 'maintenance')) DEFAULT 'open',
  last_updated TIMESTAMP DEFAULT NOW()
);

-- Location tracking table
CREATE TABLE IF NOT EXISTS location_tracks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id),
  session_id UUID,
  location GEOGRAPHY(POINT, 4326) NOT NULL,
  accuracy FLOAT,
  speed FLOAT,
  recorded_at TIMESTAMP DEFAULT NOW()
);

-- Hauling sessions table
CREATE TABLE IF NOT EXISTS hauling_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id),
  elevator_id UUID REFERENCES elevators(id),
  elevator_name TEXT NOT NULL,
  location GEOGRAPHY(POINT, 4326) NOT NULL,
  grain_type TEXT,
  start_time TIMESTAMP NOT NULL,
  end_time TIMESTAMP,
  total_duration_seconds INTEGER,
  status TEXT CHECK (status IN ('active', 'completed', 'cancelled')) DEFAULT 'active',
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Timer events table
CREATE TABLE IF NOT EXISTS timer_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID REFERENCES hauling_sessions(id) ON DELETE CASCADE,
  type TEXT CHECK (type IN ('start', 'pause', 'resume', 'complete', 'custom')) NOT NULL,
  description TEXT,
  timestamp TIMESTAMP DEFAULT NOW(),
  metadata JSONB
);

-- Wait time reports table (for improving predictions)
CREATE TABLE IF NOT EXISTS wait_time_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  elevator_id UUID REFERENCES elevators(id),
  user_id UUID REFERENCES profiles(id),
  reported_wait_time INTEGER NOT NULL,
  actual_wait_time INTEGER,
  grain_type TEXT,
  reported_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================================
-- STEP 3: Create Indexes for Performance
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_elevators_location ON elevators USING GIST (location);
CREATE INDEX IF NOT EXISTS idx_elevator_status_elevator_id ON elevator_status (elevator_id);
CREATE INDEX IF NOT EXISTS idx_location_tracks_user_time ON location_tracks (user_id, recorded_at);
CREATE INDEX IF NOT EXISTS idx_hauling_sessions_user ON hauling_sessions (user_id);
CREATE INDEX IF NOT EXISTS idx_wait_time_reports_elevator ON wait_time_reports (elevator_id, reported_at);

-- ============================================================================
-- STEP 4: Enable Row Level Security
-- ============================================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE hauling_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE location_tracks ENABLE ROW LEVEL SECURITY;
ALTER TABLE timer_events ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- STEP 5: Create RLS Policies
-- ============================================================================

-- Profiles policies
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Hauling sessions policies
CREATE POLICY "Users can view own sessions" ON hauling_sessions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own sessions" ON hauling_sessions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own sessions" ON hauling_sessions
  FOR UPDATE USING (auth.uid() = user_id);

-- Location tracks policies
CREATE POLICY "Users can view own locations" ON location_tracks
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own locations" ON location_tracks
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Timer events policies (through session ownership)
CREATE POLICY "Users can view own timer events" ON timer_events
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM hauling_sessions
      WHERE hauling_sessions.id = timer_events.session_id
      AND hauling_sessions.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own timer events" ON timer_events
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM hauling_sessions
      WHERE hauling_sessions.id = timer_events.session_id
      AND hauling_sessions.user_id = auth.uid()
    )
  );

-- ============================================================================
-- STEP 6: Insert Sample Data
-- ============================================================================

-- Insert sample elevators (Des Moines area)
INSERT INTO elevators (name, company, location, address, accepted_grains, is_active) VALUES
('Prairie Grain Elevator', 'Prairie Co-op', ST_SetSRID(ST_MakePoint(-93.6209, 41.5868), 4326), '123 Main St, Des Moines, IA', ARRAY['corn', 'soybeans', 'wheat'], true),
('Valley Grain Terminal', 'Valley Grain LLC', ST_SetSRID(ST_MakePoint(-93.8121, 41.5779), 4326), '456 Oak Ave, West Des Moines, IA', ARRAY['corn', 'soybeans'], true),
('Metro Grain Hub', 'Metro Grain Inc', ST_SetSRID(ST_MakePoint(-93.5987, 41.5448), 4326), '789 Commerce Dr, Ankeny, IA', ARRAY['corn', 'soybeans', 'wheat', 'oats'], true)
ON CONFLICT DO NOTHING;

-- Add sample elevator status for each elevator
INSERT INTO elevator_status (elevator_id, current_lineup, estimated_wait_time, status)
SELECT id, 0, 15, 'open' FROM elevators
ON CONFLICT DO NOTHING;

-- ============================================================================
-- Setup Complete!
-- ============================================================================
