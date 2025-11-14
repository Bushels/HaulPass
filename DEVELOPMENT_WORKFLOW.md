# HaulPass Development Workflow

## 🐛 Bug Detection Strategy

### Level 1: Real-Time Detection (While Coding)
```bash
# Terminal 1: Hot reload
flutter run -d chrome

# Terminal 2: Watch mode for code generation
dart run build_runner watch --delete-conflicting-outputs

# Terminal 3: Continuous analysis
flutter analyze --watch
```

**Benefits**:
- Instant feedback on type errors
- See UI changes immediately
- Catch issues before committing

### Level 2: Pre-Commit Validation
```bash
# Before every commit
./scripts/pre-commit-check.sh

# This runs:
# 1. Code formatting check
# 2. Static analysis
# 3. All unit tests
# 4. TODO count
```

### Level 3: Automated CI/CD
- Runs on every push and PR
- Full test suite
- Code coverage check (70% minimum)
- Build verification
- Bundle size check

### Level 4: Manual Testing
After implementing features:
1. **Functional Testing**: Test the feature works as expected
2. **Edge Cases**: Try unexpected inputs
3. **Mobile Testing**: Test on actual device/simulator
4. **Offline Mode**: Test without internet
5. **Performance**: Check loading times, animations

---

## 🔀 Pull Request (PR) Workflow

### When to Create a PR?

#### ✅ **Create PR For**:
1. **Feature Branches** (weekly milestones)
   ```bash
   # Example: End of Week 1
   git checkout -b feature/user-onboarding
   # ... work on onboarding ...
   # Create PR: feature/user-onboarding → main
   ```

2. **Before Merging to Main**
   - Weekly feature completion
   - Major refactoring
   - Breaking changes
   - Production releases

3. **Code Review Requirements**
   - Complex business logic
   - Security-sensitive code
   - Database schema changes
   - API integrations

#### ❌ **Don't Need PR For**:
1. **Direct Commits to Feature Branch**
   - Small bug fixes
   - Documentation updates
   - Minor UI tweaks
   - Work-in-progress commits

2. **Claude Working Branches**
   - `claude/fix-*` branches during active development
   - Commit frequently, PR when feature complete

### Recommended Workflow

#### Option A: Feature Branch Per Week (Recommended for HaulPass)
```bash
# Week 1
main → feature/week1-onboarding
  ├─ claude/onboarding-models (daily commits)
  ├─ claude/onboarding-screens (daily commits)
  └─ PR at end of week → main

# Week 2
main → feature/week2-haul-workflow
  ├─ claude/haul-session-model (daily commits)
  ├─ claude/haul-screens (daily commits)
  └─ PR at end of week → main
```

**PR Review Checklist**:
- [ ] All tests passing
- [ ] Code coverage >70%
- [ ] Documentation updated
- [ ] No console errors/warnings
- [ ] Tested on Chrome + mobile
- [ ] Schema migrations (if any) documented

#### Option B: Continuous Deployment (For Solo/Rapid Development)
```bash
# For faster iteration
main (always deployable)
  ├─ commit: Add user profile model
  ├─ commit: Create onboarding screen 1
  ├─ commit: Add elevator selection
  └─ Deploy automatically to staging
```

**When to use**: Solo development, MVP stage, rapid prototyping

### PR Template

Create `.github/pull_request_template.md`:
```markdown
## Summary
Brief description of changes

## Type of Change
- [ ] New feature
- [ ] Bug fix
- [ ] Refactoring
- [ ] Documentation
- [ ] Database schema change

## Related Issues
Closes #(issue number)

## Testing
- [ ] Unit tests added/updated
- [ ] Manual testing completed
- [ ] Tested on mobile device

## Screenshots/Videos
[Add if UI changes]

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-reviewed code
- [ ] Commented complex logic
- [ ] Updated documentation
- [ ] No new warnings
- [ ] Tests pass locally
```

---

## 🚀 Recommended Workflow for HaulPass

### Daily Development Cycle

**Morning**:
```bash
# 1. Pull latest
git pull origin main

# 2. Create/continue claude branch
git checkout -b claude/implement-feature-X

# 3. Start dev environment
flutter run -d chrome

# 4. Run tests in watch mode
flutter test --watch
```

