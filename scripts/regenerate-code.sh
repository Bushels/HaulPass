#!/bin/bash

# Script to regenerate all Flutter code generation files
# Run this after modifying models or providers with code generation annotations

set -e

echo "🔄 Regenerating Flutter code generation files..."
echo ""

# Run build_runner to regenerate all .g.dart files
echo "📝 Running build_runner..."
flutter pub run build_runner build --delete-conflicting-outputs

echo ""
echo "✅ Code generation complete!"
echo ""
echo "Generated files include:"
echo "  - lib/data/models/user_models.g.dart"
echo "  - lib/presentation/providers/auth_provider.g.dart"
echo "  - And other .g.dart files"
echo ""
echo "🎯 Next steps:"
echo "  1. Review the generated files for any errors"
echo "  2. Run tests: ./scripts/run-tests.sh"
echo "  3. Test the sign up and sign in flows in the app"
