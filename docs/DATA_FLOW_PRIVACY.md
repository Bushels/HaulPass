# HaulPass - Data Flow & Privacy Documentation

## 🔒 Data Philosophy

At HaulPass, we believe **your data belongs to you**. This document explains exactly what data we collect, how we use it to improve your experience and predict lineups, how we protect it, and how you control it.

**Core Privacy Principles:**
- ✅ **Anonymous by Default**: Queue predictions use aggregate anonymous data
- ✅ **Your Farm, Your Business**: Farm locations and routes stay private
- ✅ **You Choose What to Share**: Optional data sharing with managers/accountants
- ✅ **No Selling Ever**: Your data is never sold to third parties
- ✅ **Transparent Predictions**: You see what data powers the predictions

## 📊 Data Categories & Collection Points

### 1. Account Data (User-Provided)

#### Registration Information
```
Data Type: Email, Password
Collection Point: Sign-up form
Purpose: Account authentication and communication
Retention: Until account deletion
User Control: Editable, deletable
```

```
Data Type: Full Name, Truck Number, Company
Collection Point: Profile setup
Purpose: Professional identification, elevator check-in
Retention: Until account deletion  
User Control: Editable, optional
```

#### Hauling Preferences
```
Data Type: Default grain types, preferred routes
Collection Point: Profile settings
Purpose: Personalization and recommendations
Retention: Until account deletion
User Control: Editable, optional
```

**Privacy Impact**: ⭐⭐ (Low) - Basic profile information
**Business Value**: Essential for app functionality
**Compliance**: Standard privacy policy coverage

### 2. Location & Movement Data (Automatically Collected)

#### Real-Time Location Tracking
```
Data Type: GPS coordinates (latitude, longitude)
Collection Frequency: Every 30 seconds during active hauling
Purpose: Route learning, arrival detection, lineup position tracking
Storage: Local device + encrypted cloud
Retention: 90 days (or until trip completes, whichever is shorter)
User Control: Location permissions required, can pause tracking
```

**What's Shared Anonymously:**
- "A truck is en route to Prairie Co-op, ETA 10 minutes"
- "Truck type: triaxle with trailer"
- "Estimated load weight category: 50,000-55,000 lbs"

**What's NEVER Shared:**
- Your farm location
- Your specific route
- Your identity
- Your exact load weight

#### Route Learning (For ETA Calculations)
```
Data Type: Start/end GPS coordinates, travel time, load weight
Collection Frequency: Each completed trip
Purpose: Predict YOUR future drive times on similar routes with similar loads
Storage: Encrypted, tied to your account only
Retention: Indefinitely (improves your predictions over time)
User Control: Can clear route history, disables personalized ETAs
```

**Privacy Protection:**
- Route data is NOT shared with other users
- Used only to predict YOUR future trips
- App learns that YOUR truck takes X minutes with Y weight
- Farm location coordinates stay in your account only

#### Elevator Proximity (For Lineup Predictions)
```
Data Type: Distance to elevator, arrival detection
Collection Frequency: Continuous while en route
Purpose: Update queue predictions as trucks arrive
Storage: Temporary (cleared after trip)
Retention: Real-time only, not stored long-term
User Control: Automatic with location permission
```

**What's Shared:**
- "Truck arriving at Prairie Co-op in 5 minutes" (anonymous)
- Updates queue prediction for all users

**What's Private:**
- Where you came from
- Your route to get there

**Privacy Impact**: ⭐⭐⭐ (Medium) - Location shared only near elevators, anonymously
**Business Value**: Core app functionality, queue predictions
**Compliance**: Requires explicit consent, clear privacy policy

### 3. Operational Data (User-Inputted & System-Derived)

#### Hauling Sessions
```
Data Type: Start time, end time, duration, elevator visited
Collection Method: Automatic (GPS-based) + Manual confirmation
Purpose: Performance tracking, route optimization, billing support
Storage: Encrypted cloud database
Retention: 7 years (business record requirement)
User Control: View, export, delete (with data export)
```