**During Development** (Me coding):
- I commit after each complete sub-feature
- You test in browser as I work
- We iterate quickly with hot reload

**End of Day**:
```bash
# 1. Run pre-commit checks
./scripts/pre-commit-check.sh

# 2. Commit working code
git add .
git commit -m "Implement feature X - day 1 progress"

# 3. Push to remote
git push origin claude/implement-feature-X
```

**End of Week**:
```bash
# 1. Merge claude branch to feature branch
git checkout feature/week1-onboarding
git merge claude/implement-feature-X

# 2. Create PR for review
gh pr create --title "Week 1: User Onboarding Complete" \
  --body "See SUMMARY_FOR_STAKEHOLDERS.md"

# 3. After approval, merge to main
gh pr merge --squash
```

---

## 🧪 Testing Strategy

### Test Pyramid for HaulPass

```
        E2E Tests (5%)          ← Full user workflows
       /               \
      /  Integration (15%) \    ← Feature testing
     /                      \
    /    Unit Tests (80%)    \  ← Models, logic, utils
   /__________________________\
```

### Testing Commands

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/haul_session/haul_session_test.dart

# Run tests with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Run integration tests
flutter drive --target=test_driver/app.dart

# Run tests on specific device
flutter test -d chrome
flutter test -d android
```

### What to Test

#### ✅ **Must Test**:
- Business logic (haul session state machine)
- Data models (JSON serialization)
- Calculations (wait times, averages)
- Data validation
- State transitions

#### ⚠️ **Should Test**:
- Widget behavior
- Provider state management
- API integration
- GPS functionality

#### 🤷 **Optional Testing**:
- Simple widgets
- UI layout
- Theme/styling

### Example Test Structure

```dart
// test/features/haul_session/haul_session_test.dart
void main() {
  group('HaulSession', () {
    test('starts in idle state', () {
      final session = HaulSession();
      expect(session.status, HaulSessionStatus.idle);
    });

    test('transitions from loading to loaded with weight', () {
      final session = HaulSession()..startLoading();
      expect(session.status, HaulSessionStatus.loading);

      session.completeLoading(weightKg: 25000);
      expect(session.status, HaulSessionStatus.loaded);
      expect(session.loadingWeightKg, 25000);
    });

    test('calculates average load time correctly', () {
      // Test implementation
    });
  });
}
```

---

## 🔧 Git Workflow Best Practices

### Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `test`: Add/update tests
- `docs`: Documentation
- `style`: Formatting
- `chore`: Maintenance

**Examples**:
```bash
git commit -m "feat: add grain selection screen with icon grid"

git commit -m "fix: prevent queue entry with invalid position"

git commit -m "refactor: extract timer display into reusable widget"

git commit -m "test: add unit tests for haul session state machine"
```

### Branch Naming

```bash
# Feature branches
feature/week1-onboarding
feature/week2-haul-workflow
feature/queue-intelligence

# Bug fixes
fix/timer-not-stopping
fix/gps-accuracy-issue

# Claude working branches
claude/implement-onboarding
claude/fix-timer-display
```

---

## 📊 Quality Gates

Before merging to `main`, ensure:

1. **Tests**: ✅ All tests passing, >70% coverage
2. **Analysis**: ✅ No analyzer warnings/errors
3. **Format**: ✅ Code properly formatted
4. **Functionality**: ✅ Feature works as specified
5. **Performance**: ✅ No performance regressions
6. **Documentation**: ✅ README/docs updated
7. **Review**: ✅ Code review completed (if team)

---

## 🚀 Deployment Process

### Staging (Automatic)
```yaml
# Every push to main
main → CI/CD → GitHub Pages (staging)
```

### Production (Manual)
```bash
# 1. Create release branch
git checkout -b release/v1.0.0

# 2. Update version
# Update pubspec.yaml version

# 3. Run all checks
./scripts/pre-commit-check.sh

# 4. Create release
gh release create v1.0.0 --title "Version 1.0.0 - MVP Launch"

# 5. Deploy to production
flutter build web --release
# Deploy to production hosting
```

---

## 📝 Documentation

Update these after major changes:
- README.md (overview, features)
- CHANGELOG.md (version history)
- API documentation (if applicable)
- User guide (for farmers)
- Technical architecture docs

---

*Follow this workflow for consistent, high-quality development*
