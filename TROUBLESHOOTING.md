# HaulPass Troubleshooting Guide

## Authentication Issues

### Problem: Cannot Sign Up or Login

#### Symptoms:
- Signup completes but can't login
- "Email confirmation required" message
- Stuck at login screen
- No error messages shown

#### Root Causes:

1. **Email Confirmation Enabled in Supabase**
   - Supabase requires email verification by default
   - Development environment can't receive confirmation emails
   - Users are stuck until email is verified

2. **Demo Mode Disabled**
   - Production mode requires real Supabase credentials
   - No fallback for testing without email confirmation

3. **Error Messages Not Displayed**
   - Errors caught but not shown to user
   - Silent failures make debugging difficult

---

## Solutions

### Option 1: Enable Development Mode in Code (IMPLEMENTED - Recommended)

**Status:** ✅ Already configured for development

**How it works:**
- The app now has a `isDevelopmentMode` flag in `lib/core/config/demo_config.dart`
- When enabled, users can sign up and login without email confirmation
- Automatic warning logs remind you to disable before production

**Current Configuration:**
```dart
// lib/core/config/demo_config.dart
static const bool isDevelopmentMode = true; // Set to false for production
```

**For Development:**
- Keep `isDevelopmentMode = true`
- Sign up and login work immediately without email verification
- Look for warning messages in console: "⚠️ Development mode: Skipping email confirmation check"

**For Production:**
1. Set `isDevelopmentMode = false` in `lib/core/config/demo_config.dart`
2. Enable email confirmation properly (see Option 3)
3. Test email delivery before deploying

---

### Option 2: Disable Email Confirmation in Supabase (Alternative)

**Steps:**
1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project: `nwismkrgztbttlndylmu`
3. Navigate to: **Authentication** → **Settings**
4. Find: **"Enable email confirmations"**
5. **Toggle OFF** (disable)
6. Click **Save**

**Result:** Users can sign up and login immediately without email verification.

⚠️ **Important:** Re-enable this in production!

---

### Option 3: Configure Email Confirmations Properly (For Production)

**For production, configure email properly:**

1. **Supabase Email Settings:**
   - Go to Authentication → Email Templates
   - Customize "Confirm signup" template
   - Add your domain to "Site URL"

2. **Set Redirect URLs:**
   ```
   Site URL: https://your-domain.com
   Redirect URLs:
     - http://localhost:3000/auth/callback
     - https://your-domain.com/auth/callback
   ```

3. **Test Email Delivery:**
   - Use a real email address
   - Check spam folder
   - Verify email templates are working

---

## Quick Diagnostic Checklist

### When signup/login fails:

- [ ] Check browser console for errors (F12 → Console)
- [ ] Verify Supabase URL and key in `.env`
- [ ] Check if email confirmation is disabled in Supabase
- [ ] Verify network requests succeed (F12 → Network)
- [ ] Check Supabase Dashboard → Authentication → Users
- [ ] Look for auth errors in terminal running Flutter

---

## Common Error Messages

### "Email confirmation required"
**Cause:** Supabase email confirmation is enabled
**Fix:** Disable in Supabase settings (see Option 1)

### "Sign up failed: AuthException"
**Cause:** Supabase connection issue or invalid credentials
**Fix:** Check `.env` file has correct SUPABASE_URL and SUPABASE_ANON_KEY

### "Passwords do not match"
**Cause:** Password and confirm password fields don't match
**Fix:** Re-enter passwords carefully

### "Invalid login credentials"
**Cause:** Wrong email/password or account doesn't exist
**Fix:**
1. Verify email/password
2. Check if account exists in Supabase Dashboard
3. Try password reset

### User sees no error at all
**Cause:** Error not displayed in UI
**Fix:** Check browser console (F12) for actual error

---

## Environment Configuration

### Required Environment Variables

```bash
# .env file
SUPABASE_URL=https://nwismkrgztbttlndylmu.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
GOOGLE_MAPS_API_KEY=your_maps_key_here
```

### Verify Configuration:

