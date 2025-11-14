# HaulPass - Gap Analysis and Implementation Roadmap

## Current State Analysis

### What's Already Implemented ✅

#### Data Models
- ✅ **Elevator Models** (`elevator_models.dart`)
  - Basic elevator information (name, company, location, grains)
  - Operating hours
  - Contact information
  - Timer sessions (basic structure)
  - Timer events

- ✅ **User Models** (`user_models.dart`)
  - User profiles
  - User settings
  - Authentication state
  - Subscription management

- ✅ **Location Models** (`location_models.dart`)
  - GPS location tracking
  - Location history

#### Features
- ✅ **Authentication** - Supabase auth integration
- ✅ **Location Tracking** - GPS tracking capability
- ✅ **Basic Timer** - Start/stop timer functionality
- ✅ **Elevator Search** - View nearby elevators
- ✅ **Home Dashboard** - Basic layout with elevator display

#### Infrastructure
- ✅ **Flutter Web** - Cross-platform foundation
- ✅ **Supabase Integration** - Backend connectivity
- ✅ **Riverpod State Management** - Provider architecture
- ✅ **GitHub Pages Deployment** - CI/CD pipeline

---

## What's Missing ❌

### Critical MVP Gaps

#### 1. User Onboarding Flow ❌
**Current**: Basic email/password authentication only
**Needed**:
- Farm name collection
- Binyard name collection
- Grain truck name/number
- Grain capacity (optional)
- Favorite elevator selection (single only)

#### 2. Complete Haul Workflow ❌
**Current**: Basic timer with start/stop
**Needed**:
- ❌ Grain type selection screen
- ❌ Loading phase with timer
- ❌ Weight entry (kg/lbs toggle)
- ❌ Drive phase with distance tracking
- ❌ Queue entry with truck count
- ❌ Unloading phase with timer
- ❌ Post-unload data entry (weight, dockage, grade, price, notes)
- ❌ Return phase timer
- ❌ Pause/resume functionality
- ❌ Daily summary screen

#### 3. State Machine Logic ❌
**Current**: No workflow state management
**Needed**:
- ❌ Complete state machine for haul phases
- ❌ State persistence
- ❌ State recovery after app restart
- ❌ Validation between states

#### 4. Timer Display Logic ❌
**Current**: Shows hours, minutes, seconds all the time
**Needed**:
- ❌ Show minutes only during active tasks
- ❌ Show seconds only after completion
- ❌ Color coding (green/red based on average)
- ❌ Current task display

#### 5. Dashboard Requirements ❌
**Current**: Shows multiple elevators
**Needed**:
- ❌ Single favorite elevator only
- ❌ Current queue length display
- ❌ Estimated wait time
- ❌ Personal stats (loads hauled, avg wait, avg unload)

#### 6. Queue Intelligence System ❌
**Current**: Not implemented
**Needed**:
- ❌ Queue entry with position
- ❌ Cross-validation between users
- ❌ Real-time queue updates
- ❌ Wait time calculation algorithm
- ❌ Notifications for queue changes

#### 7. Data Models ❌
**Current**: Basic models exist but incomplete
**Needed**:
- ❌ `haul_sessions` table with all phases
- ❌ `queue_snapshots` table
- ❌ `elevator_stats` cache table
- ❌ `user_elevator_stats` table
- ❌ User profile extensions (farm, binyard, truck)

#### 8. Analytics & Summaries ❌
**Current**: No analytics
**Needed**:
- ❌ Daily summary generation
- ❌ Average time calculations per elevator
- ❌ Weight comparison (truck vs elevator)
- ❌ Efficiency metrics (time/tonne)
- ❌ Historical trends

---

## Implementation Roadmap

### 🎯 Phase 1: Foundation & Core Workflow (Weeks 1-4)

#### Week 1: User Onboarding & Data Models

**Tasks**:
1. **Update User Profile Model**
   - Add farm_name field
   - Add binyard_name field
   - Add grain_truck_name field
   - Add grain_capacity_kg field (nullable)
   - Add preferred_unit field (kg/lbs)
   - Add favorite_elevator_id field (single, nullable)

