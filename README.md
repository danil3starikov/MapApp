# MapApp

## ⚙️ Setup & Installation

**1. Clone the repository:**

```bash
git clone https://github.com/danil3starikov/MapApp.git
cd MapApp
```

**2. Install dependencies:**

```bash
flutter pub get
```

**3. Generate Database Code:**

```bash
dart run build_runner build
```

-----

## 🔑 Running the App

You must provide your Google Maps API Key when running the app.

### Mac (Terminal)

**1. Export your API key as an environment variable:**

```bash
export MAPS_API_KEY=your_actual_api_key_here
```

**2. Run the app passing the key:**

```bash
flutter run --dart-define=MAPS_API_KEY=$MAPS_API_KEY
```

## ⚠️ Important Note

Ensure your Google Cloud Console project has the following APIs enabled:

- Maps SDK for Android
- Maps SDK for iOS
- Places API


