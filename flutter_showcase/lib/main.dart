import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Import our custom logo painter
import 'painters/logo_painter.dart';

// Use deferred loading for showcase app to improve initial load time
import 'showcase_app.dart' deferred as showcase;

void main() {
  runApp(const FlutterShowcaseApp());
}

class FlutterShowcaseApp extends StatefulWidget {
  const FlutterShowcaseApp({super.key});

  @override
  State<FlutterShowcaseApp> createState() => _FlutterShowcaseAppState();
}

class _FlutterShowcaseAppState extends State<FlutterShowcaseApp> {
  bool _isShowcaseLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadShowcase();
  }

  Future<void> _loadShowcase() async {
    // Pre-cache material icons and system fonts while loading the showcase
    await Future.wait([
      showcase.loadLibrary(),
      _precacheAssets(),
    ]);

    if (mounted) {
      setState(() {
        _isShowcaseLoaded = true;
      });
    }
  }

  Future<void> _precacheAssets() async {
    // Simulate some pre-caching work to allow the UI to show a loading state
    // In a real app, you would precache actual assets here
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Präsentation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0553B1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child ?? const SizedBox.shrink(),
        breakpoints: [
          const Breakpoint(start: 0, end: 600, name: MOBILE),
          const Breakpoint(start: 601, end: 900, name: TABLET),
          const Breakpoint(start: 901, end: 1200, name: DESKTOP),
          const Breakpoint(start: 1201, end: double.infinity, name: '4K'),
        ],
      ),
      home: _isShowcaseLoaded ? showcase.ShowcaseApp() : _buildLoadingScreen(),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF0553B1).withAlpha(13),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom logo with pulsating animation
            const Center(
              child: AnimatedLogoWidget(size: 80),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.05, 1.05),
                )
                .then()
                .scale(
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(0.95, 0.95),
                ),
          ],
        ),
      ),
    );
  }
}
