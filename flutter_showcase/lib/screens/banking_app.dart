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
    _primaryColor = const Color(0xFF48BB78); // N26-inspired teal color

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
      color: Colors.grey[50], // N26 uses a white/light gray background
      child: Column(
        children: [
          // N26-like app bar with clean design
          Container(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            color: Colors.grey[50],
            child: Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => _cardAnimationController.forward(),
                  onExit: (_) => _cardAnimationController.reverse(),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: _primaryColor.withOpacity(0.1),
                    child: Text(
                      'AM',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms).scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      duration: 400.ms),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Good morning',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      'Alex Morgan',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 100.ms)
                    .moveX(begin: -10, end: 0, duration: 400.ms, delay: 100.ms),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.search,
                          color: Colors.black54, size: 20),
                    ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
                    const SizedBox(width: 12),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.notifications_outlined,
                              color: Colors.black54, size: 20),
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
                                fontSize: 8,
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

          // N26-style card section
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
                  final rotationY = 0.03 * _cardAnimationController.value;
                  final rotationX = -0.01 * _cardAnimationController.value;

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
                    children: [
                      // Card header with bank logo and card type
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'N',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                '26',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'DEBIT',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '€8,546.32',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '•••• 4832',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            '08/26',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
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

          // Balance graph section - N26 style
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            color: _primaryColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '+18%',
                            style: TextStyle(
                              color: _primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Balance graph
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      // Y-axis labels
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('€9k',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 10)),
                          Text('€8k',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 10)),
                          Text('€7k',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 10)),
                          Text('€6k',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 10)),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // Chart area
                      Expanded(
                        child: CustomPaint(
                          painter: BankingChartPainter(_primaryColor),
                          size: const Size(double.infinity, 100),
                        ).animate().custom(
                              duration: 1500.ms,
                              delay: 700.ms,
                              builder: (context, value, child) {
                                return ClipRect(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: value,
                                    child: child,
                                  ),
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ),

                // X-axis months
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _months
                        .map((month) => Text(
                              month,
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 10),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 600.ms)
              .moveY(begin: 20, end: 0, duration: 500.ms, delay: 600.ms),

          // N26-style Quick actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Quick actions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickAction('Send', Icons.north_east, _primaryColor,
                        delay: 800.ms),
                    _buildQuickAction(
                        'Request', Icons.south_west, _primaryColor,
                        delay: 900.ms),
                    _buildQuickAction('Cards', Icons.credit_card, _primaryColor,
                        delay: 1000.ms),
                    _buildQuickAction('More', Icons.grid_view, _primaryColor,
                        delay: 1100.ms),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 700.ms),

          // Transactions - N26 style (clean and minimal)
          Expanded(
            child: Container(
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
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'See all',
                          style: TextStyle(
                            color: _primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms, delay: 1100.ms).moveY(
                      begin: 10, end: 0, duration: 400.ms, delay: 1100.ms),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
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
                          'Amazon',
                          'Yesterday, 5:20 PM',
                          '-€67.30',
                          Icons.shopping_cart_outlined,
                          Colors.amber.shade800,
                          delay: 1300.ms,
                        ),
                        _buildTransactionItem(
                          'Grocery Store',
                          'Yesterday, 3:15 PM',
                          '-€28.75',
                          Icons.shopping_basket,
                          Colors.green,
                          delay: 1400.ms,
                        ),
                        _buildTransactionItem(
                          'Salary Deposit',
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
          ),
        ],
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
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Icon(icon, color: color, size: 20),
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
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isIncome
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              amount,
              style: TextStyle(
                color: isIncome ? Colors.green.shade700 : Colors.red.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 14,
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
