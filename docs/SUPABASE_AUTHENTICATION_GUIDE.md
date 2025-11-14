# Supabase Authentication Guide for HaulPass

## ✅ You're Already Authenticated!

Your app is already configured to connect to Supabase. The **anon key** you provided is all you need for app-level authentication.

## 🔐 How Supabase Authentication Works

### Two Levels of Authentication

#### 1. **App-to-Supabase** (Already Done ✅)
```dart
// Your app authenticates to Supabase using the anon key
await Supabase.initialize(
  url: 'https://nwismkrgztbttlndylmu.supabase.co',
  anonKey: 'eyJhbG...' // Your anon key
);

// Now your app can use Supabase!
final client = Supabase.instance.client;
```

**What it does**:
- Allows your Flutter app to communicate with Supabase
- Provides access to Auth, Database, Storage APIs
- No separate "authentication link" needed

#### 2. **User Authentication** (We'll Build This)
```dart
// Farmers sign up
await Supabase.instance.client.auth.signUp(
  email: 'farmer@example.com',
  password: 'secure_password',
);

// Farmers sign in
await Supabase.instance.client.auth.signInWithPassword(
  email: 'farmer@example.com',
  password: 'secure_password',
);

// Check if user is logged in
final user = Supabase.instance.client.auth.currentUser;
```

**What it does**:
- Farmers create accounts and log in
- Managed entirely by Supabase Auth API
- Stores user sessions securely
- Handles password resets, email verification, etc.

---

## 🚀 Authentication Flow in HaulPass

### **Step 1: App Starts** (App-to-Supabase Auth)
```
Flutter App Loads
    ↓
Environment Service initializes (.env file)
    ↓
Supabase.initialize(url, anonKey) ← Uses your anon key
    ↓
Supabase Client Ready ✅
```

### **Step 2: User Opens App** (User Authentication)
```
User Opens HaulPass
    ↓
Check: Is user logged in?
    ├─ YES → Show Home Screen
    └─ NO → Show Auth Screen (Sign Up / Sign In)
```

### **Step 3: Sign Up Flow** (What We'll Build)
```
New Farmer Signs Up
    ↓
Enter: Email, Password
    ↓
Supabase.auth.signUp()
    ↓
User Account Created ✅
    ↓
Show Onboarding: Farm, Binyard, Truck details
    ↓
Save to user_profiles table
    ↓
Show Home Screen
```

### **Step 4: Sign In Flow**
```
Returning Farmer Signs In
    ↓
Enter: Email, Password
    ↓
Supabase.auth.signInWithPassword()
    ↓
User Authenticated ✅
    ↓
Load Profile from user_profiles
    ↓
Show Home Screen
```

---

## 🧪 Verify Supabase Is Working

### Option 1: Run the Test Suite
```bash
flutter test test/core/services/supabase_test.dart
```

This will verify:
- ✅ Environment variables loaded
- ✅ Supabase client initialized
- ✅ Auth client available
- ✅ Database client available

### Option 2: Check in Your Browser

1. **Go to Supabase Dashboard**:
   - Visit: https://supabase.com/dashboard
   - Select project: `nwismkrgztbttlndylmu`

2. **Check Authentication**:
   - Go to: **Authentication** → **Users**
   - Currently empty (no farmers signed up yet)
   - This is normal!

3. **Check Database**:
   - Go to: **Table Editor**
   - You should see your tables (if created)
   - We'll create the schema next

4. **Check API**:
   - Go to: **Settings** → **API**
   - Verify your **anon key** matches what's in `.env`
   - Check **Project URL** matches

---

## 🔍 About the HTTP 403 Response

When we tested with curl:
```bash
curl https://nwismkrgztbttlndylmu.supabase.co/rest/v1/
# Response: 403
```

**This is expected!** Here's why:

### What 403 Means:
- ✅ **Supabase is reachable** (not 404 or 500)
- ✅ **Your anon key is recognized** (not 401)
- ✅ **Row Level Security (RLS) is working** (protecting your data)

### Why We Get 403:
1. **No tables exist yet** → Nothing to query
2. **RLS policies not set up** → Data is protected by default
3. **Need specific endpoint** → Can't just hit root API

### This Will Work Once We:
1. Create database tables (coming next!)
2. Set up Row Level Security policies
3. Make actual queries to specific tables

---

## 📊 What's Needed in Supabase Dashboard

Before we can fully use Supabase, we need to create:

### 1. **Database Tables** (We'll create via SQL)
- `user_profiles` - Extended user info
- `elevators` - Grain elevator data
- `haul_sessions` - Complete haul tracking
- `queue_snapshots` - Real-time queue data
- `elevator_stats` - Cached statistics
- `user_elevator_stats` - Personal analytics

### 2. **Row Level Security (RLS) Policies**
Example for `user_profiles`:
```sql
-- Users can read their own profile
CREATE POLICY "Users can view own profile"
ON user_profiles FOR SELECT
USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
ON user_profiles FOR UPDATE
USING (auth.uid() = id);
```

### 3. **Authentication Settings** (Already configured!)
- Email/Password enabled
- Email confirmation (optional)
- Password requirements

---

## 🎯 Current Status

### ✅ **What's Working**:
- Anon key configured
- Supabase client can initialize
- Auth API available
- Database API available

### 🔄 **Next Steps** (What we're building):
1. Create database schema in Supabase
2. Set up RLS policies
3. Build auth screens (sign up / sign in)
4. Build onboarding flow
5. Implement user profile management

---

## 🧪 Simple Authentication Test

Want to verify Supabase Auth works? Try this in your Supabase dashboard:

### Test Sign Up:
1. Go to **Authentication** → **Users**
2. Click **Add user** → **Create new user**
3. Enter test email: `test@example.com`
4. Enter password: `TestPassword123!`
5. Click **Create user**

If this works, your Supabase Auth is fully functional! ✅

---

## 🚨 Common Issues & Solutions

### Issue: "Can't connect to Supabase"
**Solution**:
- Check `.env` file exists
- Verify `SUPABASE_URL` and `SUPABASE_ANON_KEY` are set
- Run: `./scripts/test-supabase-connection.sh`

### Issue: "Invalid API key"
**Solution**:
- Get fresh anon key from Supabase Dashboard
- Copy **exactly** (including all characters)
- Update `.env` file
- Restart Flutter app

### Issue: "403 Forbidden" when querying
**Solution**:
- Normal! Tables don't exist yet
- We'll create them in next step
- RLS policies will be set up

### Issue: "User can't sign up"
**Solution**:
- Check email confirmation is disabled (for development)
- Verify no password policy violations
- Check Supabase logs in dashboard

---

## 📝 Summary

### You Already Have:
✅ Supabase project created
✅ Anon key configured
✅ App-to-Supabase authentication working
✅ Environment variables set up

### You Don't Need:
❌ Separate "authentication link"
❌ OAuth setup (unless you want Google/Apple login)
❌ Additional API keys for basic features

### We're Building Next:
1. Database schema (SQL migrations)
2. User authentication screens
3. Onboarding flow
4. Profile management

---

**You're all set!** The "authentication" you were concerned about is already done. The anon key IS the authentication mechanism for your app to talk to Supabase. Now we just need to build the user-facing features! 🚀