#### Event Logging
```
Data Type: "Arrived", "In Line", "Loading Started", "Complete"
Collection Method: One-tap buttons, voice commands
Purpose: Detailed operational tracking, wait time analysis
Storage: Encrypted cloud database
Retention: 7 years
User Control: Edit event descriptions, delete individual events
```

#### Grain & Load Information
```
Data Type: Grain type, load weight, quality notes
Collection Method: Dropdown selection, voice-to-text
Purpose: Elevator compatibility, market analytics
Storage: Encrypted cloud database
Retention: 7 years
User Control: Edit, delete, mark as sensitive
```

**Privacy Impact**: ⭐⭐⭐ (Medium) - Business operational data
**Business Value**: Core value proposition, market intelligence
**Compliance: Business records, industry requirements

### 4. Engagement & Analytics Data (Automatically Collected)

#### App Usage Patterns
```
Data Type: Screen views, feature usage, session duration
Collection Frequency: Every app interaction
Purpose: UX improvement, feature prioritization
Storage: Anonymous aggregated analytics
Retention: 26 months
User Control: Opt-out of analytics, GDPR compliant
```

#### Device Information
```
Data Type: Device type, OS version, app version
Collection Frequency: App launch
Purpose: Compatibility testing, performance optimization
Storage: Anonymous analytics
Retention: 12 months
User Control: Cannot be disabled (necessary for functionality)
```

#### Performance Metrics
```
Data Type: Load times, crash reports, error logs
Collection Frequency: As needed for debugging
Purpose: App stability and performance improvement
Storage: Anonymous crash reporting service
Retention: 90 days
User Control: Cannot be disabled (security requirement)
```

**Privacy Impact**: ⭐ (Minimal) - Anonymous, aggregated data
**Business Value**: Essential for app improvement
**Compliance**: Standard analytics privacy policy

## 🔄 Data Flow Architecture

### User Device Layer
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   User Device   │    │   User Device   │    │   User Device   │
│                 │    │                 │    │                 │
│ • GPS Tracking  │────│ • Local Storage │────│ • App Interface │
│ • Manual Input  │    │ • Offline Cache │    │ • Notifications │
│ • Voice Notes   │    │ • Settings      │    │ • Background    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Data Transmission
```
User Device → Internet → HaulPass Cloud → Processing → Storage
     ↓              ↓           ↓            ↓           ↓
   Raw GPS      Encrypted   Firewall &   AI/ML     Database
   Manual       TLS 1.3     WAF         Analysis    Encryption
   Voice        Requests    Protection   Engines     at Rest
```

### Cloud Processing Layers
```
┌─────────────────────────────────────────────────────────────┐
│                    HaulPass Cloud Platform                   │
├─────────────────┬─────────────────┬─────────────────────────┤
│   API Gateway   │   Load Balancer │    Security Layer       │
│                 │                 │                         │
│ • Rate Limiting │ • Auto-scaling  │ • DDoS Protection      │
│ • Authentication│ • Health Checks │ • Intrusion Detection  │
│ • Request Logic │ • Failover      │ • Data Validation      │
└─────────────────┴─────────────────┴─────────────────────────┘
         ↓                       ↓                      ↓
┌─────────────────────────────────────────────────────────────┐
│                 Data Processing Pipeline                     │
├─────────────────┬─────────────────┬─────────────────────────┤
│   Real-time     │   Batch         │    Machine Learning     │
│   Processing    │   Processing    │    Models               │
│                 │                 │                         │
│ • Live Updates  │ • Daily Reports │ • Route Optimization   │
│ • Notifications │ • Analytics     │ • Wait Time Prediction │
│ • Status Sync   │ • Data Mining   │ • Pattern Recognition  │
└─────────────────┴─────────────────┴─────────────────────────┘
         ↓                       ↓                      ↓
┌─────────────────────────────────────────────────────────────┐
│                  Secure Data Storage                        │
├─────────────────┬─────────────────┬─────────────────────────┤
│   Primary DB    │   Analytics DB  │    Backup & Archive     │
│                 │                 │                         │
│ • User Data     │ • Aggregated    │ • Disaster Recovery     │
│ • Sessions      │ • Anonymized    │ • Long-term Storage     │
│ • Real-time     │ • Statistical   │ • Compliance Archive    │
└─────────────────┴─────────────────┴─────────────────────────┘
```

