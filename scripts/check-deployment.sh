#!/bin/bash

# GitHub Pages Deployment Troubleshooting Script
# Helps diagnose common deployment issues

echo "🔍 HaulPass GitHub Pages Deployment Checker"
echo "=============================================="
echo ""

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Not in HaulPass directory"
    echo "   Please run this from /home/user/HaulPass/"
    exit 1
fi

echo "✅ In HaulPass directory"
echo ""

# Check .nojekyll file
echo "📋 Checking Jekyll configuration..."
if [ -f "web/.nojekyll" ]; then
    echo "✅ .nojekyll file exists (Jekyll disabled)"
else
    echo "⚠️  .nojekyll file missing - creating it..."
    touch web/.nojekyll
    echo "✅ Created web/.nojekyll"
fi
echo ""

# Check GitHub Pages workflow
echo "📋 Checking GitHub Actions workflow..."
if [ -f ".github/workflows/deploy-pages.yml" ]; then
    echo "✅ Deploy workflow exists"
else
    echo "❌ Deploy workflow missing!"
    echo "   Expected: .github/workflows/deploy-pages.yml"
fi
echo ""

# Check web directory
echo "📋 Checking web directory..."
if [ -d "web" ]; then
    echo "✅ web/ directory exists"
    echo "   Contents:"
    ls -1 web/ | sed 's/^/     - /'
else
    echo "❌ web/ directory missing!"
fi
echo ""

# Check pubspec.yaml dependencies
echo "📋 Checking Flutter dependencies..."
if grep -q "supabase_flutter" pubspec.yaml; then
    echo "✅ Supabase Flutter dependency found"
else
    echo "⚠️  Supabase Flutter dependency not found"
fi

if grep -q "go_router" pubspec.yaml; then
    echo "✅ GoRouter dependency found"
else
    echo "⚠️  GoRouter dependency not found"
fi
echo ""

# Check git status
echo "📋 Checking Git status..."
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "✅ Current branch: $BRANCH"

    # Check if there are uncommitted changes
    if git diff-index --quiet HEAD --; then
        echo "✅ No uncommitted changes"
    else
        echo "⚠️  You have uncommitted changes"
        echo "   Run: git status"
    fi
else
    echo "❌ Not a git repository"
fi
echo ""

# Instructions
echo "=============================================="
echo "📖 Next Steps to Enable GitHub Pages"
echo "=============================================="
echo ""
echo "1️⃣  Commit the .nojekyll file (if just created):"
echo "   git add web/.nojekyll"
echo "   git commit -m 'fix: add .nojekyll to disable Jekyll'"
echo "   git push"
echo ""
echo "2️⃣  Enable GitHub Pages on GitHub.com:"
echo "   • Go to: https://github.com/Bushels/HaulPass"
echo "   • Click 'Settings' tab"
echo "   • Scroll to 'Pages' in left sidebar"
echo "   • Under 'Source', select: GitHub Actions"
echo "   • Click 'Save'"
echo ""
echo "3️⃣  Check deployment status:"
echo "   • Go to: https://github.com/Bushels/HaulPass/actions"
echo "   • Look for 'Deploy to GitHub Pages' workflow"
echo "   • Wait for green checkmark (✓)"
echo ""
echo "4️⃣  Access your live app:"
echo "   • URL format: https://<username>.github.io/HaulPass/"
echo "   • Replace <username> with your GitHub username"
echo ""
echo "=============================================="
echo "🆘 Common Issues"
echo "=============================================="
echo ""
echo "Issue: 404 Page Not Found"
echo "  → Enable GitHub Pages in Settings first"
echo "  → Wait 2-3 minutes after enabling"
echo "  → Check Actions tab for deployment status"
echo ""
echo "Issue: Blank white screen"
echo "  → Hard refresh: Ctrl+Shift+R (Windows/Linux)"
echo "  → Hard refresh: Cmd+Shift+R (Mac)"
echo "  → Check browser console (F12) for errors"
echo ""
echo "Issue: Build fails in Actions"
echo "  → Check Actions logs for specific error"
echo "  → Ensure pubspec.yaml has all dependencies"
echo "  → Verify Flutter version compatibility"
echo ""
echo "=============================================="
echo ""
echo "Run this script again after making changes!"
echo ""
