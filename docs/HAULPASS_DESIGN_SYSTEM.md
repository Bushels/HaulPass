# HaulPass Design System
**Farmer-First UI/UX Guide**

Version 1.0 | Updated: 2025-11-14

---

## Table of Contents

1. [Design Philosophy](#design-philosophy)
2. [User Research: Understanding Farmers](#user-research)
3. [Color System](#color-system)
4. [Typography](#typography)
5. [Components](#components)
6. [Spacing & Layout](#spacing--layout)
7. [Iconography](#iconography)
8. [Micro-Interactions](#micro-interactions)
9. [Privacy-First Design](#privacy-first-design)
10. [Gamification System](#gamification-system)
11. [Accessibility](#accessibility)
12. [Dark Mode](#dark-mode)

---

## Design Philosophy

### Core Principles

**1. Professional Data Tool, Not Cheap App**
- Modern glassmorphism with depth
- Subtle shadows and glows
- Premium feel without being flashy
- Trustworthy and credible

**2. Farmer-First Usability**
- Large, finger-friendly touch targets (minimum 48x48dp)
- Icon-driven, visual-first interface
- Simple navigation with maximum 3 taps to any feature
- Works perfectly on slow/unstable connections
- Optimized for Android (primary device for farmers)

**3. Data Transparency**
- Clear data visualizations over dense text
- Real-time insights presented visually
- Dashboard-first approach
- Actionable information at a glance

**4. Privacy Protection**
- Farmers are vulnerable to privacy issues
- Build-in protection by default
- Visual indicators for data security
- Plain language privacy controls

**5. Engagement Through Achievement**
- Celebrate every milestone
- Visual progress tracking
- Dopamine-driven micro-rewards
- Long-term goals with daily wins

### Anti-Patterns to Avoid

❌ **Generic AI App Vibes**
- No generic gradients everywhere
- No overly rounded "bubbly" design
- No cluttered dashboards
- No tiny text or controls

❌ **Complexity**
- No hidden features
- No multi-step navigation to core functions
- No jargon or technical terms
- No overwhelming data dumps

❌ **Privacy Dark Patterns**
- No pre-checked consent boxes
- No hidden opt-outs
- No unclear data usage
- No buried privacy settings

---

## User Research: Understanding Farmers

### Device & Tech Profile

**Primary Devices:**
- Android smartphones (70%+)
- Budget to mid-range devices
- Screens: 5.5" - 6.5"
- Often used outdoors (bright sunlight)

**Familiar Apps:**
- Facebook, YouTube, WhatsApp, Google Search
- Banking apps
- Weather apps
- Basic understanding of notifications and home screen widgets

**Internet Connectivity:**
- Often rural with spotty 4G/LTE
- Limited WiFi access
- Data plan conscious
- Offline-first needs

### Usage Context

**When They Use HaulPass:**
- In the truck cab (landscape or portrait)
- At the binyard (often standing)
- At the elevator (waiting in queue)
- End of day (reviewing hauls)

**Physical Constraints:**
- Hands may be dirty/dusty
- Wearing gloves sometimes
- Bright sunlight glare
- Bumpy roads (in truck)

**Mental Model:**
- Think in terms of "hauls" and "loads"
- Time-sensitive (harvest season rush)
- Result-oriented (want efficiency gains)
- Value concrete data over estimates

---

## Color System

### Primary Palette

**Brand Colors (Grain & Earth Tones)**

```dart
// Primary - Grain Gold
static const Color primary = Color(0xFFF9A825); // Warm gold
static const Color primaryLight = Color(0xFFFFD95A);
static const Color primaryDark = Color(0xFFC17900);

// Secondary - Harvest Blue
static const Color secondary = Color(0xFF1565C0); // Trust blue
static const Color secondaryLight = Color(0xFF5E92F3);
static const Color secondaryDark = Color(0xFF003C8F);

// Accent - Field Green
static const Color accent = Color(0xFF2E7D32); // Success green
static const Color accentLight = Color(0xFF60AD5E);
static const Color accentDark = Color(0xFF005005);
```

**Semantic Colors**

```dart
// Success
static const Color success = Color(0xFF2E7D32);
static const Color successBg = Color(0xFFE8F5E9);

// Warning
static const Color warning = Color(0xFFF57C00);
static const Color warningBg = Color(0xFFFFF3E0);

// Error
static const Color error = Color(0xFFD32F2F);
static const Color errorBg = Color(0xFFFFEBEE);

// Info
static const Color info = Color(0xFF1976D2);
static const Color infoBg = Color(0xFFE3F2FD);
```

**Neutral Scale**

```dart
// Light mode neutrals
static const Color surface = Color(0xFFFAFAFA);
static const Color surfaceVariant = Color(0xFFEEEEEE);
static const Color onSurface = Color(0xFF212121);
static const Color onSurfaceVariant = Color(0xFF757575);

// Borders & dividers
static const Color outline = Color(0xFFBDBDBD);
static const Color outlineVariant = Color(0xFFE0E0E0);
```

### Glow Effects

**Primary Button Glow**
```dart
BoxShadow(
  color: primary.withOpacity(0.3),
  blurRadius: 12,
  offset: Offset(0, 4),
  spreadRadius: 0,
)
```

**Success Glow**
```dart
BoxShadow(
  color: success.withOpacity(0.25),
  blurRadius: 10,
  offset: Offset(0, 3),
  spreadRadius: 0,
)
```

**Glassmorphism Background**
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.7),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: Colors.white.withOpacity(0.2),
    ),
  ),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: child,
  ),
)
```

---

## Typography

### Font Family

**Primary: Inter** (Clean, modern, highly legible)
- Designed for screens
- Excellent readability at small sizes
- Wide range of weights

**Fallback: System Font** (Roboto on Android, SF Pro on iOS)

### Type Scale

```dart
// Display - Hero sections
static const TextStyle displayLarge = TextStyle(
  fontSize: 57,
  fontWeight: FontWeight.w700,
  height: 1.12,
  letterSpacing: -0.25,
);

static const TextStyle displayMedium = TextStyle(
  fontSize: 45,
  fontWeight: FontWeight.w600,
  height: 1.16,
);

static const TextStyle displaySmall = TextStyle(
  fontSize: 36,
  fontWeight: FontWeight.w600,
  height: 1.22,
);

// Headline - Section titles
static const TextStyle headlineLarge = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w600,
  height: 1.25,
);

static const TextStyle headlineMedium = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.w600,
  height: 1.29,
);

static const TextStyle headlineSmall = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  height: 1.33,
);

// Title - Cards, list items
static const TextStyle titleLarge = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w500,
  height: 1.27,
);

static const TextStyle titleMedium = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  height: 1.50,
  letterSpacing: 0.15,
);

static const TextStyle titleSmall = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  height: 1.43,
  letterSpacing: 0.1,
);

// Body - Main content
static const TextStyle bodyLarge = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 1.50,
  letterSpacing: 0.5,
);

