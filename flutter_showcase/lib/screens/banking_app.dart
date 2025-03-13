import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

import '../models/showcase_item.dart';
import '../painters/showcase_painters.dart';

class BankingAppScreen extends StatefulWidget {
  final ShowcaseItem showcaseItem;

  const BankingAppScreen({
    super.key,
    required this.showcaseItem,
  });

  @override
  State<BankingAppScreen> createState() => _BankingAppScreenState();
}

class _BankingAppScreenState extends State<BankingAppScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _cardAnimationController;
  late Color _primaryColor;

  final List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

  @override
  void initState() {
    super.initState();
    _primaryColor = const Color(0xFF48BB78); // .dev-inspired teal color

    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[50], // .dev uses a white/light gray background
      child: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // .dev-like app bar with clean design
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                    color: Colors.grey[50],
                    child: Row(
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => _cardAnimationController.forward(),
                          onExit: (_) => _cardAnimationController.reverse(),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: _primaryColor.withOpacity(0.1),
                            child: Text(
                              'AM',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ).animate().fadeIn(duration: 400.ms).scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1, 1),
                              duration: 400.ms),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Good morning',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Text(
                              'Alex Morgan',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 100.ms)
                            .moveX(
                                begin: -10,
                                end: 0,
                                duration: 400.ms,
                                delay: 100.ms),
                        const Spacer(),
                        Wrap(
                          spacing: 12,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.search,
                                  color: Colors.black54, size: 18),
                            ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.black54,
                                      size: 18),
                                ),
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: _primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Text(
                                      '2',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 7,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // .dev-style card section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => _cardAnimationController.forward(),
                      onExit: (_) => _cardAnimationController.reverse(),
                      child: AnimatedBuilder(
                        animation: _cardAnimationController,
                        builder: (context, child) {
                          // Calculate subtle 3D rotation effect
                          final rotationY =
                              0.03 * _cardAnimationController.value;
                          final rotationX =
                              -0.01 * _cardAnimationController.value;

                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001) // perspective
                              ..rotateY(rotationY)
                              ..rotateX(rotationX),
                            alignment: Alignment.center,
                            child: child,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _primaryColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: _primaryColor.withOpacity(0.25),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Card header with bank logo and card type
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '.',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        'dev',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'DEBIT',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Card balance
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'AVAILABLE BALANCE',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      '€8,546.32',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                )
                                    .animate()
                                    .fadeIn(duration: 500.ms, delay: 300.ms)
                                    .moveY(
                                        begin: 10,
                                        end: 0,
                                        duration: 500.ms,
                                        delay: 300.ms),
                              ),

                              const SizedBox(height: 20),

                              // Card number and expiry info
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '•••• 4832',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Text(
                                    '08/26',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 300.ms).scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                        duration: 600.ms,
                        delay: 300.ms,
                      ),

                  // Balance graph section - .dev style
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Your balance over time',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: _primaryColor,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '+18%',
                                    style: TextStyle(
                                      color: _primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Balance graph with interaction
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: SizedBox(
                            height: 120, // Increased height to prevent clipping
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Row(
                                  children: [
                                    // Y-axis labels
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text('€9k',
                                            style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 9)),
                                        Text('€8k',
                                            style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 9)),
                                        Text('€7k',
                                            style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 9)),
                                        Text('€6k',
                                            style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 9)),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    // Chart area
                                    Expanded(
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTapUp: (details) {
                                            // Handle tap on chart
                                          },
                                          child: Stack(
                                            children: [
                                              CustomPaint(
                                                painter:
                                                    InteractiveBankingChartPainter(
                                                        _primaryColor),
                                                size: const Size(
                                                    double.infinity, 100),
                                              ).animate().custom(
                                                    duration: 1500.ms,
                                                    delay: 700.ms,
                                                    builder: (context, value,
                                                        child) {
                                                      return ClipRect(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          widthFactor: value,
                                                          child: child,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                              // Interactive overlay
                                              LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  return RepaintBoundary(
                                                    child: CustomPaint(
                                                      painter:
                                                          ChartInteractionPainter(
                                                        chartWidth: constraints
                                                            .maxWidth,
                                                        chartHeight: constraints
                                                            .maxHeight,
                                                        primaryColor:
                                                            _primaryColor,
                                                      ),
                                                      size: Size(
                                                          constraints.maxWidth,
                                                          constraints
                                                              .maxHeight),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // X-axis months with extra padding to prevent clipping
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _months
                                .map((month) => Text(
                                      month,
                                      style: TextStyle(
                                          color: Colors.grey[500], fontSize: 9),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 600.ms).moveY(
                      begin: 20, end: 0, duration: 500.ms, delay: 600.ms),

                  // .dev-style Quick actions
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Quick actions',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.grey[500],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 80, // Increased height to accommodate shadows
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                                vertical:
                                    4), // Add padding to prevent vertical shadow clipping
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            clipBehavior: Clip
                                .none, // Important: Prevent clipping of shadows
                            children: [
                              _buildQuickAction(
                                  'Send', Icons.north_east, _primaryColor,
                                  delay: 800.ms),
                              _buildQuickAction(
                                  'Request', Icons.south_west, _primaryColor,
                                  delay: 900.ms),
                              _buildQuickAction(
                                  'Cards', Icons.credit_card, _primaryColor,
                                  delay: 1000.ms),
                              _buildQuickAction(
                                  'Stats', Icons.bar_chart, _primaryColor,
                                  delay: 1100.ms),
                              _buildQuickAction(
                                  'More', Icons.grid_view, _primaryColor,
                                  delay: 1200.ms),
                              _buildQuickAction(
                                  'Settings', Icons.settings, _primaryColor,
                                  delay: 1300.ms),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 700.ms),

                  // Transactions - .dev style (clean and minimal)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Recent transactions',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'See all',
                                style: TextStyle(
                                  color: _primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 1100.ms)
                            .moveY(
                                begin: 10,
                                end: 0,
                                duration: 400.ms,
                                delay: 1100.ms),
                        const SizedBox(height: 12),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 280),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              _buildTransactionItem(
                                'Starbucks Coffee',
                                'Today, 9:32 AM',
                                '-€4.50',
                                Icons.coffee,
                                Colors.brown,
                                delay: 1200.ms,
                              ),
                              _buildTransactionItem(
                                'Amazon Shopping - Electronics',
                                'Yesterday, 5:20 PM',
                                '-€67.30',
                                Icons.shopping_cart_outlined,
                                Colors.amber.shade800,
                                delay: 1300.ms,
                              ),
                              _buildTransactionItem(
                                'Local Grocery Store',
                                'Yesterday, 3:15 PM',
                                '-€28.75',
                                Icons.shopping_basket,
                                Colors.green,
                                delay: 1400.ms,
                              ),
                              _buildTransactionItem(
                                'Salary Deposit - March',
                                'Mar 1, 10:00 AM',
                                '+€2,450.00',
                                Icons.account_balance,
                                _primaryColor,
                                delay: 1500.ms,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCardOption(String title, IconData icon,
      {required Duration delay}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: delay).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 400.ms,
          delay: delay,
        );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color,
      {Duration delay = Duration.zero}) {
    return Tooltip(
      message: title,
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Add padding for the shadows
        child: Container(
          height: 58,
          width: 58,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.15),
                color.withOpacity(0.25),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.7),
                blurRadius: 10,
                offset: const Offset(-5, -5),
                spreadRadius: 0,
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.8),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () {},
              splashColor: color.withOpacity(0.3),
              highlightColor: color.withOpacity(0.15),
              child: Ink(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: color.withOpacity(0.8),
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .custom(
              duration: 2000.ms,
              delay: 500.ms + delay,
              builder: (context, value, child) {
                // Subtle pulsing glow effect
                final sinValue = math.sin(math.pi * value);
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.2 * sinValue),
                        blurRadius: 15 * sinValue,
                        spreadRadius: 2 * sinValue,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
            ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: delay).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 500.ms,
          delay: delay,
          curve: Curves.elasticOut,
        );
  }

  Widget _buildTransactionItem(
      String title, String date, String amount, IconData icon, Color color,
      {Duration delay = Duration.zero}) {
    final isIncome = amount.startsWith('+');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 10,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        date,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: isIncome
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              amount,
              style: TextStyle(
                color: isIncome ? Colors.green.shade700 : Colors.red.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          )
              .animate(
                onPlay: (controller) =>
                    controller.repeat(reverse: true, period: 3000.ms),
                delay: 1000.ms + delay,
              )
              .shimmer(
                  duration: 1200.ms,
                  color:
                      isIncome ? Colors.green.shade300 : Colors.red.shade300),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: delay).slideX(
        begin: 0.1,
        end: 0,
        duration: 500.ms,
        delay: delay,
        curve: Curves.easeOutQuad);
  }
}

class InteractiveBankingChartPainter extends CustomPainter {
  final Color primaryColor;

  InteractiveBankingChartPainter(this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    // Background grid lines
    final gridPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw horizontal grid lines
    for (int i = 1; i < 4; i++) {
      final y = height / 4 * i;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    // Draw line chart
    final linePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Define data points (mockup data)
    final path = Path();
    final points = [
      Offset(width * 0.05, height * 0.7), // Starting point
      Offset(width * 0.2, height * 0.5), // Up
      Offset(width * 0.3, height * 0.6), // Down a bit
      Offset(width * 0.45, height * 0.3), // Up again
      Offset(width * 0.55, height * 0.25), // Slight up
      Offset(width * 0.7, height * 0.4), // Down
      Offset(width * 0.85, height * 0.2), // Final up
      Offset(width * 0.95, height * 0.15), // End point
    ];

    // Create the path through the points
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      // Using quadratic bezier curves for smooth lines
      final controlPoint = Offset(
        (points[i - 1].dx + points[i].dx) / 2,
        points[i - 1].dy,
      );
      path.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        points[i].dx,
        points[i].dy,
      );
    }

    // Draw the main line
    canvas.drawPath(path, linePaint);

    // Draw gradient fill under the line
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryColor.withOpacity(0.3),
          primaryColor.withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    // Complete the fill path
    final fillPath = Path.from(path);
    fillPath.lineTo(width * 0.95, height); // Bottom right
    fillPath.lineTo(width * 0.05, height); // Bottom left
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);

    // Draw data points
    final pointPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final pointStrokePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw only a few key points to avoid cluttering
    final keyPoints = [0, 3, 6, 7];
    for (int i in keyPoints) {
      // Draw outer circle
      canvas.drawCircle(points[i], 5, pointPaint);
      canvas.drawCircle(points[i], 5, pointStrokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ChartInteractionPainter extends CustomPainter {
  final double chartWidth;
  final double chartHeight;
  final Color primaryColor;

  ChartInteractionPainter({
    required this.chartWidth,
    required this.chartHeight,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // This painter will handle interactive elements like tooltips
    // For now, adding highlight zones at important data points

    final points = [
      Offset(chartWidth * 0.05, chartHeight * 0.7),
      Offset(chartWidth * 0.2, chartHeight * 0.5),
      Offset(chartWidth * 0.3, chartHeight * 0.6),
      Offset(chartWidth * 0.45, chartHeight * 0.3),
      Offset(chartWidth * 0.55, chartHeight * 0.25),
      Offset(chartWidth * 0.7, chartHeight * 0.4),
      Offset(chartWidth * 0.85, chartHeight * 0.2),
      Offset(chartWidth * 0.95, chartHeight * 0.15),
    ];

    final keyPoints = [0, 3, 6, 7];

    for (int i in keyPoints) {
      // Add subtle glow effect for interactive points
      final glowPaint = Paint()
        ..color = primaryColor.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(points[i], 12, glowPaint);
    }

    // Draw a vertical indicator line on key date points
    final indicatorPaint = Paint()
      ..color = primaryColor.withOpacity(0.4)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw dashed lines manually
    for (int i in keyPoints) {
      _drawDashedLine(
        canvas,
        Offset(points[i].dx, 0),
        Offset(points[i].dx, chartHeight),
        indicatorPaint,
      );
    }

    // Add tooltip on one point as an example
    final tooltipPoint = points[3]; // Using the middle point
    //_drawTooltip(canvas, tooltipPoint, '€8,254', 'Apr 15');
  }

  // Helper method to draw dashed lines
  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 3;
    const dashSpace = 3;

    // Calculate the length of the line
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    // Calculate the number of segments
    final segments = (distance / (dashWidth + dashSpace)).floor();

    // Draw the dashed line
    final unitDx = dx / distance;
    final unitDy = dy / distance;

    var startX = p1.dx;
    var startY = p1.dy;

    for (int i = 0; i < segments; i++) {
      final endX = startX + unitDx * dashWidth;
      final endY = startY + unitDy * dashWidth;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );

      startX = endX + unitDx * dashSpace;
      startY = endY + unitDy * dashSpace;
    }
  }

  void _drawTooltip(Canvas canvas, Offset point, String value, String date) {
    const tooltipWidth = 80.0;
    const tooltipHeight = 40.0;
    const arrowSize = 6.0;

    // Position tooltip above the point
    final tooltipRect = Rect.fromCenter(
      center: Offset(point.dx, point.dy - tooltipHeight / 2 - 15),
      width: tooltipWidth,
      height: tooltipHeight,
    );

    // Draw tooltip background
    final tooltipPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 2);

    final tooltipShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Draw shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        tooltipRect.inflate(2),
        const Radius.circular(8),
      ),
      tooltipShadowPaint,
    );

    // Draw tooltip
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        tooltipRect,
        const Radius.circular(8),
      ),
      tooltipPaint,
    );

    // Draw arrow pointing to the data point
    final arrowPath = Path()
      ..moveTo(point.dx, point.dy - 10)
      ..lineTo(point.dx - arrowSize, point.dy - 15)
      ..lineTo(point.dx + arrowSize, point.dy - 15)
      ..close();

    canvas.drawPath(arrowPath, tooltipPaint);

    // Draw text in tooltip
    final textPainter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        tooltipRect.center.dx - textPainter.width / 2,
        tooltipRect.top + 10,
      ),
    );

    // Draw date in tooltip
    final dateTextPainter = TextPainter(
      text: TextSpan(
        text: date,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    dateTextPainter.layout();
    dateTextPainter.paint(
      canvas,
      Offset(
        tooltipRect.center.dx - dateTextPainter.width / 2,
        tooltipRect.top + 25,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