## 🛡️ Data Protection & Security

### Encryption Standards

#### Data in Transit
- **Protocol**: TLS 1.3 for all communications
- **Certificate**: Let's Encrypt SSL certificates
- **API Security**: JWT tokens with 1-hour expiration
- **Database**: SSL connections for all queries

#### Data at Rest
- **Database**: AES-256 encryption for all stored data
- **File Storage**: Server-side encryption for documents/images
- **Backups**: Encrypted backups with separate key management
- **Mobile Storage**: iOS/Android encryption for local data

### Access Control

#### User Data Access
```
┌─────────────────────────────────────────────────────────────┐
│                     User Data Access                        │
├─────────────────┬─────────────────┬─────────────────────────┤
│     User        │  HaulPass Staff │    Third Parties       │
│                 │                 │                         │
│ • Own Data      │ • Support Only  │ • Elevator Operators   │
│ • Full Export   │ • Debug Access  │   (limited to status)  │
│ • Deletion      │ • Aggregated    │ • Analytics Partners   │
│ • Anonymization │   Analytics     │   (anonymized only)    │
└─────────────────┴─────────────────┴─────────────────────────┘
```

#### Administrative Access
- **Principle of Least Privilege**: Staff only access data needed for their role
- **Audit Logging**: All data access logged and monitored
- **Two-Factor Authentication**: Required for all admin accounts
- **Role-Based Access**: Different permission levels for different roles

### Compliance Framework

#### GDPR Compliance (European Users)
```
Right to Access      ✓ Users can download all their data
Right to Rectification ✓ Users can correct any data
Right to Erasure     ✓ Users can delete their account
Right to Portability ✓ Users can export data in standard formats
Right to Object      ✓ Users can opt-out of processing
```

#### Industry Standards
- **SOC 2 Type II**: Security and availability controls
- **ISO 27001**: Information security management
- **PCI DSS**: Payment card industry standards (if applicable)
- **Agricultural Data**: Industry-specific privacy guidelines

## 🎯 How We Use Your Data

### Queue Prediction System (The Core Value)

#### How Anonymous Data Powers Predictions

**The Challenge:**
Farmers waste hours in lineups because they don't know how long the wait will be BEFORE they leave the yard.

**The Solution:**
HaulPass uses anonymous aggregate data from all users to predict future queue states.

#### What Data Goes Into Predictions

**From Users WITH HaulPass (Anonymous):**
```
Collected:
• "User X is loaded and heading to Prairie Co-op"
• "ETA: 10 minutes from now"
• "Truck type: Triaxle with trailer"
• "Estimated weight: 50,000-55,000 lbs"
• "Historical unload time for this user: 7-9 minutes"

NOT Collected:
• User identity
• Farm location
• Exact route
• Exact weight
```

**From Users Without HaulPass (Estimated):**
```
When You Arrive:
• You report: "2 trucks ahead of me"
• You select their types: "Triaxle", "Super-B"

App Estimates:
• Unknown truck #1: ~8 min unload (triaxle average)
• Unknown truck #2: ~12 min unload (super-B average)
• Assumes they're hauling the same grain type as majority
```

#### Real-Time Prediction Updates

**Example: You're loading corn at 6:00 AM**

```
6:00 AM - You open app:
┌─────────────────────────────────────────────────┐
│ Prairie Co-op                                   │
│ Current wait: 8 minutes                         │
│ • 1 truck in line (with app, 6 min unload est.)│
│                                                  │
│ When YOU arrive (6:12 AM):                      │
│ Predicted wait: 5 minutes                       │
│ • Current truck will be done                    │
│ • 2 trucks arriving before you will take ~10min│
│ • You'll be 3rd when you arrive                 │
└─────────────────────────────────────────────────┘
```