2. **Create Onboarding Screens**
   - Name entry screen
   - Email/password screen
   - Farm name screen
   - Binyard name screen
   - Grain truck details screen
   - Favorite elevator selector screen

3. **Supabase Schema Updates**
   ```sql
   -- Update user_profiles table
   ALTER TABLE user_profiles ADD COLUMN farm_name TEXT NOT NULL DEFAULT '';
   ALTER TABLE user_profiles ADD COLUMN binyard_name TEXT NOT NULL DEFAULT '';
   ALTER TABLE user_profiles ADD COLUMN grain_truck_name TEXT NOT NULL DEFAULT '';
   ALTER TABLE user_profiles ADD COLUMN grain_capacity_kg DECIMAL(10,2);
   ALTER TABLE user_profiles ADD COLUMN preferred_unit TEXT DEFAULT 'kg';
   ALTER TABLE user_profiles ADD COLUMN favorite_elevator_id UUID REFERENCES elevators(id);
   ```

4. **Validation Rules**
   - Prevent signup completion without required fields
   - Allow skip for grain capacity
   - Validate elevator selection

**Deliverables**:
- ✅ Complete onboarding flow (<2 minutes)
- ✅ All user data collected
- ✅ Favorite elevator selected

---

#### Week 2: Haul Session Model & State Machine

**Tasks**:
1. **Create Haul Session Model**
   ```dart
   class HaulSession {
     // Session metadata
     String id;
     String userId;
     String elevatorId;
     String grainType;
     DateTime sessionDate;
     HaulSessionStatus status;

     // Loading phase
     DateTime? loadingStart;
     DateTime? loadingEnd;
     double? loadingWeightKg;

     // Drive phase
     DateTime? driveStart;
     DateTime? driveEnd;
     double? driveDistanceKm;

     // Queue phase
     DateTime? queueStart;
     DateTime? queueEnd;
     int? trucksAheadCount;

     // Unload phase
     DateTime? unloadStart;
     DateTime? unloadEnd;
     double? unloadWeightKg;
     double? dockagePercent;
     String? grainGrade;
     double? pricePerTonne;
     String? notes;

     // Return phase
     DateTime? returnStart;
     DateTime? returnEnd;

     // State management
     bool isPaused;
   }
   ```

2. **Create State Machine**
   ```dart
   enum HaulSessionStatus {
     idle,
     grainSelection,
     loading,
     loaded,
     drivingToElevator,
     inQueue,
     unloading,
     unloaded,
     returning,
     paused,
     completed
   }
   ```

3. **Create Haul Session Provider**
   - Active session management
   - State transitions
   - Timer coordination
   - GPS integration

4. **Supabase Schema**
   ```sql
   CREATE TABLE haul_sessions (
     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
     user_id UUID REFERENCES user_profiles(id) NOT NULL,
     elevator_id UUID REFERENCES elevators(id) NOT NULL,
     grain_type TEXT NOT NULL,
     session_date DATE NOT NULL,
     status TEXT NOT NULL,

     -- All phase timestamps and data
     loading_start TIMESTAMP,
     loading_end TIMESTAMP,
     loading_weight_kg DECIMAL(10,2),
     -- ... (all other fields from model)

     is_paused BOOLEAN DEFAULT false,
     created_at TIMESTAMP DEFAULT NOW(),
     updated_at TIMESTAMP DEFAULT NOW()
   );
   ```

**Deliverables**:
- ✅ Complete data model
- ✅ State machine implementation
- ✅ Database schema created
- ✅ Basic state transitions working

---

#### Week 3: Haul Workflow UI (Part 1: Loading → Driving)

**Tasks**:
1. **Grain Selection Screen**
   - Grid of grain type icons (Wheat, Canola, Barley, Oats, Soybeans, etc.)
   - Dropdown option as alternative
   - "Begin Loading" button after selection

2. **Loading Phase Screen**
   - Large timer display (minutes only)
   - Current task: "Loading [Grain Type]"
   - "Weight Loaded" button
   - "Skip" button
   - Color coding (green/red vs average)

3. **Weight Entry Screen**
   - Input field with kg/lbs toggle
   - Submit button
   - Skip option
   - Display average load time after

