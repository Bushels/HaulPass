# HaulPass - GitHub Pages Deployment Guide

## Quick Start

HaulPass is configured to automatically deploy to GitHub Pages when you push to the main branch or your Claude branch.

### Access Your Live App

**URL:** `https://<your-github-username>.github.io/HaulPass/`

Example: If your GitHub username is "bushels", the URL would be:
`https://bushels.github.io/HaulPass/`

## Automatic Deployment

### How It Works

A GitHub Actions workflow (`.github/workflows/deploy-pages.yml`) automatically:
1. Builds the Flutter web app
2. Deploys to GitHub Pages
3. Makes it available at the URL above

### Triggers

Deployment happens automatically when you push to:
- `main` branch
- `claude/fix-app-issues-01Rxb2ifJoymCbUWsBCUzNMd` branch

You can also trigger manually:
1. Go to GitHub → Actions tab
2. Click "Deploy to GitHub Pages"
3. Click "Run workflow"

## Enable GitHub Pages (One-Time Setup)

If this is your first deployment, enable GitHub Pages in your repository:

1. **Go to Repository Settings**
   - Navigate to your HaulPass repository on GitHub
   - Click "Settings" tab

2. **Configure Pages**
   - Scroll to "Pages" in left sidebar
   - Under "Source", select: **GitHub Actions**
   - Click "Save"

3. **Wait for Deployment**
   - Go to "Actions" tab
   - Watch the "Deploy to GitHub Pages" workflow
   - Usually takes 2-3 minutes

4. **Access Your App**
   - Once complete, visit: `https://<username>.github.io/HaulPass/`

## Deployment Status

### Check Deployment

1. **GitHub Actions Tab**
   - Green checkmark = Success
   - Red X = Failed (check logs)
   - Yellow dot = In progress

2. **View Logs**
   - Click on the workflow run
   - Click "build" or "deploy" to see details
   - Check for any errors

### Common Issues

**Issue: 404 Not Found**
- Solution: Ensure GitHub Pages is set to "GitHub Actions" source
- Check that workflow completed successfully
- Wait a few minutes for DNS propagation

**Issue: Blank White Screen**
- Solution: Check browser console for errors
- Verify Supabase credentials in `web/index.html`
- Ensure base href is set correctly

**Issue: Build Fails**
- Solution: Check Actions logs
- Verify all dependencies in `pubspec.yaml`
- Check for any code errors

## Supabase Integration

### Environment Variables

The app uses Supabase credentials embedded in `web/index.html`:

```html
<meta name="env-SUPABASE_URL" content="https://nwismkrgztbttlndylmu.supabase.co">
<meta name="env-SUPABASE_ANON_KEY" content="eyJhbG...">
<meta name="env-GOOGLE_MAPS_API_KEY" content="AIza...">
```

**⚠️ Security Note:**
- These are **public** credentials (safe for web deployment)
- The anon key is designed to be public
- Row Level Security (RLS) protects your data
- **Change these before production launch**

### Testing Authentication

Once deployed, you can test:

1. **Sign Up Flow**
   - Click "Get Started"
   - Complete 5-step onboarding
   - Data saves to Supabase user metadata

2. **Sign In Flow**
   - Click "Sign In"
   - Enter credentials
   - Should authenticate successfully

3. **Verify in Supabase**
   - Go to Supabase Dashboard
   - Click "Authentication" → "Users"
   - See newly created users

## Testing the New UI

### What to Test

**Design System Features:**
- ✅ Glow effects on buttons (should see subtle shadow)
- ✅ Privacy badges (lock icons with green text)
- ✅ Connection status (secure indicator)
- ✅ Smooth animations (button press, page transitions)
- ✅ Dark mode toggle (if available)

**Usability:**
- ✅ Buttons easy to tap (56dp height)
- ✅ Text readable (minimum 14sp)
- ✅ Forms validate properly
- ✅ Loading states show correctly

**Mobile Testing:**
- ✅ Test on actual phone
- ✅ Test in bright sunlight
- ✅ Test with gloves (large touch targets)
- ✅ Test on slow connection

### Browser Compatibility

**Supported Browsers:**
- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+

**Mobile Browsers:**
- ✅ Chrome Mobile
- ✅ Safari iOS
- ✅ Samsung Internet

## Development Workflow

### Making Changes

1. **Update Code Locally**
   ```bash
   # Make your changes
   git add .
   git commit -m "feat: your changes"
   git push
   ```

2. **Auto-Deploy**
   - Push triggers automatic deployment
   - Wait 2-3 minutes
   - Refresh your browser

3. **Verify Changes**
   - Clear browser cache (Ctrl+Shift+R)
   - Test updated functionality

### Manual Deployment

If you want to deploy manually:

```bash
# Build for web
flutter build web --release --base-href "/HaulPass/"

# The build output is in build/web/
# GitHub Actions handles deployment automatically
```

## Performance

### Build Information

- **Build Time:** ~2-3 minutes
- **Bundle Size:** ~2-3 MB (optimized)
- **Load Time:** < 3 seconds (on 4G)

### Optimization

The Flutter web build is automatically optimized:
- ✅ Tree shaking (removes unused code)
- ✅ Code splitting
- ✅ Asset compression
- ✅ Service worker caching

## Troubleshooting

### Deployment Fails

**Check Workflow Logs:**
1. Go to Actions tab
2. Click failed workflow
3. Check error messages

**Common Fixes:**
- Ensure Flutter version is compatible
- Check for syntax errors
- Verify all imports are correct

### App Not Loading

**Browser Console:**
1. Open Developer Tools (F12)
2. Check Console tab for errors
3. Look for network failures

**Common Fixes:**
- Hard refresh (Ctrl+Shift+R)
- Clear browser cache
- Check Supabase credentials
- Verify base href in build

### Authentication Issues

**If sign up/sign in fails:**
1. Check browser console for errors
2. Verify Supabase URL is reachable
3. Check Supabase Dashboard for errors
4. Ensure RLS policies are correct

## Next Steps

### After Testing

1. **Gather Feedback**
   - Test on multiple devices
   - Note any UI issues
   - Check performance

2. **Create Production Deployment**
   - Update Supabase credentials
   - Enable email verification
   - Set up custom domain (optional)

3. **Database Schema**
   - Create `user_profiles` table
   - Set up RLS policies
   - Migrate from user metadata

## Custom Domain (Optional)

### Setup Steps

1. **Buy Domain**
   - Example: haulpass.com

2. **Configure DNS**
   - Add CNAME record pointing to: `<username>.github.io`

3. **Update GitHub Pages**
   - Settings → Pages → Custom domain
   - Enter your domain
   - Enable HTTPS

4. **Update Build**
   - Change `--base-href` to `/`
   - Rebuild and redeploy

## Support

### Resources

- **GitHub Actions Docs:** https://docs.github.com/actions
- **GitHub Pages Docs:** https://docs.github.com/pages
- **Flutter Web Docs:** https://docs.flutter.dev/platform-integration/web

### Getting Help

If deployment fails:
1. Check Actions logs first
2. Review this guide
3. Check Supabase status
4. Review Flutter web documentation

---

**Last Updated:** 2025-11-14
**Status:** ✅ Ready for Deployment
**Workflow:** `.github/workflows/deploy-pages.yml`
