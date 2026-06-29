# SkinSync Admin Panel 🏥

SkinSync Admin is a robust, cross-platform administrative dashboard built with Flutter. It serves as the central hub for managing the SkinSync ecosystem, providing clinic administrators with tools for patient oversight, treatment protocol management, staff coordination, and financial analytics.

## 🚀 Key Features


-   **Comprehensive Dashboard**: Real-time analytics and insights using interactive charts (Syncfusion & FL Chart).
-   **Patient & User Management**: Full CRUD operations for patient profiles and system users.
-   **Clinic & Staff Administration**: Manage multiple clinic locations, staff roles, and permissions.
-   **Treatment & Product Protocols**: Define and manage skin treatments, protocols, and inventory.
-   **Financial Oversight**: Track payments, manage disputes, and view transaction histories.
-   **Push Notifications**: Centralized interface for sending and managing system-wide notifications.
-   **Advanced Security**: 
    -   Two-Factor Authentication (2FA).
    -   Biometric local authentication.
    -   Secure storage for sensitive credentials.
-   **Responsive Design**: Optimized for Mobile, Tablet, Desktop, and 4K displays using `ResponsiveFramework`.

## 🛠 Tech Stack

-   **Framework**: [Flutter](https://flutter.dev/) (SDK ^3.10.4)
-   **State Management**: [Riverpod](https://riverpod.dev/) (Functional & Reactive)
-   **Architecture**: MVVM (Model-View-ViewModel) with Repository pattern.
-   **Dependency Injection**: [Get_it](https://pub.dev/packages/get_it) (Service Locator).
-   **Navigation**: [GoRouter](https://pub.dev/packages/go_router) (Declarative routing).
-   **Backend**: [Firebase](https://firebase.google.com/) (Core, Auth).
-   **UI/UX**: 
    -   `flutter_screenutil` for pixel-perfect scaling.
    -   `responsive_framework` for adaptive layouts.
    -   `Geist` font family.
    -   `flutter_glass_morphism` for modern aesthetics.
-   **Utilities**: `flutter_easyloading`, `shimmer` for loading states.

## 📁 Project Structure

```text
lib/
├── models/             # Data entities and API response models
├── repositories/       # Abstracted data fetching logic
├── services/           # External API & Firebase service integrations
├── view_models/        # Business logic and UI state (Riverpod)
├── screens/            # UI Layer
│   ├── bottom_nav/     # Core dashboard screens (Home, Patients, etc.)
│   └── auth/           # Login, Signup, 2FA, Password recovery
├── widgets/            # Reusable Atomic UI components
├── utils/              # Themes, Colors, Constants, and Helpers
├── app_init.dart       # App-wide configuration (Loading, Responsive)
├── route_generator.dart # Centralized GoRouter config
└── firebase_options.dart# Auto-generated Firebase configuration
```

## 🏗 Setup & Installation

### Prerequisites
-   Flutter SDK: `^3.10.4`
-   Dart SDK: `^3.x`
-   Android Studio / VS Code with Flutter extensions.

### Installation Steps

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/waleedaahmedd/skinsync_admin.git
    cd skinsync_admin
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Firebase Configuration:**
    -   Ensure `firebase-tools` is installed.
    -   Run `flutterfire configure` to update `firebase_options.dart`.
    -   Place `google-services.json` in `android/app/` and `GoogleService-Info.plist` in `ios/Runner/`.

4.  **Environment Setup:**
    -   The app uses a service locator (`locator.dart`) for dependency injection. Ensure all services are registered in the `initializeServices()` function.

5.  **Run the application:**
    ```bash
    flutter run -d chrome  # For Web
    flutter run            # For Mobile/Desktop
    ```

## 🌐 Deployment (CI/CD)

The project uses GitHub Actions for automated deployment to **Vercel**.

-   **Trigger**: Any push to the `staging` branch.
-   **Secrets Required**: 
    -   `VERCEL_TOKEN`: Your Vercel account token.
    -   `VERCEL_ORG_ID`: Vercel Organization ID.
    -   `VERCEL_PROJECT_ID`: Vercel Project ID.
-   **Build Command**: `flutter build web --release --no-tree-shake-icons`

## 🛡 Security & Best Practices

-   **Token Handling**: Uses `flutter_secure_storage` for persistence.
-   **Input Validation**: `pinput` for OTP and custom validators for forms.
-   **Error Handling**: Centralized `api_base_helper.dart` for handling HTTP exceptions.

## 📄 License

© 2024 SkinSync. All rights reserved. 
This project is proprietary. Unauthorized distribution or reproduction is strictly prohibited.

---
Built with ❤️ by the SkinSync Team.
