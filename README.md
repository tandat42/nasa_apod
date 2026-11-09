# NASA APOD

## About the Project

**nasa_apod** is a test task that shows NASA's Astronomy Picture of the Day (APOD). Entries are fetched from the NASA
Science WordPress API at `https://science.nasa.gov/wp-json/wp/v2/apod-basic` (see
`lib/core/resolvers/api_resolver.dart`). The app is built with scalability in mind, providing a foundation for future
improvements. The UI is implemented in a minimalistic way, focusing on meeting the requirements.

## Supported Platforms

- Android
- iOS
- Web

## Getting Started

A fresh clone won't build as-is: `.env` and all generated files (`*.g.dart`, `*.config.dart`) are git-ignored.

1. Install dependencies:

   ```sh
   flutter pub get
   ```

2. Create the env file and set your API key (get one at [api.nasa.gov](https://api.nasa.gov/)). The key is sent as the
   `api_key` query parameter on every request.

   ```sh
   cp .env.example .env
   # then edit .env and set NASA_API_KEY=<your key>
   ```

3. Generate code (Retrofit, Injectable, Envied, etc.). Re-run this whenever `.env` or annotated classes change:

   ```sh
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:

   ```sh
   flutter run
   ```

## Web Demo

The project is deployed to GitHub Pages:
**[tandat42.github.io/nasa_apod/build/web](https://tandat42.github.io/nasa_apod/build/web/)**.

For fast deploy, the `build/web` folder is committed to the repo (it is explicitly un-ignored in `.gitignore`), and
GitHub Pages serves it directly from the branch. To update the deployment, rebuild and commit the output:

```sh
flutter build web --release --base-href /nasa_apod/build/web/
git add build/web && git commit -m "Update web build" && git push
```

## Tech Stack

- **State Management:** [Riverpod](https://riverpod.dev/) (Not used for dependency injection)
- **Dependency Injection:** [GetIt](https://pub.dev/packages/get_it)
- **Networking:** [Retrofit](https://pub.dev/packages/retrofit) with [Dio](https://pub.dev/packages/dio)
- **Navigation:** [Go Router](https://pub.dev/packages/go_router)
- **Code Generation:** [Build Runner](https://pub.dev/packages/build_runner)
- **Testing:** AI-generated tests that work fine
- **Linting:** [very_good_analysis](https://pub.dev/packages/very_good_analysis)
- **Additional Libraries:** The stack contains more small libraries that are not explicitly mentioned.

## Features

- Fetches and displays NASA's Astronomy Picture of the Day
- Modular architecture allowing future growth
- Simple UI for initial implementation

## Future Enhancements

- **iOS Setup:** Complete iOS setup to run on a real device.
- **Localization (l10n):** Move hardcoded texts to a separate file or setup internationalization.
- **Improved Design:** Enhance UI and implement a consistent theme, setup system assets.
