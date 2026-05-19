# Sylph — Weather & Air 🌤️

Beautiful, fast weather and air quality app built with Flutter.

## ✨ Features

- 🌡️ **Real-time Weather** - Current conditions, feels like, humidity, wind, pressure
- 💨 **Air Quality Index** - AQI monitoring with detailed pollutant breakdowns
- 📍 **Location Search** - Search any city worldwide
- 🔔 **Push Notifications** - Weather alerts and AQI warnings
- 📊 **Local History** - Track searched cities with timestamps
- ⚙️ **Personalization** - Name, home city, temperature units (°C/°F)
- 🌙 **Dark Theme** - Modern dark UI with accent colors
- 📱 **Responsive Design** - Optimized for all screen sizes

## 🛠️ Tech Stack

- **Framework**: Flutter 3.19.0 (Dart 3.0+)
- **State Management**: StatefulWidget
- **APIs**:
  - OpenWeatherMap API (weather data)
  - WAQI API (air quality data)
- **Firebase**: Cloud Messaging (push notifications)
- **Local Storage**: SharedPreferences
- **UI**: Material Design 3
- **Fonts**: Google Fonts + Boldonse

## 🚀 Quick Start

### 1. Clone & Setup

```bash
git clone https://github.com/vsrlaptop/Sylph.git
cd Sylph
flutter pub get
```

### 2. Add API Keys

Create environment variables or use GitHub Secrets:

```bash
flutter run \
  --dart-define=OWM_KEY=your_openweathermap_key \
  --dart-define=WAQI_KEY=your_waqi_key
```

### 3. Configure Firebase (for notifications)

1. Download `google-services.json` from Firebase Console
2. Place at: `android/app/google-services.json`

### 4. Generate App Icons

```bash
flutter pub run flutter_launcher_icons
```

### 5. Run

```bash
flutter run
```

## 📦 Build APK

### Debug Build:

```bash
flutter build apk --debug \
  --dart-define=OWM_KEY=your_key \
  --dart-define=WAQI_KEY=your_key
```

### Release Build:

```bash
flutter build apk --release \
  --dart-define=OWM_KEY=your_key \
  --dart-define=WAQI_KEY=your_key
```

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed instructions.

## 📁 Project Structure

```
lib/
├── main.dart                    # Main app entry & weather UI
├── services/
│   ├── network_service.dart     # API calls (weather, AQI)
│   └── notification_service.dart # Firebase Cloud Messaging
assets/
├── icon/                        # App icons
└── fonts/                       # Custom fonts
android/
├── app/                         # Android build config
└── google-services.json         # Firebase config
```

## 🎨 Design System

**Color Palette:**
- Primary: `#c8f04e` (Lime)
- Secondary: `#4ecbf0` (Cyan)
- Background: `#0a0a0f` (Very Dark)
- Surface: `#111118` (Dark)
- Text: `#f0ede8` (Light)

**Typography:**
- Display: Boldonse (custom, 24-48px)
- Body: DM Sans (14-16px)
- Label: DM Sans (10-12px)

## 🔐 Security

- API keys never hardcoded
- Secrets stored in GitHub (injected at build time)
- Firebase credentials in `.gitignore`
- No sensitive data in SharedPreferences

## 📊 Data Models

- **WeatherData**: Current weather conditions
- **AQIData**: Air quality index & pollutants
- **HistoryItem**: Searched cities with metadata

## 🤝 Contributing

1. Fork the repo
2. Create feature branch: `git checkout -b feature/name`
3. Commit changes: `git commit -m 'Add feature'`
4. Push: `git push origin feature/name`
5. Open PR

## 📝 License

MIT License - See LICENSE file

## 👨‍💻 Author

Made by Vijayarka

## 📞 Support

- Documentation: See [SETUP_GUIDE.md](SETUP_GUIDE.md)
- Issues: Open GitHub issues
- API Docs: 
  - [OpenWeatherMap](https://openweathermap.org/api)
  - [WAQI](https://waqi.info/api)
  - [Firebase](https://firebase.flutter.dev)

---

**Sylph** brings you real-time weather and air quality data with a beautiful, intuitive interface. 🌍✨
