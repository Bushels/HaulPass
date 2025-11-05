# HaulPass - Complete Feature Documentation

## 🎯 Core Problem

Farmers waste hours every day sitting in grain elevator lineups without knowing wait times in advance. HaulPass solves this by predicting queue times before farmers leave their yards, using real-time data from all app users.

## 📱 Complete User Workflow

### 1. Loading at the Yard

**User opens app and sees:**
- Favorite elevators with current estimated wait times
- Option to start a new load

**Loading Process:**
1. Tap "New Load" button
2. Select grain type (corn, soybeans, wheat, canola, oats, etc.)
3. Enter moisture % (optional)
4. Enter weight from truck scale in lbs or kg (optional - not all farmers have scales)
5. Select destination elevator from list

**Smart Features:**
- App automatically calculates ETA based on:
  - GPS distance to elevator
  - Historical drive times from this location
  - Load weight (learns that heavier loads = slower travel)
  - Current route conditions
- Shows predicted lineup times at all elevators based on historical patterns for this time/day

### 2. Predictive Queue Intelligence

**Real-Time Tracking + Pattern Learning:**
The app combines real-time data with historical patterns for the most accurate predictions:

**Backend Tracking (Anonymous):**
- Tracks which users are loaded and heading to which elevator
- Knows estimated arrival times based on GPS distance
- Tracks current lineup state from users at elevators
- Combines with historical patterns for confidence

**What Farmers See (Focused on Their Experience):**
```
Richardson Pioneer
Current lineup: 4 trucks (confirmed by app users)
Est wait time: 3hr 18min
Status: 16% busier than usual for Tuesday 2 PM

Your predicted experience:
• Arrive at: 2:45 PM
• Position in line: 7th
• Est unload time: 6:20 PM
• Total time: 3hr 35min
```

**What You DON'T See:**
- Who else is hauling
- Where other farmers are coming from
- Other users' load details
- Identity of other haulers

**Status Bar Visualization:**
```
[████████████░░░░░░░░] 16% busier than usual
Your wait: 3hr 18min | Typical: 2hr 45min
```

**How It Works:**
- App knows 6 trucks are en route (anonymous)
- Knows 4 trucks currently in line (reported by users there)
- Calculates your position when you arrive
- Estimates each truck's unload time
- Shows YOU when YOU'll be done
- Doesn't tell you about other farmers' specifics

### 3. En Route to Elevator

**Automatic GPS Tracking:**
- App tracks location in background
- Monitors progress toward destination
- Updates ETA continuously
- Compares actual vs predicted travel time to improve algorithm

**User sees:**
- Live map showing route
- Updated ETA
- Real-time lineup updates:
  - "5 trucks now waiting at Richardson"
  - "Your est wait: 3hr 25min" (updates as conditions change)
  - "2 trucks just arrived" (anonymous count updates)

### 4. Arrival at Elevator

**Automatic Detection:**
- GPS detects arrival at elevator location
- App prompts: "Have you arrived at [Elevator Name]?"

**If user confirms "Yes":**
- App asks: "How many trucks ahead of you?" (not counting the truck currently unloading)
- Options: 0, 1, 2, 3, 4, 5+ (with manual entry)
- User can select truck types in line:
  - Super-B (large semi)
  - Triaxle with trailer
  - Triaxle (single unit)
  - Dual axle
  - Single axle
  - Unknown (assumes average)

**If user doesn't respond:**
- If GPS shows stopped movement near elevator for 2+ minutes
- App automatically assumes they're in lineup
- Estimates their position based on timing

**Smart Validation:**
- Compares reported truck count vs predicted lineup
- Adjusts algorithm accuracy for future predictions
- Updates wait time estimate based on actual lineup

### 5. Waiting in Lineup

**Real-Time Position Tracking:**
- App tracks movement through the line
- Updates position as trucks move up
- Shows estimated time to unload

**Unload Time Estimates:**

**For trucks WITH HaulPass (in front of you):**
- Uses their actual historical avg unload time
- Factors in their reported load weight
- More accurate predictions

**For trucks WITHOUT HaulPass:**
- Uses truck type (if you selected when arriving)
- Uses elevator's historical average for that truck type
- Assumes typical load size

**Your Display:**
```
Position: 3rd in line
Trucks ahead:
• Truck 1: ~8 min (unloading now)
• Truck 2: ~7 min (app user, known avg time)
• You're next: ~8 min (your avg unload time)

Est completion: 4:42 PM
```

**Movement Detection:**
- GPS detects forward movement in line
- Updates position automatically
- "You're now 3rd in line" → "You're now 2nd in line" → "You're next!"

**Time Tracking:**
- Total time in lineup
- Average movement speed through line
- Estimated time to unload position

### 6. Unloading

**Detection Methods:**

**Option A - Manual Button:**
- User taps "Unloading Now" button
- Starts unload timer
- Geotags exact unload location

