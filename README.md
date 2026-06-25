# 📰 News App

### Stay informed with real-time news from around the world

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Android](https://img.shields.io/badge/Android-API%2021+-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://android.com)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](LICENSE)

[⬇️ Download APK](https://github.com/Umair-Habibx123/news_app/releases/download/v1.1/news_app.apk) • [🐛 Report Bug](https://github.com/Umair-Habibx123/news_app/issues) • [✨ Request Feature](https://github.com/Umair-Habibx123/news_app/issues)

</div>

---

## 📖 About

A Flutter application that allows users to browse the latest news articles from various categories using the [News API](https://newsapi.org/). The app fetches real-time news articles and displays them with images, titles, dates, and sources in a clean, intuitive interface.

---

## ✨ Features

- 🔴 **Real-time News** — Latest headlines from multiple trusted sources
- 🗂️ **Category Filtering** — Browse by Technology, Health, Sports, Business, and more
- 🔍 **Search** — Find articles by keyword instantly
- 🖼️ **Rich Article Cards** — Images, titles, source names, and publication dates
- 📱 **Clean UI** — Smooth, mobile-first design built with Flutter

---

## 📲 Download

> **Latest Version: v1.1**

| Platform | Download |
|---|---|
| Android (APK) | [⬇️ Download APK](https://github.com/Umair-Habibx123/news_app/releases/download/v1.1/news_app.apk) |

> ℹ️ Enable **"Install from Unknown Sources"** in Android settings before installing.

All releases → [GitHub Releases](https://github.com/Umair-Habibx123/news_app/releases)

---

## 🛠️ Built With

- [Flutter](https://flutter.dev/) — UI framework
- [Dart](https://dart.dev/) — Programming language
- [News API](https://newsapi.org/) — News data source
- [HTTP](https://pub.dev/packages/http) — API requests

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x or higher)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- Android device or emulator (API 21+)
- [News API Key](https://newsapi.org/) (free)

Check your Flutter setup:
```bash
flutter doctor
```

---

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/Umair-Habibx123/news_app
cd news_app
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Add your API key**

Visit [newsapi.org](https://newsapi.org/) and sign up for a free API key. Then open:

```
lib/services/NewsProviderApi.dart
```

And replace the placeholder:
```dart
const String apiKey = 'YOUR_API_KEY_HERE';
```

**4. Run the app**
```bash
# List connected devices
flutter devices

# Run on your device
flutter run -d <device_id>
```

---

## 📱 Running on a Physical Android Device

1. Enable **Developer Options** on your phone (tap *Build Number* 7 times in Settings → About Phone)
2. Enable **USB Debugging** in Developer Options
3. Connect via USB cable and tap **Allow** on the popup
4. Verify connection:
```bash
adb devices
```
5. Run:
```bash
flutter run
```

---

## 📦 Build APK

```bash
# Debug build (for testing)
flutter build apk --debug

# Release build (for distribution)
flutter build apk --release
```

Output:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 📁 Project Structure

```
news_app/
├── lib/
│   ├── main.dart               # App entry point
│   ├── models/                 # Data models
│   ├── screens/                # UI screens
│   ├── services/               # API & business logic
│   │   └── NewsProviderApi.dart
│   └── widgets/                # Reusable widgets
├── android/                    # Android-specific files
├── assets/                     # Images, fonts, etc.
└── pubspec.yaml                # Dependencies & metadata
```

---

## 🌐 API Reference

This app uses the [News API](https://newsapi.org/).

| Endpoint | Description |
|---|---|
| `/v2/top-headlines` | Fetch top headlines by category/country |
| `/v2/everything` | Search all articles by keyword |

**Free tier limits:** 100 requests/day · Development use only

> ⚠️ News API free tier does not allow production/published apps. Upgrade to a paid plan for Play Store distribution.

---

## 🤝 Contributing

Contributions are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 🐛 Issues

Found a bug or have a suggestion? [Open an issue](https://github.com/Umair-Habibx123/news_app/issues)

---

## 📄 License

This project is open-source under the **MIT License**. See the [LICENSE](LICENSE) file for details.