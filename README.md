# Drizzle Weather

Drizzle is a Flutter weather app for mobile and web. Search for a city, use your current location, check current conditions, and view a five-day forecast. Weather data comes from OpenWeather.

## What you need

- Flutter installed and available in your terminal
- An OpenWeather API key
- A browser or a configured mobile device or emulator

## Run locally

From the project folder, create your local environment file:

```powershell
Copy-Item .env.example .env
```

Open `.env` and replace the placeholder with your key:

```dotenv
OPENWEATHER_API_KEY=your_actual_key
```

Then install the dependencies and run the app:

```powershell
flutter pub get
flutter run
```

To run it specifically in Chrome, use `flutter run -d chrome`. The current-location feature asks for location permission when you use it.

`.env` is ignored by Git. Commit `.env.example` as the template, but keep your real key in your local `.env` file.

## Project layout

| Path | Purpose |
| --- | --- |
| `lib/features/` | Search, current weather, forecast, and their view models and widgets |
| `lib/features/weather_repository/` | Requests weather and geocoding data from OpenWeather |
| `lib/data/` | HTTP service, responses, and API errors |
| `lib/core/` | Shared configuration and location service |
| `lib/resources/` | App strings, colors, assets, and API URLs |
| `lib/utils/routes/` | App routes and screen setup |
| `test/` | Repository tests |

The app uses `provider` for screen state and `flutter_dotenv` to load the API key at startup.

## Check the project

```powershell
flutter analyze
flutter test
```

## Build for web

```powershell
flutter build web --release
```

The build is written to `build/web`. The Vercel configuration in `web/vercel.json` is copied into the build and provides route fallback for the web app.

To deploy the generated site with the Vercel CLI:

```powershell
npx vercel --cwd build/web
npx vercel --cwd build/web --prod
```

The first command creates a preview deployment. The second deploys to production.

**Web API key note:** Flutter web bundles `.env` into files sent to the browser. People can inspect the OpenWeather key in a web build. Use a key with appropriate provider restrictions and do not treat it as a private server secret.