4. **Drive Phase Screen**
   - Auto-display "Begin Haul to [Elevator]"
   - Timer (minutes only)
   - Show average time
   - Color coding
   - GPS tracking in background
   - Distance counter

**Deliverables**:
- ✅ Grain selection working
- ✅ Loading timer functional
- ✅ Weight entry saving
- ✅ Drive timer tracking

---

#### Week 4: Haul Workflow UI (Part 2: Queue → Summary)

**Tasks**:
1. **Queue Entry Screen**
   - GPS-triggered prompt "In Elevator Queue"
   - Number picker: "How many trucks ahead?"
   - Note: "Not including currently unloading"
   - Submit button
   - Queue timer starts

2. **Unloading Screen**
   - GPS-triggered prompt "Begin Unloading"
   - Timer (minutes only)
   - "Finished Unloading" button
   - Show comparison to average

3. **Post-Unload Data Entry**
   - Weight input (kg/lbs) - REQUIRED
   - Dockage % - optional
   - Grain grade dropdown - optional
   - Price per tonne - optional
   - Notes text field - optional

4. **Return Phase Screen**
   - Auto-start return timer
   - Show "Return Trip" label
   - Two buttons:
     - "Begin Load" (another trip)
     - "Finished for Day"

5. **Daily Summary Screen**
   ```
   Thanks for using HaulPass!

   You hauled 73,321kg of Canola today in 3 trips!

   🚛 Average full trip: 1hr 52min
   ⏱️ Load time: 21 min (6% faster than usual)
   ⏳ Wait time: 37 min (11% longer, elevator 15% busier)
   📦 Unload time: 8min 11sec average
   🛣️ Round trip: 31.5km @ 89km/hr average
   ⚖️ Scale accuracy: 98% match
   📊 Dockage: 2.45% (0.78% higher than usual)
   ```

**Deliverables**:
- ✅ Complete workflow from start to finish
- ✅ All data collected and saved
- ✅ Daily summary generated
- ✅ Single farmer can track complete haul

---

### 🎯 Phase 2: Queue Intelligence (Weeks 5-8)

#### Week 5: Queue System Foundation

**Tasks**:
1. **Queue Snapshot Model**
   ```dart
   class QueueSnapshot {
     String id;
     String elevatorId;
     String userId;
     String? haulSessionId;
     int queuePosition;
     int trucksAhead;
     int estimatedWaitMinutes;
     AppLocation userLocation;
     DateTime snapshotTime;
   }
   ```

2. **Queue Snapshot Table**
   ```sql
   CREATE TABLE queue_snapshots (
     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
     elevator_id UUID REFERENCES elevators(id) NOT NULL,
     user_id UUID REFERENCES user_profiles(id) NOT NULL,
     haul_session_id UUID REFERENCES haul_sessions(id),
     queue_position INTEGER NOT NULL,
     trucks_ahead INTEGER NOT NULL,
     estimated_wait_minutes INTEGER,
     user_location GEOGRAPHY(POINT, 4326),
     snapshot_time TIMESTAMP DEFAULT NOW(),
     created_at TIMESTAMP DEFAULT NOW()
   );
   ```

3. **Queue Entry Logic**
   - Capture queue entry from user
   - Save to queue_snapshots
   - Update haul session

4. **Cross-Validation Logic**
   - Compare new entry with existing queue
   - Validate position matches GPS
   - Flag inconsistencies

**Deliverables**:
- ✅ Queue data collected
- ✅ Basic validation working
- ✅ Data persisted correctly

---

#### Week 6: Wait Time Calculation

**Tasks**:
1. **User Stats Table**
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

2. **Stats Calculation Functions**
   ```sql
   -- Function to calculate user's average unload time
   CREATE OR REPLACE FUNCTION calculate_user_avg_unload(
     p_user_id UUID,
     p_elevator_id UUID
   ) RETURNS DECIMAL AS $$
     SELECT AVG(
       EXTRACT(EPOCH FROM (unload_end - unload_start)) / 60.0
     )
     FROM haul_sessions
     WHERE user_id = p_user_id
       AND elevator_id = p_elevator_id
       AND status = 'completed'
       AND unload_end IS NOT NULL
       AND session_date > NOW() - INTERVAL '90 days';
   $$ LANGUAGE SQL;
   ```