```bash
# Run app and check console logs
flutter run -d chrome

# Look for:
✅ All services initialized
✅ Supabase initialized successfully
✅ Supabase URL: https://nwismkrgztbttlndylmu.supabase.co
```

---

## Database Setup Issues

### Tables Not Found

If you get "relation does not exist" errors:

**Create Required Tables:**

```sql
-- Run in Supabase SQL Editor

-- User profiles table
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT,
  first_name TEXT,
  last_name TEXT,
  farm_name TEXT,
  binyard_name TEXT,
  grain_truck_name TEXT,
  grain_capacity_kg DECIMAL,
  preferred_unit TEXT DEFAULT 'kg',
  favorite_elevator_id TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);
```

---

## Browser-Specific Issues

### Chrome
- Clear cache: F12 → Application → Clear storage
- Disable extensions that block cookies
- Check CORS errors in console

### Safari
- Enable developer tools
- Check "Prevent Cross-Site Tracking" setting
- Allow cookies from Supabase domain

### Firefox
- Check Enhanced Tracking Protection
- Allow third-party cookies for Supabase
- Clear site data

---

## Network Issues

### CORS Errors

**Symptoms:**
```
Access to fetch blocked by CORS policy
```

**Fix:**
1. Verify Supabase URL is correct
2. Check Supabase dashboard → Settings → API
3. Add your domain to allowed origins

### Connection Timeout

**Symptoms:**
```
Network request failed
Connection timeout
```

**Fix:**
1. Check internet connection
2. Verify Supabase service status
3. Try different network
4. Check firewall/proxy settings

---

## Testing Authentication Flow

### Manual Test Steps:

1. **Signup:**
   ```
   Email: test@example.com
   Password: Test123!@#
   Fill all required fields
   → Should create account immediately (if email confirmation disabled)
   ```

2. **Login:**
   ```
   Email: test@example.com
   Password: Test123!@#
   → Should redirect to dashboard
   ```

3. **Verify:**
   - Check Supabase Dashboard → Authentication → Users
   - Should see new user listed
   - Email should match test@example.com

---

## Getting Help

### Debug Logs Location:

- **Browser Console:** F12 → Console tab
- **Network Requests:** F12 → Network tab
- **Flutter Logs:** Terminal running `flutter run`
- **Supabase Logs:** Dashboard → Logs

### Information to Provide:

When reporting auth issues, include:

1. Error message (exact text)
2. Browser console logs
3. Network tab screenshot (Supabase requests)
4. Steps to reproduce
5. Environment (browser, OS)
6. Supabase email confirmation setting (enabled/disabled)

---

## Best Practices

### Development:
- ✅ Disable email confirmation in Supabase
- ✅ Use test email addresses
- ✅ Check console logs regularly
- ✅ Test in incognito mode
- ✅ Clear cache between tests

### Production:
- ✅ Enable email confirmation
- ✅ Configure custom email templates
- ✅ Set proper redirect URLs
- ✅ Monitor Supabase logs
- ✅ Test email delivery
- ✅ Enable MFA (optional)

---

## Quick Fixes Summary

| Problem | Quick Fix | Time |
|---------|-----------|------|
| Can't login after signup | ✅ Already fixed - Development mode enabled | 0 min |
| No error messages | Check browser console | 1 min |
| Invalid credentials | Verify email/password in Supabase Dashboard | 2 min |
| Connection failed | Check .env file has correct keys | 1 min |
| Tables not found | Run SQL setup scripts | 5 min |
| CORS errors | Verify Supabase URL | 1 min |

---

## Status Indicators

### Healthy System:
```
✅ Supabase initialized successfully
✅ All services initialized
✅ Connectivity monitoring initialized
✅ Firebase initialized (or skipped with warning)
```

### Problem Indicators:
```
❌ Supabase initialization error
❌ Environment Configuration Error
❌ Sign in error: AuthException
❌ Sign up error: Email confirmation required
```

---

## Contact & Resources

- **Supabase Docs:** https://supabase.com/docs/guides/auth
- **Flutter Docs:** https://docs.flutter.dev/
- **HaulPass GitHub:** [Your repo URL]
- **Report Issues:** [GitHub Issues URL]
