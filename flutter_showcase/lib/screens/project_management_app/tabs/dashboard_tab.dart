import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardTab extends StatelessWidget {
  final Color darkBgColor;
  final Color cardBgColor;
  final LinearGradient primaryGradient;
  final Color mainColor;
  final Color accentColor;
  final Color textColor;
  final Color secondaryTextColor;

  // Project data
  final int totalProjects;
  final int completedProjects;
  final int pendingTasks;

  const DashboardTab({
    super.key,
    required this.darkBgColor,
    required this.cardBgColor,
    required this.primaryGradient,
    required this.mainColor,
    required this.accentColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.totalProjects,
    required this.completedProjects,
    required this.pendingTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App header with title and notification
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.work_outline,
                      color: mainColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.search,
                      color: secondaryTextColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.notifications_none_outlined,
                          color: secondaryTextColor,
                          size: 18,
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: darkBgColor, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // Main content
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message with user avatar
                _buildUserGreeting(),

                const SizedBox(height: 24),

                // Project overview section
                _buildProjectOverview(),

                const SizedBox(height: 24),

                // Recent tasks
                _buildRecentTasks(),

                const SizedBox(height: 24),

                // Team members
                _buildTeamMembers(),

                const SizedBox(height: 20), // Standard bottom padding
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserGreeting() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guten Morgen,',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Alex Martinez',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '4 anstehende Aufgaben für diese Woche',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mainColor.withOpacity(0.1),
              border: Border.all(color: mainColor, width: 2),
            ),
            child: Center(
              child: Text(
                'AM',
                style: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Projekte',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            _buildStatCard(
              'Gesamt',
              '$totalProjects',
              Icons.work_outline,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              'Abgeschlossen',
              '$completedProjects',
              Icons.check_circle_outline,
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              'Ausstehend',
              '$pendingTasks',
              Icons.access_time,
              Colors.orange,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildProjectProgressCard(
          'Website Redesign',
          'Mobile App Team',
          0.75,
          '75%',
          ['AM', 'JS', 'KL'],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(
        begin: 0.2,
        end: 0,
        duration: 600.ms,
        delay: 200.ms,
        curve: Curves.easeOutQuad);
  }

  Widget _buildProjectProgressCard(
    String title,
    String team,
    double progress,
    String progressText,
    List<String> members,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: mainColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'In Bearbeitung',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            team,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                progressText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: members.asMap().entries.map((entry) {
                  final i = entry.key;
                  final initials = entry.value;
                  return Align(
                    widthFactor: 0.7,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: getAvatarColor(i),
                        shape: BoxShape.circle,
                        border: Border.all(color: mainColor, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.remove_red_eye, size: 14),
                label: const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color getAvatarColor(int index) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  Widget _buildRecentTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aktuelle Aufgaben',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        _buildTaskCard(
          'UI Design überarbeiten',
          'Website Redesign',
          'Heute',
          TaskPriority.high,
        ),
        const SizedBox(height: 12),
        _buildTaskCard(
          'API-Dokumentation erstellen',
          'Backend Services',
          'Morgen',
          TaskPriority.medium,
        ),
        const SizedBox(height: 12),
        _buildTaskCard(
          'Kundenfeedback einarbeiten',
          'Mobile App',
          '3 Tage',
          TaskPriority.low,
        ),
      ],
    );
  }

  Widget _buildTaskCard(
    String title,
    String project,
    String dueDate,
    TaskPriority priority,
  ) {
    Color priorityColor;
    String priorityText;

    switch (priority) {
      case TaskPriority.high:
        priorityColor = Colors.red;
        priorityText = 'Hoch';
        break;
      case TaskPriority.medium:
        priorityColor = Colors.orange;
        priorityText = 'Mittel';
        break;
      case TaskPriority.low:
        priorityColor = Colors.green;
        priorityText = 'Niedrig';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  priorityText,
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.work_outline,
                color: secondaryTextColor,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                project,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.calendar_today,
                color: secondaryTextColor,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                dueDate,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'AM',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: mainColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.more_vert,
                    color: secondaryTextColor,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMembers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Teammitglieder',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white10, width: 1),
          ),
          child: Column(
            children: [
              _buildTeamMemberRow(
                'Alex Martinez',
                'UI/UX Designer',
                Colors.blue,
                'AM',
              ),
              const SizedBox(height: 12),
              _buildDivider(),
              const SizedBox(height: 12),
              _buildTeamMemberRow(
                'Julia Schmidt',
                'Frontend Entwickler',
                Colors.green,
                'JS',
              ),
              const SizedBox(height: 12),
              _buildDivider(),
              const SizedBox(height: 12),
              _buildTeamMemberRow(
                'Kevin Lee',
                'Backend Entwickler',
                Colors.orange,
                'KL',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamMemberRow(
    String name,
    String role,
    Color avatarColor,
    String initials,
  ) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: avatarColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              const SizedBox(height: 2),
              Text(
                role,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
        ),
        Icon(
          Icons.message_outlined,
          color: secondaryTextColor,
          size: 18,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.white10,
    );
  }
}

enum TaskPriority {
  high,
  medium,
  low,
}