3. **Wait Time Algorithm**
   ```dart
   int calculateEstimatedWait(String elevatorId, int currentPosition) {
     // Get queue users ahead of this position
     final queueUsers = getQueueUsers(elevatorId);

     int totalMinutes = 0;
     for (int i = 0; i < currentPosition; i++) {
       final user = queueUsers[i];
       final avgUnload = getUserAvgUnloadTime(user.userId, elevatorId);
       final cushion = 2; // Movement time
       totalMinutes += (avgUnload + cushion).ceil();
     }

     return totalMinutes;
   }
   ```

4. **Dashboard Wait Time Display**
   - Show estimated wait for favorite elevator
   - Update in real-time

**Deliverables**:
- ✅ Accurate wait time calculations
- ✅ Stats tracking functional
- ✅ Dashboard displays estimates

---

#### Week 7: Real-Time Updates

**Tasks**:
1. **Supabase Realtime Setup**
   ```dart
   class QueueRealtimeService {
     late RealtimeChannel _queueChannel;

     void initialize(String elevatorId) {
       _queueChannel = Supabase.instance.client
         .channel('queue_updates_$elevatorId')
         .onPostgresChanges(
           event: PostgresChangeEvent.insert,
           schema: 'public',
           table: 'queue_snapshots',
           filter: PostgresChangeFilter(
             type: PostgresChangeFilterType.eq,
             column: 'elevator_id',
             value: elevatorId,
           ),
           callback: _handleQueueUpdate,
         )
         .subscribe();
     }
   }
   ```

2. **Notification System**
   - Trigger on queue changes
   - Send to users with elevator favorited
   - Include queue length and wait time

3. **Elevator Stats Cache**
   ```sql
   CREATE TABLE elevator_stats (
     elevator_id UUID PRIMARY KEY REFERENCES elevators(id),
     current_queue_length INTEGER DEFAULT 0,
     current_wait_estimate_minutes INTEGER DEFAULT 0,
     average_unload_time_minutes DECIMAL(5,2),
     total_loads_today INTEGER DEFAULT 0,
     busy_score DECIMAL(3,2),
     last_activity TIMESTAMP,
     updated_at TIMESTAMP DEFAULT NOW()
   );
   ```

4. **Auto-Update Logic**
   - Recalculate wait times on queue changes
   - Update elevator_stats cache
   - Trigger notifications

**Deliverables**:
- ✅ Real-time queue updates
- ✅ Notifications working
- ✅ All users stay in sync

---

#### Week 8: Multi-User Testing & Refinement

**Tasks**:
1. **Conflict Resolution**
   - Handle simultaneous queue entries
   - Consensus algorithm for position disagreements
   - Outlier detection

2. **Data Reliability Scoring**
   - Track user accuracy over time
   - Weight reliable users higher
   - Flag suspicious data

3. **Testing with 5-10 Users**
   - Coordinate queue entries
   - Validate cross-validation
   - Test notification delivery
   - Measure wait time accuracy

4. **Bug Fixes and Optimization**
   - Fix any issues found in testing
   - Optimize database queries
   - Improve UI/UX based on feedback

**Deliverables**:
- ✅ Stable multi-user queue system
- ✅ Accurate wait time predictions
- ✅ Validated with real users

---

### 🎯 Phase 3: Analytics & Polish (Weeks 9-12)

#### Week 9-10: Personal Analytics

**Tasks**:
1. **Historical Data Queries**
   - Aggregate user stats per elevator
   - Calculate trends over time
   - Identify efficiency improvements

2. **Analytics Screens**
   - Personal dashboard with charts
   - Elevator comparison view
   - Time-based analysis

3. **Data Export**
   - CSV export of haul history
   - PDF summary reports

**Deliverables**:
- ✅ Comprehensive personal analytics
- ✅ Useful insights for farmers

---

#### Week 11: Elevator Analytics & Predictions

**Tasks**:
1. **Elevator Pattern Analysis**
   - Busiest times of day
   - Busiest days of week
   - Seasonal patterns

2. **Predictive Features (Basic)**
   - Recommend best haul times
   - Show historical wait times

3. **Elevator Detail Pages**
   - Full stats for each elevator
   - Historical patterns graph

