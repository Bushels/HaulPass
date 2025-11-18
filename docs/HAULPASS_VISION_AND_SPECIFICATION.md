# HaulPass - Complete Vision and Technical Specification v2.1

**Last Updated:** November 18, 2025 - UI Redesign Implementation

## Executive Summary

**HaulPass is a real-time grain hauling intelligence platform that helps farmers make data-driven decisions about when and where to haul grain, reducing wait times and maximizing profitability through live queue tracking and comparative analytics.**

### ⭐ NEW: Mobile-First UI Redesign (v2.1)

We've completely redesigned the UI with a **mobile-first, farmer-optimized** approach for the alpha webapp launch. The new interface focuses on:

1. **Instant Insights** - Favorite elevator wait time front and center
2. **Smart Comparisons** - "13% faster than usual for Tuesday" type intelligence
3. **Quick Actions** - Start a load in 3 taps with optional detail collection
4. **Rich Statistics** - Interactive data showing grain types, weights, and trends
5. **Beautiful Design** - Premium animations and smooth transitions

**See [UI_REDESIGN_SUMMARY.md](./UI_REDESIGN_SUMMARY.md) for complete implementation details.**

### The Hook (Why Farmers Open the App)
**"Should I haul right now?"** - Farmers open HaulPass to see the **live elevator queue** at their favorite elevator and make an immediate go/no-go decision. This saves 30-60 minutes per trip by avoiding peak times.

### The Retention (Why Farmers Keep Using It)
As farmers use HaulPass, they discover **comparative intelligence** that reveals which elevators give better dockage rates, which ones have calibration issues, and optimal timing patterns—insights worth thousands per season.

### Core Value Ladder
1. **Immediate Value**: Live queue length → Avoid waiting (Hook - Day 1)
2. **Progressive Value**: Track haul efficiency → Improve operations (Week 1-4)
3. **Network Value**: Compare elevators → Choose better destinations (Month 1-3)
4. **Strategic Value**: Analyze patterns → Optimize entire season (Season 1+)

---

## Table of Contents

