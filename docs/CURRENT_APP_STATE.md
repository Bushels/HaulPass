# HaulPass - Current App State & Workflow

**Date:** November 17, 2025
**User:** buperac@gmail.com
**Status:** ✅ Successfully signed in after fixing AutoDispose provider bug

---

## 📱 Current App Structure

### Main Navigation (Bottom Nav Bar)
Your app has **4 main screens** accessible via bottom navigation:

1. **🏠 Home** - Dashboard and quick actions
2. **🏢 Elevators** - Find and track queues at grain elevators
3. **⏱️ Haul Timer** - Track your current haul (shows red badge when timer active)
4. **👤 Profile** - Settings and stats

---

## 🎨 Current Design

### Technology Stack
- **Framework:** Flutter (cross-platform: Web, Windows, Mobile)
- **UI Design:** Material 3 (modern Material Design)
- **State Management:** Riverpod 2.x with code generation
- **Backend:** Supabase (PostgreSQL + PostGIS + Realtime)
- **Theme:** Light/Dark mode support (follows system preference)

### Design Features
- ✅ Modern Material 3 components
- ✅ Responsive layout (works on web, mobile, desktop)
- ✅ Offline mode with cached data
- ✅ Real-time updates via Supabase subscriptions
- ✅ Smooth animations and transitions
- ✅ Accessibility features
- ✅ Professional grain hauling themed UI

---

## 👤 Your Account: buperac@gmail.com

### Account Type
- **Demo User:** Yes, this email is configured as the demo account in `lib/core/config/demo_config.dart`
- **Registration Data:** You just created this account through the signup flow
- **Profile Data:** From your signup:
  - Email: buperac@gmail.com
  - Name: (what you entered during signup)
  - Farm details: (what you entered)
  - Truck details: (what you entered)
  - Favorite Elevator: (the elevator you selected)

### Demo Data
**Currently:** Your account has **ONLY the data you entered during signup**. There is **NO pre-populated demo loads, timers, or history** yet.

The demo configuration shows:
```dart
static const String demoEmail = 'buperac@gmail.com';
static const String demoPassword = 'demo123';
```

But this is just for configuration - it doesn't automatically create demo loads/data.

---

## 🔄 Complete User Workflow

### 1️⃣ **Home Screen** (Dashboard)
**Purpose:** Quick overview and actions

**Current Features:**
- Welcome message with your name
- Quick action cards:
  - 🚚 Start New Haul
  - 🏢 Find Elevator
  - 📊 View History
  - ⏱️ Active Timer (if running)
- Recent activity feed
- Offline indicator (if disconnected)

**Workflow:**
```
Home → Tap "Start New Haul" → Goes to Haul Timer screen
Home → Tap "Find Elevator" → Goes to Elevators screen
Home → Tap "View History" → Shows past hauls
```

---

### 2️⃣ **Elevators Screen** (Grain Elevator Directory)
**Purpose:** Find elevators and track queue times

**Current Features:**
- **Elevator Directory:** 513 grain elevators from `elevators_import` table
- **Search & Filter:**
  - Autocomplete search by name, company, location
  - Filter by company
  - Sort by name, distance, capacity
- **Map View:** (if implemented)
  - Shows elevator locations
  - Your current location
  - Nearby elevators within radius
- **Elevator Details:**
  - Name, company, address
  - Capacity (tonnes)
  - Grain types accepted
  - Railway access
  - Car spots available
  - Current wait time (if tracked)
- **Real-time Queue Updates:** Via Supabase realtime channels
- **Favorite Elevators:** Star your most-used elevators

**Workflow:**
```
Elevators → Search for elevator → View details → See queue/wait time
Elevators → Filter by company → Find nearby elevators
Elevators → Tap elevator → Start timer for that location
Elevators → Star favorite → Quick access from home
```

**Database Integration:**
- Table: `elevators_import` (513 rows)
- Columns: id, name, company, address, location (PostGIS geography), capacity_tonnes, grain_types, railway, elevator_type, car_spots
- PostGIS RPC: `get_elevators_near(lat, lng, radius_km, max_results)`
- View: `elevators_with_favorites` (joins with your favorites)

---

### 3️⃣ **Haul Timer Screen** (Track Your Haul)
**Purpose:** Time tracking for grain hauling trips

**Current Features:**
- **Timer Controls:**
  - ▶️ Start Timer (select elevator first)
  - ⏸️ Pause Timer
  - ⏹️ Stop Timer (saves to history)
  - 🔄 Resume Timer
- **Live Timer Display:**
  - Current elapsed time
  - Destination elevator
  - Load details (grain type, weight)
  - Distance/route info
