import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  final Color darkBgColor;
  final Color cardBgColor;
  final Color mainColor;
  final Color accentColor;
  final Color textColor;
  final Color secondaryTextColor;

  const ProfileTab({
    super.key,
    required this.darkBgColor,
    required this.cardBgColor,
    required this.mainColor,
    required this.accentColor,
    required this.textColor,
    required this.secondaryTextColor,
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
        
        // Recent activity
        _buildRecentActivity(),
        
        const SizedBox(height: 24),
        
        // Settings
        _buildSettingsSection(),
        
        const SizedBox(height: 60), // Bottom padding for FAB
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          // Profile picture with badges
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      mainColor.withOpacity(0.7),
                      mainColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white10, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'AM',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: darkBgColor, width: 2),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // User name and role
          Text(
            'Alex Martinez',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'UI/UX Designer',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          // Edit profile button
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  mainColor.withOpacity(0.8),
                  mainColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              child: const Text(
                'Profil bearbeiten',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem('25', 'Projekte\nabgeschlossen'),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _buildStatItem('98%', 'Positive\nBewertungen'),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _buildStatItem('142', 'Aufgaben\nerledigt'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: secondaryTextColor,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.white10,
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Letzte Aktivitäten',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: mainColor,
              ),
              child: const Text(
                'Alle anzeigen',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10, width: 1),
          ),
          child: Column(
            children: [
              _buildActivityItem(
                icon: Icons.task_alt,
                color: Colors.green,
                title: 'Aufgabe abgeschlossen',
                description: 'Team Meeting vorbereiten',
                timeAgo: 'Vor 2 Stunden',
              ),
              _buildDivider(),
              _buildActivityItem(
                icon: Icons.comment,
                color: Colors.blue,
                title: 'Neuer Kommentar',
                description: 'UI Design überarbeiten',
                timeAgo: 'Vor 4 Stunden',
              ),
              _buildDivider(),
              _buildActivityItem(
                icon: Icons.folder,
                color: Colors.orange,
                title: 'Projekt aktualisiert',
                description: 'Website Redesign',
                timeAgo: 'Vor 1 Tag',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required String timeAgo,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            timeAgo,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.white10,
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Einstellungen',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10, width: 1),
          ),
          child: Column(
            children: [
              _buildSettingsItem(
                'Benachrichtigungen',
                Icons.notifications_none_outlined,
                Colors.amber,
              ),
              _buildDivider(),
              _buildSettingsItem(
                'Privatsphäre & Sicherheit',
                Icons.lock_outline,
                Colors.blue,
              ),
              _buildDivider(),
              _buildSettingsItem(
                'Sprache',
                Icons.language,
                Colors.green,
              ),
              _buildDivider(),
              _buildSettingsItem(
                'Support',
                Icons.help_outline,
                Colors.purple,
              ),
              _buildDivider(),
              _buildSettingsItem(
                'Ausloggen',
                Icons.logout,
                Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: secondaryTextColor,
            size: 20,
          ),
        ],
      ),
    );
  }
}