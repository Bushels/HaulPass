#!/bin/bash
# Pre-commit checks for HaulPass

set -e  # Exit on any error

echo "🔍 Running pre-commit checks..."

# 1. Format check
echo "📝 Checking code formatting..."
dart format --set-exit-if-changed lib/ test/ || {
  echo "❌ Code formatting issues found. Run: dart format lib/ test/"
  exit 1
}

# 2. Analyze code
echo "🔬 Running static analysis..."
flutter analyze || {
  echo "❌ Static analysis failed"
  exit 1
}

# 3. Run tests
echo "🧪 Running tests..."
flutter test || {
  echo "❌ Tests failed"
  exit 1
}

# 4. Check for TODOs in critical files (optional warning)
echo "📋 Checking for TODOs..."
TODO_COUNT=$(grep -r "TODO\|FIXME" lib/ --exclude-dir=*.g.dart | wc -l)
if [ $TODO_COUNT -gt 0 ]; then
  echo "⚠️  Warning: $TODO_COUNT TODOs found (not blocking commit)"
fi

echo "✅ All checks passed! Safe to commit."
