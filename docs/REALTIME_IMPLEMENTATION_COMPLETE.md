# Real-Time Queue Monitoring Implementation

**Date:** November 18, 2025
**Status:** ✅ Complete - Ready for Testing
**Version:** v2.1

---

## Overview

The real-time queue monitoring system is now fully implemented and integrated into the HaulPass app. Farmers can now see live updates of elevator queue status while they're loading their trucks and decide whether to wait or switch elevators.

---

## What's Been Implemented

### 1. Database Layer ✅

#### Tables Created

**elevator_status**
- Tracks current queue status for each elevator
- Fields: current_lineup, estimated_wait_time, status, last_updated
- Enabled for Realtime updates via Supabase

**queue_updates**
- Historical log of all queue updates
- Used for calculating trends and comparisons
- Fields: elevator_id, lineup_count, wait_time_minutes, reported_by, created_at

**user_queue_status**
- Tracks user's current hauling status
- Controls alert silencing when "waiting in queue"
- Fields: user_id, elevator_id, status, alerts_silenced, started_at

#### Row Level Security (RLS) ✅

All tables have RLS enabled with appropriate policies:
- **elevator_status**: Anyone can read, authenticated users can update
- **queue_updates**: Anyone can read, authenticated users can insert their own
- **user_queue_status**: Users can only access their own status

#### Realtime Publications ✅

All three tables are published to Supabase Realtime for live subscriptions.

### 2. Service Layer ✅

#### ElevatorQueueService

**Location:** [lib/core/services/elevator_queue_service.dart](../lib/core/services/elevator_queue_service.dart)

**Features:**
- Subscribe to real-time elevator status updates via WebSockets
- Automatic reconnection on network issues
- Get queue history for trend analysis
- Update elevator status (farmer reports)
- Manage user queue status for alert silencing

**Key Methods:**
```dart
Stream<ElevatorStatus> subscribeToElevator(String elevatorId)
Future<void> updateElevatorStatus({...})
Future<List<QueueUpdate>> getQueueHistory({...})
Future<void> setUserQueueStatus({...})
Future<UserQueueStatus?> getUserQueueStatus()
```

#### QueueAlertManager

**Location:** [lib/core/services/queue_alert_manager.dart](../lib/core/services/queue_alert_manager.dart)

**Features:**
- Monitor queue changes and generate smart alerts
- Alert debouncing (3-second cooldown to prevent spam)
- Priority levels (1-3) based on severity
- Automatic alert silencing when user is "waiting in queue"

**Alert Types:**
- **queueGrowing**: Queue increased by 3+ trucks
- **queueShrinking**: Queue decreased by 3+ trucks
- **waitTimeIncreased**: Wait time increased by 15+ minutes
- **waitTimeDecreased**: Wait time decreased by 10+ minutes
- **elevatorStatusChanged**: Elevator status changed (open/busy/closed)

**Alert Triggers:**
```dart
// Queue growing fast!
if (newLineup - oldLineup >= 3) {
  emit("Queue growing fast! +5 trucks in line");
}

// Wait time increased significantly
if (newWait - oldWait >= 15) {
  emit("Wait time increased by +20 minutes");
}
```

### 3. Provider Layer ✅

#### Dashboard Providers

**Location:** [lib/presentation/providers/dashboard_providers.dart](../lib/presentation/providers/dashboard_providers.dart)

**Providers Created:**
- `favoriteElevatorIdProvider` - User's favorite elevator ID
- `favoriteElevatorNameProvider` - Elevator name lookup
- `liveElevatorInsightsProvider` - Combines real-time status with historical data
- `favoriteElevatorInsightsProvider` - Live insights for favorite elevator
- `favoriteElevatorAlertsProvider` - Stream of alerts for favorite elevator
- `userStatisticsProvider` - User haul statistics (mock data for now)

