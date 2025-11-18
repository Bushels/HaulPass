# HaulPass Sign-Up Flow Documentation

## Overview
This document explains how the HaulPass sign-up process works, from user registration through email confirmation to first login.

## Sign-Up Process Flow

### 1. Multi-Step Registration Form
**Location:** `lib/presentation/screens/auth/signup_screen.dart`

The sign-up process consists of 5 steps (0-indexed):

#### Step 0: Authentication Details
- **Fields:**
  - Email address (validated, must contain @)
  - Password (minimum 6 characters)
  - Confirm Password (must match)
  - Accept Terms checkbox (required)
- **Validation:** Form validates email format, password length, password match, and terms acceptance
- **Button:** "Continue" (enabled only when terms accepted)

#### Step 1: Personal Information
- **Fields:**
  - First Name (required)
  - Last Name (required)
- **Button:** "Continue"

#### Step 2: Farm Details
- **Fields:**
  - Farm Name (required)
  - Binyard Name (optional)
- **Button:** "Continue"

#### Step 3: Truck Details (Grain Hauler Specific)
- **Fields:**
  - Grain Truck Name (optional)
  - Grain Capacity (optional, numeric)
  - Unit Selection (dropdown: kg, tonnes, bushels, pounds)
  - Fields aligned with flex ratio 3:2 for visual balance
- **Button:** "Continue"

#### Step 4: Elevator Selection
- **Features:**
  - Autocomplete search (search-as-you-type, max 50 results)
  - Server-side search via `ElevatorService.searchElevators()`
  - Searches 513 elevators in `elevators_import` table
  - Selected elevator displays in green container with checkmark
  - Can change or remove selected elevator
- **Buttons:**
  - "Complete Sign Up" (primary button, calls `_completeSignUp`)
  - "Skip for now" (text button, can add elevator later)

### 2. Backend Registration
**Location:** `lib/presentation/providers/auth_provider.dart` → `signUp()` method

When user clicks "Complete Sign Up":

1. **Validation:**
   - Passwords match check
   - Terms acceptance check
   - Form validation for all required fields

2. **Supabase Registration:**
   ```dart
   await Supabase.instance.client.auth.signUp(
     email: request.email,
     password: request.password,
     data: {
       'first_name': request.firstName,
       'last_name': request.lastName,
       'farm_name': request.farmName,
       'binyard_name': request.binyardName,
       'grain_truck_name': request.grainTruckName,
       'grain_capacity_kg': request.grainCapacityKg,
       'preferred_unit': request.preferredUnit,
       'favorite_elevator_id': request.favoriteElevatorId,
     },
   );
   ```

3. **User Metadata Storage:**
   - All form data stored in Supabase `auth.users.user_metadata`
   - Accessible via `user.userMetadata['field_name']`
   - Used to populate `UserProfile` model

### 3. Email Confirmation Behavior

**Configuration:** `lib/core/config/demo_config.dart`

Two modes controlled by `isDevelopmentMode`:

#### Development Mode (`isDevelopmentMode = true`)
- Email confirmation **SKIPPED**
- User immediately signed in after registration
- Auth state set to authenticated
- Navigation to home screen automatic
- **Warning:** Console logs reminder to disable in production

#### Production Mode (`isDevelopmentMode = false`)
- Email confirmation **REQUIRED**
- Supabase sends confirmation email
- User must click link in email
- `user.emailConfirmedAt` remains `null` until confirmed
- Error message: "Please check your email to confirm your account"
- User **CANNOT** sign in until email confirmed

### 4. Post-Registration Flow

#### Development Mode Path:
```
Sign Up → Supabase Creates Account → _handleSignedIn() → Set Auth State → Navigate to Home
```

#### Production Mode Path:
```
Sign Up → Supabase Creates Account → Email Sent → User Clicks Link → Email Confirmed → Can Sign In
```

## Sign-In Process Flow

### 1. Sign-In Screen
**Location:** `lib/presentation/screens/auth/signin_screen.dart`

- Email and password fields
- Remember me checkbox
- Forgot password link
- "Sign In" button calls `authNotifierProvider.signIn()`

### 2. Sign-In Authentication
**Location:** `lib/presentation/providers/auth_provider.dart` → `signIn()` method

1. **Supabase Authentication:**
   ```dart
   await Supabase.instance.client.auth.signInWithPassword(
     email: email,
     password: password,
   );
   ```

2. **Email Confirmation Check:**
   ```dart
   if (response.user!.emailConfirmedAt == null && !DemoConfig.shouldSkipEmailConfirmation) {
     // Production: Block sign-in, show error
     await Supabase.instance.client.auth.signOut();
     state = state.copyWith(error: AuthError(
       message: 'Please confirm your email address before signing in.',
     ));
     return;
   }
   ```

3. **Auth State Listener:**
   - Supabase triggers `onAuthStateChange` event
   - `_handleAuthStateChange()` processes `AuthChangeEvent.signedIn`
   - Calls `_handleSignedIn(session)` to update app state

4. **User Profile Creation:**
   - Extracts metadata from `session.user.userMetadata`
   - Creates `UserProfile` object with all registration data
   - Updates auth state to authenticated

## Router Navigation & Guards

**Location:** `lib/main.dart` → `_createRouter()`

### Redirect Logic:
```dart
redirect: (context, state) {
  final isAuthenticated = ref.read(isAuthenticatedProvider);
  final isAuthRoute = currentLocation.startsWith('/auth');

  // Not authenticated + trying to access app → redirect to /auth
  if (!isAuthenticated && !isAuthRoute) {
    return '/auth';
  }

  // Authenticated + on auth screens → redirect to home
  if (isAuthenticated && isAuthRoute) {
    return '/';
  }

  return null; // No redirect needed
}
```

