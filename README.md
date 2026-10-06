# NovaBank Mobile

The Flutter mobile client for **NovaBank**, a financial system built with a Spring Boot microservices backend. Users can register, manage their account, and send and receive money between accounts on the same system.

> **Note:** NovaBank is an educational / portfolio project. It is not intended for real financial use.

Backend repository: [Financial-system-Backend](https://github.com/NaelEbrahim/Financial-system-Backend)

## Features

* User registration with email OTP verification
* Login with JWT access and refresh tokens
* User profile management
* Account balance overview
* Send money to another account using the receiver's wallet key
* Transaction PIN verification for transfers
* Transaction history
* In-app notifications
* Mark notifications as read
* Delete notifications
* Update password
* Update email

## Screenshots

Add screenshots to the `screenshots/` folder and link them here.

| Login                           | Home                          | Send Money                                | Transaction History                             |
| ------------------------------- | ----------------------------- | ----------------------------------------- | ----------------------------------------------- |
| ![Login](screenshots/login.png) | ![Home](screenshots/home.png) | ![Send Money](screenshots/send-money.png) | ![Transaction History](screenshots/history.png) |

## Tech Stack

* Flutter
* Dart
* Dio (HTTP client)
* BLoC / Cubit (state management)

## Architecture

The app communicates only with the backend **API Gateway**, which validates JWT tokens and routes requests to the appropriate microservices.

```text
Flutter App
     |
     v
API Gateway
     |
     +----> Identity Service
     |
     +----> Account Service
     |
     +----> Transaction Service
     |
     +----> Notification Service
```

### Authentication Flow

```text
Login
  |
  v
Identity Service
  |
  +--> Access Token
  +--> Refresh Token
          |
          v
     Flutter App
          |
          +--> Dio interceptor adds access token
          |
          +--> On 401, refresh token is used
                    |
                    v
             New Access Token
```

## Getting Started

### Prerequisites

* Flutter SDK (stable channel)
* Android Studio or VS Code with the Flutter plugin
* An Android emulator, iOS simulator, or physical device
* NovaBank backend running locally

### 1. Clone the repository

```bash
git clone https://github.com/NaelEbrahim/Financial-system-Mobile.git
cd Financial-system-Mobile
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure the API Base URL

Set the base URL of the backend API Gateway in the application's network/constants configuration.

For example:

```dart
const String baseUrl = 'http://10.0.2.2:8222';
```

Use the appropriate address for your environment:

| Environment      | Base URL                             |
| ---------------- | ------------------------------------ |
| Android emulator | `http://10.0.2.2:8222`               |
| iOS simulator    | `http://localhost:8222`              |
| Physical device  | `http://<your-computer-LAN-IP>:8222` |

> `10.0.2.2` allows an Android emulator to access the host machine's `localhost`.

### 4. Run the application

```bash
flutter run
```

## Project Structure

```text
lib/
├── bloc/
├── models/
├── modules/
├── remote/
├── shared/
└── main.dart
```

The project uses a centralized `Manager` for application state and BLoC/Cubit-style state management.

## Backend Setup

The mobile application requires the NovaBank backend to be running.

Follow the setup instructions in the [backend repository](https://github.com/NaelEbrahim/Financial-system-Backend).

The backend requires:

1. Docker infrastructure
2. Config Server
3. Discovery Service
4. Identity Service
5. Account Service
6. Transaction Service
7. Notification Service
8. API Gateway

For local email verification, OTP emails can be viewed through **MailDev**.

## Configuration & Security

Sensitive files and credentials should never be committed to the repository.

Keep the following files local when applicable:

* `.env` files
* `android/key.properties`
* Android keystore files (`*.jks`, `*.keystore`)
* `google-services.json`
* `GoogleService-Info.plist`

## Development

Run tests:

```bash
flutter test
```

Analyze the code:

```bash
flutter analyze
```

Format the code:

```bash
dart format .
```

Build an Android APK:

```bash
flutter build apk
```

## Project Status

NovaBank Mobile is an ongoing **software engineering portfolio project** focused on:

* Flutter mobile development
* State management with BLoC / Cubit
* REST API integration with Dio
* JWT authentication and token refresh
* Form validation
* Pagination
* Pull-to-refresh
* Microservices integration

## License

This project is licensed under the **MIT License**.

See the [LICENSE](LICENSE) file for details.