**How It Works:**
1. Subscribes to real-time elevator status via Supabase Realtime
2. Fetches historical queue data for comparisons
3. Calculates yesterday's and last week's wait times
4. Combines data into `ElevatorInsights` model
5. Streams updates to UI as changes occur

### 4. UI Integration ✅

#### Smart Dashboard Updates

**Location:** [lib/presentation/screens/home/smart_dashboard_screen.dart](../lib/presentation/screens/home/smart_dashboard_screen.dart)

**Changes:**
- Replaced mock data with live `liveElevatorInsightsProvider`
- Added async data handling with `AsyncValue.when()`
- Implemented loading state with spinner
- Implemented error state with retry button
- Added real-time alert listener with SnackBar notifications

**Real-Time Alert Display:**
```dart
ref.listen<AsyncValue<QueueAlert>>(
  favoriteElevatorAlertsProvider,
  (previous, next) {
    next.whenData((alert) {
      if (alert.priority >= 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(alert.message),
            backgroundColor: _getAlertColor(alert.type),
          ),
        );
      }
    });
  },
);
```

**States Handled:**
- **Loading**: Shows "Loading elevator data..." with spinner
- **Data**: Displays live elevator insights with auto-updates
- **Error**: Shows error message with retry button

---

## How It Works (User Flow)

### 1. App Opens
```
User opens app
  ↓
Dashboard loads
  ↓
Subscribes to favorite elevator status
  ↓
Shows current wait time (e.g., "8 min")
  ↓
Displays comparisons ("56% quicker than yesterday")
```

### 2. Live Updates
```
Another farmer reports queue update
  ↓
Supabase Realtime broadcasts change
  ↓
App receives new status via WebSocket
  ↓
QueueAlertManager checks thresholds
  ↓
If significant change: Generate alert
  ↓
Show SnackBar notification
  ↓
Update dashboard card instantly
```

### 3. Alert Silencing
```
User clicks "Start Load"
  ↓
Status set to "loading"
  ↓
User drives to elevator
  ↓
Status set to "driving"
  ↓
User arrives at elevator
  ↓
Status set to "waiting_in_queue"
  ↓
Alerts automatically silenced
  ↓
User finishes unloading
  ↓
Status cleared
  ↓
Alerts resume
```

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    Smart Dashboard                       │
│  (watches liveElevatorInsightsProvider & alerts)        │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│              Dashboard Providers                         │
│  - liveElevatorInsightsProvider                         │
│  - favoriteElevatorAlertsProvider                       │
└────────────────┬────────────────────────────────────────┘
                 │
        ┌────────┴────────┐
        ▼                 ▼
┌──────────────────┐  ┌──────────────────┐
│ QueueService     │  │ AlertManager     │
│                  │  │                  │
│ - Subscribe to   │  │ - Monitor changes│
│   Realtime       │  │ - Generate alerts│
│ - Get history    │  │ - Debounce spam  │
│ - Update status  │  │ - Check silencing│
└────────┬─────────┘  └────────┬─────────┘
         │                     │
         └──────────┬──────────┘
                    ▼
