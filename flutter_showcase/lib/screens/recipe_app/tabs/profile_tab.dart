import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  final Color cardBgColor;
  final Color mainColor;
  final Color accentColor;

  const ProfileTab({
    super.key,
    required this.cardBgColor,
    required this.mainColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // Profile header
        _buildProfileHeader(),
        
        const SizedBox(height: 24),
        
        // User stats
        _buildUserStats(),
        
        const SizedBox(height: 24),
        
        // Settings options
        _buildSettingsSection(),
        
        const SizedBox(height: 24),
        
        // App options
        _buildAppOptionsSection(),
        
        const SizedBox(height: 60), // Bottom padding for FAB
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Profile picture and food background
        Stack(
          alignment: Alignment.center,
          children: [
            // Food background
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mainColor.withOpacity(0.07),
              ),
              child: Icon(
                Icons.restaurant_menu,
                color: mainColor.withOpacity(0.1),
                size: 60,
              ),
            ),
            // Profile picture
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mainColor,
                boxShadow: [
                  BoxShadow(
                    color: mainColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Name
        const Text(
          'Julia Schmidt',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 4),
        // Email
        Text(
          'julia.schmidt@example.com',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        // Edit profile button
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit_outlined, size: 16),
          label: const Text(
            'Profil bearbeiten',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: mainColor.withOpacity(0.08),
            foregroundColor: mainColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(160, 34),
          ),
        ),
      ],
    );
  }

  Widget _buildUserStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('25', 'Rezepte\nAngesehen'),
          _buidStatDivider(),
          _buildStatItem('12', 'Rezepte\nGespeichert'),
          _buidStatDivider(),
          _buildStatItem('8', 'Gerichte\nGekocht'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: mainColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buidStatDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Einstellungen',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingsItem(
                'Ernährungspräferenzen',
                Icons.restaurant_menu,
                Colors.orange,
              ),
              _buildDivider(),
              _buildSettingsItem(
                'Benachrichtigungen',
                Icons.notifications_none,
                Colors.blue,
              ),
              _buildDivider(),
              _buildSettingsItem(
                'Sprache ändern',
                Icons.language,
                Colors.green,
              ),
              _buildDivider(),
              _buildSettingsItem(
                'Maßeinheiten',
                Icons.straighten,
                Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'App',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingsItem(
                'Über die App',
                Icons.info_outline,
                Colors.grey,
              ),
              _buildDivider(),
              _buildSettingsItem(
                'Bewertung abgeben',
                Icons.star_border,
                Colors.amber,
              ),
              _buildDivider(),
              _buildSettingsItem(
                'Datenschutz',
                Icons.security,
                Colors.red,
              ),
              _buildDivider(),
              _buildSettingsItem(
                'Ausloggen',
                Icons.logout,
                Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        color: Colors.grey[200],
      ),
    );
  }
}