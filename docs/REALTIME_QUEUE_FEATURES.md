# HaulPass Real-Time Queue Features

**Last Updated:** November 18, 2025
**Version:** 2.1
**Status:** Design Specification

---

## Overview

HaulPass provides real-time elevator queue updates so farmers can make informed decisions throughout their hauling workflow. The system continuously monitors elevator queue status and alerts farmers when conditions change, allowing them to decide whether to proceed or wait after loading.

---

## Critical User Journey

### Scenario: Farmer Decides Whether to Wait After Loading

```
8:00 AM - Farmer checks app
┌─────────────────────────────────────┐
│ Prairie Gold Co-op                  │
│ 8 min wait time est.                │
│ 2 trucks in line                    │
│ ✓ Good time to haul                 │
└─────────────────────────────────────┘
Decision: "Good timing, I'll start loading"

8:25 AM - Loading complete (23 min)
Farmer checks app again BEFORE driving
┌─────────────────────────────────────┐
│ Prairie Gold Co-op                  │
│ 35 min wait time est. ⚠️            │
│ 7 trucks in line (+5 trucks!)       │
│ ⚠️ Long wait expected               │
└─────────────────────────────────────┘
Decision: "Too busy now. I'll wait or switch elevators"

Alternative: Queue stayed low
┌─────────────────────────────────────┐
│ Prairie Gold Co-op                  │
│ 12 min wait time est.               │
│ 3 trucks in line (+1 truck)         │
│ ✓ Good time to haul                 │
└─────────────────────────────────────┘
Decision: "Still good, let's go!"
```

---

## Real-Time Features

### 1. Live Queue Monitoring

**Purpose:** Show current elevator status without refresh

**Implementation:**
- Supabase Realtime subscriptions to `elevator_status` table
- WebSocket connection for instant updates
- Automatic reconnection on network issues

**Data Monitored:**
```dart
{
  elevatorId: string,
  currentLineup: int,        // Number of trucks waiting
  estimatedWait: int,        // Minutes
  status: 'open' | 'busy' | 'closed',
  lastUpdated: DateTime,
  updatedBy: string,         // User ID who reported
}
```

**Update Frequency:**
- Continuous WebSocket stream
- 5-second heartbeat to detect disconnections
- Instant push when queue changes

### 2. Queue Change Alerts

**Alert Triggers:**
```dart
// Alert when lineup increases significantly
if (newLineup - oldLineup >= 3) {
  showAlert('Queue growing fast! +${difference} trucks');
}

// Alert when wait time crosses thresholds
if (oldWait < 20 && newWait >= 20) {
  showAlert('Wait time increased to ${newWait} min');
}

// Alert when elevator status changes
if (status changed to 'busy' or 'closed') {
  showAlert('${elevatorName} is now ${status}');
}
```

**Alert Behavior:**
- **Only show when NOT in "Waiting in Queue" status**
- Farmer can silence alerts by marking "Waiting in Elevator Queue"
- Resume alerts after "Finish Unloading" button pressed
- Push notifications if app is in background

### 3. Smart Recommendations

Based on real-time data, show actionable insights:

```dart
// When queue is growing
"Queue growing fast! Consider waiting 30 min"

// When alternative elevator is better
"Viterra (12km away) has 5 min wait vs 35 min here"

// Historical patterns
"Usually clears out by 10:30 AM based on Tuesdays"

// Best time to leave
"If you leave now, estimated arrival wait: 15 min"
```

---

## Database Schema for Real-Time

### Tables

#### `elevator_status` (Real-time enabled)
```sql
CREATE TABLE elevator_status (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  elevator_id BIGINT REFERENCES elevators_import(id),
  current_lineup INT NOT NULL DEFAULT 0,
  estimated_wait_minutes INT NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'open', -- 'open', 'busy', 'closed'
  last_updated TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_by UUID REFERENCES auth.users(id),
  confidence_score FLOAT DEFAULT 1.0, -- Data quality indicator
  UNIQUE(elevator_id)
);

-- Enable realtime
ALTER PUBLICATION supabase_realtime ADD TABLE elevator_status;

-- Index for fast lookups
CREATE INDEX idx_elevator_status_elevator_id ON elevator_status(elevator_id);
CREATE INDEX idx_elevator_status_updated ON elevator_status(last_updated DESC);
```

