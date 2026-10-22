# Project README & Implementation Status: Library Management Flutter App

---

## 1. Project Overview & Architecture

This cross-platform **Flutter Mobile/Web Application** (`flutter_app/lib_mgmt`) serves as the frontend interface for the Laravel Library Management backend. It communicates securely via **Laravel Sanctum** token-based authentication and features a fully **dynamic, database-driven theme engine** that adapts its color presets, corner styles, font scales, and dark mode settings in real-time based on backend configurations.

### Architectural Layout & Directory Structure

```text
lib/
├── config/
│   └── api_config.dart          # Centralized API base URL configurations
├── screens/
│   ├── login_screen.dart        # Authentication & credential handling
│   ├── home_dashboard.dart      # Main dashboard with dynamic DB theme engine & system directories
│   ├── books.dart               # Books Catalog & Book Detail views (DB-themed, zero-shadow)
│   ├── authors.dart             # Authors Directory & Author Detail views (DB-themed, zero-shadow)
│   ├── lib_users.dart           # Library Users profile directory & detail views
│   └── transactions.dart        # Transaction logs, borrowing history & individual record views
└── services/
    ├── auth_services.dart       # Sanctum login, token storage, and logout handlers
    └── api_client.dart          # Automated Bearer token injection HTTP client wrapper

```

---

## 2. Implementation Progress

### What Is Done & Fully Functional ✅

1. **Authentication & Security (`Laravel Sanctum`)**:
* Complete login shell supporting user authentication against `POST /api/login`.
* Secure local token caching utilizing `flutter_secure_storage`.
* Automatic `Authorization: Bearer <token>` header injection across all protected routes via `ApiClient`.
* Session persistence check on app startup and clean logout routing.


2. **Dynamic DB-Driven Theme Engine**:
* The app fetches live styling rules from the `/settings` backend endpoint.
* Supports multiple theme presets (`ocean`, `emerald`, `sunset`, `slate`, `amber`, `cyber`), corner style radiuses (`smooth`, `sharp`, `pill`), font scaling, and dark/light modes seamlessly across screens.


3. **Core Feature Screens & Detail Views**:
* **Dashboard (`MyHomePage`)**: Central navigation hub with responsive grid cards matching backend presets.
* **Books Catalog (`BooksScreen` & `BookDetailScreen`)**: Full inventory listing, responsive multi-column layout, title metrics badge, zero-shadow cards (`elevation: 0`), and complete detail views.
* **Authors Directory (`AuthorsScreen` & `AuthorDetailScreen`)**: Browse author profiles, see counts of published works, and inspect individual author book records.
* **Library Users (`LibUsersScreen` & `LibUserDetailScreen`)**: Member management tracking active roles, fine histories, and donation logs.
* **Transactions Log (`TransactionsScreen` & `TransactionDetailScreen`)**: Borrowing activities, return statuses, date tracking, and fine calculation breakdowns.



---

### What Is Not Done / Future Enhancements 🛠️

1. **Write Operations / Forms**:
* Currently, the app handles read-only views and authentication. Adding new books, registering new library users, or creating manual borrowing transactions from the mobile UI is pending.


2. **Advanced Search & Filtering**:
* Real-time text search bars and dropdown filters for sorting books, authors, or transaction logs by date/status have not yet been wired up.


3. **Cross-Platform Network Adjustments**:
* While Android emulator configuration uses `10.0.2.2`, testing on Chrome or physical devices requires manual local IP configurations (`localhost` or local network IP).
