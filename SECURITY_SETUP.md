# 🔒 Security Setup for HaulPass

## ⚠️ Important: Your API Keys Were Exposed

Your Supabase and Google Maps API keys were committed to your public GitHub repository. This document outlines the steps to secure your application.

---

## 🚨 Immediate Actions Required

### 1. Rotate Your Google Maps API Key (CRITICAL)

Your exposed key: `AIzaSyBu0Lto_W97FHEU_9l1SAlwdlsdwYqDb2k`

**Steps:**
1. Go to [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
2. **Delete** the exposed API key immediately
3. Create a new API key
4. **Add HTTP Referrer Restrictions:**
   - For production: `https://yourdomain.com/*`
   - For local dev: `http://localhost:*`, `http://127.0.0.1:*`
5. Save the new key securely

**Why?** Exposed Google Maps API keys can be abused, leading to:
- Unauthorized usage charges on your billing account
- Thousands of dollars in fraudulent API calls

---

### 2. Verify Supabase Security

Your exposed Supabase anon key: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

**Note:** Supabase anon keys are designed to be client-facing, BUT you must ensure:

**Steps:**
1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Navigate to your project: `nwismkrgztbttlndylmu`
3. Check **Authentication** → **Policies**
4. Ensure **Row Level Security (RLS)** is enabled on ALL tables
5. Verify your RLS policies are restrictive and correct
6. Consider rotating the anon key if you suspect abuse

**How to Check for Abuse:**
```bash
# Check Supabase logs for suspicious activity
# Dashboard → Logs → Search for unusual patterns
```

---

## 🔧 Fix Your Local Setup

### Step 1: Copy the Template

```bash
# Copy the template to create your local index.html
copy web\index.html.template web\index.html
```

### Step 2: Update web/index.html with Your NEW Keys

Open `web/index.html` and replace:
- `YOUR_SUPABASE_URL_HERE` → Your Supabase URL
- `YOUR_SUPABASE_ANON_KEY_HERE` → Your Supabase anon key
- `YOUR_GOOGLE_MAPS_API_KEY_HERE` → Your NEW Google Maps API key

### Step 3: Verify .gitignore

Ensure `web/index.html` is listed in `.gitignore`:
```
# Web index.html contains secrets - use index.html.template instead
web/index.html
```

---

## 🧹 Clean Up Git History

Your old keys are still in your git history. To remove them:

### Option 1: Use BFG Repo-Cleaner (Recommended)

```bash
# Download BFG from https://rtyley.github.io/bfg-repo-cleaner/

# Replace all instances of the exposed keys
java -jar bfg.jar --replace-text passwords.txt

# Clean up
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force push (WARNING: Destructive operation)
git push --force
```

Create `passwords.txt`:
```
AIzaSyBu0Lto_W97FHEU_9l1SAlwdlsdwYqDb2k
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53aXNta3JnenRidHRsbmR5bG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIxODQ5NzgsImV4cCI6MjA3Nzc2MDk3OH0.AYBnfLG4G0p63keKqVCcqvziEfr0Loo9r4-5daNb0BI
```

### Option 2: Use git-filter-repo

```bash
# Install git-filter-repo
pip install git-filter-repo

# Create a file with patterns to remove
git-filter-repo --path web/index.html --invert-paths

# Force push
git push --force
```

⚠️ **WARNING:** Force pushing will rewrite history. Coordinate with your team if others have cloned the repo.

---

## 📝 Going Forward

### For Local Development:

1. Keep your `web/index.html` file LOCAL ONLY
2. Use `web/index.html.template` as the source of truth
3. Never commit `web/index.html` to git

### For Team Members:

Create a `.env` file from `.env.example`:
```bash
copy .env.example .env
```

Then manually copy values from `web/index.html` to `.env` for documentation.

### For Production Deployment:

Use environment variable injection at build time:
```bash
# Example: Inject secrets during CI/CD
flutter build web --dart-define=SUPABASE_URL=$SUPABASE_URL
```

---

## ✅ Verification Checklist

- [ ] Rotated Google Maps API key
- [ ] Added HTTP referrer restrictions to new Google Maps API key
- [ ] Verified Supabase RLS policies are enabled
- [ ] Created local `web/index.html` from template
- [ ] Added new keys to local `web/index.html`
- [ ] Verified `web/index.html` is in `.gitignore`
- [ ] Removed old keys from git history
- [ ] Tested app with new keys locally
- [ ] Monitored Google Cloud Console for unusual activity
- [ ] Monitored Supabase Dashboard for suspicious requests

---

## 🆘 Need Help?

If you suspect your keys have been abused:
1. Check Google Cloud Console → Billing for unexpected charges
2. Check Supabase Dashboard → Logs for suspicious activity
3. Contact support immediately if you see unauthorized usage

---

## 📚 Learn More

- [Supabase Security Best Practices](https://supabase.com/docs/guides/auth/row-level-security)
- [Google Maps API Security](https://developers.google.com/maps/api-security-best-practices)
- [Removing Sensitive Data from Git](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