#### `queue_updates` (Historical log)
```sql
CREATE TABLE queue_updates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  elevator_id BIGINT REFERENCES elevators_import(id),
  lineup_count INT NOT NULL,
  wait_time_minutes INT NOT NULL,
  status TEXT NOT NULL,
  reported_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  source TEXT DEFAULT 'user_report', -- 'user_report', 'system_estimate', 'sensor'
  metadata JSONB
);

-- Index for analytics
CREATE INDEX idx_queue_updates_elevator_created ON queue_updates(elevator_id, created_at DESC);
```

#### `user_queue_status` (Track farmer's current state)
```sql
CREATE TABLE user_queue_status (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id),
  elevator_id BIGINT REFERENCES elevators_import(id),
  status TEXT NOT NULL, -- 'loading', 'driving', 'waiting_in_queue', 'unloading', 'completed'
  alerts_silenced BOOLEAN DEFAULT FALSE,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable realtime for cross-user coordination
ALTER PUBLICATION supabase_realtime ADD TABLE user_queue_status;
```

---

## Supabase Realtime Implementation

### Flutter Client Setup

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class ElevatorQueueService {
  final supabase = Supabase.instance.client;
  RealtimeChannel? _queueChannel;

  /// Subscribe to elevator queue updates
  Stream<ElevatorStatus> subscribeToElevator(String elevatorId) {
    final streamController = StreamController<ElevatorStatus>();

    _queueChannel = supabase.channel('elevator:$elevatorId')
      ..on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(
          event: '*', // INSERT, UPDATE, DELETE
          schema: 'public',
          table: 'elevator_status',
          filter: 'elevator_id=eq.$elevatorId',
        ),
        (payload, [ref]) {
          final data = payload['new'] as Map<String, dynamic>;
          final status = ElevatorStatus.fromJson(data);
          streamController.add(status);
        },
      )
      ..subscribe();

    return streamController.stream;
  }

  /// Update queue status (after user reports)
  Future<void> reportQueueStatus({
    required String elevatorId,
    required int lineupCount,
    required int waitMinutes,
  }) async {
    await supabase.from('elevator_status').upsert({
      'elevator_id': elevatorId,
      'current_lineup': lineupCount,
      'estimated_wait_minutes': waitMinutes,
      'status': _calculateStatus(lineupCount, waitMinutes),
      'last_updated': DateTime.now().toIso8601String(),
      'updated_by': supabase.auth.currentUser?.id,
      'confidence_score': 1.0, // High confidence for user reports
    }, onConflict: 'elevator_id');

    // Also log in history
    await supabase.from('queue_updates').insert({
      'elevator_id': elevatorId,
      'lineup_count': lineupCount,
      'wait_time_minutes': waitMinutes,
      'status': _calculateStatus(lineupCount, waitMinutes),
      'reported_by': supabase.auth.currentUser?.id,
      'source': 'user_report',
    });
  }

  String _calculateStatus(int lineup, int wait) {
    if (lineup > 5 || wait > 40) return 'busy';
    if (lineup == 0 && wait < 10) return 'open';
    return 'moderate';
  }

  /// Set user's queue status (silences alerts)
  Future<void> setUserStatus({
    required String status,
    required String? elevatorId,
  }) async {
    await supabase.from('user_queue_status').upsert({
      'user_id': supabase.auth.currentUser!.id,
      'elevator_id': elevatorId,
      'status': status,
      'alerts_silenced': status == 'waiting_in_queue',
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id');
  }

  void dispose() {
    _queueChannel?.unsubscribe();
  }
}
```

### Provider Integration

```dart
@riverpod
Stream<ElevatorStatus> liveElevatorStatus(
  LiveElevatorStatusRef ref,
  String elevatorId,
) {
  final service = ref.watch(elevatorQueueServiceProvider);
  return service.subscribeToElevator(elevatorId);
}

@riverpod
class QueueAlertManager extends _$QueueAlertManager {
  Timer? _alertDebouncer;

  @override
  Future<void> build() async {
    // Listen to favorite elevator
    final favoriteElevatorId = ref.watch(favoriteElevatorProvider);
    final userStatus = ref.watch(currentUserQueueStatusProvider);

    if (favoriteElevatorId != null) {
      ref.listen(
        liveElevatorStatusProvider(favoriteElevatorId),
        (previous, next) {
          if (previous != null && next.hasValue) {
            _checkForAlerts(previous.value!, next.value!, userStatus);
          }
        },
      );
    }
  }

  void _checkForAlerts(
    ElevatorStatus old,
    ElevatorStatus current,
    UserQueueStatus? userStatus,
  ) {
    // Don't alert if user is waiting in queue
    if (userStatus?.alertsSilenced == true) return;

    // Debounce rapid changes
    _alertDebouncer?.cancel();
    _alertDebouncer = Timer(const Duration(seconds: 3), () {
      _evaluateAndShowAlert(old, current);
    });
  }

  void _evaluateAndShowAlert(ElevatorStatus old, ElevatorStatus current) {
    final lineupChange = current.currentLineup - old.currentLineup;
    final waitChange = current.estimatedWaitMinutes - old.estimatedWaitMinutes;

    if (lineupChange >= 3) {
      _showAlert(
        'Queue Alert',
        'Queue growing! +$lineupChange trucks (now ${current.currentLineup})',
        AlertPriority.high,
      );
    } else if (waitChange >= 15) {
      _showAlert(
        'Wait Time Alert',
        'Wait increased to ${current.estimatedWaitMinutes} min',
        AlertPriority.medium,
      );
    }
  }

  void _showAlert(String title, String message, AlertPriority priority) {
    // Show in-app notification
    NotificationService.instance.showLocal(title, message);

    // Show push notification if app in background
    if (priority == AlertPriority.high) {
      NotificationService.instance.showPush(title, message);
    }
  }
}
```

---

## UI Components for Real-Time

### Live Queue Badge

```dart
class LiveQueueBadge extends ConsumerWidget {
  final String elevatorId;

  const LiveQueueBadge({required this.elevatorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(liveElevatorStatusProvider(elevatorId));

    return statusAsync.when(
      data: (status) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getStatusColor(status.currentLineup),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.circle, size: 8, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              'LIVE: ${status.currentLineup} trucks',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Icon(Icons.error_outline, color: Colors.red),
    );
  }

  Color _getStatusColor(int lineup) {
    if (lineup < 3) return Colors.green;
    if (lineup < 6) return Colors.orange;
    return Colors.red;
  }
}
```

---

## Testing Real-Time Features

### Local Testing
```dart
// Simulate queue changes for testing
void _simulateQueueGrowth() async {
  for (int i = 0; i < 10; i++) {
    await Future.delayed(const Duration(seconds: 5));
    await queueService.reportQueueStatus(
      elevatorId: 'test-elevator',
      lineupCount: i + 2,
      waitMinutes: (i + 2) * 5,
    );
  }
}
```

### Multi-Device Testing
1. Open app on Phone A
2. Open app on Phone B (different user)
3. Phone B reports queue update
4. Phone A should see update within 2-3 seconds
5. Verify alerts trigger correctly

---

## Performance Considerations

### Optimization Strategies

1. **Connection Pooling**
   - Reuse single WebSocket connection
   - Subscribe to multiple channels on one connection

2. **Debouncing**
   - Wait 2-3 seconds before showing alerts
   - Prevents alert spam from rapid changes

3. **Battery Optimization**
   - Disconnect when app in background > 5 min
   - Reconnect on app resume

4. **Data Caching**
   - Cache last known status
   - Show cached data while reconnecting

5. **Bandwidth**
   - Only subscribe to favorite/nearby elevators
   - Unsubscribe when user navigates away

---

## Security & Privacy

### Row Level Security (RLS)

```sql
-- Anyone can read elevator status
CREATE POLICY "elevator_status_read" ON elevator_status
  FOR SELECT USING (true);

-- Only authenticated users can update
CREATE POLICY "elevator_status_update" ON elevator_status
  FOR UPDATE USING (auth.uid() IS NOT NULL);

-- Users can only update their own queue status
CREATE POLICY "user_queue_status_update" ON user_queue_status
  FOR UPDATE USING (auth.uid() = user_id);
```

### Data Privacy
- Queue updates are anonymous (no personal data)
- User location not shared
- Only elevator ID and queue count transmitted

---

## Future Enhancements

### Phase 1 (Current)
- ✅ Real-time queue updates
- ✅ Basic alerts
- ✅ Silence when waiting in queue

### Phase 2 (Next Sprint)
- 🔄 Predictive wait times using ML
- 🔄 Crowd-sourced accuracy improvements
- 🔄 Historical pattern analysis

### Phase 3 (Future)
- 📅 Computer vision for automatic lineup counting
- 📅 Integration with elevator management systems
- 📅 Weather-based wait time adjustments
- 📅 Grain price correlation

---

## Documentation Links

- [UI Redesign Summary](./UI_REDESIGN_SUMMARY.md)
- [Vision & Specification](./HAULPASS_VISION_AND_SPECIFICATION.md)
- [Supabase Setup](../supabase/README.md)
- [Flutter Realtime Docs](https://supabase.com/docs/guides/realtime)

---

**Status:** 🚧 Ready for Implementation
**Next Steps:** Set up Supabase tables and RLS policies