static const TextStyle bodyMedium = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1.43,
  letterSpacing: 0.25,
);

static const TextStyle bodySmall = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 1.33,
  letterSpacing: 0.4,
);

// Label - Buttons, form labels
static const TextStyle labelLarge = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  height: 1.43,
  letterSpacing: 0.1,
);

static const TextStyle labelMedium = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  height: 1.33,
  letterSpacing: 0.5,
);

static const TextStyle labelSmall = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  height: 1.45,
  letterSpacing: 0.5,
);
```

### Usage Guidelines

- **Minimum body text size: 14sp** (never smaller for readability)
- **Line height: 1.4-1.5** for comfortable reading
- **Max line length: 60-70 characters** for body text
- **Use bold weights (600+)** for emphasis, not ALL CAPS
- **Letter spacing** for small labels to improve legibility

---

## Components

### Buttons

#### Primary Button (Call to Action)

**Design:**
- Height: 56dp (tall for easy tapping)
- Padding: 24dp horizontal
- Border radius: 12dp
- Background: Gradient (primary → primaryDark)
- Shadow: Soft glow (12dp blur, 4dp offset)
- Text: labelLarge, white, semibold

**States:**
- Default: Full color with glow
- Hover: Slightly brighter
- Pressed: Scale 0.98, darker shade
- Disabled: 40% opacity, no glow
- Loading: Spinner with reduced opacity

```dart
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null && !isLoading) ...[
                  Icon(icon, color: Colors.white),
                  SizedBox(width: 8),
                ],
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                else
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