**Deliverables**:
- ✅ Predictive recommendations
- ✅ Historical pattern display

---

#### Week 12: Performance & Polish

**Tasks**:
1. **Performance Optimization**
   - Database indexing
   - Query optimization
   - GPS battery optimization

2. **Error Handling**
   - Graceful error messages
   - Data recovery mechanisms
   - Offline support

3. **UI Polish**
   - Animation refinements
   - Accessibility improvements
   - Mobile optimization

4. **Documentation**
   - User guide
   - Help screens
   - FAQ

**Deliverables**:
- ✅ Production-ready app
- ✅ Complete documentation
- ✅ Ready for wider launch

---

## Priority Matrix

### Must Have (MVP)
1. ✅ Complete user onboarding with all required fields
2. ✅ Full haul workflow (all 7 phases)
3. ✅ Data persistence for all haul data
4. ✅ Single favorite elevator
5. ✅ Queue entry and position tracking
6. ✅ Basic wait time calculations
7. ✅ Daily summary generation

### Should Have (MVP+)
1. ✅ Real-time queue updates
2. ✅ Cross-validation of queue positions
3. ✅ Notifications for queue changes
4. ✅ Personal analytics dashboard
5. ✅ Historical patterns display

### Could Have (Future)
1. ⏳ Multiple favorite elevators
2. ⏳ Premium features (grain breakdown, pricing)
3. ⏳ Advanced predictions
4. ⏳ Elevator scheduling
5. ⏳ Farm management features

### Won't Have (Out of Scope)
1. ❌ Social features
2. ❌ Marketplace functionality
3. ❌ Direct elevator booking (until later)
4. ❌ Multi-language support (until later)

---

## Migration Strategy

### From Current Implementation

1. **Keep What Works**
   - ✅ Supabase integration
   - ✅ Authentication system
   - ✅ Location tracking
   - ✅ Basic UI framework

2. **Refactor**
   - 🔄 Timer implementation → Haul session state machine
   - 🔄 Elevator display → Single favorite only
   - 🔄 User profile → Extended fields

3. **Add New**
   - ➕ Complete haul workflow screens
   - ➕ Queue intelligence system
   - ➕ Analytics and summaries
   - ➕ Real-time updates

4. **Remove/Deprecate**
   - ❌ Multiple elevator display on dashboard (for MVP)
   - ❌ Generic timer functionality
   - ❌ Unused navigation routes

---

## Risk Assessment

### High Risk 🔴
1. **GPS accuracy in rural areas** - Mitigation: Test extensively, add manual override
2. **Multi-user queue conflicts** - Mitigation: Robust conflict resolution algorithm
3. **Wait time accuracy** - Mitigation: Learn and improve over time, set expectations

### Medium Risk 🟡
1. **User adoption** - Mitigation: Clear onboarding, demonstrated value quickly
2. **Data consistency** - Mitigation: Validation, error handling
3. **Battery drain from GPS** - Mitigation: Adaptive tracking intervals

### Low Risk 🟢
1. **Database performance** - Mitigation: Proper indexing, caching
2. **UI/UX** - Mitigation: User testing, iterative improvements
3. **Deployment** - Mitigation: Existing CI/CD pipeline

---

## Success Criteria by Phase

### Phase 1 (Weeks 1-4)
- ✅ Single user can complete full haul workflow
- ✅ All data saves correctly
- ✅ No critical bugs
- ✅ <2 minute onboarding time

### Phase 2 (Weeks 5-8)
- ✅ 5+ users can use queue system simultaneously
- ✅ Wait time predictions within 20% accuracy
- ✅ Real-time updates delivered within 30 seconds
- ✅ No data conflicts

### Phase 3 (Weeks 9-12)
- ✅ Users report value from analytics
- ✅ App performance metrics met (load time, battery usage)
- ✅ Ready for production launch
- ✅ Documentation complete

---

## Next Steps

1. **Review this roadmap** with stakeholders
2. **Prioritize any adjustments** based on feedback
3. **Set up project board** with all tasks
4. **Begin Week 1 implementation** - User onboarding
5. **Schedule weekly check-ins** to track progress

---

*This is a living document - update as implementation progresses*