### Routes:
- `/auth` - Landing auth screen
- `/auth/signin` - Sign-in screen
- `/auth/signup` - Sign-up screen
- `/` - Main navigation (home, loads, elevators, profile)

## Elevator Search Integration

**Location:**
- Dialog: `lib/presentation/widgets/dialogs/elevator_search_dialog.dart`
- Service: `lib/data/services/elevator_service.dart`
- Database: Supabase `elevators_import` table (513 rows)

### Search Implementation:
1. User types in search field
2. `onChanged` triggers `_searchElevators(query)` with debouncing
3. Calls `ElevatorService.searchElevators(name: query, limit: 50)`
4. Server-side query: `ilike '%query%'` for case-insensitive substring match
5. Results displayed in list with company and address
6. Selected elevator stored as `Map<String, dynamic>`
7. Favorite elevator ID saved to user metadata

### Database Query:
```dart
PostgrestFilterBuilder q = _client
  .from('elevators_import')
  .select('id,name,company,address,capacity_tonnes,grain_types,railway,elevator_type');

if (name != null && name.isNotEmpty) {
  q = q.ilike('name', '%$name%');
}

final data = await q.order('name').limit(limit);
```

## Data Models

### RegisterRequest
**Location:** `lib/data/models/user_models.dart`

Contains all sign-up form data:
- Authentication: email, password, confirmPassword, acceptTerms
- Personal: firstName, lastName
- Farm: farmName, binyardName
- Truck: grainTruckName, grainCapacityKg, preferredUnit
- Elevator: favoriteElevatorId

### UserProfile
Represents authenticated user with:
- Supabase user ID
- Email
- Display name and names
- Farm and truck details
- Favorite elevator ID
- User settings
- Timestamps (createdAt, lastLogin)

## Common Issues & Solutions

### Issue: "Email confirmation required"
**Cause:** Production mode requires email confirmation
**Solution:**
1. Check email inbox for Supabase confirmation link
2. Click link to confirm email
3. Then sign in
**Dev Workaround:** Set `isDevelopmentMode = true` in `demo_config.dart`

### Issue: Sign-in succeeds but doesn't navigate to dashboard
**Cause:** Race condition between auth state update and router redirect
**Solution:** See TROUBLESHOOTING.md for router fixes

### Issue: "Passwords do not match"
**Cause:** Password and confirm password fields differ
**Solution:** Ensure both fields have identical values

### Issue: Elevator search returns no results
**Cause:**
1. No elevators match search term
2. Supabase connection issue
**Solution:**
1. Try different search terms (name, company, location)
2. Check Supabase connection status
3. Verify `elevators_import` table has data (should have 513 rows)

## Testing Sign-Up Flow

### Manual Test Checklist:
1. ✅ Navigate to sign-up page
2. ✅ Fill in email and password (valid format)
3. ✅ Accept terms checkbox (button should enable)
4. ✅ Click "Continue" to step 1
5. ✅ Fill in first and last name
6. ✅ Click "Continue" to step 2
7. ✅ Fill in farm name (binyard optional)
8. ✅ Click "Continue" to step 3
9. ✅ Fill in truck details (optional, check field alignment)
10. ✅ Click "Continue" to step 4
11. ✅ Type town name in search field
12. ✅ Verify autocomplete results appear
13. ✅ Click on an elevator to select (should show green box)
14. ✅ Verify "Complete Sign Up" button is visible
15. ✅ Click "Complete Sign Up"
16. ✅ Verify account created successfully
17. ✅ Check for email confirmation (production) or auto-signin (dev)
18. ✅ Navigate to home dashboard

### Development Mode Test:
- Set `isDevelopmentMode = true`
- Sign up should complete and auto-signin
- No email confirmation required
- Should navigate to home screen immediately

### Production Mode Test:
- Set `isDevelopmentMode = false`
- Sign up should show "Check your email" message
- Email confirmation required before sign-in
- Clicking confirmation link sets `emailConfirmedAt`
- Then can sign in normally

## Code References

### Key Files:
- **Sign-Up Screen:** `lib/presentation/screens/auth/signup_screen.dart:1-700`
- **Sign-In Screen:** `lib/presentation/screens/auth/signin_screen.dart:1-293`
- **Auth Provider:** `lib/presentation/providers/auth_provider.dart:1-354`
  - Sign-Up: Lines 161-222
  - Sign-In: Lines 110-157
  - Auth State Listener: Lines 28-45
- **Demo Config:** `lib/core/config/demo_config.dart:1-31`
- **Router:** `lib/main.dart:44-122`
- **Elevator Dialog:** `lib/presentation/widgets/dialogs/elevator_search_dialog.dart:1-336`
- **Elevator Service:** `lib/data/services/elevator_service.dart:84-122`

### Supabase Integration:
- **Auth:** `supabase_flutter` package
- **Elevators Table:** `elevators_import` (BIGINT id, 513 rows, no RLS)
- **User Metadata:** Stored in `auth.users.user_metadata` JSON field
- **Email Settings:** Configured in Supabase Dashboard → Authentication → Email Templates

## Future Enhancements

1. **Email Verification Toggle:** Admin UI to enable/disable email confirmation
2. **Social Sign-In:** Google, Apple OAuth integration
3. **Phone Verification:** SMS-based verification option
4. **Profile Completion:** Wizard for users who skip optional fields
5. **Elevator Favorites:** Allow multiple favorite elevators (currently one)
6. **Truck Fleet:** Support multiple trucks per user
7. **Farm Management:** Multiple farms/binyards per user