#### Secondary Button (Alternative Actions)

**Design:**
- Height: 56dp
- Border: 2dp, primary color
- Background: Transparent
- Text: primary color
- No glow

#### Text Button (Tertiary Actions)

**Design:**
- Height: 48dp
- No border or background
- Text: secondary color, underline on hover
- Padding: 16dp horizontal

### Cards

#### Data Card (Dashboard Stats)

**Design:**
- Padding: 20dp
- Border radius: 16dp
- Background: Glassmorphism (white 70% opacity, blur 10)
- Border: 1dp white 20% opacity
- Shadow: Subtle elevation (4dp blur, 2dp offset)

**Content Structure:**
- Icon (32dp) + Title (titleMedium)
- Primary value (displayMedium, semibold)
- Secondary info (bodySmall, muted)
- Optional chart/visualization

```dart
class DataCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: accentColor ?? primary),
                SizedBox(width: 12),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: accentColor ?? primary,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 4),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### Form Inputs

#### Text Field

**Design:**
- Height: 56dp
- Padding: 16dp horizontal
- Border radius: 12dp
- Border: 2dp, outline color
- Label: Floating label (Material 3 style)
- Icon: Leading icon (24dp) with 12dp spacing

**States:**
- Default: outline border
- Focus: primary color border, primary color label
- Error: error color border, error message below
- Disabled: 60% opacity

**Guidelines:**
- Always include labels (no placeholder-only fields)
- Use helper text for examples/guidance
- Show character count for limited fields
- Prefix/suffix for units (kg, lbs, $, etc.)

### Privacy Indicators

#### Data Lock Badge

**When to use:**
- Sign up/sign in screens
- Profile settings
- Data entry forms

**Design:**
```dart
class PrivacyBadge extends StatelessWidget {
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: success.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline, size: 16, color: success),
          SizedBox(width: 6),
          Text(
            message,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: success,
            ),
          ),
        ],
      ),
    );
  }
}
```

**Example messages:**
- "Your data is encrypted"
- "Private to you only"
- "Not shared with anyone"

#### Connection Status Indicator

**Design:**
- Small dot (8dp) + text (labelSmall)
- Colors:
  - Green: "Connected securely"
  - Yellow: "Offline mode"
  - Red: "Connection error"

---

## Spacing & Layout

### Spacing Scale

```dart
static const double space4 = 4.0;
static const double space8 = 8.0;
static const double space12 = 12.0;
static const double space16 = 16.0;
static const double space20 = 20.0;
static const double space24 = 24.0;
static const double space32 = 32.0;
static const double space40 = 40.0;
static const double space48 = 48.0;
static const double space64 = 64.0;
```

### Layout Guidelines

**Screen Padding:**
- Mobile: 16-24dp horizontal, 16dp vertical
- Tablet: 32dp horizontal, 24dp vertical

**Component Spacing:**
- Related items: 8-12dp
- Sections: 24-32dp
- Major sections: 48-64dp

**Touch Targets:**
- Minimum: 48x48dp
- Preferred: 56x56dp for primary actions
- Spacing between: 8dp minimum

**Max Content Width:**
- Forms: 400dp
- Dashboard cards: 360dp
- Body text: 640dp

---

## Iconography

### Icon Style

- **Outlined style** (Material Symbols Outlined)
- **Size: 24dp** default, 32dp for emphasis, 16dp for inline
- **Color: Match text color** or use semantic colors
- **Stroke weight: 2dp** (medium weight)

### Core Icons

```dart
// Navigation
home: Icons.home_outlined,
map: Icons.map_outlined,
person: Icons.person_outlined,
settings: Icons.settings_outlined,

// Haul operations
truck: Icons.local_shipping_outlined,
grain: Icons.agriculture_outlined,
elevator: Icons.warehouse_outlined,
location: Icons.location_on_outlined,
route: Icons.route_outlined,

// Status
success: Icons.check_circle_outlined,
warning: Icons.warning_amber_outlined,
error: Icons.error_outlined,
info: Icons.info_outlined,

// Actions
add: Icons.add_circle_outlined,
edit: Icons.edit_outlined,
delete: Icons.delete_outlined,
search: Icons.search,
filter: Icons.filter_list,