**How We Know:**
- Current truck has HaulPass → we know their actual avg unload time
- 2 users with HaulPass are en route, arriving at 6:08 and 6:10
- Their ETAs are based on their GPS distance + their historical drive times
- Their unload times predicted from their weight + historical patterns

**What You DON'T See:**
- Who the other farmers are
- Where they're coming from
- Their exact weights
- Their farm locations

#### Personalized ETA Calculations (Your Data Only)

```
Your Data Used (NOT Shared):
• Your historical drive times from various starting points
• How your drive time changes with load weight
• Your typical driving patterns
• Your truck's performance characteristics

How It Helps You:
• "Based on your history, this trip takes 12 minutes with a 52,000 lb load"
• "Last time you went here with similar weight, it took 11 minutes"
• App learns YOUR specific patterns, not generic averages
• Accounts for your truck, your driving style, your routes

Privacy Protection:
• This data stays in YOUR account
• Other users don't see your patterns
• You're not compared to other drivers
• Your routes remain private
```

### Industry Intelligence & Analytics

#### Market Trend Analysis
```
Aggregated Data Used:
• Regional grain movement patterns
• Seasonal hauling trends
• Elevator capacity utilization
• Supply chain bottlenecks

How It Helps the Industry:
• Better infrastructure planning
• Improved supply chain efficiency
• More accurate market forecasting
• Enhanced elevator operations
```

#### Performance Benchmarking
```
Your Data (Anonymized):
• Hauling efficiency metrics
• Route optimization success rates
• Seasonal performance variations
• Technology adoption patterns

How It Helps You:
• Compare performance with industry averages
• Identify improvement opportunities
• Benchmark against similar operations
• Data-driven business decisions

How It Helps Others:
• Aggregate industry insights
• Technology improvement priorities
• Policy and infrastructure recommendations
```

## 📱 Cross-Platform Data Flow

### Web Application
```
Browser → HaulPass Cloud → Database
• Session-based authentication
• Real-time WebSocket connections
• Offline-first PWA capabilities
• Automatic data synchronization
```

### Mobile Applications (iOS/Android)
```
Native App → Local Storage → Sync → Cloud
• Background GPS tracking
• Offline operation support
• Push notification delivery
• Secure local data encryption
```

### Data Synchronization
```
┌─────────────────────────────────────────────────────────────┐
│                 Multi-Device Synchronization                 │
├─────────────────┬─────────────────┬─────────────────────────┤
│   Real-time     │   Periodic      │     Conflict            │
│   Sync          │   Sync          │     Resolution          │
│                 │                 │                         │
│ • Status Updates│ • Daily Backup  │ • Last-write-wins       │
│ • Notifications │ • Analytics     │ • User notification     │
│ • Quick Changes │ • Bulk Updates  │ • Manual override       │
└─────────────────┴─────────────────┴─────────────────────────┘
```

## 🎛️ User Control & Privacy Settings

### Granular Privacy Controls

#### Location Privacy
```
Location Sharing Levels:
┌─────────────────────────────────────────────────────────────┐
│ OFF       │ BASIC     │ ENHANCED    │ FULL      │ CUSTOM    │
│           │           │             │           │           │
│ No GPS    │ Route     │ Route +     │ All data  │ User      │
│ tracking  │ only      │ Elevator    │ collection│ selects   │
│           │           │ proximity   │           │ specific  │
└─────────────────────────────────────────────────────────────┘
```

#### Data Retention Settings
```
Retention Period Options:
• 30 days: Minimal storage, maximum privacy
• 90 days: Balanced approach (default)
• 1 year: Extended analytics, better recommendations
• Business records: 7 years (required for tax/compliance)
• Custom: User-defined periods
```

