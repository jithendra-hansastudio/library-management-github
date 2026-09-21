# Library Management System - Technical Context & Notes for AI

## 1. Project Overview & Objective
This repository (`library-management-github`) is a **Full-Stack Library Management System**. 
The application provides complete library operations including member management, author & book cataloging, book borrowing/checkout transactions, member book donations, idle copy inventory tracking, and dynamic overdue fine calculation.

---

## 2. Technology Stack
* **Backend Framework**: Laravel 12 (PHP 8.4)
* **Database**: MariaDB / MySQL using Laravel Eloquent ORM
* **Containerization**: Docker & Docker Compose (`app` PHP-FPM 8.4, `web` Nginx, `mariadb`)
* **Web Frontend**: Vue 3 + Inertia.js (with Shadcn/Vue components) & Blade templates
* **Mobile Frontend**: Flutter (`flutter_app/lib_mgmt`) cross-platform mobile/web application consuming Laravel REST APIs
* **Testing Framework**: Pest & PHPUnit
* **Development Environment**: Laravel Herd / Docker Desktop on Windows

---

## 3. Database Schema & Eloquent Relationships

| Model | Relationship | Relation Type | Target Model | Description |
|---|---|---|---|---|
| **`LibUser`** | `transactions()` | `hasMany` | `Transaction` | Library member's borrowing records |
| | `donations()` | `hasMany` | `Donation` | Books donated by the member |
| **`Author`** | `books()` | `hasMany` | `Book` | Books authored by this person |
| **`Book`** | `author()` | `belongsTo` | `Author` | The author of the book |
| | `transactions()` | `hasMany` | `Transaction` | Historical & active borrow records |
| | `idleCopy()` / `extraCopies()` | `hasOne` / `hasMany` | `ExtraCopy` | Inventory copy tracking |
| **`Transaction`**| `user()` | `belongsTo` | `LibUser` | Member who borrowed the book |
| | `book()` | `belongsTo` | `Book` | The borrowed book |
| **`Donation`** | `user()` | `belongsTo` | `LibUser` | Donor member details |
| **`ExtraCopy`** | `book()` | `belongsTo` | `Book` | Parent book details |

---

## 4. Current Existing Features

1. **Member Management (`LibUser`, `LibusersController`)**
   * Member creation, listing, and profile viewing.
   * RESTful endpoints (`GET /api/users`, `POST /api/users`) and Web routes.

2. **Author Cataloging (`Author`, `AuthorController`)**
   * Author metadata management linked to written books (`Author hasMany Book`).
   * Endpoint `GET /api/authors-with-books` to retrieve authors nested with their books.

3. **Book Management (`Book`, `BooksController`)**
   * Catalog creation, listing, and details (`Book belongsTo Author`).
   * Integration with idle copy inventory tracking.

4. **Circulation & Transaction Tracking (`Transaction`, `TransactionsController`)**
   * Checkout/borrow transaction creation with automatically assigned 14-day return window.
   * **Dynamic Overdue Fine Calculation**: On-the-fly calculation of overdue fines (₹10/day) in `TransactionsController::api_index()` based on overdue days without altering database state.

5. **Book Donation System (`Donation`, `DonorsController`)**
   * Tracking book donations made by library members.

6. **Extra / Idle Copies Management (`ExtraCopy`, `ExtracopiesController`)**
   * Inventory tracking for extra book copies.

7. **Code Quality & Documentation**
   * **Comprehensive Doc Blocks**: Complete PHPDoc blocks added across all Models (`Book`, `Author`, `Transaction`, `LibUser`, `Donation`, `ExtraCopy`) and Controllers detailing parameter types, return values, and function descriptions.
   * **Automated Unit & Relationship Testing**: Pest test suite (`tests/Unit/`) verifying Eloquent model relationships, database constraints, and API responses.

8. **Multi-Platform Frontend Integrations**
   * Blade & Vue 3 + Inertia web interface.
   * Flutter app frontend structure (`flutter_app/lib_mgmt`) designed to interface with Laravel REST APIs.

---

## 5. Planned & Future Architecture Features

1. **Concurrency-Safe Checkout**: Pessimistic database row locking (`lockForUpdate()`) to prevent race conditions during book borrowing.
2. **Real-Time Book Reservations**: FIFO waitlist queue with automated 48-hour hold windows on returned books.
3. **Automated Notification Engine**: Queued background jobs (Laravel Queues + FCM push notifications) for due date reminders (3 days prior) and overdue alerts.
4. **Role-Based Access Control (RBAC)**: Permissions (Admin, Librarian, Member) via Laravel Policies & Middleware.


---

## 6. Key Configuration Files & Entry Points
* Backend API Routes: [`routes/api.php`](file:///c:/Users/geniu/Herd/newphpproj/routes/api.php)
* Backend Web Routes: [`routes/web.php`](file:///c:/Users/geniu/Herd/newphpproj/routes/web.php)
* Docker Setup & Cheatsheet: [`readME_guide.md`](file:///c:/Users/geniu/Herd/newphpproj/readME_guide.md)
* Eloquent Map: [`toBeRead.md`](file:///c:/Users/geniu/Herd/newphpproj/toBeRead.md)
* Flutter Entrypoint: [`flutter_app/lib_mgmt/lib/main.dart`](file:///c:/Users/geniu/Herd/newphpproj/flutter_app/lib_mgmt/lib/main.dart)
