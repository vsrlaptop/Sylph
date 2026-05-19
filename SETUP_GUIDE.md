# Sylph Setup Guide 📖

Complete setup instructions for building and deploying the Sylph weather app.

## 📋 Prerequisites

- Flutter SDK 3.19.0+
- Dart 3.0+
- Android SDK (for APK builds)
- Git
- GitHub account

## 🔐 Step 1: Add API Keys to GitHub Secrets

### 1.1 Get API Keys

**OpenWeatherMap API:**
1. Go to https://openweathermap.org/api
2. Sign up for free account
3. Get your API key from Dashboard
4. Store safely (looks like: `fa736ae62b05126fda481140ce2f39ef`)

**WAQI API (Air Quality):**
1. Go to https://waqi.info/api
2. Sign up for free account
3. Get your API token
4. Store safely

### 1.2 Add to GitHub Secrets

1. Go to: **Repository → Settings → Secrets and variables → Actions**
2. Click: **New repository secret**
3. Add:
   - **Name:** `OWM_KEY`
   - **Secret:** `your_openweathermap_api_key`
4. Click: **Add secret**
5. Repeat for `WAQI_KEY`

✅ **Done!** Your secrets are now secure and used only during builds.

---

## 🎨 Step 2: Create App Icons

### 2.1 Design Icons

Create a 512×512 PNG image with:
- **Text:** "Sylph" in bold letters
- **Color:** `#c8f04e` (lime green)
- **Background:** `#0a0a0f` (very dark)
- **Style:** Modern, minimal

### 2.2 Generate App Icons

Place your icon at: `assets/icon/sylph.png`

Then run:
```bash
flutter pub run flutter_launcher_icons
```

This generates all required icon sizes for Android.

---

## 🖥️ Step 3: Local Development

### 3.1 Clone Repository

```bash
git clone https://github.com/vsrlaptop/Sylph.git
cd Sylph
```

### 3.2 Get Dependencies

```bash
flutter pub get
```

### 3.3 Run App

```bash
flutter run \
  --dart-define=OWM_KEY=your_api_key \
  --dart-define=WAQI_KEY=your_waqi_key
```

Replace with your actual API keys.

---

## 📦 Step 4: Build APK

### 4.1 Debug APK

```bash
flutter build apk --debug \
  --dart-define=OWM_KEY=your_api_key \
  --dart-define=WAQI_KEY=your_waqi_key
```

Output: `build/app/outputs/apk/debug/app-debug.apk`

### 4.2 Release APK

First, set up Android signing:

**Create keystore (one-time):**
```bash
keytool -genkey -v -keystore ~/.android/sylph.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias sylph
```

**Create `key.properties`:**

Create file at: `android/key.properties`

```properties
storeFile=/Users/YourUsername/.android/sylph.jks
storePassword=your_store_password
keyAlias=sylph
keyPassword=your_key_password
```

**Build Release APK:**

```bash
flutter build apk --release \
  --dart-define=OWM_KEY=your_api_key \
  --dart-define=WAQI_KEY=your_waqi_key
```

Output: `build/app/outputs/apk/release/app-release.apk`

---

## 🚀 Step 5: Release & Deploy

### 5.1 Create Version Tag

```bash
git tag v1.0.0
git push origin v1.0.0
```

### 5.2 GitHub Actions

GitHub Actions automatically:
1. Builds release APK
2. Creates GitHub Release
3. Uploads APK to release

**View workflow:** Go to **Actions** tab in your repository

### 5.3 Manual Release (Optional)

To manually create a release:

1. Go to **Releases** → **Create a new release**
2. **Tag:** `v1.0.0`
3. **Title:** `Version 1.0.0`
4. **Description:** Feature list, bug fixes, etc.
5. **Attach APK:** Upload the release APK
6. **Publish**

---

## 🔔 Step 6: Push Notifications Setup

Sylph uses **local notifications** (no server needed):

- Weather alerts (heat, cold, storms)
- Air quality warnings (unhealthy AQI)
- Daily reminders (8 AM by default)

**Android Permissions** are already configured.

**To test:**
```dart
import 'package:sylph/services/notification_service.dart';

final notificationService = NotificationService();
await notificationService.initializeNotifications();

// Show test alert
await notificationService.showWeatherAlert(
  city: 'Tokyo',
  condition: 'Heavy Rain',
  description: 'Severe weather expected',
);
```

---

## 📱 Step 7: Install & Test APK

### 7.1 Connect Android Device

```bash
adb devices
```

### 7.2 Install APK

```bash
adb install build/app/outputs/apk/release/app-release.apk
```

### 7.3 Test Features

- ✅ Search cities
- ✅ View weather data
- ✅ Check air quality
- ✅ Save home city
- ✅ Receive notifications
- ✅ Export/import data

---

## 📝 Pre-Release Checklist

- [ ] API keys added to GitHub Secrets
- [ ] App icons created & generated
- [ ] Version number updated in `pubspec.yaml`
- [ ] APK built and tested locally
- [ ] Release notes written
- [ ] Git tag created (`git tag vX.X.X`)
- [ ] Changes pushed to main
- [ ] GitHub Actions workflow completed
- [ ] Release APK uploaded

---

## 🛠️ Troubleshooting

### "API key not set" Error

**Solution:** Make sure to pass `--dart-define` flags:
```bash
flutter run \
  --dart-define=OWM_KEY=your_key \
  --dart-define=WAQI_KEY=your_key
```

### "City not found" Error

**Solution:** Check spelling, network connection, or try another city.

### APK Build Fails

**Solution:**
1. Run: `flutter clean`
2. Run: `flutter pub get`
3. Try building again

### Notifications Not Showing

**Solution:**
1. Check Android permissions in Settings
2. Make sure notifications are enabled for the app
3. Restart the app

### GitHub Actions Workflow Not Running

**Solution:**
1. Check secrets are added correctly
2. Verify branch name is `main`
3. Check workflow file at `.github/workflows/build_apk.yml`
4. View logs in **Actions** tab

---

## 📞 Support

- **Documentation:** Flutter Dev Docs
- **APIs:**
  - [OpenWeatherMap](https://openweathermap.org/api)
  - [WAQI](https://waqi.info/api)
- **Issues:** Open GitHub issues in the repository

---

## 🎉 You're Done!

Your Sylph app is ready for production! 🌤️

**Next steps:**
1. Customize colors/fonts as needed
2. Add more features (hourly forecast, etc.)
3. Submit to Google Play Store
4. Share with friends! 🚀