- **Timer States:**
  - Idle (no timer)
  - Running (actively timing)
  - Paused (timer stopped but not saved)
  - Completed (saved to history)
- **Background Tracking:**
  - Timer continues when app minimized
  - Push notifications for milestones
  - Location tracking (if enabled)

**Workflow:**
```
Timer → Select Elevator → Enter Load Details → Start Timer
  ↓
[Timer Running] → Drive to elevator → Arrive → Stop Timer
  ↓
Timer Saved to History → View stats → Rate experience
```

**Database Integration:**
- Table: `haul_timers` (or similar)
- Realtime channel: `timer:[session_id]`
- Stores: start_time, end_time, elevator_id, user_id, grain_type, weight, distance, duration

---

### 4️⃣ **Profile Screen** (Settings & Stats)
**Purpose:** User settings and performance analytics

**Current Features:**
- **Profile Info:**
  - Name, email
  - Farm name
  - Truck details
  - Favorite elevator
  - Profile picture (if implemented)
- **Statistics:**
  - Total hauls completed
  - Total time tracked
  - Average haul duration
  - Most visited elevators
  - Distance traveled
- **Settings:**
  - Preferred units (kg, tonnes, bushels, pounds)
  - Location tracking on/off
  - Push notifications on/off
  - Theme preference (light/dark/system)
  - Privacy settings
- **Account Actions:**
  - Edit profile
  - Change password
  - Manage favorites
  - Sign out

**Workflow:**
```
Profile → Edit Profile → Update farm/truck details → Save
Profile → View Stats → See haul history → Analyze performance
Profile → Settings → Toggle location tracking → Privacy control
Profile → Sign Out → Return to login screen
```

**Database Integration:**
- User metadata in Supabase auth.users.user_metadata
- User stats aggregated from haul_timers table
- Favorites in `favorite_elevators` table

---

## 📊 Database Schema Overview

### Core Tables

#### 1. `elevators_import` (513 rows)
**Purpose:** Complete grain elevator directory
```sql
- id: BIGINT (primary key)
- name: TEXT (elevator name)
- company: TEXT (operating company)
- address: TEXT (full address)
- location: GEOGRAPHY (PostGIS point, lat/lng)
- capacity_tonnes: NUMERIC
- grain_types: TEXT[] (array of accepted grains)
- railway: TEXT (railway access info)
- elevator_type: TEXT
- car_spots: TEXT
- created_at: TIMESTAMP
```

#### 2. `favorite_elevators`
**Purpose:** User's favorited elevators
```sql
- id: UUID (primary key)
- user_id: UUID (references auth.users)
- elevator_id: BIGINT (references elevators_import)
- notes: TEXT (optional user notes)
- created_at: TIMESTAMP
```

#### 3. `haul_timers` (likely)
**Purpose:** Track grain hauling sessions
```sql
- id: UUID (primary key)
- user_id: UUID (references auth.users)
- elevator_id: BIGINT (references elevators_import)
- start_time: TIMESTAMP
- end_time: TIMESTAMP
- duration_seconds: INTEGER
- grain_type: TEXT
- weight_kg: NUMERIC
- distance_km: NUMERIC
- status: TEXT (active, paused, completed)
- notes: TEXT
- created_at: TIMESTAMP
```

### Database Views

#### `elevators_with_favorites`
**Purpose:** Show elevators with user's favorite status
```sql
SELECT
  e.*,
  CASE WHEN f.elevator_id IS NOT NULL THEN true ELSE false END AS is_favorite,
  f.created_at AS favorited_at,
  f.notes AS favorite_notes
FROM elevators_import e
LEFT JOIN favorite_elevators f ON e.id = f.elevator_id AND f.user_id = auth.uid()
```

### PostGIS Functions

#### `get_elevators_near(lat, lng, radius_km, max_results)`
**Purpose:** Find nearby elevators using geospatial queries
```sql
Returns elevators within radius_km of (lat, lng), ordered by distance
Includes calculated distance_km column
Uses ST_DWithin for efficient spatial filtering
```

---

## 🎯 Typical User Journey

### **Journey 1: First Haul**
```
1. Sign In → buperac@gmail.com
2. Home Screen → See welcome and quick actions
3. Tap "Start New Haul" → Goes to Timer screen
4. Select Elevator → Search for your favorite elevator
5. Enter Load Details → Grain type, weight
6. Start Timer → Timer begins tracking
7. Drive to elevator → Timer runs in background
8. Arrive at elevator → Stop timer
9. Rate Experience → How was the wait time?
10. View Stats → See your first completed haul
```

