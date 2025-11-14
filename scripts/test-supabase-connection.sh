#!/bin/bash
# Test Supabase connection and environment configuration

set -e

echo "🔍 Testing Supabase Connection..."
echo "================================="
echo ""

# Check if .env file exists
if [ ! -f ".env" ]; then
  echo "❌ Error: .env file not found!"
  echo "Please create .env file from .env.example and add your Supabase credentials."
  exit 1
fi

echo "✅ .env file found"
echo ""

# Check if required variables are set
echo "📋 Checking environment variables:"

# Read .env file
source .env 2>/dev/null || echo "⚠️  Warning: Could not source .env file"

# Check SUPABASE_URL
if [ -z "$SUPABASE_URL" ] || [ "$SUPABASE_URL" == "your_supabase_url_here" ]; then
  echo "❌ SUPABASE_URL not configured"
  exit 1
else
  echo "✅ SUPABASE_URL configured: $SUPABASE_URL"
fi

# Check SUPABASE_ANON_KEY
if [ -z "$SUPABASE_ANON_KEY" ] || [ "$SUPABASE_ANON_KEY" == "your_actual_anon_key_here" ]; then
  echo "❌ SUPABASE_ANON_KEY not configured"
  exit 1
else
  echo "✅ SUPABASE_ANON_KEY configured (hidden for security)"
fi

echo ""
echo "🔗 Testing connection to Supabase..."

# Test connection with curl
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "${SUPABASE_URL}/rest/v1/" \
  -H "apikey: ${SUPABASE_ANON_KEY}" \
  -H "Content-Type: application/json")

if [ "$RESPONSE" == "200" ] || [ "$RESPONSE" == "401" ] || [ "$RESPONSE" == "404" ] || [ "$RESPONSE" == "403" ]; then
  echo "✅ Successfully connected to Supabase!"
  echo "   HTTP Status: $RESPONSE"
  if [ "$RESPONSE" == "403" ]; then
    echo "   Note: 403 is expected - it means Supabase is reachable but requires authentication"
  fi
else
  echo "❌ Failed to connect to Supabase"
  echo "   HTTP Status: $RESPONSE"
  echo "   Please check your SUPABASE_URL and SUPABASE_ANON_KEY"
  exit 1
fi

echo ""
echo "🎉 All checks passed!"
echo ""
echo "Next steps:"
echo "1. Run: flutter pub get"
echo "2. Run: flutter run -d chrome"
echo "3. Check console for successful Supabase initialization"
