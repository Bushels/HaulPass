# HaulPass 2.0 - Setup Instructions

## 🚀 Quick Start Guide

This guide will get HaulPass 2.0 running on your local machine and ready for alpha testing.

## Prerequisites

- Flutter SDK 3.19.0 or higher
- Dart SDK 3.3.0 or higher
- Android Studio / VS Code with Flutter extensions
- Supabase account (free tier available)

## Step 1: Environment Setup

### Install Flutter
```bash
# Download and install Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

### Install Dependencies
```bash
cd haulpass_new
flutter pub get
```

## Step 2: Supabase Backend Setup

### Create Supabase Project
1. Go to [supabase.com](https://supabase.com)
2. Create a new account or sign in
3. Create a new project
4. Note your project URL and anon key

### Configure Environment
```bash
# Copy environment template
cp .env.example .env

# Edit .env with your Supabase credentials
```

Create `.env` file:
```env
# Supabase Configuration
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
SUPABASE_SERVICE_KEY=your-service-role-key-here

# Development Settings
ENABLE_DEBUG_LOGGING=true
ENABLE_ANALYTICS=false
ENABLE_CRASH_REPORTING=false
```

### Database Setup
Run these SQL commands in your Supabase SQL editor:

```sql
-- Enable PostGIS for location data
CREATE EXTENSION IF NOT EXISTS postgis;

-- User profiles table
CREATE TABLE profiles (
  id UUID REFERENCES auth.users PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  truck_number TEXT,
  company TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Elevators table
CREATE TABLE elevators (
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
CREATE TABLE elevator_status (
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
CREATE TABLE location_tracks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id),
  session_id UUID,
  location GEOGRAPHY(POINT, 4326) NOT NULL,
  accuracy FLOAT,
  speed FLOAT,
  recorded_at TIMESTAMP DEFAULT NOW()
);

-- Hauling sessions table
CREATE TABLE hauling_sessions (
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
CREATE TABLE timer_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID REFERENCES hauling_sessions(id) ON DELETE CASCADE,
  type TEXT CHECK (type IN ('start', 'pause', 'resume', 'complete', 'custom')) NOT NULL,
  description TEXT,
  timestamp TIMESTAMP DEFAULT NOW(),
  metadata JSONB
);

-- Wait time reports table (for improving predictions)
CREATE TABLE wait_time_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  elevator_id UUID REFERENCES elevators(id),
  user_id UUID REFERENCES profiles(id),
  reported_wait_time INTEGER NOT NULL,
  actual_wait_time INTEGER,
  grain_type TEXT,
  reported_at TIMESTAMP DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX idx_elevators_location ON elevators USING GIST (location);
CREATE INDEX idx_elevator_status_elevator_id ON elevator_status (elevator_id);
CREATE INDEX idx_location_tracks_user_time ON location_tracks (user_id, recorded_at);
CREATE INDEX idx_hauling_sessions_user ON hauling_sessions (user_id);
CREATE INDEX idx_wait_time_reports_elevator ON wait_time_reports (elevator_id, reported_at);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE hauling_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE location_tracks ENABLE ROW LEVEL SECURITY;
ALTER TABLE timer_events ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can view own sessions" ON hauling_sessions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own sessions" ON hauling_sessions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own sessions" ON hauling_sessions
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can view own locations" ON location_tracks
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own locations" ON location_tracks
  FOR INSERT WITH CHECK (auth.uid() = user_id);
```

### Add Sample Data
```sql
-- Insert sample elevators
INSERT INTO elevators (name, company, location, address, accepted_grains, is_active) VALUES
('Prairie Grain Elevator', 'Prairie Co-op', ST_SetSRID(ST_MakePoint(-93.6209, 41.5868), 4326), '123 Main St, Des Moines, IA', ARRAY['corn', 'soybeans', 'wheat'], true),
('Valley Grain Terminal', 'Valley Grain LLC', ST_SetSRID(ST_MakePoint(-93.8121, 41.5779), 4326), '456 Oak Ave, West Des Moines, IA', ARRAY['corn', 'soybeans'], true),
('Metro Grain Hub', 'Metro Grain Inc', ST_SetSRID(ST_MakePoint(-93.5987, 41.5448), 4326), '789 Commerce Dr, Ankeny, IA', ARRAY['corn', 'soybeans', 'wheat', 'oats'], true);

-- Add sample elevator status
INSERT INTO elevator_status (elevator_id, current_lineup, estimated_wait_time, status) 
SELECT id, 0, 15, 'open' FROM elevators;
```

## Step 3: Build and Run

### Generate Code
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Run Web Version
```bash
flutter run -d chrome
```

### Run Mobile Version
```bash
flutter run -d android  # For Android
flutter run -d ios      # For iOS (requires Xcode)
```

### Build for Production
```bash
# Web build
flutter build web --release --web-renderer html

# Android APK
flutter build apk --release

# iOS (requires Xcode)
flutter build ios --release
```

## Step 4: Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Test on Multiple Devices
```bash
flutter run -d chrome
flutter run -d android
flutter run -d ios
```

## Troubleshooting

### Common Issues

#### Build Errors
```bash
# Clean build
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs

# Clear cache
flutter pub cache clean
flutter pub get
```

#### Supabase Connection Issues
- Check your `.env` file has correct Supabase URL and keys
- Ensure your Supabase project is active
- Verify Row Level Security policies are set up correctly

#### Location Services Issues
- Android: Check location permissions in device settings
- iOS: Enable "While Using the App" location permission
- Web: Allow location access in browser

#### Performance Issues
- Run `flutter analyze` to check for code issues
- Check memory usage with `flutter run --profile`
- Test on multiple devices for performance consistency

## Deployment

### Web Deployment (Recommended for Alpha)
```bash
# Build web version
flutter build web --release --web-renderer html

# Deploy to Netlify, Vercel, or your hosting service
# Upload the build/web/ directory
```

### Mobile App Stores
```bash
# Android Play Store
flutter build appbundle --release

# iOS App Store
flutter build ipa --release
```

## Support

- **Technical Issues**: Check the troubleshooting section above
- **Flutter Documentation**: https://docs.flutter.dev/
- **Supabase Documentation**: https://supabase.com/docs
- **HaulPass Support**: help@haulpass.com

## Next Steps

1. **Set up Supabase backend** using the instructions above
2. **Test core features** (authentication, elevator search, GPS tracking)
3. **Gather feedback** from alpha testers
4. **Iterate and improve** based on user feedback

---

**Happy coding! 🚀**
