# Flutter Showcase Development Guide

## Commands
- Setup: `flutter pub get`
- Run: `flutter run -d chrome`
- Build: `flutter build web --release`
- Lint: `flutter analyze`
- All tests: `flutter test`
- Single test: `flutter test test/widget_test.dart`
- Specific test: `flutter test --name="test name" test/widget_test.dart`

## Code Style
- Standard Flutter linting rules from `package:flutter_lints/flutter.yaml`
- Classes: PascalCase (ShowcaseApp)
- Variables/functions: camelCase (buildLayout)
- Private members: leading underscore (_controller)
- Files: snake_case (showcase_app.dart)
- Import order: Dart/Flutter, third-party, local
- Strong typing, required parameters, const widgets
- State: StatefulWidget pattern, proper controller lifecycle
- Responsive: dedicated methods for different screen sizes

## UI Layout
- Card-based layout with 2/3 and 1/3 sections
- Desktop: horizontal card split with left section (2/3) for app items, right section (1/3) for app preview
- Mobile: vertical card split with top section (2/3) for app items, bottom section (1/3) for app preview
- Left/top section: Light background with showcase items in a grid/list
- Right/bottom section: Slightly darker background for app screen preview
- Clean, modern card design with subtle shadows and rounded corners

## Project Structure
Main components in lib/models, lib/painters, lib/screens, lib/widgets