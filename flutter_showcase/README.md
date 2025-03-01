# Flutter Showcase

An interactive and responsive Flutter showcase designed to replace static header images on your website. This project demonstrates Flutter's capabilities with animations, responsive design, and interactive elements that showcase your Flutter development expertise.

## Features

- **Responsive Design**: Automatically adapts to different screen sizes and orientations
- **Interactive Elements**: Mouse interactions, hover effects, and touch optimizations
- **Fancy Animations**: Beautiful animations and transitions throughout the experience
- **App Mockups**: Showcases different types of Flutter applications (E-commerce, Fitness, Banking, etc.)
- **Custom Graphics**: Interactive background with subtle animations
- **Easy to Embed**: Designed to be easily embedded in your website as an iframe

## How to Use

### Running the Project

1. Clone the repository
2. Navigate to the project directory
3. Run the following commands:

```bash
flutter pub get
flutter run -d chrome
```

### Building for Production

To build the project for production and embedding on your website:

```bash
flutter build web --release
```

The built files will be available in the `build/web` directory.

### Embedding on Your Website

Replace your current header image with this interactive Flutter showcase by adding an iframe:

```html
<iframe 
  src="path/to/flutter_showcase/build/web/index.html" 
  style="width: 100%; height: 500px; border: none; overflow: hidden;"
  scrolling="no"
  allowtransparency="true"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture">
</iframe>
```

#### Responsive Height

For a responsive height that adjusts to the screen size:

```html
<div style="position: relative; padding-bottom: 40%; height: 0; overflow: hidden;">
  <iframe 
    src="path/to/flutter_showcase/build/web/index.html" 
    style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: none;"
    scrolling="no"
    allowtransparency="true"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture">
  </iframe>
</div>
```

## Customization

You can customize the showcase by modifying the following files:

- `lib/showcase_app.dart`: Main layout and app structure
- `lib/models/showcase_item.dart`: Showcase item model
- `lib/widgets/interactive_background.dart`: Custom background animation
- `lib/widgets/app_showcase_item.dart`: Individual showcase item card
- `lib/widgets/floating_app_screen.dart`: App mockups that appear on hover/tap

## Credits

Created with Flutter 💙

## License

This project is open source under the MIT License.