1. [Product Positioning](#product-positioning)
2. [User Experience Hierarchy](#user-experience-hierarchy)
3. [Home Screen Design](#home-screen-design)
4. [Complete Haul Workflow](#complete-haul-workflow)
5. [Queue Intelligence System](#queue-intelligence-system)
6. [Comparative Intelligence Platform](#comparative-intelligence-platform)
7. [User Onboarding](#user-onboarding)
8. [Data Models and Storage](#data-models-and-storage)
9. [Technical Stack](#technical-stack)
10. [Implementation Roadmap](#implementation-roadmap)
11. [Success Metrics](#success-metrics)

---

## Product Positioning

### What HaulPass Is

**Primary Function**: A real-time queue intelligence app that tells farmers when to haul grain

**Secondary Function**: A comparative analytics platform that reveals which elevators provide the best value

**Not**: A scheduling app, an elevator management tool, or a simple timer

### The Farmer's Mental Model

```
6:00 AM - Coffee in hand, farmer thinks:
"Should I start hauling today or wait until afternoon?"

Opens HaulPass → Sees:
┌────────────────────────────────────┐
│ 🏢 Prairie Grain Co-op             │
│                                    │
│ 🚛 Current Queue: 2 trucks         │
│ ⏱️  Estimated Wait: ~18 minutes    │
│                                    │
│ ✅ GOOD TIME TO HAUL               │
└────────────────────────────────────┘

Decision made. Starts loading.
```

### Why This Works

**Behavioral Psychology:**
- **Immediate feedback** → Dopamine hit from making smart decision
- **Visible savings** → "I just saved 40 minutes by checking first"
- **Social proof** → "2 trucks ahead" means activity is verified
- **Pattern recognition** → Learns when elevator is busiest

**Economic Psychology:**
- Time = Money (40 minutes saved × $50/hour = $33 per decision)
- Better dockage = Direct profit ($0.50/bushel × 1000 bushels = $500)
- Equipment calibration insights = Avoid disputes

---

## User Experience Hierarchy

### Priority 1: Queue Intelligence (The Hook)
**Goal**: Get farmer to open app daily to check queue

**User Question**: "Should I haul right now?"

**Answer Provided**:
- Current queue length
- Estimated wait time
- Historical comparison ("busier than usual")

**Design Priority**:
- Largest element on home screen
- Updates in real-time
- Visible at a glance

---

### Priority 2: Personal Efficiency (The Habit)
**Goal**: Farmer uses app during every haul

**User Question**: "How am I doing compared to usual?"

**Answer Provided**:
- Load time comparison
- Drive time tracking
- Unload efficiency
- Daily summary stats

**Design Priority**:
- Secondary tiles below queue intelligence
- Progressive disclosure (show more over time)
- Positive reinforcement ("6% faster than usual!")

---

### Priority 3: Comparative Intelligence (The Retention)
**Goal**: Farmer discovers strategic insights over weeks/months

**User Question**: "Am I getting a fair deal at this elevator?"

**Answer Provided**:
- Dockage comparison across elevators
- Moisture calibration variance
- Price comparison (future)
- Optimal timing patterns (ML)

**Design Priority**:
- Revealed gradually as data accumulates
- Shown in context (after completing haul)
- Non-intrusive but valuable
- Positioned as "pro tips" / "insights"

---

## Home Screen Design

### Layout Hierarchy

```
┌─────────────────────────────────────────────────┐
│  HaulPass                     🔔 📊 👤          │ ← Header
├─────────────────────────────────────────────────┤
│                                                 │
│  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  │
│  ┃ 🏢 Prairie Grain Co-op                  ┃  │ ← HERO CARD
│  ┃                                          ┃  │   (Glassmorphic)
│  ┃ 🚛 Current Queue: 2 trucks               ┃  │   (Glowing accents)
│  ┃ ⏱️  Est. Wait: ~18 min                   ┃  │   (Real-time)
│  ┃                                          ┃  │
│  ┃ ✅ Good time to haul                     ┃  │ ← Status indicator
│  ┃                                          ┃  │
│  ┃ Last updated: 2 minutes ago              ┃  │
│  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  │
│                                                 │
│  ┌────────────────┐  ┌────────────────┐       │
│  │ 📊 Your Stats  │  │ 🚚 Last Haul   │       │ ← Secondary Tiles
│  │                │  │                │       │   (Glass cards)
│  │ Total Hauls:47 │  │ Yesterday      │       │
│  │ Avg Wait: 21m  │  │ 3 loads, 73t   │       │
│  │ Avg Dockage:   │  │ Wait: 15m      │       │
│  │   1.4%         │  │ Dockage: 1.2%  │       │
│  └────────────────┘  └────────────────┘       │
│                                                 │
│  ┌─────────────────────────────────────────┐  │
│  │     [🚚 Start New Haul]                 │  │ ← Primary CTA
│  └─────────────────────────────────────────┘  │
│                                                 │
│  Quick Actions:                                │
│  🔍 Find Different Elevator                    │ ← Quick actions
│  📊 View Full History                          │
│  ⚙️  Settings                                  │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Hero Card States

#### State 1: Good Time to Haul
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 🏢 Prairie Grain Co-op     ┃
┃                            ┃
┃ 🚛 Queue: 2 trucks         ┃
┃ ⏱️  Wait: ~18 min          ┃
┃                            ┃
┃ ✅ Good time to haul       ┃ ← Green glow
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

#### State 2: Moderate Queue
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 🏢 Prairie Grain Co-op     ┃
┃                            ┃
┃ 🚛 Queue: 4 trucks         ┃
┃ ⏱️  Wait: ~42 min          ┃
┃                            ┃
┃ ⚠️  Moderate wait expected ┃ ← Amber glow
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

#### State 3: Long Queue
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 🏢 Prairie Grain Co-op     ┃
┃                            ┃
┃ 🚛 Queue: 7 trucks         ┃
┃ ⏱️  Wait: ~1hr 15min       ┃
┃                            ┃
┃ 🔴 Long wait - Consider    ┃ ← Red glow
┃    hauling later           ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

#### State 4: No Data Yet
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 🏢 Prairie Grain Co-op     ┃
┃                            ┃
┃ 📡 No recent activity      ┃
┃                            ┃
┃ Be the first to haul today ┃ ← Blue glow
┃ and help others!           ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

### Design System

**Glassmorphic Cards:**
- Semi-transparent background (rgba(255,255,255,0.1))
- Backdrop blur: 10-20px
- Subtle border: 1px solid rgba(255,255,255,0.2)
- Soft shadow: 0 8px 32px rgba(0,0,0,0.1)

**Glowing Status Indicators:**
- Green (good): #4CAF50 with 8px blur glow
- Amber (moderate): #FF9800 with 8px blur glow
- Red (busy): #F44336 with 8px blur glow
- Blue (no data): #2196F3 with 8px blur glow

**Typography:**
- Hero numbers: 48px bold
- Status text: 18px medium
- Secondary: 14px regular
- Timestamps: 12px light opacity 60%

**Animations:**
- Hero card pulses gently (1s ease-in-out)
- Queue number updates with slide animation
- Real-time badge glows continuously

---

## Complete Haul Workflow

---

## 🎯 Real-Time Queue Intelligence: The Core Loop

**This is the star feature.** The queue updates in real-time DURING loading, giving farmers a critical decision point.

### The Problem This Solves

**Old Way:**
```
Farmer loads truck (20 min) → Drives to elevator → Waits 60 min in line
💔 Wasted time, no information
```

**HaulPass Way:**
```
Farmer starts loading → Checks app → Queue: 2 trucks ✅
  ↓ (20 minutes pass while loading)
Farmer finishes loading → Checks app → Queue: 5 trucks 🔴
  ↓
Farmer decides: "I'll wait for queue to drop"
  ↓ (40 minutes monitoring queue via app)
Queue drops to 2 trucks ✅ → Farmer drives → Arrives, 15 min wait
💚 Saved 40+ minutes by checking queue in real-time
```

---

### Loading Screen with LIVE Queue Updates

**Key Insight**: Farmers spend 15-25 minutes loading. Queue can change dramatically in that time.

```
┌─────────────────────────────────────────┐
│ Loading Wheat                           │
├─────────────────────────────────────────┤
│                                         │
│        ⏱️  18m                          │ ← Loading timer
│   Your avg: 21m (3m faster!)            │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                         │
│ 🏢 Prairie Grain Queue (LIVE):          │ ← Real-time updates
│                                         │
│ 🚛 5 trucks (+3 new)                    │ ← Changed!
│ ⏱️  ~62 min (+44 min) 🔴                │ ← Jumped significantly
│                                         │
│ 📈 Trend: ▲ Growing                     │ ← Visual indicator
│ Updated: 8 seconds ago ●                │ ← Pulse animation
│                                         │
│ 🔔 Queue Alert:                         │
│ 3 more trucks joined while you loaded   │
│                                         │
│ [Finish Loading]                        │
└─────────────────────────────────────────┘
```

**Technical:**
- WebSocket subscription to queue updates
- Updates every 30 seconds
- Visual animation when number changes
- Color coding: Green (<20min), Amber (20-40min), Red (>40min)

---

### Critical Decision Point: After Loading

**This is where the magic happens.** Farmer has current queue info and decides whether to drive now or wait.

```
┌─────────────────────────────────────────┐
│ ✅ Loading Complete!                    │
├─────────────────────────────────────────┤
│                                         │
│ Your Truck Configuration:               │
│ Super B - 8 axles (62,500 lbs)          │
│ [Change Truck Type]                     │
│                                         │
│ Weight Loaded:                          │
│ [27,400] kg  [Toggle: kg/lbs/bushels]  │
│                                         │
│ Bin Moisture (optional):                │
│ [14.0] %  [Skip]                        │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                         │
│ 🏢 Prairie Grain CURRENT Queue:         │
│                                         │
│ 🚛 5 trucks in line:                    │
│    • 2× Super B (8-axle)                │ ← See truck types!
│    • 2× Tandem + Trailer                │
│    • 1× Straight Truck                  │
│                                         │
│ ⏱️  Est. Wait: ~62 minutes              │
│ 🔴 LONG WAIT - Consider waiting         │
│                                         │
│ Updated: 5 seconds ago                  │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                         │
│ What do you want to do?                 │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │   🚚 Drive Now                      │ │
│ │   (Accept 62 min wait)              │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │   ⏸️  Wait to Unload                │ │ ← NEW
│ │   (Monitor queue, drive when clear) │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ 💡 Tip: Queue usually clears in 30-40  │
│    minutes. Keep app open to monitor.  │
│                                         │
└─────────────────────────────────────────┘
```

**User Psychology:**
- Seeing current queue gives control
- Truck types make it tangible ("2 Super Bs ahead")
- Decision feels informed, not guessing

---

### "Wait to Unload" State: Keep Monitoring

**Goal**: Keep farmer engaged with app, watching queue drop in real-time.

```
┌─────────────────────────────────────────┐
│ ⏸️  Loaded & Ready - Monitoring Queue   │
├─────────────────────────────────────────┤
│                                         │
│ You're loaded with 27,400 kg of Wheat   │
│ Ready to haul when queue improves       │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                         │
│ 🏢 Prairie Grain LIVE Queue:            │
│                                         │
│ 🚛 3 trucks (-2 in last 15 min) ✅      │ ← Improving!
│ ⏱️  Est. Wait: ~28 min (-34 min)        │
│                                         │
│ Queue Status:                           │
│    • 1× Super B (8-axle)                │
│    • 1× Tandem + Trailer                │
│    • 1× Straight Truck                  │
│                                         │
│ 📉 Trend: ▼ Clearing (Good!)            │
│ Updated: 6 seconds ago ●                │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                         │
│ ✅ Queue improved by 34 minutes!        │ ← Positive reinforcement
│                                         │
│ You've saved ~40 min by monitoring      │
│ the queue instead of driving earlier    │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │   🚚 Start Hauling Now              │ │
│ │   (Good time! 28 min wait)          │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ [Set Alert: Notify when < 20 min]      │
│                                         │
│ 💡 Keep this screen open to see        │
│    real-time updates every 30 seconds  │
│                                         │
└─────────────────────────────────────────┘
```

**Engagement Hooks:**
- Live countdown timer on updates
- Visual animation when queue drops
- "Time saved" counter (gamification)
- Green checkmark when queue hits target
- Optional: Push notification when queue < threshold

---

### Queue Entry with Truck Types

**When farmer arrives at elevator, they report queue position AND truck types ahead.**

```
┌─────────────────────────────────────────┐
│ 🏢 Arrived at Prairie Grain Co-op       │
├─────────────────────────────────────────┤
│                                         │
│ How many trucks ahead of you?           │
│ (Not including currently unloading)     │
│                                         │
│  [0] [1] [2] [3] [4] [5] [6+]           │
│                                         │
│ Selected: 3 trucks ahead                │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                         │
│ What types? (helps predict wait time)   │
│                                         │
│ Truck 1 (closest to pit):               │
│ ┌─────────────────────────────────────┐ │
│ │ ○ Super B - 8 axle                  │ │
│ │ ○ Super B - 7 axle                  │ │
│ │ ○ Tandem + Trailer                  │ │
│ │ ○ Tandem + Pony                     │ │
│ │ ○ Straight Truck                    │ │
│ │ ○ Other/Unknown                     │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ Truck 2:                                │
│ [Same dropdown...]                      │
│                                         │
│ Truck 3:                                │
│ [Same dropdown...]                      │
│                                         │
│ [Skip Truck Types]  [Submit Queue Info] │
│                                         │
│ 💡 Truck types help everyone get        │
│    accurate wait time estimates         │
│                                         │
└─────────────────────────────────────────┘
```

**After Submission:**
```
✅ Queue Position Confirmed

You're 4th in line (including you)

Ahead of you:
• Super B - 8 axle (~12 min unload)
• Tandem + Trailer (~8 min unload)
• Straight Truck (~5 min unload)

Your estimated wait: ~28 minutes

Queue data shared with other farmers ✓
```

---

### Why Truck Types Are Game-Changing

**Better Predictions:**

| Truck Type | Avg GVW | Avg Unload Time |
|------------|---------|-----------------|
| Super B - 8 axle | 62,500 lbs (28,400 kg) | 12-15 min |
| Super B - 7 axle | 57,000 lbs (25,900 kg) | 11-13 min |
| Tandem + Trailer | 48,300 lbs (21,900 kg) | 8-10 min |
| Tandem + Pony | 41,300 lbs (18,700 kg) | 7-9 min |
| Straight Truck | 24,300 lbs (11,000 kg) | 5-7 min |

**Old System (Weight-Based):**
- "3 trucks ahead, average 9 min each = 27 min wait"
- ❌ Inaccurate: Could be 3 Super Bs (45 min!) or 3 Straight Trucks (18 min)

**New System (Truck Type-Based):**
- "1× Super B (14 min) + 1× Tandem (9 min) + 1× Straight (6 min) = 29 min wait"
- ✅ Accurate: Accounts for actual vehicle capacity

**Visual Representation:**
```
Queue Visualization:

┌────────────────────────────────────┐
│ 🏢 Prairie Grain Queue:            │
│                                    │
│ [🚛🚛] Super B - 8 axle (14 min)   │ ← Biggest
│ [🚛] Tandem + Trailer (9 min)      │ ← Medium
│ [🚛] Straight Truck (6 min)        │ ← Smallest
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│ [YOU] Super B - 8 axle             │ ← You're here
│                                    │
│ Est. Total Wait: 29 minutes        │
└────────────────────────────────────┘
```

---

## Pre-Haul: The Decision

**User Story**: Steve wakes up at 6am, checks HaulPass over coffee

```
Opens app → Sees hero card:
"2 trucks in queue, 18 min wait - GOOD TIME"

Thinks: "Perfect, I'll start loading after breakfast"

Sets reminder for 7am
```

---

### Phase 1: Grain Selection & Loading

**Screen**: Grain Type Selector

```
┌─────────────────────────────────┐
│ Select Grain Type               │
├─────────────────────────────────┤
│                                 │
│  🌾 Wheat    🌻 Canola          │
│                                 │
│  🌾 Barley   🌾 Oats            │
│                                 │
│  🌽 Corn     🫘 Soybeans        │
│                                 │
│  🫛 Lentils  🫛 Peas            │
│                                 │
└─────────────────────────────────┘
```

**After Selection**: Optional Pre-Load Data

```
┌─────────────────────────────────┐
│ Optional: Bin Data              │
├─────────────────────────────────┤
│                                 │
│ Weight (bin scale):             │
│ [        ] kg  [Toggle units]   │
│                                 │
│ Moisture % (bin reading):       │
│ [    ] %                        │
│                                 │
│ 💡 Why collect this?            │
│ Compare with elevator readings  │
│ to detect calibration issues    │
│                                 │
│ [Skip]          [Start Loading] │
└─────────────────────────────────┘
```

**During Loading**:

```
┌─────────────────────────────────┐
│ Loading Wheat                   │
├─────────────────────────────────┤
│                                 │
│        ⏱️  23m                  │ ← Large, real-time
│                                 │
│   Your avg: 21m (2m slower)     │ ← Comparison
│                                 │
│ [Weight Loaded & Continue]      │ ← Single tap
└─────────────────────────────────┘
```

---

### Phase 2: Drive to Elevator

**Auto-Start**: When loading completes, auto-transition

```
┌─────────────────────────────────┐
│ Haul to Prairie Grain Co-op     │
├─────────────────────────────────┤
│                                 │
│        ⏱️  12m                  │
│                                 │
│   Your avg: 14m (2m faster!)    │
│   Distance: 8.2 km              │
│                                 │
│ Current Queue: 2 trucks         │ ← Live update
│ Est. wait when you arrive: 15m  │ ← Prediction
│                                 │
│ [Pause Haul]                    │ ← Emergency stop
└─────────────────────────────────┘
```

**GPS Intelligence**: App detects proximity to elevator

---

### Phase 3: Queue Entry (Critical for Network Effect)

**Auto-Prompt**: GPS detects arrival at elevator

```
┌─────────────────────────────────┐
│ 🏢 Arrived at Prairie Grain     │
├─────────────────────────────────┤
│                                 │
│ How many trucks ahead?          │
│ (Not including currently        │
│  unloading)                     │
│                                 │
│  [0] [1] [2] [3] [4] [5] [6+]   │ ← Large buttons
│                                 │
│ 💡 This helps other farmers     │
│    know the current queue       │
│                                 │
└─────────────────────────────────┘
```

**After Submission**:

```
┌─────────────────────────────────┐
│ ⏳ Waiting in Queue             │
├─────────────────────────────────┤
│                                 │
│        ⏱️  8m                   │
│                                 │
│   Est. remaining: 12 minutes    │
│                                 │
│ Your position: 3rd              │
│                                 │
│ 📡 Queue data shared with       │
│    other farmers                │
│                                 │
│ [Begin Unloading]               │ ← Manual advance
└─────────────────────────────────┘
```

---

### Phase 4: Unloading

**Manual Start**: User taps when at pit

```
┌─────────────────────────────────┐
│ Unloading Wheat                 │
├─────────────────────────────────┤
│                                 │
│        ⏱️  8m 47s               │
│                                 │
│   Your avg: 9m 12s              │
│   (YOU'RE 4% FASTER!)           │
│                                 │
│ [Finished Unloading]            │
└─────────────────────────────────┘
```

---

### Phase 5: Post-Haul Data Entry (Comparative Intelligence Capture)

**Data Collection Screen**:

```
┌─────────────────────────────────────────┐
│ Haul Complete! 🎉                       │
├─────────────────────────────────────────┤
│                                         │
│ Elevator Scale Weight:                  │
│ [        ] kg  [Toggle]                 │
│                                         │
│ Elevator Moisture Reading:              │
│ [    ] %                                │
│                                         │
│ Dockage %:                              │
│ [    ] %                                │
│                                         │
│ ─────────────────────                  │
│                                         │
│ 💡 All fields optional, but help you    │
│    compare elevators over time          │
│                                         │
│ [Skip All]              [Save & View    │
│                          Insights]      │
└─────────────────────────────────────────┘
```

**If Data Entered**: Show Comparative Insights

```
┌─────────────────────────────────────────┐
│ 📊 Your Haul Insights                   │
├─────────────────────────────────────────┤
│                                         │
│ Dockage Comparison:                     │
│ ├─ Your load: 1.2%                      │
│ ├─ Elevator avg: 1.8% (90 days)        │
│ └─ ✅ You got 33% less deduction!      │
│                                         │
│ Moisture Variance:                      │
│ ├─ Your bin: 14.0%                      │
│ ├─ Elevator: 14.5%                      │
│ └─ ⚠️  +0.5% difference                 │
│     (This elevator averages +0.7%       │
│      vs farmer readings)                │
│                                         │
│ Weight Accuracy:                        │
│ ├─ Your bin scale: 23,500 kg           │
│ ├─ Elevator scale: 23,150 kg           │
│ └─ 📊 98.5% match (excellent!)          │
│                                         │
│ [Continue to Return Trip]               │
└─────────────────────────────────────────┘
```

**Progressive Disclosure**: These insights get richer over time as more data accumulates

---

### Phase 6: Return Trip

**Auto-Start**:

```
┌─────────────────────────────────┐
│ Return Trip                     │
├─────────────────────────────────┤
│                                 │
│        ⏱️  14m                  │
│                                 │
│   Distance: 8.2 km              │
│                                 │
│ What's next?                    │
│                                 │
│ [Start Another Load]            │ ← Loop back
│                                 │
│ [Load for Later]                │ ← Pause state
│                                 │
│ [Done for Today]                │ ← End & summary
│                                 │
└─────────────────────────────────┘
```

---

### Phase 7: Daily Summary (Positive Reinforcement)

**If "Done for Today"**:

```
┌─────────────────────────────────────────────┐
│ 🎉 Great hauling day!                       │
├─────────────────────────────────────────────┤
│                                             │
│ You hauled 73,321 kg of Canola in 3 trips  │
│                                             │
│ ┌─────────────────────────────────────────┐ │
│ │ ⏱️  TIME BREAKDOWN                      │ │
│ │                                         │ │
│ │ Load: 21m avg (6% faster!)              │ │
│ │ Wait: 37m avg (11% longer, elevator     │ │
│ │       15% busier than usual)            │ │
│ │ Unload: 8m 11s avg                      │ │
│ │ Round trip: 1hr 52m per load            │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│ ┌─────────────────────────────────────────┐ │
│ │ 💰 VALUE DELIVERED                      │ │
│ │                                         │ │
│ │ Time saved by checking queue: ~40min    │ │
│ │ (You avoided the 2pm rush)              │ │
│ │                                         │ │
│ │ Better-than-average dockage: -0.6%      │ │
│ │ Estimated value: ~$180                  │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│ ┌─────────────────────────────────────────┐ │
│ │ 📊 INSIGHTS                             │ │
│ │                                         │ │
│ │ • This elevator gave you better dockage │ │
│ │   than your average (1.2% vs 1.4%)     │ │
│ │                                         │ │
│ │ • Morning hauls were 12% faster than    │ │
│ │   afternoon today                       │ │
│ │                                         │ │
│ │ • Your data helped 8 other farmers      │ │
│ │   decide when to haul today!            │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│ [Share Your Day] [View Detailed Stats]      │
│                                             │
└─────────────────────────────────────────────┘
```

---

## Queue Intelligence System

### How Real-Time Queue Works

#### Example: Live Update Flow

**8:00 AM**: Steve arrives at Prairie Grain Co-op
- Sees 1 truck unloading
- **Enters**: "0 trucks ahead"
- **System**: Starts Steve's queue timer
- **Updates**: All users watching this elevator see "1 truck in queue"

**8:06 AM**: Frank arrives (6 minutes later)
- **Enters**: "1 truck ahead" (Steve)
- **System**:
  - Confirms Frank is behind Steve (GPS + timing validation)
  - Knows Steve avg unload: 11m 09s
  - Calculates Frank's wait: ~11 minutes remaining
- **Updates**: Dashboard shows "2 trucks in queue, ~18 min wait"

**8:10 AM**: Ben arrives while Steve still waiting
- **Enters**: "2 trucks ahead"
- **System calculates**:
  - Steve: 5min queue + 11m unload = 16m
  - Frank: 7m 30s unload = 8m
  - Ben's estimated wait: **~24 minutes**

**8:12 AM**: Ted (at his farm) opens HaulPass
- **Sees on dashboard**:
  ```
  🚛 Current Queue: 3 trucks
  ⏱️  Est. Wait: ~39 minutes
  🔴 Long wait - Consider hauling later
  ```
- **Decides**: Will load and pause, haul after lunch

**8:15 AM**: Billy and John arrive simultaneously
- Queue grows to 5 trucks
- **System broadcasts** to all users with Prairie Grain favorited:
  ```
  🔔 Prairie Grain Co-op Queue Update
     Now: 5 trucks in queue (+2)
     Est. wait: 1hr 10min
     Consider alternative timing
  ```

Ted sees this, confirms his decision to wait.

### Data Validation & Reliability

**GPS Confirmation**:
- User must be within 500m of elevator
- Prevents false reports from non-haulers

**Position Cross-Validation**:
```typescript
function validateQueuePosition(
  userId: UUID,
  reportedPosition: number,
  elevatorId: UUID
): ValidationResult {

  // Get all current queue entries
  const currentQueue = getActiveQueueUsers(elevatorId);

  // Check timing (realistic arrival intervals)
  const lastEntry = currentQueue[currentQueue.length - 1];
  const timeSinceLastEntry = now() - lastEntry.timestamp;

  if (timeSinceLastEntry < 30) { // seconds
    return { valid: false, reason: "Too soon after previous entry" };
  }

  // Check reported position matches queue length
  if (reportedPosition !== currentQueue.length) {
    // Flag for review, use consensus
    flagOutlier(userId, elevatorId, reportedPosition);
    return { valid: false, useConsensus: true };
  }

  // Check GPS location matches elevator
  if (!isNearElevator(userId, elevatorId, 500)) { // meters
    return { valid: false, reason: "Not at elevator location" };
  }

  return { valid: true };
}
```

**Reliability Scoring**:
- Users build reputation over time
- Consistent, validated data = higher trust score
- Outliers flagged but not blocked (benefit of doubt)
- Consensus used when data conflicts

**Smart Estimation**:
```typescript
function calculateWaitTime(
  elevatorId: UUID,
  position: number
): number {

  const queueUsers = getQueueUsersAhead(elevatorId, position);
  let totalMinutes = 0;

  queueUsers.forEach(user => {
    // Get user's historical avg at THIS elevator
    const avgUnload = getUserAvgUnloadTime(user.id, elevatorId);

    // Add cushion for truck movement
    const movementBuffer = 2; // minutes

    // Weight recent performance higher
    const performanceFactor = getRecentPerformanceFactor(user.id);

    totalMinutes += (avgUnload * performanceFactor) + movementBuffer;
  });

  // Add confidence interval
  const confidence = calculateConfidence(queueUsers.length);

  return {
    estimate: Math.round(totalMinutes),
    confidence: confidence,
    range: [totalMinutes * 0.85, totalMinutes * 1.15]
  };
}
```

---

### Handling Non-HaulPass Users in Queue

**The Challenge**: Not every truck in line has HaulPass installed. These gaps create uncertainty in queue estimates.

**The Solution**: GPS-based gap detection, distance estimation, and transparent HaulPass user counts.

#### Problem Scenarios

**Scenario 1: Mixed Queue**
```
Elevator Pit
    ↓
  [Truck A] ← HaulPass user
  [Truck B] ← No app
  [Truck C] ← No app
  [Truck D] ← HaulPass user (you)
  [Truck E] ← HaulPass user
```

**System knows**:
- Truck A position (GPS)
- Truck D position (GPS)
- Truck E position (GPS)

**System doesn't know**:
- Exactly how many trucks between A and D
- Exact capacity of Truck B and C

#### Solution: Manual Count + GPS Gap Detection

**When Arriving at Elevator Queue**:

```
┌─────────────────────────────────────────┐
│ 📍 Confirm Queue Position               │
├─────────────────────────────────────────┤
│                                         │
│ You've arrived at:                      │
│ 🏢 Prairie Grain Co-op                  │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                         │
│ How many trucks are ahead of you?       │
│ (Not including currently unloading)     │
│                                         │
│  [0] [1] [2] [3] [4] [5] [6+]           │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                         │
│ 📊 Optional: What truck types?          │
│ (Tap to add, improves accuracy)         │
│                                         │
│ Truck 1: [Super B 8-axle     ▼]        │
│ Truck 2: [Tandem + Trailer   ▼]        │
│ Truck 3: [Skip this truck       ]       │
│                                         │
│ [🔍 Skip All Truck Types]               │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                         │
│ 💡 3 HaulPass users currently in queue  │
│    (Your data helps the network!)       │
│                                         │
│ [Confirm Position]                      │
│                                         │
└─────────────────────────────────────────┘
```

**After Confirmation**:

```
┌─────────────────────────────────────────┐
│ ✅ Queue Position Confirmed             │
├─────────────────────────────────────────┤
│                                         │
│ You're #4 in line                       │
│                                         │
│ 🚛 3 trucks ahead:                      │
│    • 1× Super B (8-axle)                │
│    • 1× Tandem + Trailer                │
│    • 1× Unknown type (estimated)        │
│                                         │
│ ⏱️  Est. Wait: ~38 minutes              │
│    (±12 min due to unknowns)            │
│                                         │
│ 📡 4 HaulPass users in queue            │
│    (Network effect active!)             │
│                                         │
│ [Begin Waiting]                         │
│                                         │
└─────────────────────────────────────────┘
```

#### GPS Gap Detection Algorithm

**When User Skips Truck Types**:

```typescript
interface QueueGapAnalysis {
  haulPassUserA: {
    userId: UUID;
    position: number;
    gpsLocation: [lat, lng];
    timestamp: DateTime;
  };
  haulPassUserB: {
    userId: UUID;
    position: number;
    gpsLocation: [lat, lng];
    timestamp: DateTime;
  };
  estimatedGap: {
    truckCount: number;
    totalCapacityKg: number;
    confidence: 'low' | 'medium' | 'high';
  };
}

function estimateGapBetweenUsers(
  userA: QueueUser,
  userB: QueueUser,
  elevatorId: UUID
): QueueGapAnalysis {

  // Calculate GPS distance between users
  const distanceMeters = calculateGPSDistance(
    userA.gpsLocation,
    userB.gpsLocation
  );

  // Average truck length + spacing
  const avgTruckLength = 23; // meters (Super B with trailer)
  const avgSpacing = 5; // meters between trucks

  // Estimate truck count
  const estimatedTrucks = Math.floor(
    distanceMeters / (avgTruckLength + avgSpacing)
  );

  // Subtract known positions
  const reportedGap = userB.position - userA.position - 1;

  // If GPS estimate matches reported, high confidence
  const confidence =
    Math.abs(estimatedTrucks - reportedGap) <= 1
      ? 'high'
      : Math.abs(estimatedTrucks - reportedGap) <= 2
      ? 'medium'
      : 'low';

  // Estimate total capacity (use elevator-specific averages)
  const elevatorAvgCapacity = getElevatorAvgTruckCapacity(elevatorId);
  const totalCapacityKg = reportedGap * elevatorAvgCapacity;

  return {
    haulPassUserA: userA,
    haulPassUserB: userB,
    estimatedGap: {
      truckCount: reportedGap,
      totalCapacityKg: totalCapacityKg,
      confidence: confidence
    }
  };
}
```

#### Wait Time Calculation with Gaps

**Known HaulPass User**: Use exact truck type + historical data
```typescript
const knownTruckWait =
  getUserAvgUnloadTime(userId, elevatorId, truckType) + movementBuffer;
```

**Unknown Non-HaulPass Truck**: Use elevator-specific average
```typescript
const elevatorAvgUnloadTime =
  getElevatorAvgUnloadTime(elevatorId, last90Days);

const unknownTruckWait = elevatorAvgUnloadTime + uncertaintyBuffer;
```

**Combined Estimate**:
```typescript
function calculateQueueWaitWithGaps(
  userId: UUID,
  position: number,
  elevatorId: UUID
): WaitEstimate {

  const queueAhead = getQueueUsersAhead(elevatorId, position);
  let totalMinutes = 0;
  let uncertaintyRange = 0;

  queueAhead.forEach(truckAhead => {
    if (truckAhead.isHaulPassUser && truckAhead.truckType) {
      // Known user with truck type: ±15% accuracy
      const unloadTime = getUserAvgUnloadTime(
        truckAhead.userId,
        elevatorId,
        truckAhead.truckType
      );
      totalMinutes += unloadTime + 2; // movement buffer
      uncertaintyRange += unloadTime * 0.15;

    } else if (truckAhead.isHaulPassUser && !truckAhead.truckType) {
      // Known user but no truck type: ±25% accuracy
      const avgUnloadTime = getElevatorAvgUnloadTime(elevatorId);
      totalMinutes += avgUnloadTime + 2;
      uncertaintyRange += avgUnloadTime * 0.25;

    } else {
      // Unknown non-HaulPass truck: ±50% accuracy
      const elevatorAvg = getElevatorAvgUnloadTime(elevatorId);
      totalMinutes += elevatorAvg + 3; // larger buffer
      uncertaintyRange += elevatorAvg * 0.50;
    }
  });

  return {
    estimate: Math.round(totalMinutes),
    confidenceRange: [
      Math.round(totalMinutes - uncertaintyRange),
      Math.round(totalMinutes + uncertaintyRange)
    ],
    confidence: uncertaintyRange < totalMinutes * 0.20 ? 'high' : 'medium'
  };
}
```

#### Transparency: HaulPass User Count

**Why Show This**: Builds trust and demonstrates network value

```
┌─────────────────────────────────────────┐
│ ⏳ Waiting in Queue                     │
├─────────────────────────────────────────┤
│                                         │
│        ⏱️  42m                          │
│                                         │
│   Est. remaining: 38 minutes            │
│                                         │
│ Your position: 4th                      │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                         │
│ 📡 Queue Network Status:                │
│    • 4 HaulPass users in queue          │
│    • 2 with known truck types           │
│    • Est. 1-2 non-app users             │
│                                         │
│ 💡 More app users = better accuracy!    │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                         │
│ [Begin Unloading]                       │
│                                         │
└─────────────────────────────────────────┘
```

**Key Privacy Notes**:
- ✅ Show count of HaulPass users
- ✅ Show count with known truck types
- ❌ Never show individual user identities
- ❌ Never show exact positions of other users
- ❌ Never show names or farm details

#### Per-Elevator Data Isolation

**Critical Constraint**: Every elevator has different characteristics

**Why Isolation Matters**:
```
Elevator A (Prairie Grain Co-op):
- Dual pit unloading (2 trucks at once)
- Modern equipment (fast augers)
- Avg unload time: 8m 30s

Elevator B (Richardson Pioneer Regina):
- Single pit (1 truck at a time)
- Older equipment (slower)
- Avg unload time: 14m 20s

Elevator C (Viterra Moose Jaw):
- Single pit but high capacity
- Varies by grain type
- Avg unload time: 11m 05s
```

**Database Design for Isolation**:

```sql
-- Never mix data across elevators
CREATE TABLE queue_wait_times (
  id UUID PRIMARY KEY,
  elevator_id BIGINT NOT NULL REFERENCES elevators_import(id),
  user_id UUID NOT NULL,
  truck_type TEXT,
  unload_duration_seconds INTEGER,
  grain_type TEXT,
  weight_kg NUMERIC,
  timestamp TIMESTAMPTZ,

  -- Ensure queries always filter by elevator
  CONSTRAINT unique_per_elevator UNIQUE (elevator_id, user_id, timestamp)
);

CREATE INDEX idx_wait_times_per_elevator
  ON queue_wait_times(elevator_id, grain_type, truck_type);

-- Query for elevator-specific averages only
SELECT
  elevator_id,
  truck_type,
  grain_type,
  AVG(unload_duration_seconds) as avg_unload_seconds,
  STDDEV(unload_duration_seconds) as stddev_seconds,
  COUNT(*) as sample_size
FROM queue_wait_times
WHERE
  elevator_id = $1  -- ALWAYS filter by specific elevator
  AND timestamp > NOW() - INTERVAL '90 days'
  AND unload_duration_seconds IS NOT NULL
GROUP BY elevator_id, truck_type, grain_type
HAVING COUNT(*) >= 5; -- Minimum sample size
```

**Function: Get Elevator-Specific Unload Time**:
```typescript
function getUserAvgUnloadTime(
  userId: UUID,
  elevatorId: UUID, // REQUIRED, never optional
  truckType?: TruckType
): number {

  // Query filtered to THIS elevator only
  const userHistory = db.query(`
    SELECT AVG(unload_duration_seconds) as avg_seconds
    FROM queue_wait_times
    WHERE user_id = $1
      AND elevator_id = $2
      AND truck_type = $3
      AND timestamp > NOW() - INTERVAL '90 days'
  `, [userId, elevatorId, truckType]);

  if (userHistory.avg_seconds) {
    return Math.round(userHistory.avg_seconds / 60); // convert to minutes
  }

  // Fallback: elevator average (NEVER global average)
  return getElevatorAvgUnloadTime(elevatorId, truckType);
}

function getElevatorAvgUnloadTime(
  elevatorId: UUID,
  truckType?: TruckType
): number {

  // ONLY this elevator's data
  const elevatorAvg = db.query(`
    SELECT AVG(unload_duration_seconds) as avg_seconds
    FROM queue_wait_times
    WHERE elevator_id = $1
      AND ($2::TEXT IS NULL OR truck_type = $2)
      AND timestamp > NOW() - INTERVAL '90 days'
  `, [elevatorId, truckType]);

  return Math.round(elevatorAvg.avg_seconds / 60);
}
```

#### Accuracy Improvement Table

| Scenario | Accuracy | Confidence |
|----------|----------|------------|
| All trucks HaulPass + truck types known | ±15% | High ⭐⭐⭐ |
| All trucks HaulPass, some types unknown | ±25% | Medium ⭐⭐ |
| Mixed queue, manual count provided | ±35% | Medium ⭐⭐ |
| Mixed queue, GPS gap estimation only | ±50% | Low ⭐ |

**Network Effect**: As more farmers adopt HaulPass, accuracy improves for everyone.

**Example**:
- 10% adoption: ±50% accuracy (frequent gaps)
- 30% adoption: ±35% accuracy (some gaps)
- 60% adoption: ±20% accuracy (rare gaps)
- 90% adoption: ±15% accuracy (nearly complete data)

---

## Comparative Intelligence Platform

### Philosophy: Progressive Value Discovery

**Week 1**: Farmer just uses queue intelligence
- Sees immediate benefit (time savings)
- Doesn't care about dockage yet

**Week 2-4**: Farmer starts entering optional data
- Notices patterns in own stats
- "I unload faster than I thought"

**Month 1-3**: Farmer has enough data for comparisons
- Discovers one elevator gives better dockage
- Realizes equipment calibration is off
- Starts making strategic decisions

**Season 1+**: Farmer optimizes entire operation
- Routes to better elevators
- Times hauls for efficiency
- Calibrates equipment accurately
- Maximizes profitability

### Dockage Intelligence

**What It Solves**: "Am I getting a fair grade?"

**Data Collection**:
- Farmer enters dockage % after each haul (optional)
- System aggregates across all users (anonymized)
- Minimum sample size: n > 10 for statistical validity

**Insights Provided**:

```
┌─────────────────────────────────────────┐
│ 📊 Dockage Analysis                     │
├─────────────────────────────────────────┤
│                                         │
│ Your Dockage History at Prairie Grain: │
│ ├─ Last 30 days: 1.4% avg              │
│ ├─ Last 90 days: 1.6% avg              │
│ └─ Best load: 0.8% (Nov 12)            │
│                                         │
│ Elevator Comparison (50km radius):      │
│ ┌─────────────────────────────────────┐ │
│ │ 🏢 Viterra (Moose Jaw)              │ │
│ │    Avg: 0.9% (n=847 loads)          │ │
│ │    ✅ 36% less than Prairie Grain   │ │
│ │    Distance: +12km                   │ │
│ ├─────────────────────────────────────┤ │
│ │ 🏢 Prairie Grain Co-op              │ │
│ │    Avg: 1.8% (n=1,203 loads)        │ │
│ │    Your avg: 1.4% (better!)         │ │
│ ├─────────────────────────────────────┤ │
│ │ 🏢 Richardson (Regina)              │ │
│ │    Avg: 2.4% (n=654 loads)          │ │
│ │    ⚠️  33% more than Prairie Grain  │ │
│ │    Distance: +18km                   │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ 💡 Insight:                             │
│ Viterra Moose Jaw averages 50% less    │
│ dockage despite being only 12km farther.│
│ For a 1000 bushel load at $15/bushel,  │
│ that's ~$135 more profit per load.      │
│                                         │
│ Consider routing some loads there?      │
│                                         │
│ [View Detailed Breakdown]               │
└─────────────────────────────────────────┘
```

**Grain Type Breakdown**:
```
Canola Dockage by Elevator:
┌────────────────────────────────────┐
│ 🏢 Viterra: 0.8% avg               │ ██████░░░░
│ 🏢 Prairie: 1.6% avg               │ ████████████░░░░
│ 🏢 Richardson: 2.1% avg            │ ██████████████████░░
└────────────────────────────────────┘

Wheat Dockage by Elevator:
┌────────────────────────────────────┐
│ 🏢 Viterra: 1.2% avg               │ ████████░░░░
│ 🏢 Prairie: 1.4% avg               │ ██████████░░░░
│ 🏢 Richardson: 2.8% avg            │ ████████████████████
└────────────────────────────────────┘
```

---

### Moisture Intelligence

**What It Solves**:
1. "Is my equipment calibrated correctly?"
2. "Is this elevator's scale reading fair?"
3. "Do I lose moisture in transit?"

**Data Collection**:
- Bin moisture (optional, at loading)
- Elevator moisture (optional, at unloading)
- System calculates delta automatically

**Insights Provided**:

```
┌─────────────────────────────────────────┐
│ 💧 Moisture Analysis                    │
├─────────────────────────────────────────┤
│                                         │
│ Your Equipment vs Elevator Readings:    │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ Prairie Grain Co-op                 │ │
│ │                                     │ │
│ │ Your 10 loads:                      │ │
│ │ ├─ Bin avg: 13.8%                  │ │
│ │ ├─ Elevator avg: 14.5%             │ │
│ │ └─ Delta: +0.7% (elevator higher)  │ │
│ │                                     │ │
│ │ All farmers (n=234 loads):          │ │
│ │ └─ Delta: +0.6% avg                │ │
│ │                                     │ │
│ │ ✅ Your readings are consistent     │ │
│ │    with other farmers               │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ Richardson Pioneer                  │ │
│ │                                     │ │
│ │ Your 5 loads:                       │ │
│ │ ├─ Bin avg: 13.6%                  │ │
│ │ ├─ Elevator avg: 15.2%             │ │
│ │ └─ Delta: +1.6% (elevator higher)  │ │
│ │                                     │ │
│ │ All farmers (n=187 loads):          │ │
│ │ └─ Delta: +1.4% avg                │ │
│ │                                     │ │
│ │ ⚠️  This elevator consistently      │ │
│ │    reads 0.8% higher than Prairie   │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ 💡 Insights:                            │
│                                         │
│ 1. Your bin moisture tester is          │
│    well-calibrated (matches network)    │
│                                         │
│ 2. Richardson's equipment may read      │
│    consistently higher - expect that    │
│    when hauling there                   │
│                                         │
│ 3. Consider moisture loss in transit:   │
│    ~0.3% avg in your area               │
│                                         │
│ [View Transit Loss Patterns]            │
└─────────────────────────────────────────┘
```

**Transit Loss Pattern**:
```
Moisture Loss by Trip Duration:
┌────────────────────────────────────┐
│ < 15 min: -0.1% avg                │
│ 15-30 min: -0.3% avg               │
│ 30-60 min: -0.5% avg               │
│ > 60 min: -0.8% avg                │
└────────────────────────────────────┘

Season Pattern (Your Loads):
┌────────────────────────────────────┐
│ Early Sept: -0.2% avg              │
│ Mid Sept: -0.4% avg                │
│ Late Sept: -0.6% avg               │
│ (Warmer = more evaporation)        │
└────────────────────────────────────┘
```

---

### Machine Learning Predictions (Future)

**Optimal Timing Intelligence**:

```
┌─────────────────────────────────────────┐
│ 🤖 AI Hauling Recommendations          │
├─────────────────────────────────────────┤
│                                         │
│ Best time to haul today:                │
│ ├─ 9:00-10:30 AM                        │
│ └─ Expected wait: 12 min (85% conf.)    │
│                                         │
│ Avoid:                                  │
│ ├─ 2:00-3:30 PM                         │
│ └─ Expected wait: 68 min (historical)   │
│                                         │
│ Pattern detected:                       │
│ Tuesday mornings average 40% shorter    │
│ waits than Friday afternoons at this    │
│ elevator.                               │
│                                         │
│ [Set Reminder for 8:45 AM]              │
└─────────────────────────────────────────┘
```

**Predictive Dockage Warning**:
```
┌─────────────────────────────────────────┐
│ ⚠️  Dockage Alert                       │
├─────────────────────────────────────────┤
│                                         │
│ Richardson Pioneer is averaging 3.2%    │
│ dockage this week (usually 2.4%).       │
│                                         │
│ Possible reasons:                       │
│ • Wet weather increasing foreign        │
│   material in everyone's grain          │
│ • Stricter grading standards            │
│                                         │
│ Consider:                               │
│ • Extra cleaning before hauling         │
│ • Alternative elevator this week        │
│                                         │
└─────────────────────────────────────────┘
```

---

## User Onboarding

### Signup Flow (5 Steps - Fast & Focused)

#### Step 0: Welcome & Email/Password
```
┌─────────────────────────────────────────┐
│ Welcome to HaulPass                     │
│                                         │
│ Know when to haul.                      │
│ Save time. Make better decisions.       │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ Email                               │ │
│ │ [                           ]       │ │
│ ├─────────────────────────────────────┤ │
│ │ Password                            │ │
│ │ [                           ]       │ │
│ ├─────────────────────────────────────┤ │
│ │ Confirm Password                    │ │
│ │ [                           ]       │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ☐ I accept Terms of Service            │
│                                         │
│ [Continue] (disabled until checked)     │
│                                         │
│ Already have an account? Sign In        │
└─────────────────────────────────────────┘
```

#### Step 1: Personal Info
```
┌─────────────────────────────────────────┐
│ Tell us about yourself                  │
│                                         │
│ First Name                              │
│ [                           ]           │
│                                         │
│ Last Name                               │
│ [                           ]           │
│                                         │
│ [Back]              [Continue]          │
└─────────────────────────────────────────┘
```

#### Step 2: Farm Details
```
┌─────────────────────────────────────────┐
│ Your farm                               │
│                                         │
│ Farm Name                               │
│ [                           ]           │
│                                         │
│ Binyard Name (optional)                 │
│ [                           ]           │
│                                         │
│ 💡 We'll add multi-binyard support soon │
│                                         │
│ [Back]              [Continue]          │
└─────────────────────────────────────────┘
```

#### Step 3: Truck Details
```
┌─────────────────────────────────────────┐
│ Your grain hauler                       │
│                                         │
│ Truck Name/Number (optional)            │
│ [                           ]           │
│                                         │
│ Truck Configuration:                    │
│ Select your typical hauling setup       │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ ○ Super B - 8 axles (62,500 lbs)   │ │
│ │ ○ Super B - 7 axles (57,000 lbs)   │ │
│ │ ○ A-Train - 7 axles (53,500 lbs)   │ │
│ │ ○ Semi-Trailer - 6 axles (47k lbs) │ │
│ │ ○ Semi-Trailer - 5 axles (40k lbs) │ │
│ │ ○ Tandem + Trailer - 6 axles        │ │
│ │   (48,300 lbs)                      │ │
│ │ ○ Tandem + Pony - 5 axles           │ │
│ │   (41,300 lbs)                      │ │
│ │ ○ Tridem + Pony - 6 axles           │ │
│ │   (46,300 lbs)                      │ │
│ │ ○ Tridem - 4 axles (29,300 lbs)    │ │
│ │ ○ Straight Truck - 3 axles          │ │
│ │   (24,300 lbs)                      │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ 💡 Why? Helps predict unload times      │
│    accurately for the queue system      │
│                                         │
│ [Back]    [Skip]      [Continue]        │
└─────────────────────────────────────────┘
```

#### Step 4: Select Favorite Elevator
```
┌─────────────────────────────────────────┐
│ Choose your main elevator               │
│                                         │
│ Search:                                 │
│ [🔍 Type town, company, or name...    ] │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ 🏢 Prairie Grain Co-op              │ │
│ │    Moose Jaw, SK                    │ │
│ │    Canola, Wheat, Barley            │ │
│ ├─────────────────────────────────────┤ │
│ │ 🏢 Viterra                          │ │
│ │    Regina, SK                       │ │
│ │    Wheat, Oats, Canola              │ │
│ ├─────────────────────────────────────┤ │
│ │ 🏢 Richardson Pioneer               │ │
│ │    Saskatoon, SK                    │ │
│ │    All grains accepted              │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ Selected: ✅ Prairie Grain Co-op        │
│                                         │
│ [Back]    [Skip]   [Complete Sign Up]  │
└─────────────────────────────────────────┘
```

#### Step 5: Onboarding Complete
```
┌─────────────────────────────────────────┐
│ 🎉 You're all set!                      │
├─────────────────────────────────────────┤
│                                         │
│ Here's what HaulPass does for you:      │
│                                         │
│ ✅ Shows live queue at your elevator    │
│ ✅ Tracks your haul efficiency          │
│ ✅ Compares elevators over time         │
│ ✅ Helps you make better decisions      │
│                                         │
│ 💡 Quick Tips:                          │
│ • Check the queue before loading        │
│ • Enter optional data for insights      │
│ • Your data helps other farmers too     │
│                                         │
│ Ready to start hauling smarter?         │
│                                         │
│ [Go to Dashboard]                       │
└─────────────────────────────────────────┘
```

---

## Data Models and Storage

### Current Database Schema (Supabase PostgreSQL)

#### 1. auth.users (Supabase Managed)
```sql
-- Extended with user_metadata
{
  "id": "uuid",
  "email": "text",
  "user_metadata": {
    "first_name": "text",
    "last_name": "text",
    "farm_name": "text",
    "binyard_name": "text",
    "grain_truck_name": "text",
    "truck_type": "text", -- Truck configuration (e.g., "super_b_8_axle")
    "grain_capacity_kg": "numeric", -- Optional, can be derived from truck_type
    "preferred_unit": "text" -- kg, tonnes, bushels, pounds
  }
}

-- Truck Type Enum Values:
-- "super_b_8_axle" (62,500 lbs / 28,400 kg)
-- "super_b_7_axle" (57,000 lbs / 25,900 kg)
-- "a_train_7_axle" (53,500 lbs / 24,300 kg)
-- "semi_trailer_6_axle" (47,000 lbs / 21,300 kg)
-- "semi_trailer_5_axle" (40,000 lbs / 18,100 kg)
-- "tandem_trailer_6_axle" (48,300 lbs / 21,900 kg)
-- "tandem_pony_5_axle" (41,300 lbs / 18,700 kg)
-- "tridem_pony_6_axle" (46,300 lbs / 21,000 kg)
-- "tridem_4_axle" (29,300 lbs / 13,300 kg)
-- "straight_truck_3_axle" (24,300 lbs / 11,000 kg)
```

#### 2. elevators_import (513 rows - Production Data)
```sql
CREATE TABLE elevators_import (
  id BIGINT PRIMARY KEY,
  name TEXT NOT NULL,
  company TEXT NOT NULL,
  address TEXT NOT NULL,
  location GEOGRAPHY(POINT, 4326) NOT NULL, -- PostGIS
  capacity_tonnes NUMERIC,
  grain_types TEXT[], -- Array: ['Wheat', 'Canola', ...]
  railway TEXT,
  elevator_type TEXT,
  car_spots TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Spatial index for geospatial queries
CREATE INDEX idx_elevators_location
  ON elevators_import USING GIST(location);

-- Search index
CREATE INDEX idx_elevators_name
  ON elevators_import USING GIN(to_tsvector('english', name));
```

#### 3. favorite_elevators
```sql
CREATE TABLE favorite_elevators (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  elevator_id BIGINT NOT NULL REFERENCES elevators_import(id),
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  UNIQUE(user_id, elevator_id)
);

CREATE INDEX idx_favorite_elevators_user
  ON favorite_elevators(user_id);
```

#### 4. haul_timers (Enhanced Schema)
```sql
CREATE TABLE haul_timers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  elevator_id BIGINT NOT NULL REFERENCES elevators_import(id),

  -- Session metadata
  grain_type TEXT NOT NULL,
  session_date DATE NOT NULL DEFAULT CURRENT_DATE,
  status TEXT NOT NULL DEFAULT 'active'
    CHECK (status IN ('active', 'paused', 'completed')),

  -- Loading phase
  loading_start TIMESTAMP WITH TIME ZONE,
  loading_end TIMESTAMP WITH TIME ZONE,
  loading_duration_seconds INTEGER,
  weight_bin_kg NUMERIC(10,2), -- Optional: bin scale weight
  moisture_bin_percent NUMERIC(5,2), -- Optional: bin moisture

  -- Drive phase
  drive_start TIMESTAMP WITH TIME ZONE,
  drive_end TIMESTAMP WITH TIME ZONE,
  drive_duration_seconds INTEGER,
  drive_distance_km NUMERIC(10,2),

  -- Queue phase
  queue_start TIMESTAMP WITH TIME ZONE,
  queue_end TIMESTAMP WITH TIME ZONE,
  queue_duration_seconds INTEGER,
  trucks_ahead_count INTEGER,

  -- Unloading phase
  unload_start TIMESTAMP WITH TIME ZONE,
  unload_end TIMESTAMP WITH TIME ZONE,
  unload_duration_seconds INTEGER,

  -- Post-unload data (comparative intelligence)
  weight_elevator_kg NUMERIC(10,2), -- Optional: elevator scale
  moisture_elevator_percent NUMERIC(5,2), -- Optional: elevator reading
  dockage_percent NUMERIC(5,2), -- Optional: dockage deduction
  grain_grade TEXT, -- Optional: #1, #2, #3, etc.
  price_per_tonne NUMERIC(10,2), -- Optional: price received
  notes TEXT,

  -- Return phase
  return_start TIMESTAMP WITH TIME ZONE,
  return_end TIMESTAMP WITH TIME ZONE,
  return_duration_seconds INTEGER,

  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for common queries
CREATE INDEX idx_haul_timers_user ON haul_timers(user_id);
CREATE INDEX idx_haul_timers_elevator ON haul_timers(elevator_id);
CREATE INDEX idx_haul_timers_date ON haul_timers(session_date DESC);
CREATE INDEX idx_haul_timers_status ON haul_timers(status)
  WHERE status = 'active';
```

#### 5. queue_snapshots (Real-time Queue Tracking)
```sql
CREATE TABLE queue_snapshots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  elevator_id BIGINT NOT NULL REFERENCES elevators_import(id),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  haul_timer_id UUID REFERENCES haul_timers(id),

  queue_position INTEGER NOT NULL,
  trucks_ahead INTEGER NOT NULL,
  estimated_wait_minutes INTEGER,

  -- Truck type information
  user_truck_type TEXT, -- User's truck type from profile
  trucks_ahead_types TEXT[], -- Array of truck types ahead (e.g., ['super_b_8_axle', 'tandem_trailer_6_axle'])

  user_location GEOGRAPHY(POINT, 4326),
  is_validated BOOLEAN DEFAULT false,
  validation_score NUMERIC(3,2) DEFAULT 1.0, -- 0.0 to 1.0

  snapshot_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_queue_snapshots_elevator_time
  ON queue_snapshots(elevator_id, snapshot_time DESC);
CREATE INDEX idx_queue_snapshots_active
  ON queue_snapshots(elevator_id, snapshot_time)
  WHERE snapshot_time > NOW() - INTERVAL '2 hours';
```

#### 6. Database Views

**elevators_with_favorites**
```sql
CREATE VIEW elevators_with_favorites AS
SELECT
  e.*,
  CASE
    WHEN f.elevator_id IS NOT NULL THEN true
    ELSE false
  END AS is_favorite,
  f.created_at AS favorited_at,
  f.notes AS favorite_notes
FROM elevators_import e
LEFT JOIN favorite_elevators f
  ON e.id = f.elevator_id
  AND f.user_id = auth.uid();
```

**elevator_stats_aggregate** (Materialized View for Performance)
```sql
CREATE MATERIALIZED VIEW elevator_stats_aggregate AS
SELECT
  elevator_id,
  grain_type,

  -- Dockage statistics
  COUNT(*) FILTER (WHERE dockage_percent IS NOT NULL) as dockage_sample_size,
  AVG(dockage_percent) as avg_dockage,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY dockage_percent) as median_dockage,
  STDDEV(dockage_percent) as stddev_dockage,

  -- Moisture statistics
  COUNT(*) FILTER (
    WHERE moisture_bin_percent IS NOT NULL
    AND moisture_elevator_percent IS NOT NULL
  ) as moisture_sample_size,
  AVG(moisture_elevator_percent - moisture_bin_percent) as avg_moisture_delta,
  PERCENTILE_CONT(0.5) WITHIN GROUP (
    ORDER BY moisture_elevator_percent - moisture_bin_percent
  ) as median_moisture_delta,

  -- Wait time statistics
  AVG(queue_duration_seconds) / 60.0 as avg_wait_minutes,
  AVG(unload_duration_seconds) / 60.0 as avg_unload_minutes,

  -- Updated timestamp
  MAX(updated_at) as last_updated

FROM haul_timers
WHERE status = 'completed'
  AND session_date > CURRENT_DATE - INTERVAL '90 days'
GROUP BY elevator_id, grain_type;

CREATE INDEX idx_elevator_stats_elevator
  ON elevator_stats_aggregate(elevator_id);

-- Refresh strategy: hourly or on-demand
CREATE OR REPLACE FUNCTION refresh_elevator_stats()
RETURNS void AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY elevator_stats_aggregate;
END;
$$ LANGUAGE plpgsql;
```

#### 7. PostGIS Functions (Already Implemented)

**get_elevators_near()**
```sql
CREATE OR REPLACE FUNCTION get_elevators_near(
  p_lat DOUBLE PRECISION,
  p_lng DOUBLE PRECISION,
  p_radius_km DOUBLE PRECISION DEFAULT 50,
  p_max_results INTEGER DEFAULT 20
)
RETURNS TABLE (
  id BIGINT,
  name TEXT,
  company TEXT,
  address TEXT,
  location GEOGRAPHY,
  capacity_tonnes NUMERIC,
  grain_types TEXT[],
  distance_km NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    e.id,
    e.name,
    e.company,
    e.address,
    e.location,
    e.capacity_tonnes,
    e.grain_types,
    ROUND(
      ST_Distance(
        e.location,
        ST_MakePoint(p_lng, p_lat)::geography
      ) / 1000.0,
      2
    )::NUMERIC as distance_km
  FROM elevators_import e
  WHERE ST_DWithin(
    e.location,
    ST_MakePoint(p_lng, p_lat)::geography,
    p_radius_km * 1000
  )
  ORDER BY e.location <-> ST_MakePoint(p_lng, p_lat)::geography
  LIMIT p_max_results;
END;
$$ LANGUAGE plpgsql;
```

---

## Gamification System

**See**: [GAMIFICATION.md](./GAMIFICATION.md) for complete documentation.

**Key Points:**
- Integrate achievements early (Phase 1 MVP)
- Reward data quality, not just quantity
- Celebrate real accomplishments (10 loads, 100 loads, etc.)
- Drive engagement with daily challenges
- Progressive feature unlocks via XP levels
- Optional leaderboards (opt-in only)

**Why Early Integration:**
- Drives data entry completion rates (30% → 60%+ target)
- Encourages queue reporting consistency
- Builds habit loop (check queue → earn XP → check more)
- Improves network value through quality data

**Example Achievements:**
- 🎯 **First Load**: Complete first haul (+10 XP)
- 🎯 **Data Hero**: Enter all optional fields (+50 XP, unlock Insights)
- 🎯 **Queue Helper**: Report queue 5 times (+25 XP)
- 🏆 **100 Loads**: Milestone achievement (+1,000 XP, premium unlock)

**MVP Features (Phase 1):**
- Basic achievement system
- XP & level display on profile
- "First Load" and milestone achievements
- Data quality badges

**Post-MVP (Phase 2+):**
- Leaderboards
- Daily/weekly challenges
- Streaks system
- Farm teams

---

## Technical Stack

### Frontend
- **Framework**: Flutter 3.x
- **State Management**: Riverpod 2.x with code generation
- **UI Design**: Material 3 (Material Design 3)
- **Design Style**: Glassmorphic UI with soft glows and backdrop blur
- **Platforms**: Web, Windows Desktop, iOS, Android

### Backend
- **Database**: Supabase (PostgreSQL 15+)
- **Auth**: Supabase Auth (email/password, extensible to OAuth)
- **Real-time**: Supabase Realtime (WebSocket subscriptions)
- **Geospatial**: PostGIS extension
- **Storage**: Supabase Storage (for future features like receipts)

### Key Libraries
```yaml
dependencies:
  flutter: sdk
  supabase_flutter: ^2.x
  riverpod: ^2.x
  riverpod_annotation: ^2.x
  go_router: ^13.x
  geolocator: ^11.x
  badges: ^3.x
  intl: ^0.19.x

dev_dependencies:
  build_runner: ^2.x
  riverpod_generator: ^2.x
  riverpod_lint: ^2.x
```

### Infrastructure Decisions

**Why Supabase over Firebase:**
1. **PostGIS requirement**: Geospatial queries are core to the app
2. **Complex aggregations**: Comparative intelligence needs SQL
3. **Cost at scale**: PostgreSQL is 20-30x cheaper for analytics workloads
4. **Data portability**: Can migrate to self-hosted PostgreSQL if needed
5. **No vendor lock-in**: Standard SQL, open source stack

**Design System: Glassmorphism**
- Semi-transparent cards with backdrop blur
- Soft glowing accents (green/amber/red for status)
- Neumorphic elevation for interactive elements
- Ambient gradients that shift based on context
- Professional aesthetic: "Silicon Valley meets grain country"

---

## Implementation Roadmap

### Current Status (Production)
✅ **Phase 1: Core MVP - COMPLETE**
- User authentication working
- 513 elevators loaded with PostGIS
- Timer functionality operational
- Real-time updates via Supabase Realtime
- Multi-platform deployment (Web, Windows)
- Material 3 design implemented
- Active user: buperac@gmail.com

### Phase 2: Queue Intelligence & Polish (In Progress)
**Goal**: Robust real-time queue system with 10+ active users

**Remaining Tasks**:
- [ ] Queue entry validation logic
- [ ] Cross-user position confirmation
- [ ] Estimated wait time algorithm
- [ ] Real-time notifications for queue updates
- [ ] Outlier detection and consensus
- [ ] User reliability scoring

**Timeline**: 2-3 weeks

---

### Phase 3: Comparative Intelligence (Next Priority)
**Goal**: Demonstrate value of comparative analytics

**Tasks**:
- [ ] Add moisture/dockage fields to haul workflow
- [ ] Create elevator_stats_aggregate materialized view
- [ ] Build dockage comparison UI
- [ ] Build moisture variance analysis UI
- [ ] Implement insights display after haul
- [ ] Create elevator comparison screens

**Acceptance Criteria**:
- Farmer can see dockage comparison across elevators
- Farmer can identify moisture calibration issues
- Insights appear automatically after haul completion
- Minimum 10 samples required for statistical validity

**Timeline**: 3-4 weeks

---

### Phase 4: Predictive Intelligence (Future)
**Goal**: Machine learning for optimal timing and routing

**Tasks**:
- [ ] Historical pattern analysis
- [ ] Time-of-day/day-of-week optimization
- [ ] ML model for wait time prediction
- [ ] Seasonal trend detection
- [ ] Anomaly detection (unusual dockage spikes)
- [ ] Equipment calibration drift alerts

**Timeline**: 6-8 weeks (after Phase 3 complete)

---

### Phase 5: Premium Features (Revenue)
**Goal**: Monetization with advanced features

**Tasks**:
- [ ] Multiple favorite elevators (unlock limit)
- [ ] Advanced analytics dashboard
- [ ] Price tracking and comparison
- [ ] Export data to CSV/Excel
- [ ] Historical trend charts
- [ ] Custom alerts and notifications
- [ ] Integration with farm management software

**Business Model**:
- Free tier: 1 favorite elevator, basic stats
- Premium tier: $9.99/month or $79.99/year
  - 5 favorite elevators
  - Comparative intelligence
  - ML predictions
  - Advanced analytics
  - Data export

**Timeline**: After proven product-market fit

---

## Success Metrics

### Phase 1 Metrics (Current - Production)
- [x] User can complete signup in <2 minutes ✅
- [x] User can complete full haul workflow without errors ✅
- [x] All haul data saves correctly to database ✅
- [x] Dashboard displays accurate personal stats ✅
- [x] GPS tracking works reliably in background ✅
- [x] 1+ active users (buperac@gmail.com) ✅

### Phase 2 Success Criteria (In Progress)
- [ ] 10+ active users simultaneously
- [ ] 3+ users can enter queue simultaneously without conflicts
- [ ] Wait time estimates within ±15% of actual times
- [ ] Queue notifications sent within 30 seconds
- [ ] Cross-validation catches >90% of position errors
- [ ] Users check queue before 75% of hauls

### Phase 3 Success Criteria (Comparative Intelligence)
- [ ] 50+ completed hauls with dockage data
- [ ] Farmers discover 1+ elevator with better dockage
- [ ] Moisture calibration insights reveal equipment issues
- [ ] Users report improved decision-making (surveys)
- [ ] Average 2+ optional data fields entered per haul

### Phase 4 Success Criteria (Predictive)
- [ ] ML predictions improve decision-making (A/B test)
- [ ] Timing recommendations reduce wait by 20%+
- [ ] Users follow recommendations 60%+ of time
- [ ] Predictive alerts reduce unexpected delays

### Business Success Metrics (6-12 months)
- **User Acquisition**: 500+ active farmers by Month 6
- **Engagement**: Average 3+ sessions per user per week
- **Value Delivery**: Average 30+ minutes saved per haul
- **Network Effects**: 60%+ of elevators have 3+ users
- **Revenue**: 20%+ conversion to premium (future)
- **Retention**: >70% user retention after 30 days

---

## Appendix: Queue Intelligence Deep Dive

### Algorithm: Estimated Wait Time

```typescript
interface QueueUser {
  id: UUID;
  position: number;
  arrivalTime: Date;
  avgUnloadTime: number; // minutes
  reliabilityScore: number; // 0.0 to 1.0
}

function calculateEstimatedWait(
  elevatorId: UUID,
  targetPosition: number
): WaitEstimate {

  const queueUsers = getActiveQueue(elevatorId)
    .filter(u => u.position < targetPosition)
    .sort((a, b) => a.position - b.position);

  let totalMinutes = 0;
  let confidenceScore = 1.0;

  for (const user of queueUsers) {
    // Get user's historical average at THIS specific elevator
    const avgUnload = getUserAvgUnloadTime(
      user.id,
      elevatorId,
      90 // days lookback
    );

    // Weight recent performance more heavily
    const recentFactor = getRecentPerformanceFactor(
      user.id,
      elevatorId,
      7 // last 7 days
    );

    const adjustedUnload = avgUnload * recentFactor;

    // Add movement buffer (truck -> pit transition)
    const movementBuffer = 2; // minutes

    // Account for user reliability (flagged outliers get less weight)
    const reliability = user.reliabilityScore;
    confidenceScore *= reliability;

    totalMinutes += (adjustedUnload + movementBuffer);
  }

  // Add confidence interval based on sample size
  const sampleSize = queueUsers.length;
  const confidenceLevel = Math.min(0.95, 0.5 + (sampleSize * 0.1));

  return {
    estimate: Math.round(totalMinutes),
    confidenceLevel: confidenceScore * confidenceLevel,
    range: {
      min: Math.round(totalMinutes * 0.80),
      max: Math.round(totalMinutes * 1.20)
    },
    sampleSize: sampleSize
  };
}
```

### Validation: GPS-Based Position Confirmation

```typescript
function validateQueueEntry(
  userId: UUID,
  elevatorId: UUID,
  reportedPosition: number,
  userLocation: { lat: number, lng: number }
): ValidationResult {

  // Check 1: GPS proximity (must be within 500m)
  const elevator = getElevator(elevatorId);
  const distance = calculateDistance(userLocation, elevator.location);

  if (distance > 0.5) { // km
    return {
      valid: false,
      reason: "Not at elevator location",
      suggestedAction: "Move closer to elevator"
    };
  }

  // Check 2: Time since last entry (prevent spam)
  const lastEntry = getLastQueueEntry(elevatorId);
  const timeSince = now() - lastEntry.timestamp;

  if (timeSince < 60) { // seconds
    return {
      valid: false,
      reason: "Entry too soon after previous",
      suggestedAction: "Wait at least 60 seconds"
    };
  }

  // Check 3: Position consistency
  const currentQueue = getActiveQueue(elevatorId);
  const expectedPosition = currentQueue.length;

  if (reportedPosition !== expectedPosition) {
    // Flag but don't block - use consensus later
    flagOutlier(userId, elevatorId, reportedPosition, expectedPosition);

    // Use reported position but lower reliability score
    updateReliabilityScore(userId, 0.8); // slight penalty

    return {
      valid: true,
      warning: "Position differs from expected, using consensus",
      expectedPosition: expectedPosition,
      userReportedPosition: reportedPosition
    };
  }

  // Check 4: Historical behavior (user has good track record?)
  const reliability = getUserReliabilityScore(userId);

  if (reliability < 0.5) {
    return {
      valid: true,
      warning: "Low reliability score, verification required",
      requiresManualReview: true
    };
  }

  return { valid: true };
}
```

---

## Conclusion

HaulPass is not just a timer app—it's an intelligence platform that transforms grain hauling from guessing to knowing.

**The Hook**: Live queue intelligence answers "should I haul now?" → Opens the app

**The Habit**: Efficiency tracking shows "how am I doing?" → Uses it every haul

**The Retention**: Comparative analytics reveals "am I getting a fair deal?" → Becomes indispensable

**The Moat**: Network effects mean every user makes the platform more valuable → Competitors can't replicate

This document serves as the complete strategic and technical specification for HaulPass v2.0. All development, design decisions, and feature prioritization should align with this vision.

---

*Last Updated: January 2025*
*Version: 2.0*
*Status: Production (Phase 1 Complete, Phase 2 In Progress)*
*Active Users: 1 (buperac@gmail.com)*
*Database: 513 elevators loaded, PostGIS operational*