**Option B - Automatic Detection:**
- GPS recognizes unload area from historical data
- Knows where other trucks have tapped "Unload" button
- Automatically detects when truck reaches that position
- Confirms with user: "Are you unloading now?"

**During Unload:**
- Timer tracks unload duration
- Associates time with load weight for future predictions
- Updates other users' wait time estimates

### 7. Post-Unload Data Entry

**Required/Optional Fields:**

**Elevator Weight (Optional):**
- Enter official weight from elevator ticket (lbs or kg)
- App compares with farmer's scale weight (if entered earlier)
- Calculates weight difference for scale accuracy tracking

**Dockage % (Optional):**
- Enter dockage percentage from elevator
- Tracks dockage by elevator and grain type
- Historical dockage comparison

**Grain Price (Optional):**
- Enter price per bushel/tonne
- App calculates total load value
- Tracks earnings for the day/week/season

**Quick Actions:**
- "Save Load" - completes this load
- "New Load" - immediately start another round trip
- "Done Hauling for Today" - end daily tracking

### 8. Multiple Loads Per Day

**Round Trip Tracking:**
- Each "New Load" button = another round trip
- App tracks:
  - Load count for the day
  - Total weight hauled
  - Total kms driven
  - Cumulative time driving, waiting, unloading
  - Total revenue (if prices entered)

**Between Loads:**
- Can view daily progress
- See summary so far
- Compare to previous days
- Adjust strategy based on lineup predictions

### 9. End of Day Summary

**Manual Trigger:**
- User taps "Done Hauling for Today" button

**Daily Summary Includes:**
- **Total loads**: Number of trips completed
- **Total weight hauled**: Sum of all loads (tonnes/bushels)
- **Total kms driven**: Round trip distance sum
- **Time breakdown**:
  - Time spent driving
  - Time spent in lineups
  - Time spent unloading
  - Total time on road
- **Efficiency metrics**:
  - Average time per load
  - Wait time percentage
  - Loads per hour
- **Financial summary** (if prices entered):
  - Total revenue for the day
  - Average price per unit
  - Top earning loads

**Historical Comparison:**
- Compare to previous days
- Weekly/monthly totals
- Best/worst days analysis

### 10. Data & Analytics Features

**Load History:**
- View all past loads
- Filter by:
  - Date range
  - Grain type
  - Elevator
  - Weight range
  - Price range
- Sort by:
  - Date (newest/oldest)
  - Weight (highest/lowest)
  - Revenue (highest/lowest)
  - Wait time (longest/shortest)
  - Dockage (highest/lowest)

**Elevator Insights:**
- Average wait times by elevator
- Best times of day to visit each elevator
- Historical dockage rates
- Fastest unload elevators
- Most consistent elevators

**Personal Stats:**
- Total lifetime weight hauled
- Total kms driven
- Most hauled grain type
- Favorite elevators
- Best efficiency days
- Seasonal trends

### 11. Social Features (Potential Premium)

**Anonymous Leaderboards:**

**Daily Scoreboard:**
- Most grain unloaded today (anonymous usernames)
- Most kms driven today
- Most loads completed
- Highest efficiency rating

**Filters:**
- By region
- By grain type
- By truck type
- All-time records

**Privacy:**
- All data is anonymous
- Users choose their display name
- No personal information shown
- Can opt-out of leaderboards entirely

### 12. Premium Features (Future)

**Contract Pricing:**
- Store contract prices by grain type and buyer
- Automatic contract price application
- Contract vs spot price comparison
- Alert when spot price exceeds contract

**Spot Market Integration:**
- Live market prices from commodity exchanges
- Automatic price updates
- Price trend charts
- Best price alerts

**Farm Data Sharing:**
- Share load data with farm managers
- Export for accounting software
- Integration with farm management systems
- Multi-user farm accounts

**Advanced Analytics:**
- Fuel efficiency tracking
- Cost per load analysis
- ROI calculations
- Seasonal planning tools

## 🧠 Machine Learning & Algorithms

### Travel Time Prediction

**Factors Considered:**
- Base GPS distance
- Historical drive times from this location
- Load weight (heavier = slower)
- Time of day
- Day of week
- Weather conditions
- Road conditions
- Driver-specific patterns

**Learning Over Time:**
- Each completed trip refines the model
- Learns individual driving patterns
- Accounts for truck-specific differences
- Adapts to seasonal variations

### Queue Time Prediction

**Real-Time Prediction Algorithm:**

**Input Data:**
- **Current lineup**: Trucks at elevator now (reported by app users there)
- **En route trucks**: Anonymous count of app users heading there with ETAs
- **Historical patterns**: Typical wait times for this day/time
- **Seasonal factors**: Harvest vs off-season multipliers
- **Truck types**: Known types for better unload time estimates

**Calculation for YOUR Wait Time:**
```
Your Predicted Wait =
  Current Trucks in Line × (Their Avg Unload Times) +
  Trucks Arriving Before You × (Their Avg Unload Times) +
  Movement Time Through Line +
  Your Unload Time
```