// Data
chart: Icons.bar_chart,
trend_up: Icons.trending_up,
trend_down: Icons.trending_down,
calendar: Icons.calendar_today,
time: Icons.access_time,

// Privacy
lock: Icons.lock_outlined,
visibility: Icons.visibility_outlined,
visibility_off: Icons.visibility_off_outlined,
shield: Icons.shield_outlined,
```

---

## Micro-Interactions

### Principles

1. **Provide Feedback** - Every action gets immediate visual response
2. **Guide Users** - Animations show relationships and flow
3. **Delight Subtly** - Moments of joy without distraction
4. **Be Fast** - Animations under 300ms

### Common Animations

#### Button Press

```dart
AnimatedScale(
  duration: Duration(milliseconds: 100),
  scale: _isPressed ? 0.96 : 1.0,
  child: button,
)
```

#### Success Checkmark

```dart
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  curve: Curves.easeOutBack,
  transform: Matrix4.identity()..scale(_isSuccess ? 1.0 : 0.0),
  child: Icon(Icons.check_circle, color: success, size: 64),
)
```

#### Loading Skeleton

```dart
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: skeletonCard,
)
```

#### Number Counter

```dart
TweenAnimationBuilder<int>(
  duration: Duration(milliseconds: 800),
  tween: IntTween(begin: 0, end: finalValue),
  builder: (context, value, child) {
    return Text('$value');
  },
)
```

---

## Privacy-First Design

### Core Principles

1. **Privacy by Default**
   - Most secure settings enabled by default
   - Opt-in for data sharing, not opt-out
   - Clear explanation before any data collection

2. **Transparency**
   - Show exactly what data is collected
   - Explain why it's needed in plain language
   - Provide easy access to privacy dashboard

3. **User Control**
   - Granular privacy controls
   - Easy to find and change settings
   - Delete data easily

4. **Data Minimization**
   - Only collect what's absolutely necessary
   - Clear retention policies
   - Automatic data cleanup

### UI Patterns

#### Just-in-Time Consent

**When requesting location access:**

```dart
Dialog(
  child: Column(
    children: [
      Icon(Icons.location_on_outlined, size: 64, color: primary),
      SizedBox(height: 16),
      Text(
        'Enable Location Tracking?',
        style: headlineSmall,
      ),
      SizedBox(height: 8),
      Text(
        'We need your location to:',
        style: bodyMedium,
      ),
      SizedBox(height: 12),
      FeatureList([
        '✓ Track your route to the elevator',
        '✓ Calculate accurate drive times',
        '✓ Show your position in queue',
      ]),
      SizedBox(height: 16),
      PrivacyNote(
        'Your location is only used during active hauls and never shared.',
      ),
      SizedBox(height: 20),
      PrimaryButton(text: 'Enable Location'),
      TextButton(text: 'Not Now'),
    ],
  ),
)
```

#### Privacy Dashboard

**Screen showing:**
- Data collected (with icons)
- Who can see it (just you, other farmers in queue, etc.)
- Retention period
- Download/delete options

```dart
class PrivacyDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DataCategoryCard(
          icon: Icons.location_on_outlined,
          title: 'Location Data',
          description: 'Used to track routes and queue position',
          visibility: 'Only you',
          retention: 'Deleted after 90 days',
          dataSize: '2.3 MB',
        ),
        DataCategoryCard(
          icon: Icons.local_shipping_outlined,
          title: 'Haul History',
          description: 'Your load records and efficiency metrics',
          visibility: 'Only you',
          retention: 'Kept until you delete',
          dataSize: '854 KB',
        ),
        // ... more categories

        SizedBox(height: 32),
        OutlineButton(
          text: 'Download All My Data',
          icon: Icons.download_outlined,
        ),
        SizedBox(height: 12),
        TextButton(
          text: 'Delete My Account',
          color: error,
        ),
      ],
    );
  }
}
```

#### Data Sharing Opt-In

**For queue intelligence feature:**

```dart
class QueueSharingOptIn extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Icon(Icons.people_outlined, size: 48, color: info),
          SizedBox(height: 16),
          Text(
            'Help Other Farmers?',
            style: headlineSmall,
          ),
          SizedBox(height: 8),
          Text(
            'Share your queue position with other farmers hauling to the same elevator. This helps everyone see real-time wait times.',
            textAlign: TextAlign.center,
            style: bodyMedium,
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What's shared:', style: labelMedium),
                SizedBox(height: 8),
                Text('✓ Your position in queue (anonymous)', style: bodySmall),
                Text('✓ Estimated wait time', style: bodySmall),
                SizedBox(height: 12),
                Text('What's NOT shared:', style: labelMedium),
                SizedBox(height: 8),
                Text('✗ Your name or farm', style: bodySmall),
                Text('✗ Your exact location', style: bodySmall),
                Text('✗ Load details', style: bodySmall),
              ],
            ),
          ),
          SizedBox(height: 20),
          SwitchListTile(
            title: Text('Share Queue Data'),
            value: _shareData,
            onChanged: (value) => setState(() => _shareData = value),
          ),
          SizedBox(height: 8),
          Text(
            'You can change this anytime in Settings > Privacy',
            style: bodySmall.copyWith(color: onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
```

---

## Gamification System

### Framework

**Two-Track System:**
1. **Daily Streaks** - Immediate gratification
2. **Lifetime Milestones** - Long-term goals

### Streak System

**Haul Streak** - Days with at least one haul

**Visual Design:**
```dart
class StreakCard extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFA000).withOpacity(0.1),
            Color(0xFFFF6F00).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFFFA000).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Fire icon with glow
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFFFA000),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFFA000).withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(Icons.local_fire_department, color: Colors.white, size: 32),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$currentStreak Day Streak!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFF6F00),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Longest: $longestStreak days',
                  style: bodySmall.copyWith(color: onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

**Streak Levels:**
- 3 days: "Getting Started" (bronze flame)
- 7 days: "Committed" (silver flame)
- 14 days: "Dedicated" (gold flame)
- 30 days: "Legend" (platinum flame with particle effects)

### Milestone System

**Categories:**

1. **Total Hauls**
   - 10, 25, 50, 100, 250, 500, 1000 hauls
   - Badges: Bronze → Silver → Gold → Platinum → Diamond

2. **Total Grain Hauled**
   - Based on kg/bushels
   - Visual: Grain silo filling up

3. **Efficiency Master**
   - Based on average haul time improvements
   - Badges show time saved

4. **Distance Driver**
   - Total miles driven
   - Route map visualization

5. **Queue Champion**
   - Shortest wait times
   - Contributed queue data points

**Badge Design:**

```dart
class AchievementBadge extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int progress;
  final int total;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: unlocked ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unlocked ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Badge icon with conditional glow
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: unlocked ? color : Colors.grey,
              boxShadow: unlocked ? [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 16,
                  spreadRadius: 4,
                ),
              ] : null,
            ),
            child: Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: titleMedium.copyWith(
              color: unlocked ? color : Colors.grey,
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          // Progress bar
          LinearProgressIndicator(
            value: progress / total,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation(color),
          ),
          SizedBox(height: 4),
          Text(
            '$progress / $total',
            style: labelSmall.copyWith(color: onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
```

**Unlock Animation:**

When milestone is reached:
1. Badge scales up with bounce effect
2. Particle burst animation
3. Confetti overlay
4. Haptic feedback
5. Success sound (optional, user preference)
6. Push notification

```dart
void showMilestoneUnlocked(BuildContext context, Achievement achievement) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti background
          ConfettiWidget(),
          // Main card
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: achievement.color.withOpacity(0.3),
                  blurRadius: 24,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🎉 Milestone Unlocked!',
                  style: headlineMedium,
                ),
                SizedBox(height: 24),
                // Animated badge
                AnimatedScale(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  scale: 1.0,
                  child: AchievementBadge(achievement),
                ),
                SizedBox(height: 24),
                Text(
                  achievement.title,
                  style: titleLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  achievement.description,
                  style: bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                PrimaryButton(
                  text: 'Awesome!',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
```

### Progress Visualization

**Dashboard Widget:**

```dart
class ProgressOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Progress', style: headlineSmall),
        SizedBox(height: 16),

        // Streak
        StreakCard(currentStreak: 5, longestStreak: 12),

        SizedBox(height: 16),

        // Next milestones
        Text('Next Milestones', style: titleMedium),
        SizedBox(height: 12),

        MilestonePreview(
          icon: Icons.local_shipping,
          title: '50 Hauls',
          progress: 37,
          total: 50,
          color: primary,
        ),

        MilestonePreview(
          icon: Icons.route,
          title: '1,000 Miles',
          progress: 847,
          total: 1000,
          color: secondary,
        ),
      ],
    );
  }
}
```

---

## Accessibility

### WCAG 2.1 Level AA Compliance

**Color Contrast:**
- Normal text: 4.5:1 minimum
- Large text (18pt+): 3:1 minimum
- UI components: 3:1 minimum

**Text Size:**
- Support system font size preferences
- Test at 200% zoom
- Never smaller than 12sp

**Touch Targets:**
- 48x48dp minimum (WCAG AAA)
- 8dp spacing between targets

**Semantics:**
- All images have alt text
- Form fields have labels
- Buttons have descriptive labels
- Screen reader support

**Keyboard Navigation:**
- All actions accessible via keyboard
- Visible focus indicators
- Logical tab order

---

## Dark Mode

### Color Palette

```dart
// Dark mode colors
static const Color darkSurface = Color(0xFF121212);
static const Color darkSurfaceVariant = Color(0xFF1E1E1E);
static const Color darkOnSurface = Color(0xFFE0E0E0);
static const Color darkOnSurfaceVariant = Color(0xFFB0B0B0);

// Adjusted primary for dark mode (less saturated)
static const Color darkPrimary = Color(0xFFFFB74D);
static const Color darkSecondary = Color(0xFF64B5F6);
static const Color darkAccent = Color(0xFF81C784);
```

### Implementation

```dart
ThemeData darkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkSecondary,
      surface: darkSurface,
      onSurface: darkOnSurface,
      // ... complete scheme
    ),
    // Elevated surfaces in dark mode
    cardTheme: CardTheme(
      color: darkSurfaceVariant,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
    ),
  );
}
```

### Dark Mode Guidelines

1. **Automatic detection** - Follow system preference by default
2. **Manual override** - Setting to force light/dark/auto
3. **Reduce glow intensity** - Shadows less pronounced in dark mode
4. **Adjust glassmorphism** - Darker blur, more prominent borders
5. **Elevation through borders** - Less reliance on shadows

---

## Implementation Checklist

### Phase 1: Foundation (Week 1)
- [ ] Create theme configuration file
- [ ] Implement color system
- [ ] Set up typography
- [ ] Create spacing constants
- [ ] Configure dark mode

### Phase 2: Core Components (Week 2)
- [ ] PrimaryButton with glow
- [ ] SecondaryButton
- [ ] TextButton
- [ ] DataCard with glassmorphism
- [ ] Custom text fields
- [ ] Privacy badges

### Phase 3: Privacy UI (Week 2-3)
- [ ] Just-in-time consent dialogs
- [ ] Privacy dashboard screen
- [ ] Data sharing opt-in cards
- [ ] Connection status indicators

### Phase 4: Gamification (Week 3-4)
- [ ] Streak tracking system
- [ ] Milestone definitions
- [ ] Achievement badges
- [ ] Unlock animations
- [ ] Progress dashboard widgets

### Phase 5: Polish (Week 4)
- [ ] Micro-interactions
- [ ] Loading states
- [ ] Error states
- [ ] Empty states
- [ ] Success animations

### Phase 6: Testing (Week 5)
- [ ] Accessibility audit
- [ ] Color contrast validation
- [ ] Touch target verification
- [ ] User testing with farmers
- [ ] Performance optimization

---

## Resources

### Design Tools
- Figma file: [HaulPass Design System]
- Icon library: Material Symbols
- Color palette: https://coolors.co/f9a825-1565c0-2e7d32

### Research References
- WCAG 2.1 Guidelines: https://www.w3.org/WAI/WCAG21/quickref/
- Material Design 3: https://m3.material.io/
- Privacy by Design: https://privacypatterns.org/

### Flutter Packages
- `flutter_animate` - Micro-interactions
- `shimmer` - Loading skeletons
- `confetti` - Celebration animations
- `flutter_secure_storage` - Privacy features

---

**Version History:**
- v1.0 (2025-11-14) - Initial design system
- Next update: After user testing feedback

**Maintained by:** HaulPass Design Team
**Questions?** See CONTRIBUTING.md
