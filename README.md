# NASA APOD

## About the Project

**nasa_apod** is a test task utilizing the [NASA Astronomy Picture of the Day (APOD)](https://api.nasa.gov/) API. The app is built with scalability in mind, providing a foundation for future improvements. The UI is implemented in a minimalistic way, focusing on meeting the requirements.

## Tech Stack

- **State Management:** [Riverpod](https://riverpod.dev/) (Not used for dependency injection)
- **Dependency Injection:** [GetIt](https://pub.dev/packages/get_it)
- **Networking:** [Retrofit](https://pub.dev/packages/retrofit) with [Dio](https://pub.dev/packages/dio)
- **Navigation:** [Go Router](https://pub.dev/packages/go_router)
- **Code Generation:** Heavily utilized
- **Testing:** AI-generated tests that work fine
- **Additional Libraries:** The stack contains more small libraries that are not explicitly mentioned.

## Features

- Fetches and displays NASA's Astronomy Picture of the Day
- Modular architecture allowing future growth
- Simple UI for initial implementation

## Future Enhancements

- **iOS Setup:** App tested only on Android for now, need to check iOS build.
- **Localization (l10n):** Move hardcoded texts to a separate file or setup internationalization.
- **Improved Design:** Enhance UI and implement a consistent theme, setup system assets.
- **Stricter Linting Rules:** Ensure code quality and best practices are enforced.
- **Stricter access setup:** Disable access to some code from other parts of the app.
