# Testing Guide - Enhanced Home Screen

## Quick Start

The Enhanced Home Screen is now integrated into the app and ready for testing!

### 1. Install Dependencies

```bash
flutter pub get
```

This will install the new packages:
- `flutter_animate` - Smooth animations
- `shimmer` - Loading skeletons
- `percent_indicator` - Progress bars
- `fl_chart` - Charts (for future use)
- `timeago` - Relative time formatting

### 2. Run on Web (Alpha Testing)

```bash
flutter run -d chrome
```

Or for a specific port:

```bash
flutter run -d chrome --web-port=8080
```

### 3. Run on Mobile (Beta Testing)

**iOS Simulator:**
```bash
flutter run -d 'iPhone 15 Pro'
```

**Android Emulator:**
```bash
flutter run -d emulator-5554
```

## What You'll See

### Home Screen Features

1. **App Bar**
   - "HaulPass" title with tagline
   - Live connection indicator (green dot)
   - User profile menu

2. **Quick Stats Card** (blue/purple container)
   - Average wait time across all elevators
   - Number of active elevators
   - Fastest elevator name

3. **Elevator Cards** (3 sample cards)
   - **Richardson Pioneer**: 4 trucks, 3h 18m wait, 16% busier
   - **Prairie Co-op**: 2 trucks, 18m wait, normal
   - **Cargill Grain**: 1 truck, 8m wait, 25% slower

4. **Card Details**
   - Large wait time display (36pt font)
   - Visual busyness gradient bar
   - Distance and ETA
   - Grain type chips
   - Status badges (Open/Busy/Closed)

5. **Floating Action Button**
   - "New Load" button (shows placeholder message)

### Animations to Verify

- ✨ Cards fade in and slide from right
- ✨ Wait times scale and fade in
- ✨ Connection indicator has shimmer effect
- ✨ Busyness bar marker animates smoothly
- ✨ Pull-to-refresh shows loading skeleton

## Testing Checklist

### Visual Tests

- [ ] Cards display with correct layout
- [ ] Wait times are large and easy to read
- [ ] Busyness bars show gradient (green → grey → orange → red)
- [ ] Status badges show correct colors
- [ ] Touch targets are large (minimum 64dp)
- [ ] Text is high contrast for outdoor visibility

### Interaction Tests

- [ ] Pull down to refresh (shows skeleton, then cards)
- [ ] Tap card to see bottom sheet details
- [ ] Tap "New Load" button (shows coming soon message)
- [ ] Open user menu (Profile, Settings, Sign Out)
- [ ] Scroll smoothly through elevator list

### Responsive Tests

- [ ] Works on mobile (375px width)
- [ ] Works on tablet (768px width)
- [ ] Works on desktop/web (1024px+ width)
- [ ] Cards adapt to screen size

### Animation Tests

- [ ] Smooth fade-in on initial load
- [ ] Staggered card entrance (100ms delay each)
- [ ] Busyness bar marker moves smoothly
- [ ] Wait time numbers scale in
- [ ] Skeleton shimmer effect works

## Sample Data Overview

The screen uses realistic sample data for UI testing:

```dart
// Elevator 1: Richardson Pioneer
- Location: Winnipeg, MB (12.3 km away)
- Trucks waiting: 4 (+ 0 en route)
- Wait time: 3hr 18min
- Typical: 2hr 45min
- Busyness: +16% busier
- Status: Open
- Grains: Corn, Wheat, Soybeans, Canola

// Elevator 2: Prairie Co-op
- Location: Winnipeg, MB (8.7 km away)
- Trucks waiting: 2 (+ 0 en route)
- Wait time: 18min
- Typical: 15min
- Busyness: 0% (normal)
- Status: Open
- Grains: Corn, Wheat, Oats

// Elevator 3: Cargill Grain
- Location: Winnipeg, MB (15.2 km away)
- Trucks waiting: 1 (+ 0 en route)
- Wait time: 8min
- Typical: 20min
- Busyness: -25% slower
- Status: Open
- Grains: Corn, Wheat, Soybeans
```

## Known Limitations (Expected)

These are placeholders that will be implemented next:

- ❌ **No real data** - Using sample data only
- ❌ **No location services** - Distance/ETA are hardcoded
- ❌ **No real-time updates** - Pull-to-refresh reloads sample data
- ❌ **New Load button** - Shows placeholder message
- ❌ **Settings menu** - Not implemented yet
- ❌ **Connection indicator** - Always shows "Live"
- ❌ **Bottom sheet details** - Basic implementation only

