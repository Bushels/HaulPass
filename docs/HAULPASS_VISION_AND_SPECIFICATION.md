# HaulPass - Complete Vision and Technical Specification

## Executive Summary

HaulPass is a farmer-first grain hauling efficiency application designed to reduce wait times at grain elevators by collecting farmer-side data on routes, geolocations, observations, and time tracking. Unlike traditional elevator-side scheduling software, HaulPass starts with farmer data collection to build trust and demonstrate value before enabling elevator scheduling capabilities.

**Core Value Proposition:** Help farmers make data-driven decisions about when to haul grain, reducing wait times and improving operational efficiency through real-time queue intelligence and predictive analytics.

---

## Table of Contents

1. [Core Philosophy](#core-philosophy)
2. [MVP Features (Version 1.0)](#mvp-features-version-10)
3. [Future Features (Version 2.0+)](#future-features-version-20)
4. [User Onboarding](#user-onboarding)
5. [Complete Haul Workflow](#complete-haul-workflow)
6. [Queue Intelligence System](#queue-intelligence-system)
7. [Data Models and Storage](#data-models-and-storage)
8. [Technical Implementation Strategy](#technical-implementation-strategy)
9. [Success Metrics](#success-metrics)

---

## Core Philosophy

### Why Start with Farmers?

Grain elevators are hesitant to deploy scheduling software because if a farmer doesn't show up on time, it could ruin the entire day's schedule. Therefore, HaulPass approaches the problem from the farmer's side:

1. **Build data first** - Collect real-world timing, queue, and route data from farmers
2. **Demonstrate value** - Show farmers immediate benefits (reduced wait times)
3. **Create network effects** - More farmers = better predictions for everyone
4. **Enable elevator features later** - Once trust and data exist, add scheduling tools

### Key Design Principles

- **Minimize manual input** - Use GPS, timers, and intelligent defaults
- **Single task focus** - Prevent errors by limiting concurrent operations
- **Real-time collaboration** - Cross-validate data between users
- **Progressive disclosure** - Start simple, unlock features as needed
- **Offline-first** - Work in rural areas with poor connectivity

---

## MVP Features (Version 1.0)

### Dashboard

The farmer opens HaulPass and sees:

- **ONE favorite elevator** (only 1 initially to prevent data errors)
  - Current queue length (number of trucks waiting)
  - Estimated wait time if joining queue now
  - Summary stats:
    - Total loads hauled to this elevator
    - Average wait time at this elevator
    - Average unload time at this elevator

### User Profile (Minimal Data Collection)

Required on signup:
- Name
- Email
- Farm Name
- Binyard Name (single binyard initially)
- Grain Truck Name/Number
- Grain Capacity: kg/lbs (optional - app learns over time)

### Haul Tracking Workflow

Complete grain hauling cycle tracking with:

1. **Grain Selection** - Choose grain type (dropdown or icons)
2. **Loading Timer** - Track time to load truck
3. **Weight Entry** - Optional scale weight (kg/lbs toggle)
4. **Drive Timer** - Track travel time to elevator
5. **Queue Entry** - Enter number of trucks ahead, start wait timer
6. **Unload Timer** - Track unloading time
7. **Post-Haul Data** - Weight, dockage %, grade, price, notes (all optional except weight)
8. **Return Timer** - Track return trip or next load
9. **Daily Summary** - Comprehensive stats at end of day

### Timer Display Logic

- **During active tasks**: Show minutes only (e.g., "23m")
- **Color coding**:
  - Green = Under average time
  - Red = Over average time
- **After completion**: Show with seconds (e.g., "23m 47s")
- **Always visible**: Current task being performed

### Favorite Elevator Management

- **Can search** for any elevator
- **Can swap** favorite elevator when hauling to different location
- **Cannot add multiple** favorites in MVP (unlock later)
- **Reason**: Prevents accidental wrong elevator selection and bad data

---

## Future Features (Version 2.0+)

### Premium Features

1. **Multiple Favorite Elevators** (2-3 displayed on dashboard)
2. **Seasonal Grain Tracking**
   - Total metric tonnes hauled per elevator
   - Average price per elevator
   - Average dockage per elevator
3. **Breakdown by Grain Type**
   - Weight per grain type
   - Quality breakdown (#1, #2, #3)
   - Dockage per grain type
   - Price per grain type
4. **Truck Type Indicators in Queue** - See what types of trucks are ahead

### Farm Management Features

1. **Bin Selection** - Track which bin grain came from
2. **Field Tracking** - What field the grain came from
3. **Combine Tracking** - What combine harvested that field
4. **Multiple Binyards** - Haul from different farm locations
5. **Multiple Grain Haulers** - Track different trucks

### Predictive Intelligence

1. **Time-Based Predictions**
   - "2pm expecting smaller elevator lineup"
   - "Expected time saved waiting: 47 minutes"
2. **Historical Analytics**
   - Busiest times of day graph
   - Busiest days of week
   - Seasonal patterns
3. **Route Optimization**
   - Best time to haul based on current routes
   - Aggregate data from farmers currently loading

### Elevator Features (Long-term)

1. **Elevator Scheduling** - Appointment booking system
2. **Two-way Communication** - Elevator can message farmers
3. **Capacity Management** - Real-time available capacity
4. **Price Updates** - Current grain prices per elevator

---

## User Onboarding

### Signup Flow

```
Screen 1: Name
Screen 2: Email + Password
Screen 3: Farm Name
Screen 4: Binyard Name
Screen 5: Grain Truck Name/Number
Screen 6: Grain Capacity (kg/lbs) - with "Skip" option
Screen 7: Search and Select Favorite Elevator
```

### Onboarding Principles

- **Quick to complete** - Target <2 minutes
- **Optional fields clearly marked** - Don't block signup
- **Educational tooltips** - Explain why data is needed
- **Can be completed later** - Allow "Skip" and finish setup later

---

## Complete Haul Workflow

### Pre-Haul Decision Phase

**User Story**: Steve opens HaulPass while drinking coffee at 6am to decide if he should start hauling.

1. **Open app** - Dashboard loads
2. **View favorite elevator** - "Prairie Grain Co-op"
   - Current queue: 2 trucks
   - Estimated wait: 18 minutes
   - His average wait: 21 minutes
   - His average unload: 9m 12s
3. **Make decision** - Queue looks good, he'll haul

### 1. Start Haul

**Action**: Steve taps "Haul Grain"

```
Display: Grain Type Selector
Options: Dropdown menu OR Icon grid
Grains: Wheat, Canola, Barley, Oats, Soybeans, etc.
```

### 2. Loading Phase

**Action**: Select grain type → Tap "Begin Loading"

```
Timer starts (shows minutes only)
Display: "Loading [Grain Type]"
Background: GPS tracking position
Color: Green if < average, Red if > average
```

**When auger shuts off**:

**Action**: Tap "Weight Loaded"

```
Display: Weight input screen
Field: [    ] kg  [Toggle kg/lbs]
Buttons: [Submit]  [Skip]
```

**On Submit/Skip**:
- Timer stops
- Show average load time
- If weight entered, show time/tonne metric

### 3. Drive to Elevator

**Action**: Automatically shows "Begin Haul to [Elevator Name]"

```
Button: "Begin Haul to Prairie Grain Co-op"
Tap: Start drive timer
Display:
  - Timer (minutes only)
  - Average time to elevator: 14m
  - Current time: 12m (GREEN)
  - Distance tracking in background
```

### 4. Queue Entry

**Trigger**: GPS detects proximity to elevator

**Action**: Prompt appears "In Elevator Queue"

```
Display: Queue Entry Screen
Question: "How many trucks ahead of you?"
Note: "(Not including currently unloading)"
Input: [0] [1] [2] [3] [4] [5] [6+]
```

**On Submit**:
- Drive timer stops (shows with seconds)
- Queue timer starts
- Cross-validates with other users' positions
- Updates everyone's estimated wait times

### 5. Unloading Phase

**Trigger**: GPS detects movement to pit/unload location (last long stop before leaving)

**Action**: Prompt "Begin Unloading"

```
Tap: Start unload timer
Display: "Unloading [Grain Type]"
Timer: Shows minutes only
```

**Action**: Tap "Finished Unloading"

```
Timer stops
Display: Unload Summary
  - Your time: 8m 47s
  - Your average: 9m 12s (YOU WERE 4% FASTER!)
```

**Data Entry Screen**:

```
Weight (kg/lbs): [        ] (required)
Dockage %: [    ] (optional)
Grain Grade: [ #1 / #2 / #3 / Other ] (optional)
Price: $[    ]/tonne (optional)
Notes: [                    ] (optional)
```

### 6. Return Trip

**Action**: Automatically starts return timer

```
Display: "Return Trip"
Timer: Shows minutes
Options:
  [Begin Load] - Starting another trip today
  [Finished for Day] - Done hauling
```

### 7. Next Load or End Day

**If "Begin Load"**:
- Returns to grain selection
- **Option to "Pause after loading"** for loading tomorrow
- Can **Unpause** when ready to haul

**If "Finished for Day"**:

```
Display: Daily Summary

╔══════════════════════════════════════════════════╗
║  Thanks for using HaulPass, have a great rest    ║
║  of your day!                                      ║
╠══════════════════════════════════════════════════╣
║                                                    ║
║  You hauled 73,321kg of Canola today in 3 trips! ║
║                                                    ║
║  🚛 Average full trip: 1hr 52min                  ║
║  ⏱️  Load time: 21 min (6% faster than usual)    ║
║  ⏳ Wait time: 37 min (11% longer, elevator 15%  ║
║     busier than usual)                            ║
║  📦 Unload time: 8min 11sec average               ║
║  🛣️  Round trip: 31.5km @ 89km/hr average        ║
║  ⚖️  Scale accuracy: 98% match                    ║
║  📊 Dockage: 2.45% (0.78% higher than usual)     ║
║                                                    ║
╚══════════════════════════════════════════════════╝
```

---

## Queue Intelligence System

### How It Works

**Example Scenario**: Understanding real-time queue intelligence at Prairie Grain Co-op

#### Current State

**Steve** (SuperB truck, avg unload 11m 09s):
- Arrives at elevator
- Sees 1 truck unloading
- **Enters**: 0 trucks ahead
- **System**: Starts Steve's queue timer

**Frank** (Tandem truck, avg unload 7m 30s):
- Arrives 6 minutes later
- **Enters**: 1 truck ahead
- **System confirms**: Frank is behind Steve
- **System knows**:
  - Steve's been waiting 6 minutes
  - Steve usually takes 11m 09s to unload
  - Estimated wait for Frank: ~11 minutes

**Ben** (Single truck, avg unload 5m 45s):
- Arrives while Steve is still in queue
- **Enters**: 2 trucks ahead
- **System calculates**:
  - Steve: ~5 min remaining wait + 11m 09s unload
  - Frank: 7m 30s unload
  - Movement cushion: ~2 minutes each
  - **Ben's estimated wait**: ~25 minutes

#### Real-Time Updates

**Ted** (at his farm considering hauling):
- Opens HaulPass
- Views Prairie Grain Co-op
- **Sees**:
  - 3 trucks in queue
  - Estimated wait: 39 minutes
  - Last updated: 2 minutes ago

**While Ted is deciding:**
- **Billy** and **John** arrive at elevator
- Both submit queue positions
- **System updates ALL users** with elevator in favorites:

**Notification**:
```
🔔 Prairie Grain Co-op Queue Update
   Now: 4 trucks in queue
   Est. wait: 1hr 06min
   (Updated 30 seconds ago)
```

**Ted's Decision**:
- Decides to pause after loading
- Will haul later when queue is shorter

### Data Cross-Validation

**When a user enters queue position**:

1. **GPS Confirmation** - User actually at elevator location
2. **Position Validation** - Cross-check with other users
3. **Timing Validation** - Realistic based on previous person's entry time
4. **Outlier Detection** - Flag inconsistent data

**If data doesn't match**:
- Use consensus from multiple users
- Weight more reliable users higher (established history)
- Flag potential errors for review

### Notification Strategy

**Who gets notified**:
- Users with this elevator in favorites
- Users currently en route to this elevator
- Users who hauled here in last 7 days

**What triggers notifications**:
- Queue length changes by ±2 trucks
- Wait time changes by ±15 minutes
- Elevator status changes (open/closed/full)
- Unusual activity detected

**Notification content**:
```
🔔 [Elevator Name] Update
   Queue: [X] trucks ([+/-Y] from before)
   Wait: [XX]min ([+/-YY]min from before)
   Updated: [time] ago
```

---

## Data Models and Storage

### Supabase Schema

#### 1. User Profile Table
```sql
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  farm_name TEXT NOT NULL,
  binyard_name TEXT NOT NULL,
  grain_truck_name TEXT NOT NULL,
  grain_capacity_kg DECIMAL(10,2), -- Optional, learned over time
  preferred_unit TEXT DEFAULT 'kg' CHECK (preferred_unit IN ('kg', 'lbs')),
  favorite_elevator_id UUID REFERENCES elevators(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

#### 2. Elevator Table
```sql
CREATE TABLE elevators (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  company TEXT NOT NULL,
  location GEOGRAPHY(POINT, 4326) NOT NULL,
  address TEXT,
  accepted_grains TEXT[],
  phone_number TEXT,
  email TEXT,
  operating_hours JSONB,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_elevators_location ON elevators USING GIST(location);
```

#### 3. Haul Session Table
```sql
CREATE TABLE haul_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES user_profiles(id) NOT NULL,
  elevator_id UUID REFERENCES elevators(id) NOT NULL,
  grain_type TEXT NOT NULL,
  session_date DATE NOT NULL,
  status TEXT CHECK (status IN ('loading', 'driving', 'queued', 'unloading', 'returning', 'paused', 'completed')),

  -- Loading phase
  loading_start TIMESTAMP,
  loading_end TIMESTAMP,
  loading_weight_kg DECIMAL(10,2),
  loading_duration_seconds INTEGER,

  -- Drive to elevator phase
  drive_start TIMESTAMP,
  drive_end TIMESTAMP,
  drive_duration_seconds INTEGER,
  drive_distance_km DECIMAL(10,2),

  -- Queue phase
  queue_start TIMESTAMP,
  queue_end TIMESTAMP,
  queue_duration_seconds INTEGER,
  trucks_ahead_count INTEGER,

  -- Unloading phase
  unload_start TIMESTAMP,
  unload_end TIMESTAMP,
  unload_duration_seconds INTEGER,
  unload_weight_kg DECIMAL(10,2),
  dockage_percent DECIMAL(5,2),
  grain_grade TEXT,
  price_per_tonne DECIMAL(10,2),
  notes TEXT,

  -- Return phase
  return_start TIMESTAMP,
  return_end TIMESTAMP,
  return_duration_seconds INTEGER,

  -- Metadata
  is_paused BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_haul_sessions_user ON haul_sessions(user_id);
CREATE INDEX idx_haul_sessions_elevator ON haul_sessions(elevator_id);
CREATE INDEX idx_haul_sessions_date ON haul_sessions(session_date);
```

#### 4. Queue Snapshot Table
```sql
CREATE TABLE queue_snapshots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  elevator_id UUID REFERENCES elevators(id) NOT NULL,
  user_id UUID REFERENCES user_profiles(id) NOT NULL,
  haul_session_id UUID REFERENCES haul_sessions(id),
  queue_position INTEGER NOT NULL, -- 0 = currently unloading
  trucks_ahead INTEGER NOT NULL,
  estimated_wait_minutes INTEGER,
  user_location GEOGRAPHY(POINT, 4326),
  snapshot_time TIMESTAMP DEFAULT NOW(),

  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_queue_elevator_time ON queue_snapshots(elevator_id, snapshot_time DESC);
```

#### 5. Elevator Stats Cache Table
```sql
CREATE TABLE elevator_stats (
  elevator_id UUID PRIMARY KEY REFERENCES elevators(id),
  current_queue_length INTEGER DEFAULT 0,
  current_wait_estimate_minutes INTEGER DEFAULT 0,
  average_unload_time_minutes DECIMAL(5,2),
  total_loads_today INTEGER DEFAULT 0,
  busy_score DECIMAL(3,2), -- 0.0 to 1.0, indicates how busy vs normal
  last_activity TIMESTAMP,
  updated_at TIMESTAMP DEFAULT NOW()
);
```

#### 6. User Stats Table
```sql
CREATE TABLE user_elevator_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES user_profiles(id) NOT NULL,
  elevator_id UUID REFERENCES elevators(id) NOT NULL,

  total_loads INTEGER DEFAULT 0,
  average_wait_minutes DECIMAL(7,2),
  average_unload_minutes DECIMAL(7,2),
  average_drive_minutes DECIMAL(7,2),
  average_load_minutes DECIMAL(7,2),

  total_weight_kg DECIMAL(12,2),
  average_dockage_percent DECIMAL(5,2),

  last_haul_date DATE,
  updated_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(user_id, elevator_id)
);
```

### Key Calculations

#### Estimated Wait Time Algorithm

```typescript
function calculateEstimatedWait(elevator_id: UUID, current_position: int): int {
  // Get all users currently in queue
  const queueUsers = getQueueUsers(elevator_id);

  // Get their average unload times
  let totalEstimatedMinutes = 0;

  for (let i = 0; i < current_position; i++) {
    const user = queueUsers[i];
    const avgUnloadTime = getUserAvgUnloadTime(user.id, elevator_id);
    const cushion = 2; // minutes for truck movement

    totalEstimatedMinutes += avgUnloadTime + cushion;
  }

  return totalEstimatedMinutes;
}
```

#### Average Time Calculations

```sql
-- User's average unload time at specific elevator
SELECT
  AVG(unload_duration_seconds) / 60.0 as avg_unload_minutes
FROM haul_sessions
WHERE user_id = $1
  AND elevator_id = $2
  AND status = 'completed'
  AND unload_duration_seconds IS NOT NULL
  AND session_date > NOW() - INTERVAL '90 days';

-- Elevator's current busy score (compared to typical activity)
SELECT
  CASE
    WHEN typical_loads = 0 THEN 0
    ELSE (current_loads::DECIMAL / typical_loads::DECIMAL)
  END as busy_score
FROM (
  SELECT
    COUNT(*) FILTER (WHERE session_date = CURRENT_DATE) as current_loads,
    AVG(COUNT(*)) FILTER (WHERE
      EXTRACT(DOW FROM session_date) = EXTRACT(DOW FROM CURRENT_DATE)
    ) as typical_loads
  FROM haul_sessions
  WHERE elevator_id = $1
  GROUP BY session_date
) as stats;
```

---

## Technical Implementation Strategy

### Phase 1: Core MVP (Weeks 1-4)

**Goal**: Single farmer can track a complete haul workflow

1. **User Authentication** (Supabase Auth)
   - Email/password signup
   - Profile creation with required fields

2. **Elevator Selection**
   - Search elevators by name/location
   - Set single favorite elevator
   - View elevator details

3. **Haul Workflow**
   - Implement all 7 phases of haul
   - Timer management
   - Data collection at each phase
   - GPS tracking in background

4. **Data Storage**
   - Create all required tables
   - Implement data models
   - Save haul sessions

5. **Basic Dashboard**
   - Show favorite elevator
   - Display personal stats
   - No queue intelligence yet (coming in Phase 2)

### Phase 2: Queue Intelligence (Weeks 5-8)

**Goal**: Multiple farmers collaborate on queue data

1. **Queue System**
   - Queue entry flow
   - Position tracking
   - Cross-validation logic

2. **Real-Time Updates**
   - Supabase Realtime subscriptions
   - Queue change notifications
   - Wait time recalculation

3. **Estimated Wait Times**
   - Implement calculation algorithm
   - Display on dashboard
   - Historical accuracy tracking

4. **Multi-User Coordination**
   - Consensus algorithm for queue positions
   - Outlier detection
   - Data reliability scoring

### Phase 3: Analytics & Optimization (Weeks 9-12)

**Goal**: Provide valuable insights and predictions

1. **Personal Analytics**
   - Daily summaries
   - Historical trends
   - Efficiency metrics

2. **Elevator Analytics**
   - Busy time patterns
   - Historical wait times
   - Seasonal trends

3. **Predictive Features**
   - Best time to haul suggestions
   - Wait time predictions
   - Route optimization

4. **Premium Features**
   - Grain type breakdowns
   - Price tracking
   - Dockage analysis

### Phase 4: Polish & Scale (Weeks 13-16)

**Goal**: Production-ready application

1. **Performance Optimization**
   - Database query optimization
   - GPS battery optimization
   - Offline functionality

2. **Error Handling**
   - Graceful degradation
   - Data recovery
   - Conflict resolution

3. **User Experience**
   - Onboarding improvements
   - Tutorial system
   - Help documentation

4. **Testing**
   - Unit tests
   - Integration tests
   - User acceptance testing

---

## Success Metrics

### Phase 1 Success Criteria

- [ ] User can complete signup in <2 minutes
- [ ] User can complete full haul workflow without errors
- [ ] All haul data saves correctly to database
- [ ] Dashboard displays accurate personal stats
- [ ] GPS tracking works reliably in background

### Phase 2 Success Criteria

- [ ] 3+ users can enter queue simultaneously without conflicts
- [ ] Wait time estimates within 15% of actual times
- [ ] Queue notifications sent within 30 seconds
- [ ] Cross-validation catches >90% of position errors

### Phase 3 Success Criteria

- [ ] Daily summaries generate with 100% accuracy
- [ ] Predictive wait times improve decision-making (user surveys)
- [ ] Premium features have >20% adoption rate
- [ ] Users report average time savings of >30 minutes/day

### Phase 4 Success Criteria

- [ ] App works offline for all core features
- [ ] <1% error rate in production
- [ ] >4.5 star rating in app stores
- [ ] >80% user retention after 30 days

### Long-term Business Metrics

- **User Acquisition**: 1000+ active farmers by Month 6
- **Engagement**: Average 5+ sessions per user per week
- **Value Delivery**: Average 2+ hours saved per user per week
- **Network Effects**: >50% of grain elevators have 3+ users
- **Revenue**: >30% conversion to premium features

---

## App State Logic

### Critical Rules

1. **App Open** (foreground or background) = User is hauling or considering hauling
2. **App Closed** = User is not hauling
3. **Timer always shows** current task being performed
4. **Only tap next button** when moving to that task (no skipping ahead)
5. **One task at a time** - Cannot have multiple timers running
6. **Pause state** - Can pause after loading to resume later

### State Machine

```
IDLE → GRAIN_SELECTION
GRAIN_SELECTION → LOADING
LOADING → LOADED (with weight) / LOADED (skipped weight)
LOADED → DRIVING_TO_ELEVATOR
DRIVING_TO_ELEVATOR → IN_QUEUE
IN_QUEUE → UNLOADING
UNLOADING → UNLOADED (data entry)
UNLOADED → RETURNING
RETURNING → LOADING (next trip) / PAUSED (load for later) / COMPLETED (done for day)
PAUSED → DRIVING_TO_ELEVATOR (resume)
COMPLETED → IDLE (daily summary shown)
```

---

## Conclusion

This document serves as the complete technical and functional specification for HaulPass. All future development, documentation updates, and feature decisions should reference this document to maintain alignment with the core vision.

**Next Steps**:
1. Review and confirm all specifications
2. Create detailed UI/UX mockups based on workflow
3. Build database schema in Supabase
4. Implement Phase 1 MVP
5. Begin user testing with 5-10 farmers

---

*Last Updated: [Date]*
*Version: 1.0*
*Status: Living Document - Updates as needed*
