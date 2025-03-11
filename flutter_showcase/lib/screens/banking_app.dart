import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

import '../models/showcase_item.dart';
import '../painters/showcase_painters.dart';

class BankingAppScreen extends StatelessWidget {
  final ShowcaseItem showcaseItem;

  const BankingAppScreen({
    super.key,
    required this.showcaseItem,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1D1E33),
      child: Column(
        children: [
          // App bar
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1D1E33),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.account_circle_outlined, 
                    color: Colors.white,
                    size: 20,
                  ),
                ).animate()
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 400.ms),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Willkommen zurück',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      'Alex Morgan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ).animate()
                  .fadeIn(duration: 400.ms, delay: 100.ms)
                  .moveX(begin: -10, end: 0, duration: 400.ms, delay: 100.ms),
                const Spacer(),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                    ),
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
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
                ).animate()
                  .fadeIn(duration: 400.ms, delay: 200.ms),
              ],
            ),
          ),
          
          // Balance chart section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    showcaseItem.color,
                    showcaseItem.color.withOpacity(0.8),
                    showcaseItem.color.withOpacity(0.7),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: showcaseItem.color.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Card header
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gesamtsaldo',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '\$8,546.00',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ).animate()
                        .fadeIn(duration: 500.ms, delay: 300.ms)
                        .moveY(begin: -10, end: 0, duration: 500.ms, delay: 300.ms),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.trending_up, 
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '+18%',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ).animate()
                        .fadeIn(duration: 500.ms, delay: 400.ms)
                        .moveY(begin: -10, end: 0, duration: 500.ms, delay: 400.ms),
                    ],
                  ),
                  
                  // Mini chart
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 60,
                    child: CustomPaint(
                      painter: BankingChartPainter(Colors.white),
                      size: const Size(double.infinity, 60),
                    ),
                  ).animate()
                    .custom(
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

                  // Card options
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCardOption('Konten', Icons.credit_card, delay: 800.ms),
                      _buildCardOption('Zahlungen', Icons.payments_outlined, delay: 900.ms),
                      _buildCardOption('Analysen', Icons.analytics_outlined, delay: 1000.ms),
                    ],
                  ),
                ],
              ),
            ),
          ).animate()
            .fadeIn(duration: 600.ms, delay: 300.ms)
            .scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1, 1),
              duration: 600.ms,
              delay: 300.ms,
            ),
          
          // Quick actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickAction('Senden', Icons.send, Colors.green, delay: 800.ms),
                _buildQuickAction('Empfangen', Icons.call_received, Colors.blue, delay: 900.ms),
                _buildQuickAction('Bezahlen', Icons.payment, Colors.orange, delay: 1000.ms),
                _buildQuickAction('Mehr', Icons.more_horiz, Colors.purple, delay: 1100.ms),
              ],
            ),
          ),
          
          // Transactions
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Neueste Transaktionen',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: showcaseItem.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Alle anzeigen',
                          style: TextStyle(
                            color: showcaseItem.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ).animate()
                    .fadeIn(duration: 400.ms, delay: 1100.ms)
                    .moveY(begin: 10, end: 0, duration: 400.ms, delay: 1100.ms),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildTransactionItem(
                          'Starbucks Kaffee',
                          'Heute, 9:32 Uhr',
                          '-\$4.50',
                          Icons.coffee,
                          Colors.brown,
                          delay: 1200.ms,
                        ),
                        _buildTransactionItem(
                          'Amazon Einkauf',
                          'Gestern, 17:20 Uhr',
                          '-\$67.30',
                          Icons.shopping_cart_outlined,
                          Colors.amber.shade800,
                          delay: 1300.ms,
                        ),
                        _buildTransactionItem(
                          'Supermarkt',
                          'Gestern, 15:15 Uhr',
                          '-\$28.75',
                          Icons.shopping_basket,
                          Colors.green,
                          delay: 1400.ms,
                        ),
                        _buildTransactionItem(
                          'Gehaltseingang',
                          '1. Mär, 10:00 Uhr',
                          '+\$2,450.00',
                          Icons.account_balance,
                          Colors.blue,
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
  
  Widget _buildCardOption(String title, IconData icon, {required Duration delay}) {
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
    ).animate()
      .fadeIn(duration: 400.ms, delay: delay)
      .scale(
        begin: const Offset(0.8, 0.8),
        end: const Offset(1, 1),
        duration: 400.ms,
        delay: delay,
      );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color, {Duration delay = Duration.zero}) {
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
        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ).animate()
      .fadeIn(duration: 400.ms, delay: delay)
      .scale(
        begin: const Offset(0.8, 0.8),
        end: const Offset(1, 1),
        duration: 500.ms, 
        delay: delay,
        curve: Curves.elasticOut,
      );
  }

  Widget _buildTransactionItem(
    String title, 
    String date, 
    String amount, 
    IconData icon, 
    Color color,
    {Duration delay = Duration.zero}
  ) {
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
          ).animate(
            onPlay: (controller) => controller.repeat(reverse: true, period: 3000.ms),
            delay: 1000.ms + delay,
          )
            .shimmer(duration: 1200.ms, color: isIncome ? Colors.green.shade300 : Colors.red.shade300),
        ],
      ),
    ).animate()
      .fadeIn(duration: 600.ms, delay: delay)
      .slideX(begin: 0.1, end: 0, duration: 500.ms, delay: delay, curve: Curves.easeOutQuad);
  }
}