## Common Issues

### Build Errors

**Issue**: `flutter_animate` or other packages not found
```
Solution: Run `flutter pub get` again
```

**Issue**: Import errors for `queue_models.dart`
```
Solution: Run `dart run build_runner build --delete-conflicting-outputs`
```

**Issue**: `currentUserProvider` not found
```
This is normal if auth isn't set up. The app should handle this gracefully
with a fallback to 'U' (User) initial.
```

### Runtime Errors

**Issue**: Supabase configuration error
```
This is expected! The app uses sample data for now.
You can ignore Supabase errors in debug mode.
```

**Issue**: No elevators showing (empty state)
```
Check that `_getSampleData()` is being called in
`lib/presentation/screens/home/enhanced_home_screen.dart`
```

## Performance Testing

### Web Performance
- Initial load: Should be < 3 seconds
- Animation frame rate: Should be 60fps
- Memory usage: Should be < 100MB

### Mobile Performance
- Initial load: Should be < 2 seconds
- Scroll performance: Should be smooth (60fps)
- Animation performance: No dropped frames
- Battery usage: Minimal (no background tasks yet)

## Next Steps After Testing

Once you've verified the Enhanced Home Screen works:

### 1. Integrate Real Data
- Create `lib/presentation/providers/queue_provider.dart`
- Fetch real elevator data from Supabase
- Implement real-time subscriptions

### 2. Add Location Services
- Request GPS permissions
- Calculate actual distances
- Implement arrival detection

### 3. Implement New Load Flow
- Create load entry screen
- Add grain type selector
- Add moisture/weight inputs
- Connect to Supabase

### 4. Build Daily Summary Screen
- Create summary UI with charts
- Aggregate user's daily data
- Show efficiency metrics

## Debugging

### Enable Verbose Logging

Add to `main.dart`:
```dart
if (kDebugMode) {
  debugPrint('🏠 EnhancedHomeScreen loaded');
  debugPrint('📊 Elevator count: ${elevators.length}');
}
```

### Check Provider State

Add to `enhanced_home_screen.dart`:
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final elevatorsAsync = ref.watch(elevatorsWithQueueProvider);

  // Debug print
  print('Provider state: ${elevatorsAsync.runtimeType}');

  elevatorsAsync.when(
    data: (elevators) => print('Got ${elevators.length} elevators'),
    loading: () => print('Loading...'),
    error: (e, st) => print('Error: $e'),
  );

  // ... rest of build
}
```

### Hot Reload Tips

- ✅ UI changes: Use `r` for hot reload
- ✅ Provider changes: Use `R` for hot restart
- ✅ Model changes: Rebuild with build_runner, then hot restart
- ✅ New dependencies: Stop app, pub get, restart

## Screenshots

Take screenshots at these sizes for documentation:

1. **Mobile Portrait** (375x812)
   - iPhone 13/14 standard size

2. **Tablet** (768x1024)
   - iPad standard size

3. **Desktop** (1280x720)
   - Web browser size

## Testing on Different Conditions

### Outdoor Visibility Test
- Test in bright sunlight (if possible)
- Verify high contrast colors work
- Check text legibility at arm's length

### Glove Test
- Wear work gloves
- Verify all buttons are easy to tap
- Check that 64dp touch targets work

### Network Conditions
- Test on slow 3G connection
- Test with intermittent connectivity
- Verify loading states appear correctly

## Success Criteria

The Enhanced Home Screen is ready for alpha when:

- ✅ All 3 sample cards display correctly
- ✅ Animations are smooth and professional
- ✅ Pull-to-refresh works
- ✅ Touch targets are large enough
- ✅ Works on web, iOS, and Android
- ✅ Loading states show properly
- ✅ No console errors (except Supabase config warnings)

## Report Issues

If you find bugs, note:
1. Platform (web/iOS/Android)
2. Screen size
3. Steps to reproduce
4. Expected vs actual behavior
5. Screenshots/screen recording

## Ready for Alpha!

Once testing passes, you can:
1. Deploy to web for farmer feedback
2. Share the web URL with alpha testers
3. Gather feedback on UI/UX
4. Iterate on design based on feedback

Then move to beta with real Supabase integration and location services!
