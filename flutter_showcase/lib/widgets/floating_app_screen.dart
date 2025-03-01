import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/showcase_item.dart';

class FloatingAppScreen extends StatelessWidget {
  final ShowcaseItem showcaseItem;

  const FloatingAppScreen({
    super.key,
    required this.showcaseItem,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 500,
      child: Stack(
        children: [
          // Phone frame
          _buildPhoneFrame(),
          
          // App screen content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: _buildAppContent(),
              ),
            ),
          ),
        ],
      ).animate()
        .fadeIn(duration: 300.ms)
        .slide(begin: const Offset(0.3, 0), end: Offset.zero, duration: 500.ms, curve: Curves.easeOutQuad),
    );
  }

  Widget _buildPhoneFrame() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Screen bezel
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(34),
                ),
              ),
            ),
          ),
          
          // Notch
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 120,
              height: 25,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppContent() {
    // Select the appropriate app UI based on the showcase item
    switch (showcaseItem.title) {
      case 'E-Commerce App':
        return _buildECommerceApp();
      case 'Fitness Tracker':
        return _buildFitnessApp();
      case 'Banking App':
        return _buildBankingApp();
      case 'Food Delivery':
        return _buildFoodDeliveryApp();
      case 'Travel App':
        return _buildTravelApp();
      default:
        return _buildGenericApp();
    }
  }

  Widget _buildECommerceApp() {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          // App bar
          Container(
            padding: const EdgeInsets.all(16),
            color: showcaseItem.color,
            child: Row(
              children: [
                const Icon(Icons.menu, color: Colors.white),
                const Spacer(),
                const Text(
                  'SHOP',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.shopping_cart_outlined, color: Colors.white),
              ],
            ),
          ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    'Search products...',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          
          // Featured product
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: showcaseItem.color.withOpacity(0.1),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(12),
                    ),
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: _buildProductPlaceholder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: showcaseItem.color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Summer Collection',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Discover our new styles',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: showcaseItem.color,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Shop Now'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate()
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.3, end: 0, duration: 500.ms),
          
          // Products grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _buildProductItem(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFitnessApp() {
    return Material(
      color: const Color(0xFF1E1E2A),
      child: Column(
        children: [
          // App bar
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E1E2A),
            child: Row(
              children: [
                const Icon(Icons.menu, color: Colors.white),
                const Spacer(),
                const Text(
                  'FITNESS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.notifications_outlined, color: Colors.white),
              ],
            ),
          ),
          
          // Activity stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A38),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Today\'s Activity',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '85%',
                        style: TextStyle(
                          color: showcaseItem.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 80,
                    child: _buildActivityChart(),
                  ),
                ],
              ),
            ),
          ),
          
          // Workout plans
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Workout Plans',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildWorkoutItem(
                          'Running',
                          '30 min • 4.5 km',
                          Icons.directions_run,
                          Colors.blue,
                        ),
                        _buildWorkoutItem(
                          'Strength Training',
                          '45 min • Full Body',
                          Icons.fitness_center,
                          Colors.red,
                        ),
                        _buildWorkoutItem(
                          'Yoga',
                          '25 min • Flexibility',
                          Icons.self_improvement,
                          Colors.purple,
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

  Widget _buildBankingApp() {
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
                const Icon(Icons.account_circle, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back',
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
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.notifications_outlined, color: Colors.white),
                ),
              ],
            ),
          ),
          
          // Card balance
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
                    showcaseItem.color.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Main Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        '****4512',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '\$8,546.00',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Available Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ).animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.2, end: 0, duration: 500.ms),
          
          // Quick actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickAction('Send', Icons.send, Colors.green),
                _buildQuickAction('Receive', Icons.call_received, Colors.blue),
                _buildQuickAction('Pay', Icons.payment, Colors.orange),
                _buildQuickAction('More', Icons.more_horiz, Colors.purple),
              ],
            ),
          ),
          
          // Transactions
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 24),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildTransactionItem(
                          'Starbucks Coffee',
                          'Today, 9:32 AM',
                          '-\$4.50',
                          Icons.coffee,
                          Colors.brown,
                        ),
                        _buildTransactionItem(
                          'Grocery Store',
                          'Yesterday, 3:15 PM',
                          '-\$28.75',
                          Icons.shopping_basket,
                          Colors.green,
                        ),
                        _buildTransactionItem(
                          'Salary Deposit',
                          'Mar 1, 10:00 AM',
                          '+\$2,450.00',
                          Icons.account_balance,
                          Colors.blue,
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

  Widget _buildFoodDeliveryApp() {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          // App bar with search
          Container(
            padding: const EdgeInsets.all(16),
            color: showcaseItem.color,
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Delivery to',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          'Home, 123 Main St',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'Search for restaurants, dishes...',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Categories
          SizedBox(
            height: 100,
            child: ListView(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              children: [
                _buildFoodCategory('Pizza', Icons.local_pizza, Colors.red),
                _buildFoodCategory('Burger', Icons.fastfood, Colors.amber),
                _buildFoodCategory('Sushi', Icons.set_meal, Colors.orange),
                _buildFoodCategory('Dessert', Icons.cake, Colors.pink),
              ],
            ),
          ),
          
          // Featured restaurants
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Featured Restaurants',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: showcaseItem.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Restaurant list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildRestaurantItem(
                  'Italian Bistro',
                  '4.8 ★ • 25-35 min',
                  '\$\$',
                  Colors.red.shade100,
                ),
                _buildRestaurantItem(
                  'Sushi House',
                  '4.5 ★ • 30-40 min',
                  '\$\$\$',
                  Colors.blue.shade100,
                ),
                _buildRestaurantItem(
                  'Burger Joint',
                  '4.6 ★ • 15-25 min',
                  '\$',
                  Colors.amber.shade100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelApp() {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          // App bar with background image
          Stack(
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: Color(0xFF0553B1),
                ),
                child: const Center(
                  child: Text(
                    '🏝️',
                    style: TextStyle(fontSize: 80),
                  ),
                ),
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.menu, color: Colors.white),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.notifications_outlined, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bali, Indonesia',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        const Text(
                          '4.9',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Tropical',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade600),
                  const SizedBox(width: 12),
                  Text(
                    'Search destinations...',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          
          // Categories
          SizedBox(
            height: 40,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                _buildTravelCategory('All', isSelected: true),
                _buildTravelCategory('Beach'),
                _buildTravelCategory('Mountain'),
                _buildTravelCategory('City'),
                _buildTravelCategory('Cultural'),
              ],
            ),
          ),
          
          // Popular destinations
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Destinations',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'See All',
                  style: TextStyle(
                    color: showcaseItem.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Destination cards
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              children: [
                _buildDestinationCard('Ubud', 'Cultural Center', Colors.green.shade100),
                _buildDestinationCard('Kuta', 'Beach Paradise', Colors.blue.shade100),
                _buildDestinationCard('Seminyak', 'Luxury Resorts', Colors.orange.shade100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenericApp() {
    return Material(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              showcaseItem.icon,
              size: 60,
              color: showcaseItem.color,
            ),
            const SizedBox(height: 16),
            Text(
              showcaseItem.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              showcaseItem.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widgets for the different app types
  Widget _buildProductPlaceholder() {
    return Container(
      color: showcaseItem.color.withOpacity(0.2),
      child: Center(
        child: Icon(
          Icons.image,
          size: 40,
          color: showcaseItem.color,
        ),
      ),
    );
  }

  Widget _buildProductItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: [
                  Colors.blue.shade100,
                  Colors.green.shade100,
                  Colors.orange.shade100,
                  Colors.purple.shade100,
                ][index % 4],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  [
                    Icons.checkroom,
                    Icons.watch,
                    Icons.backpack,
                    Icons.headphones,
                  ][index % 4],
                  size: 30,
                  color: [
                    Colors.blue.shade800,
                    Colors.green.shade800,
                    Colors.orange.shade800,
                    Colors.purple.shade800,
                  ][index % 4],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  [
                    'T-Shirt',
                    'Watch',
                    'Backpack',
                    'Headphones',
                  ][index % 4],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${(index + 2) * 10}.99',
                  style: TextStyle(
                    color: showcaseItem.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 400.ms, delay: (200 * index).ms)
      .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: (200 * index).ms);
  }

  Widget _buildActivityChart() {
    return CustomPaint(
      painter: ActivityChartPainter(showcaseItem.color),
    );
  }

  Widget _buildWorkoutItem(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(Icons.play_arrow, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
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
    );
  }

  Widget _buildTransactionItem(String title, String date, String amount, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
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
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: amount.startsWith('+') ? Colors.green : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCategory(String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantItem(String name, String info, String price, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                '🍽️',
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      price,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  info,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: showcaseItem.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Free Delivery',
                        style: TextStyle(
                          color: showcaseItem.color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelCategory(String title, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? showcaseItem.color : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDestinationCard(String title, String subtitle, Color color) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, color: Colors.red, size: 16),
            ),
          ),
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '🏝️',
                style: TextStyle(fontSize: 60),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityChartPainter extends CustomPainter {
  final Color color;

  ActivityChartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const barCount = 7;
    final barWidth = size.width / (barCount * 2);
    final maxBarHeight = size.height * 0.8;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const values = [0.5, 0.7, 0.4, 0.8, 0.6, 0.9, 0.5];

    for (int i = 0; i < barCount; i++) {
      final barHeight = maxBarHeight * values[i];
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          i * (barWidth * 2) + barWidth / 2,
          size.height - barHeight,
          barWidth,
          barHeight,
        ),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, paint);
    }

    // Draw progress line
    final linePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height - maxBarHeight * values[0]);

    for (int i = 0; i < barCount; i++) {
      path.lineTo(
        i * (barWidth * 2) + barWidth,
        size.height - maxBarHeight * values[i],
      );
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}