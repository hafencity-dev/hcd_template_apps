import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

import '../models/showcase_item.dart';

class MusicAppScreen extends StatefulWidget {
  final ShowcaseItem showcaseItem;

  const MusicAppScreen({
    super.key,
    required this.showcaseItem,
  });

  @override
  State<MusicAppScreen> createState() => _MusicAppScreenState();
}

class _MusicAppScreenState extends State<MusicAppScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  
  // Track state variables
  bool _isPlaying = false;
  int _currentTrackIndex = 0;
  double _currentPlaybackPosition = 0.3;
  bool _isShuffle = false;
  bool _isRepeat = false;
  bool _isFavorite = false;
  
  // Define mock data for the music app
  final List<Map<String, dynamic>> _tracks = [
    {'title': 'Summer Vibes', 'artist': 'Cosmic Waves', 'duration': '3:45', 'color': Colors.orange},
    {'title': 'Midnight Groove', 'artist': 'Electric Pulse', 'duration': '4:20', 'color': Colors.blue},
    {'title': 'Urban Dreams', 'artist': 'The Soundscapers', 'duration': '3:15', 'color': Colors.green},
    {'title': 'Digital Sunset', 'artist': 'Neon Horizon', 'duration': '4:05', 'color': Colors.purple},
    {'title': 'Acoustic Journey', 'artist': 'The Travelers', 'duration': '3:58', 'color': Colors.red},
  ];
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF121212),
      child: SafeArea(
        child: Column(
          children: [
            // App bar
            _buildAppBar(),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Cover section with player
                    _buildMusicPlayer(),
                    
                    // Playlist section
                    _buildPlaylist(),
                  ],
                ),
              ),
            ),
            
            // Mini player at bottom
            _buildMiniPlayer(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu button
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 16,
            ),
          ).animate()
            .fadeIn(duration: 300.ms)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 300.ms),
          
          // Title
          const Text(
            'SPIELT JETZT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ).animate()
            .fadeIn(duration: 400.ms, delay: 100.ms)
            .moveY(begin: -10, end: 0, duration: 400.ms, delay: 100.ms),
          
          // Options button
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 16,
            ),
          ).animate()
            .fadeIn(duration: 300.ms, delay: 200.ms)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 300.ms, delay: 200.ms),
        ],
      ),
    );
  }
  
  Widget _buildMusicPlayer() {
    final currentTrack = _tracks[_currentTrackIndex];
    final trackColor = currentTrack['color'] as Color;
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Album art with rotation
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              // Only rotate if playing
              final rotationValue = _isPlaying 
                  ? _animationController.value * 2 * math.pi
                  : 0.0;
              
              return Transform.rotate(
                angle: rotationValue,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      // Outer glow that pulsates with music
                      BoxShadow(
                        color: trackColor.withOpacity(_isPlaying ? 0.5 : 0.3),
                        blurRadius: _isPlaying ? 
                          30 + (math.sin(_animationController.value * math.pi * 2) * 10) : 
                          30,
                        spreadRadius: _isPlaying ? 
                          5 + (math.sin(_animationController.value * math.pi * 2) * 2) : 
                          5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    gradient: SweepGradient(
                      center: Alignment.center,
                      startAngle: 0,
                      endAngle: math.pi * 2,
                      colors: [
                        trackColor.withOpacity(0.9),
                        trackColor.withOpacity(0.7),
                        trackColor.withOpacity(0.8),
                        trackColor.withOpacity(0.6),
                        trackColor.withOpacity(0.9),
                      ],
                      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                      transform: GradientRotation(_animationController.value * math.pi * 2),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white24,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.music_note,
                          color: Colors.white.withOpacity(0.8),
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ).animate()
            .fadeIn(duration: 800.ms)
            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 800.ms),
          
          const SizedBox(height: 32),
          
          // Track info
          Column(
            children: [
              Text(
                currentTrack['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ).animate()
                .fadeIn(duration: 600.ms, delay: 300.ms)
                .moveY(begin: 10, end: 0, duration: 600.ms, delay: 300.ms),
              
              const SizedBox(height: 8),
              
              Text(
                currentTrack['artist'],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ).animate()
                .fadeIn(duration: 600.ms, delay: 400.ms)
                .moveY(begin: 10, end: 0, duration: 600.ms, delay: 400.ms),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Progress bar
          Column(
            children: [
              // Animated music visualizer
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Hero(
                    tag: 'music_visualizer',
                    flightShuttleBuilder: (
                      BuildContext flightContext,
                      Animation<double> animation,
                      HeroFlightDirection flightDirection,
                      BuildContext fromHeroContext,
                      BuildContext toHeroContext,
                    ) {
                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, _) {
                          return CustomPaint(
                            painter: MusicVisualizerPainter(
                              trackColor, 
                              _animationController.value,
                              _isPlaying,
                            ),
                            size: const Size(double.infinity, 40),
                          );
                        },
                      );
                    },
                    child: SizedBox(
                      height: 40,
                      child: CustomPaint(
                        painter: MusicVisualizerPainter(
                          trackColor, 
                          _animationController.value,
                          _isPlaying,
                        ),
                        size: const Size(double.infinity, 40),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 8),
              
              // Progress slider
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                  activeTrackColor: trackColor,
                  inactiveTrackColor: Colors.white.withOpacity(0.2),
                  thumbColor: Colors.white,
                  overlayColor: trackColor.withOpacity(0.2),
                ),
                child: Slider(
                  value: _currentPlaybackPosition,
                  onChanged: (value) {
                    setState(() {
                      _currentPlaybackPosition = value;
                    });
                  },
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 500.ms),
              
              // Time indicators
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1:08',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      currentTrack['duration'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 600.ms),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Shuffle button
              IconButton(
                icon: Icon(
                  Icons.shuffle,
                  color: _isShuffle ? trackColor : Colors.white.withOpacity(0.6),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isShuffle = !_isShuffle;
                  });
                },
              ).animate()
                .fadeIn(duration: 400.ms, delay: 700.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 400.ms, delay: 700.ms),
              
              // Previous button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentTrackIndex = (_currentTrackIndex - 1) % _tracks.length;
                      if (_currentTrackIndex < 0) _currentTrackIndex = _tracks.length - 1;
                    });
                  },
                ),
              ).animate()
                .fadeIn(duration: 400.ms, delay: 800.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 400.ms, delay: 800.ms),
              
              // Play/Pause button
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      trackColor,
                      trackColor.withOpacity(0.7),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: trackColor.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                      if (_isPlaying) {
                        _animationController.repeat();
                      } else {
                        // For smoother pause, don't abruptly stop
                        _animationController.animateTo(
                          _animationController.value + 0.1, 
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        ).then((_) => _animationController.stop());
                      }
                    });
                  },
                ),
              ).animate()
                .fadeIn(duration: 400.ms, delay: 900.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 400.ms, delay: 900.ms)
                .then()
                .shimmer(delay: 1200.ms, duration: 1200.ms),
              
              // Next button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentTrackIndex = (_currentTrackIndex + 1) % _tracks.length;
                    });
                  },
                ),
              ).animate()
                .fadeIn(duration: 400.ms, delay: 1000.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 400.ms, delay: 1000.ms),
              
              // Repeat button
              IconButton(
                icon: Icon(
                  Icons.repeat,
                  color: _isRepeat ? trackColor : Colors.white.withOpacity(0.6),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isRepeat = !_isRepeat;
                  });
                },
              ).animate()
                .fadeIn(duration: 400.ms, delay: 1100.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 400.ms, delay: 1100.ms),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Like and Add buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.white.withOpacity(0.6),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
              ).animate(
                onPlay: (controller) => controller.repeat(reverse: true, period: 2000.ms),
              )
                .fadeIn(duration: 400.ms, delay: 1200.ms)
                .scale(
                  begin: const Offset(0.8, 0.8), 
                  end: const Offset(1, 1), 
                  duration: 400.ms, 
                  delay: 1200.ms,
                )
                .then()
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 300.ms,
                  curve: Curves.easeIn,
                )
                .then(delay: 300.ms)
                .scale(
                  begin: const Offset(1.1, 1.1),
                  end: const Offset(1, 1),
                  duration: 300.ms,
                  curve: Curves.easeOut,
                ),
              
              const SizedBox(width: 32),
              
              Icon(
                Icons.playlist_add,
                color: Colors.white.withOpacity(0.6),
                size: 20,
              ).animate()
                .fadeIn(duration: 400.ms, delay: 1300.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 400.ms, delay: 1300.ms),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPlaylist() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Als Nächstes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.playlist_play,
                      color: Colors.white.withOpacity(0.6),
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_tracks.length} Lieder',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate()
            .fadeIn(duration: 600.ms, delay: 1200.ms)
            .moveY(begin: 10, end: 0, duration: 600.ms, delay: 1200.ms),
          
          // Playlist items
          Column(
            children: List.generate(
              _tracks.length,
              (index) => _buildTrackItem(index),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTrackItem(int index) {
    final track = _tracks[index];
    final isCurrentTrack = index == _currentTrackIndex;
    final trackColor = track['color'] as Color;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          // Add visual feedback with smooth transitions
          _isPlaying = false;
          // For smoother transition
          _animationController.animateTo(
            _animationController.value + 0.05,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          ).then((_) {
            setState(() {
              _currentTrackIndex = index;
              _isPlaying = true;
              _animationController.repeat();
            });
          });
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrentTrack ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isCurrentTrack
              ? Border.all(color: trackColor.withOpacity(0.3), width: 1)
              : null,
        ),
        child: Row(
          children: [
            // Track thumbnail
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    trackColor.withOpacity(0.8),
                    trackColor.withOpacity(0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: isCurrentTrack
                    ? [
                        BoxShadow(
                          color: trackColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Icon(
                  isCurrentTrack ? Icons.music_note : Icons.music_note_outlined,
                  color: Colors.white.withOpacity(0.9),
                  size: 20,
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Track info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track['title'],
                    style: TextStyle(
                      color: Colors.white.withOpacity(isCurrentTrack ? 1.0 : 0.9),
                      fontWeight: isCurrentTrack ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    track['artist'],
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Duration and options
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  track['duration'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  Icons.more_horiz,
                  color: Colors.white.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ).animate()
        .fadeIn(duration: 600.ms, delay: 1300.ms + (index * 100).ms)
        .moveX(begin: 20, end: 0, duration: 600.ms, delay: 1300.ms + (index * 100).ms),
    );
  }
  
  Widget _buildMiniPlayer() {
    final currentTrack = _tracks[_currentTrackIndex];
    final trackColor = currentTrack['color'] as Color;
    
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Track thumbnail
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  trackColor.withOpacity(0.8),
                  trackColor.withOpacity(0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Icon(
                Icons.music_note,
                color: Colors.white.withOpacity(0.8),
                size: 16,
              ),
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(reverse: true, period: 2000.ms),
          )
            .shimmer(delay: 2000.ms, duration: 1200.ms),
          
          const SizedBox(width: 12),
          
          // Track info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentTrack['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  currentTrack['artist'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Control buttons
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.skip_previous,
                  color: Colors.white.withOpacity(0.8),
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _currentTrackIndex = (_currentTrackIndex - 1) % _tracks.length;
                    if (_currentTrackIndex < 0) _currentTrackIndex = _tracks.length - 1;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 18,
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                    if (_isPlaying) {
                      _animationController.repeat();
                    } else {
                      _animationController.stop();
                    }
                  });
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.0,
                      colors: [
                        trackColor.withOpacity(1.0),
                        trackColor.withOpacity(0.7),
                      ],
                      stops: const [0.2, 1.0],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: trackColor.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ).animate(
                onPlay: (controller) => controller.repeat(reverse: true, period: 3000.ms),
              )
                .shimmer(delay: 3000.ms, duration: 1200.ms),
              const SizedBox(width: 12),
              IconButton(
                icon: Icon(
                  Icons.skip_next,
                  color: Colors.white.withOpacity(0.8),
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _currentTrackIndex = (_currentTrackIndex + 1) % _tracks.length;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 18,
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 800.ms, delay: 1500.ms)
      .moveY(begin: 20, end: 0, duration: 800.ms, delay: 1500.ms);
  }
}

class MusicVisualizerPainter extends CustomPainter {
  final Color color;
  final double animationValue;
  final bool isActive;
  
  MusicVisualizerPainter(this.color, this.animationValue, this.isActive);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
    
    // Number of bars in the visualizer
    const barCount = 30;
    final barWidth = size.width / (barCount * 1.5);
    
    // Visualizer is less active when paused
    final amplitudeFactor = isActive ? 1.0 : 0.2;
    
    // Create animated bars
    for (int i = 0; i < barCount; i++) {
      // Create dynamic heights using sin function and animation value
      final phase = (i / barCount * math.pi * 2) + (animationValue * math.pi * 2);
      
      // Combine multiple sine waves for more organic movement
      final normalizedHeight = ((math.sin(phase) * 0.5) + 
                               (math.sin(phase * 2) * 0.25) +
                               (math.sin(phase * 0.5) * 0.25)) * 
                               amplitudeFactor * 0.5 + 0.5; // Range 0.0 to 1.0
      
      // Apply min height for aesthetics
      final minHeight = size.height * 0.05;
      final variableHeight = size.height * 0.7;
      final barHeight = minHeight + (variableHeight * normalizedHeight);
      
      // Enhanced bar visual with better curvature
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          i * (barWidth * 1.5),
          size.height - barHeight,
          barWidth,
          barHeight,
        ),
        const Radius.circular(4),
      );
      
      // Add gradient to each bar for more depth
      final barPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withOpacity(1.0),
            color.withOpacity(0.7),
          ],
        ).createShader(
          Rect.fromLTWH(
            i * (barWidth * 1.5),
            size.height - barHeight,
            barWidth,
            barHeight,
          ),
        )
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round;
      
      // Apply small glow effect if active
      if (isActive && normalizedHeight > 0.7) {
        final glowPaint = Paint()
          ..color = color.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
        
        final glowRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            i * (barWidth * 1.5) - 2,
            size.height - barHeight - 2,
            barWidth + 4,
            barHeight + 4,
          ),
          const Radius.circular(5),
        );
        
        canvas.drawRRect(glowRect, glowPaint);
      }
      
      canvas.drawRRect(rect, barPaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant MusicVisualizerPainter oldDelegate) => 
      oldDelegate.animationValue != animationValue || 
      oldDelegate.isActive != isActive;
}