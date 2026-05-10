# BizAI Assistant

A polished Flutter business assistant app designed for small businesses and entrepreneurs.

## Overview

**BizAI Assistant** combines AI-powered productivity tools, business insights, and modern mobile design to help users manage operations, generate content, and interact with customers.

The app includes:
- Secure authentication with email/password, Google sign-in, and Apple sign-in
- Onboarding and profile setup for first-time users
- AI-powered chat assistant for customer replies and business communication
- Content generation for social media posts, ads, and marketing copy
- Invoice creation with PDF export and invoice management
- A insights dashboard with business metrics, growth tips, and activity analytics
- Light/dark theme support and subscription-based premium features

## Key Features

### Authentication & Entry Flow
- Onboarding experience for new users
- Login and signup screens
- Firebase-backed authentication
- Setup screen to complete the user profile before entering the app

### Dashboard & Navigation
- Home dashboard with quick access to core business tools
- Bottom navigation for fast switching between Home, Content, Chat AI, Invoices, and Insights

### AI Chat Assistant
- Customer reply generator with selectable response tone
- Tracks free message usage and unlocks unlimited access for Pro users
- Focused on generating professional, business-safe replies

### Content Generation
- Generate social media posts, captions, and marketing messages
- Choose target platform and tone for the generated content
- Save drafts and store frequently used posts directly in the app

### Invoice Management
- Create professional invoices using client, item, and pricing details
- Store and review created invoices in-app
- Upgrade to Pro to remove invoice creation limits
- PDF export support for sharing invoices

### Insights & Analytics
- AI-driven business scorecards and growth suggestions
- Weekly activity visualization with charts
- Growth checklist and key business metrics
- Tips for improving engagement, visibility, and revenue

## Tech Stack

- Flutter
- Dart
- Firebase Core
- Firebase Authentication
- Google Sign-In
- Sign in with Apple
- Provider state management
- Google Generative AI
- Shared Preferences
- PDF generation and printing
- Flutter Animate for motion effects
- FL Chart for analytics visualization

## Platforms

- Android
- iOS
- Web
- Windows

## Setup & Run

1. Ensure Flutter is installed and configured.
2. Open the project in your IDE.
3. Add your Firebase configuration:
   - `google-services.json` for Android
   - `GoogleService-Info.plist` for iOS
4. Run dependencies:
   ```bash
   flutter pub get
   ```
5. Run the app:
   ```bash
   flutter run
   ```

## Notes

- The project includes Firebase initialization logic, but it requires your own Firebase keys/configuration for full backend support.
- If Firebase is not configured, the app falls back to demo mode for local preview and testing.
- Subscription and premium feature flows are included in the UI.

## Project Structure

- `lib/main.dart` — App entry point and route definitions
- `lib/features/` — Feature modules for auth, dashboard, content, chat assistant, invoices, insights, settings, subscription
- `lib/providers/` — App state management
- `lib/core/` — Shared theme, constants, and service utilities

## Contact

For demo or presentation questions, walk through the app by highlighting:
- AI productivity tools
- business workflow support
- modern UI and multi-platform capabilities
- Firebase-powered authentication flow
