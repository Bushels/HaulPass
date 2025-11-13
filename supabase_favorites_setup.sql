-- Create favorite_elevators table for user's favorited elevators
CREATE TABLE IF NOT EXISTS favorite_elevators (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  elevator_id BIGINT NOT NULL REFERENCES elevators_import(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  notes TEXT,
  UNIQUE(user_id, elevator_id)
);

-- Add RLS policies for favorite_elevators
ALTER TABLE favorite_elevators ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own favorites
CREATE POLICY "Users can view their own favorites"
  ON favorite_elevators
  FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: Users can add their own favorites
CREATE POLICY "Users can add their own favorites"
  ON favorite_elevators
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can delete their own favorites
CREATE POLICY "Users can delete their own favorites"
  ON favorite_elevators
  FOR DELETE
  USING (auth.uid() = user_id);

-- Policy: Users can update their own favorites (notes)
CREATE POLICY "Users can update their own favorites"
  ON favorite_elevators
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_favorite_elevators_user_id ON favorite_elevators(user_id);
CREATE INDEX IF NOT EXISTS idx_favorite_elevators_elevator_id ON favorite_elevators(elevator_id);
CREATE INDEX IF NOT EXISTS idx_favorite_elevators_created_at ON favorite_elevators(created_at DESC);

-- Update statistics
ANALYZE favorite_elevators;