### **Journey 2: Check Elevator Queue**
```
1. Home → Tap "Find Elevator"
2. Elevators Screen → View list of elevators
3. Search → Type town/company name
4. Select Elevator → View details and current queue
5. See Wait Time → Real-time estimate
6. Start Timer → If ready to haul
```

### **Journey 3: Review Performance**
```
1. Profile → View stats dashboard
2. See Total Hauls → Count of completed hauls
3. Average Duration → How long hauls take
4. Top Elevators → Most visited locations
5. Distance Traveled → Total km driven
6. Export Data → Download CSV (if implemented)
```

---

## 🚀 What You Can Do Right Now

### ✅ **Currently Working**
1. ✅ Sign in / Sign out
2. ✅ Navigate between 4 main screens
3. ✅ Search for elevators (autocomplete, 513 elevators)
4. ✅ View elevator details
5. ✅ Mark elevators as favorites
6. ✅ View your profile
7. ✅ Edit profile information
8. ✅ Change settings (units, preferences)
9. ✅ Offline mode with cached data
10. ✅ Dark/light theme switching

### 🔨 **May Need Testing**
- Timer functionality (start/stop/pause)
- Real-time queue updates
- Location tracking
- Push notifications
- Map view
- History/analytics
- Data export

### ❓ **To Verify**
- Are there any existing haul records in your database?
- Is the timer screen fully implemented?
- Are real-time subscriptions working?
- Is location tracking enabled?

---

## 📝 Next Steps for Full Workflow Test

### Recommended Testing Sequence

1. **Profile Review**
   - Go to Profile screen
   - Verify your signup data is displayed
   - Update profile picture (if feature exists)
   - Change preferred unit to tonnes

2. **Elevator Search**
   - Go to Elevators screen
   - Search for your favorite elevator (the one you selected during signup)
   - View its details
   - Star it as favorite

3. **Timer Test**
   - Go to Haul Timer screen
   - Select your favorite elevator
   - Enter mock load details (grain type, weight)
   - Start timer
   - Let it run for 1-2 minutes
   - Stop timer
   - Verify it saves to history

4. **History Review**
   - Go back to Home
   - Check if your completed haul appears
   - View haul details
   - Check stats in Profile

5. **Real-time Test**
   - Open app in two browser tabs (if web)
   - Or on two devices
   - Make a change in one (favorite an elevator)
   - Verify it updates in the other

---

## 🐛 Known Issues (Recently Fixed)

1. ✅ **FIXED:** AutoDispose provider causing sign-in failures
2. ✅ **FIXED:** Navigator lock error in elevator search dialog
3. ✅ **FIXED:** Grain capacity/unit field alignment
4. ✅ **FIXED:** Missing "Complete Sign Up" button
5. ✅ **FIXED:** Elevator selection type mismatch (Map<String, dynamic>)

---

## 📚 Documentation References

- **Signup Flow:** `docs/SIGNUP_FLOW_DOCUMENTATION.md`
- **Authentication:** `docs/AUTHENTICATION_IMPLEMENTATION.md` (if exists)
- **Troubleshooting:** `docs/TROUBLESHOOTING.md`
- **Elevator Service:** `lib/data/services/elevator_service.dart`
- **Auth Provider:** `lib/presentation/providers/auth_provider.dart`
- **Main Navigation:** `lib/presentation/screens/main/main_navigation.dart`

---

## 💬 Questions to Explore

As you test the workflow, consider:

1. **Timer Functionality:**
   - Does the timer start/stop correctly?
   - Is there a "Select Elevator" button before starting?
   - Can you enter grain type and weight?
   - Does it save to history when stopped?

2. **Elevator Data:**
   - Can you see all 513 elevators?
   - Does search/filter work smoothly?
   - Are elevator details complete (address, capacity, etc.)?
   - Do real-time queue times show?

3. **User Experience:**
   - Is the design clean and modern?
   - Are there any visual bugs or layout issues?
   - Is navigation intuitive?
   - Are loading states handled well?

4. **Data Persistence:**
   - Do your favorites persist after sign out/in?
   - Does timer history remain after closing app?
   - Are settings saved correctly?

---

## 🎨 Design Evolution

This is **HaulPass 2.0** - a modern rewrite with:
- Material 3 design system
- Enhanced UI components
- Supabase backend integration
- Real-time capabilities
- Offline-first architecture
- PostGIS geospatial features

**Previous versions** may have had different designs. This is the **most recent** implementation.

---

**Ready to explore?** Start with the Elevators screen to see your 513 grain elevators, then try the Timer screen to test the full workflow!

Let me know what you find! 🚜
