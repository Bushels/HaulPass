# HaulPass - Grain Hauling Logistics Application

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.24-blue.svg)](https://flutter.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-2.3-green.svg)](https://supabase.com/)
[![PWA](https://img.shields.io/badge/PWA-Enabled-blue.svg)](https://web.dev/progressive-web-apps/)
[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Deploy-black.svg)](https://pages.github.com/)

**Professional grain hauling logistics and tracking solution**

[🚀 Live Demo](https://bushels.github.io/HaulPass) • [📖 Documentation](docs/) • [🔧 Setup Guide](SETUP.md)

</div>

## 🎯 Overview

HaulPass is a farmer-first grain hauling efficiency application that reduces wait times at grain elevators through real-time queue intelligence and comprehensive haul tracking. By collecting GPS data, timing information, and farmer observations, HaulPass enables data-driven decisions about when to haul grain, ultimately saving farmers hours every week.

**The Problem**: Farmers waste 2-4 hours daily waiting in grain elevator lines without knowing queue lengths or wait times ahead of time.

**The Solution**: HaulPass collects farmer-side data (locations, routes, queue positions, timing) to provide real-time queue intelligence and predictive wait times. Unlike traditional elevator scheduling software, we start from the farmer's perspective to build trust and demonstrate value before enabling elevator-side features.

### ✨ Core Features

**MVP (Version 1.0)**:
- **🚛 Complete Haul Tracking**: Track entire grain hauling workflow from loading to unloading
- **📍 Single Favorite Elevator**: Focus on one elevator to prevent data errors
- **⏱️ Phase-Based Timers**: Separate timers for loading, driving, queuing, unloading, and return
- **👥 Queue Intelligence**: Real-time queue positions cross-validated between farmers
- **⏳ Estimated Wait Times**: Calculated from user averages and current queue
- **📊 Daily Summaries**: Comprehensive stats at end of each hauling day
- **📈 Personal Analytics**: Track efficiency metrics over time

**Future Features**:
- Multiple favorite elevators (2-3)
- Premium grain breakdown (weight, price, quality by grain type)
- Predictive recommendations (best times to haul)
- Historical pattern analysis
- Elevator scheduling integration
- Farm management tools (bin, field, combine tracking)

## 🚀 Quick Start

### Live Demo
Visit: **https://bushels.github.io/HaulPass**

### Local Development

```bash
# Clone the repository
git clone https://github.com/Bushels/HaulPass.git
cd HaulPass

# Install dependencies
flutter pub get

# Generate required code
flutter packages pub run build_runner build

# Run on web (recommended for development)
flutter run -d chrome

# Or run on mobile
flutter run -d android  # or ios
```

## 🏗️ Architecture

### Technology Stack
- **Frontend**: Flutter 3.24 with Riverpod state management
- **Backend**: Supabase (Database, Auth, Real-time, Storage)
- **Deployment**: GitHub Pages with automated CI/CD
- **State Management**: Riverpod 2.x with code generation
- **Routing**: GoRouter for navigation
- **PWA**: Progressive Web App with offline capabilities

### Project Structure
```
lib/
├── core/
│   ├── services/         # Core services (Supabase, Environment)
│   ├── config/           # Configuration (Web, App)
│   └── theme/            # App theming
├── data/
│   ├── models/           # Data models with JSON serialization
│   ├── repositories/     # Repository pattern implementation
│   └── providers/        # Riverpod providers
├── domain/
│   ├── entities/         # Business logic entities
│   ├── repositories/     # Repository interfaces
│   └── use_cases/        # Business logic use cases
└── presentation/
    ├── screens/          # UI screens
    ├── widgets/          # Reusable UI components
    └── providers/        # State management
```

## 🔧 Configuration

### Environment Variables

Create a `.env` file (see `.env.example`):

```env
SUPABASE_URL=your_supabase_url_here
SUPABASE_ANON_KEY=your_anon_key_here
GOOGLE_MAPS_API_KEY=your_google_maps_key_here
```

### Supabase Setup

1. Create a Supabase project at https://supabase.com
2. Get your project URL and anon key from Settings > API
3. Configure environment variables
4. Set up database tables using the provided migration scripts

### Google Maps API

1. Enable Google Maps SDK for Web in Google Cloud Console
2. Generate API key with required permissions
3. Add to environment variables

## 🚀 Deployment

### Automated GitHub Pages Deployment

**Every push to `main` branch automatically:**

1. ✅ Triggers GitHub Actions workflow
2. 🔨 Builds optimized Flutter web app
3. 📦 Packages PWA with offline support
4. 🚀 Deploys to GitHub Pages
5. 🌐 Makes available at https://bushels.github.io/HaulPass

### Required GitHub Secrets

Add these secrets in repository Settings > Secrets and variables > Actions:

- `SUPABASE_URL`: Your Supabase project URL
- `SUPABASE_ANON_KEY`: Your Supabase anonymous key

### Manual Deployment

```bash
# Build web version
flutter build web --release

# Deploy to gh-pages branch
flutter build web
cd build/web
git init
git add -A
git commit -m 'deploy'
git push -f <repo_url> master:gh-pages
```

## 📱 PWA Features

- **Installable**: Add to home screen on mobile/desktop
- **Offline Support**: Basic functionality without internet
- **Push Notifications**: Real-time alerts and updates
- **Responsive Design**: Optimized for all screen sizes
- **App-like Experience**: Standalone display mode

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart

# Test web version
flutter test -d chrome
```

## 📈 Performance

- **Web Build Size**: ~12MB (optimized)
- **Load Time**: <3 seconds on average connection
- **Lighthouse Score**: 95+ (Performance, Accessibility, Best Practices)
- **PWA Rating**: 100/100 (Manifest, Service Worker)

## 🔒 Security

- ✅ No hardcoded API keys
- ✅ Environment variable validation
- ✅ Secure Supabase integration
- ✅ HTTPS enforced in production
- ✅ Content Security Policy headers
- ✅ XSS protection enabled

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📋 Development Roadmap

### Phase 1: Foundation & Core Workflow (Weeks 1-4)
- [ ] Extended user onboarding (farm, binyard, truck details)
- [ ] Complete haul workflow implementation (7 phases)
- [ ] Haul session state machine
- [ ] Timer display with color coding
- [ ] Single favorite elevator selection

### Phase 2: Queue Intelligence (Weeks 5-8)
- [ ] Queue entry and position tracking
- [ ] Cross-validation between users
- [ ] Wait time calculation algorithm
- [ ] Real-time queue updates
- [ ] Notification system

### Phase 3: Analytics & Polish (Weeks 9-12)
- [ ] Personal analytics dashboard
- [ ] Daily summary generation
- [ ] Historical pattern analysis
- [ ] Performance optimization
- [ ] Production launch preparation

**See [GAP_ANALYSIS_AND_ROADMAP.md](docs/GAP_ANALYSIS_AND_ROADMAP.md) for detailed implementation plan**

## 🐛 Bug Reports

Use [GitHub Issues](https://github.com/Bushels/HaulPass/issues) with:
- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Environment details
- Screenshots if applicable

## 📚 Documentation

- [📖 Setup Guide](SETUP.md) - Detailed setup instructions
- [🎯 Vision & Specification](docs/HAULPASS_VISION_AND_SPECIFICATION.md) - Complete product vision and technical spec
- [📊 Gap Analysis & Roadmap](docs/GAP_ANALYSIS_AND_ROADMAP.md) - Implementation roadmap and priorities
- [🏗️ Architecture](docs/TECHNICAL_ARCHITECTURE.md) - System design
- [🔄 Data Flow](docs/DATA_FLOW_PRIVACY.md) - Data handling and privacy
- [👥 User Journey](docs/CUSTOMER_JOURNEY.md) - User experience flow

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for the backend-as-a-service platform
- Riverpod team for excellent state management
- GitHub for hosting and CI/CD capabilities

---

<div align="center">

**Built with ❤️ for the grain hauling industry**

[🌐 Live Demo](https://bushels.github.io/HaulPass) | [📧 Contact](mailto:support@haulpass.com)

</div>