**Example Breakdown:**
```
Richardson Pioneer - Tuesday 2:30 PM - October
You're loading now, will arrive at 2:45 PM

Current state (2:30 PM):
• 4 trucks in line (confirmed by app users there)
• 3 app users en route, arriving before you
• 2 non-app trucks estimated

When you arrive (2:45 PM):
• Position: 7th in line
• Trucks with app (known avg times): 6 trucks × 8 min = 48 min
• Trucks without app (estimated): 2 trucks × 10 min = 20 min
• Your unload time: 8 min
• Total wait: 3hr 18min
• Complete by: 6:03 PM

Status bar: 16% busier than usual (Typical Tuesday 2 PM: 2hr 45min)
```

**Real-Time Updates:**
- As trucks arrive, position updates
- As trucks complete unloading, wait time decreases
- Anonymous count shown: "5 trucks now waiting"
- Your personal prediction updates continuously
- Comparison to historical average shown

**Privacy-Focused Display:**
- You see truck COUNTS, not identities
- You see YOUR predicted time, not others' details
- Status bar shows relative busyness
- All other users are anonymous

### Unload Position Detection

**Geofencing:**
- Create virtual boundary around unload area
- Learn from user-confirmed unload locations
- Cluster analysis of GPS points where "Unload" tapped
- Define unload zone with confidence radius

**Automatic Detection:**
- Trigger when GPS enters unload zone
- Confirm truck has been moving (to distinguish from parking)
- Check time since arrival (likely at unload position)
- Prompt user for confirmation
- Learn from confirmations/corrections

## 📊 Data Collection Points

### What the App Tracks

**Load Data:**
- Grain type
- Moisture % (optional)
- Farmer's scale weight (optional)
- Elevator's scale weight (optional)
- Dockage %
- Grain price (optional)
- Destination elevator

**Location Data:**
- GPS coordinates during hauling (for YOUR route learning)
- Route taken (private to your account)
- Travel time (for YOUR ETA improvement)
- Arrival time at elevator (anonymous for pattern learning)
- Position in lineup
- Unload location (for automatic detection)
- **Destination elevator** (anonymous - for real-time queue predictions)

**Timing Data:**
- Load start time
- Departure time from yard
- Arrival time at elevator
- Time entered lineup
- Position changes in line
- Unload start time
- Unload completion time
- Time between loads

**Lineup Data:**
- Number of trucks ahead (user-reported)
- Truck types in line (user-reported)
- Position movement timing
- Actual wait time vs predicted

**Aggregate Data:**
- Anonymous usage patterns
- Elevator throughput rates
- Regional hauling patterns
- Seasonal trends

## 🔒 Privacy & Data Sharing

**What the App Tracks (Backend):**
- ✓ Which elevator you're heading to (for queue predictions)
- ✓ Your ETA (for lineup position calculation)
- ✓ Your historical avg unload time (for accurate estimates)
- ✓ Your load weight (optional, for unload time estimates)
- ✓ Your GPS route (for YOUR ETA learning only)

**What Other Farmers See:**
- ✗ NOT who you are
- ✗ NOT where your farm is
- ✗ NOT your specific load details
- ✓ "4 trucks waiting" (anonymous count)
- ✓ "16% busier than usual" (aggregate comparison)
- ✓ Their own predicted wait time (calculated using your data anonymously)

**Your Private Data:**
- Farm location
- Exact routes
- Load weights
- Prices received
- Dockage percentages
- Financial information
- Personal identity

**Shared Anonymously for Predictions:**
- Elevator destination
- ETA arrival time
- Historical avg unload time
- Truck type
- Anonymous contribution to "X trucks en route"

**Future Opt-In Sharing:**
- Share data with farm manager/owner
- Export to accounting software
- Integration with elevator systems (with permission)
- Co-op or fleet data pooling

## 📱 User Interface Design Principles

**Speed First:**
- Most common actions require 1-2 taps
- Default values based on user history
- Smart auto-complete
- Minimal data entry required

**Farm-Friendly:**
- Large touch targets for gloved hands
- High contrast for sunlight visibility
- Voice input for all text fields
- Works with one hand while in cab

**Offline-Capable:**
- All data entry works offline
- Syncs automatically when service available
- Clear indicators of sync status
- No data loss

**Distraction-Free:**
- No data entry while moving (GPS-detected)
- Voice prompts for key events
- Minimal notifications
- Focus mode during hauling

## 🚀 Future Enhancements

**Cooperative Features:**
- Co-op member coordination
- Shared elevator information
- Group hauling optimization
- Fleet management tools

**Elevator Integration:**
- Direct elevator status feeds
- Automated check-in
- Digital ticket delivery
- Payment integration

**Weather Integration:**
- Weather-based hauling recommendations
- Field condition tracking
- Moisture prediction
- Harvest planning

**Advanced Route Planning:**
- Multi-elevator comparison
- Split load optimization
- Fuel price integration
- Maintenance scheduling

---

**Built to save farmers time, reduce stress, and increase efficiency through smart predictions and community data.**