#### Sharing Preferences
```
Data Sharing Controls:
☐ Anonymous usage analytics (helps improve app)
☐ Aggregated industry insights (helps industry)
☐ Route optimization data (helps all users)
☐ Performance benchmarking (anonymized)
☐ Marketing communications (optional)
```

### Data Export & Portability

#### Comprehensive Data Export
```
Export Formats Available:
• JSON: Machine-readable complete dataset
• CSV: Spreadsheet-compatible format
• PDF: Human-readable summary report
• XML: Structured data format

Export Includes:
• All personal profile information
• Complete hauling history
• Location and route data
• Performance analytics
• App usage statistics
```

#### Selective Data Deletion
```
Deletion Options:
• Account deletion (removes everything)
• Specific data types (e.g., location history only)
• Date range deletion (remove old sessions)
• Feature-specific deletion (remove timer data)
• Anonymization (remove personal identifiers)
```

## 🔍 Transparency & Compliance

### Data Processing Notices

#### Real-Time Processing
```
"What happens when I open the app?"
1. Location permission check (if enabled)
2. GPS coordinate collection (if enabled)
3. Nearby elevator search using your location
4. Real-time status updates from elevator network
5. Personal recommendations based on history
6. Session tracking begins (if timer active)

Duration: <5 seconds for basic features
Data Shared: Location only (with elevators for status)
Retention: Location cached for 1 hour
```

#### Background Processing
```
"What happens while I'm hauling?"
1. GPS tracking every 30 seconds (if enabled)
2. Automatic elevator detection via proximity
3. Session timer starts/stops based on location
4. Event logging when you tap buttons
5. Data sync when internet connection available
6. Battery optimization to minimize drain

Data Shared: Only elevator status (for real-time updates)
Retention: 90 days (configurable)
```

### Third-Party Integrations

#### Map Services (Google Maps/Apple Maps)
```
Data Shared: 
• Destination coordinates when navigating
• Real-time traffic data (anonymized)
• No personal information beyond routing

Why Necessary: Core navigation functionality
User Control: Can use external navigation apps instead
```

#### Analytics Services (Amplitude/Mixpanel)
```
Data Shared:
• Anonymous usage patterns
• Feature adoption metrics
• Performance data
• No personal identifiers

Why Necessary: App improvement and optimization
User Control: Can opt-out in privacy settings
```

#### Crash Reporting (Crashlytics/Sentry)
```
Data Shared:
• Anonymous crash reports
• Performance metrics
• Device compatibility data
• No personal information

Why Necessary: App stability and reliability
User Control: Cannot be disabled (security requirement)
```

## 📞 Data Questions & Support

### Common Privacy Questions

**"Can I use HaulPass without sharing my location?"**
Yes, but with limitations. You can manually enter locations and use basic features. Full route optimization requires location data.

**"Who can see my hauling routes and schedules?"**
Only you and people you explicitly share with. Fleet managers can see their drivers' data if granted permission. Elevators see anonymous status only.

**"Can elevator operators see my personal information?"**
No. Elevators receive anonymous status updates and arrival notifications only. Your personal data is never shared with third parties.

**"How do you protect my data from hackers?"**
Multiple layers: encryption in transit and at rest, secure cloud infrastructure, regular security audits, and compliance with industry standards.

**"What happens to my data if HaulPass goes out of business?"**
Your data is backed up and can be exported. We provide 90 days notice before any data deletion, with export options available.

### Support Channels

- **Privacy Questions**: privacy@haulpass.com
- **Data Access Requests**: support@haulpass.com
- **Security Concerns**: security@haulpass.com
- **General Support**: help@haulpass.com

### Privacy Contact Information
```
Data Protection Officer: Sarah Johnson
Email: privacy@haulpass.com
Phone: 1-800-HAUL-PASS
Address: 
HaulPass Data Protection
123 Agriculture Way
Des Moines, IA 50309
```

---

*This documentation is updated regularly to reflect changes in our data practices. Last updated: November 2024*

**Remember: Your data belongs to you. We're just the custodians, and we take that responsibility seriously.**
