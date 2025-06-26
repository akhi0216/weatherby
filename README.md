# Weatherby

Weatherby is a beautiful Flutter app that provides real-time weather updates and weather-related news for your city. It features a modern UI, hourly forecasts, and curated news based on current weather conditions.

## Features
- Search and view weather for any city
- Hourly weather forecast with icons
- Key weather metrics (temperature, wind, humidity, etc.)
- Weather-based news headlines and top stories
- Trending news and detailed news view
- Modern, responsive UI with gradients and cards

## Screenshots
<!-- Add your screenshots here -->

## Getting Started
1. **Clone the repository:**
   ```sh
   git clone https://github.com/akhi0216/weatherby.git
   cd weatherby
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Run the app:**
   ```sh
   flutter run
   ```

## Folder Structure
- `lib/`
  - `view/` — UI screens and widgets
  - `controller/` — State management (GetX controllers)
  - `model/` — Data models for weather and news
  - `services/` — API service classes
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/` — Platform-specific code

## Dependencies
- [Flutter](https://flutter.dev/)
- [get](https://pub.dev/packages/get) — State management
- [http](https://pub.dev/packages/http) — Networking

## API Keys
- Uses [OpenWeatherMap](https://openweathermap.org/api) for weather data
- Uses [NewsAPI](https://newsapi.org/) for news data
- Add your API keys in the respective service files if needed

## Credits
- UI inspired by modern weather and news apps
- Built with ❤️ using Flutter

---
Feel free to contribute or open issues for suggestions and improvements!