┌─────────────────────────────────────────────────────────┐
│                 Supabase Backend                         │
│  ┌────────────────┐  ┌────────────────┐                │
│  │ elevator_status│  │ queue_updates  │                │
│  │ (Realtime)     │  │ (History)      │                │
│  └────────────────┘  └────────────────┘                │
│  ┌────────────────┐                                     │
│  │user_queue_status│                                    │
│  │ (Alert Control)│                                     │
│  └────────────────┘                                     │
└─────────────────────────────────────────────────────────┘
```

---

## Testing Instructions

### 1. Setup Test Environment

You'll need two devices/browsers to test real-time updates:

**Device A (Farmer 1):**
1. Open app and sign in
2. Navigate to dashboard
3. Note current wait time

**Device B (Farmer 2):**
1. Open app and sign in as different user
2. Navigate to same elevator

### 2. Test Real-Time Updates

**On Device B:**
```dart
// Simulate farmer reporting queue update
final queueService = ref.read(elevatorQueueServiceProvider);
await queueService.updateElevatorStatus(
  elevatorId: '1',
  currentLineup: 8,  // Increased from 2
  estimatedWaitMinutes: 25,  // Increased from 8
  status: 'busy',
);
```

**Expected on Device A:**
- Wait time updates from 8 min → 25 min within 1-2 seconds
- SnackBar appears: "Wait time increased by +17 minutes"
- Card color changes from green → amber
- Status changes to "Moderate wait"

### 3. Test Alert Silencing

**On Device A:**
```dart
// Simulate farmer waiting in queue
final queueService = ref.read(elevatorQueueServiceProvider);
await queueService.setUserQueueStatus(
  elevatorId: '1',
  status: 'waiting_in_queue',
  silenceAlerts: true,
);
```

**On Device B:**
```dart
// Report another update
await queueService.updateElevatorStatus(
  elevatorId: '1',
  currentLineup: 12,
  estimatedWaitMinutes: 35,
  status: 'busy',
);
```

**Expected on Device A:**
- Wait time updates (UI still refreshes)
- **NO** SnackBar alert (silenced)
- Alert resumes after clearing status

### 4. Test Error Handling

**Disconnect Internet:**
1. Turn off WiFi/mobile data
2. Dashboard should show loading spinner briefly
3. Then show error state with "Retry" button
4. Click "Retry" → Should attempt reconnection

**Reconnect Internet:**
1. Turn WiFi back on
2. Dashboard automatically reconnects
3. Shows current live data

---

## Configuration

### Alert Thresholds

Edit in [queue_alert_manager.dart](../lib/core/services/queue_alert_manager.dart):

```dart
static const int lineupThreshold = 3;  // Alert if queue grows by 3+ trucks
static const int waitTimeThreshold = 15;  // Alert if wait increases by 15+ min
static const Duration alertDebounce = Duration(seconds: 3);  // Prevent spam
```

### Favorite Elevator

Currently hardcoded in [dashboard_providers.dart](../lib/presentation/providers/dashboard_providers.dart):

```dart
@riverpod
String favoriteElevatorId(FavoriteElevatorIdRef ref) {
  return '1';  // TODO: Fetch from user preferences
}
```

**TODO:** Create user preferences table and fetch favorite from database.

---

## Known Limitations

### 1. Mock Data Still Used For:
- User statistics (total hauls, grain breakdown, etc.)
- Recent activity
- Haul performance metrics

**Why:** These require haul tracking system which is next phase.

### 2. Hardcoded Values:
- Favorite elevator ID (currently '1')
- Elevator name (currently 'Prairie Gold Co-op')

**Why:** Need to implement user preferences system.

### 3. Historical Data Calculation:
- Uses simple averaging from queue_updates history
- May not be accurate if data is sparse

**Why:** Need more sophisticated algorithm and more historical data.

---

## Next Steps

### Phase 1: User Preferences (Recommended Next)
1. Create `user_preferences` table
2. Store favorite elevator per user
3. Update dashboard providers to fetch from preferences

### Phase 2: Haul Tracking Integration
1. Connect timer screen to user_queue_status
2. Automatically update status as haul progresses
3. Track actual haul sessions in database
4. Replace mock data with real statistics

### Phase 3: Enhanced Analytics
1. Implement predictive wait time ML model
2. Add historical pattern analysis (e.g., "Usually clears by 10:30 AM")
3. Alternative elevator suggestions
4. Price tracking integration

### Phase 4: Push Notifications
1. Set up Firebase Cloud Messaging (FCM)
2. Send push notifications for high-priority alerts
3. Allow users to configure notification preferences
4. Silent notifications for background sync

---

## Files Modified/Created

### New Files ✅
- `lib/core/services/elevator_queue_service.dart` (375 lines)
- `lib/core/services/queue_alert_manager.dart` (287 lines)
- `lib/presentation/providers/dashboard_providers.dart` (135 lines)
- `docs/REALTIME_IMPLEMENTATION_COMPLETE.md` (this file)

### Modified Files ✅
- `lib/presentation/screens/home/smart_dashboard_screen.dart`
  - Added live data integration
  - Added alert listener
  - Added async state handling
  - Removed mock data methods

### Database Migrations ✅
- `create_elevator_status_table` - Created elevator_status table
- `create_queue_updates_table` - Created queue_updates table
- `create_user_queue_status_table` - Created user_queue_status table
- `setup_rls_policies_realtime_tables_v2` - Set up all RLS policies
- `enable_realtime_publications` - Enabled Realtime on all tables

---

## Code Generation

All Riverpod providers have been generated:
```bash
dart run build_runner build --delete-conflicting-outputs
```

Generated files:
- `lib/core/services/elevator_queue_service.g.dart`
- `lib/core/services/queue_alert_manager.g.dart`
- `lib/presentation/providers/dashboard_providers.g.dart`

---

## Performance Considerations

### WebSocket Connections
- One connection per elevator being monitored
- Automatically cleaned up when widget disposed
- Reconnects automatically on network issues

### Database Queries
- Historical queries limited to 20 most recent records
- Indexed on elevator_id and created_at for fast lookups
- RLS policies optimize query plans

### Alert Debouncing
- 3-second cooldown prevents notification spam
- Priority filtering (only show priority 2+)
- Automatic silencing based on user status

---

## Security

### Row Level Security (RLS)
- All tables have RLS enabled
- Users can only modify their own queue status
- Anyone can read public elevator status (transparency)
- Queue updates linked to reporting user

### Data Privacy
- User queue status is private (per-user)
- Historical updates track who reported (accountability)
- No sensitive data exposed in Realtime broadcasts

---

## Troubleshooting

### "Loading elevator data..." Stuck

**Possible Causes:**
1. No data in elevator_status table for elevator ID
2. Supabase connection issue
3. Invalid elevator ID

**Solution:**
```sql
-- Insert initial status manually
INSERT INTO elevator_status (elevator_id, current_lineup, estimated_wait_time, status)
VALUES (1, 0, 0, 'open')
ON CONFLICT (elevator_id) DO NOTHING;
```

### Alerts Not Showing

**Possible Causes:**
1. Alert priority too low (< 2)
2. User status is "waiting_in_queue"
3. Alerts debounced (too frequent)

**Solution:**
- Check `shouldSilenceAlerts()` returns false
- Lower priority threshold in code
- Adjust debounce duration

### Real-Time Not Updating

**Possible Causes:**
1. Realtime not enabled on table
2. RLS blocking updates
3. Network connection issue

**Solution:**
```sql
-- Check Realtime publication
SELECT * FROM pg_publication_tables
WHERE pubname = 'supabase_realtime';

-- Should include: elevator_status, queue_updates, user_queue_status
```

---

## Performance Metrics

### Target Metrics
- **Update Latency**: < 2 seconds from change to UI update
- **Alert Response**: < 500ms from threshold breach to notification
- **Dashboard Load**: < 2 seconds on 4G connection
- **WebSocket Reconnect**: < 3 seconds after network recovery

### Monitoring
Use Supabase Dashboard to monitor:
- Realtime connections count
- Database query performance
- RLS policy execution time

---

## Conclusion

The real-time queue monitoring system is now **fully functional** and ready for alpha testing. Farmers can:

✅ See live elevator wait times
✅ Get instant alerts when queue changes significantly
✅ Make informed decisions about when to haul
✅ Silence alerts when waiting in line
✅ View historical trends and comparisons

**Next**: Test with real farmers, gather feedback, and iterate!

---

**Version:** v2.1.0-alpha
**Build Status:** ✅ Passing
**Realtime Status:** ✅ Active
**Ready for:** Alpha Testing with Live Data
