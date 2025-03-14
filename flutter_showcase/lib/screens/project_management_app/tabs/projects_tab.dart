import 'package:flutter/material.dart';

class ProjectsTab extends StatelessWidget {
  final Color darkBgColor;
  final Color cardBgColor;
  final Color mainColor;
  final Color accentColor;
  final Color textColor;
  final Color secondaryTextColor;

  const ProjectsTab({
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
    return Column(
      children: [
        // App header with title
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
                      Icons.folder_outlined,
                      color: mainColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Projekte',
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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.filter_list,
                  color: secondaryTextColor,
                  size: 18,
                ),
              ),
            ],
          ),
        ),

        // Project filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildProjectFilters(),
        ),

        const SizedBox(height: 16),

        // Project list
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              _buildProjectCard(
                'Website Redesign',
                'Komplette Überarbeitung der Firmenwebsite mit moderner UI',
                'UI/UX Team',
                0.75,
                '10 Mai',
                ProjectStatus.inProgress,
                ['AM', 'JS', 'KL'],
              ),
              const SizedBox(height: 16),
              _buildProjectCard(
                'Mobile App Entwicklung',
                'Neue mobile Anwendung für iOS und Android',
                'Mobile Dev Team',
                0.45,
                '22 Juni',
                ProjectStatus.inProgress,
                ['AM', 'JS'],
              ),
              const SizedBox(height: 16),
              _buildProjectCard(
                'Backend API',
                'Neue REST API für die Produktdatenbank',
                'Backend Team',
                1.0,
                '15 April',
                ProjectStatus.completed,
                ['KL'],
              ),
              const SizedBox(height: 16),
              _buildProjectCard(
                'Design System',
                'Einheitliches Design System für alle Produkte',
                'Design Team',
                0.1,
                '30 Juli',
                ProjectStatus.planned,
                ['AM'],
              ),
              const SizedBox(height: 60), // Bottom padding for FAB
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectFilters() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _buildFilterOption('Alle', isSelected: true),
            _buildFilterOption('Aktiv'),
            _buildFilterOption('Abgeschlossen'),
            _buildFilterOption('Geplant'),
            _buildFilterOption('Pausiert'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? mainColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : secondaryTextColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildProjectCard(
    String title,
    String description,
    String team,
    double progress,
    String dueDate,
    ProjectStatus status,
    List<String> members,
  ) {
    Color statusColor;
    String statusText;

    switch (status) {
      case ProjectStatus.planned:
        statusColor = Colors.blue;
        statusText = 'Geplant';
        break;
      case ProjectStatus.inProgress:
        statusColor = Colors.orange;
        statusText = 'In Bearbeitung';
        break;
      case ProjectStatus.completed:
        statusColor = Colors.green;
        statusText = 'Abgeschlossen';
        break;
      case ProjectStatus.onHold:
        statusColor = Colors.grey;
        statusText = 'Pausiert';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
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
                      description,
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Icon(
                  Icons.group_outlined,
                  color: secondaryTextColor,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  team,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.calendar_today,
                  color: secondaryTextColor,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Fällig: $dueDate',
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
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
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
                            border: Border.all(color: cardBgColor, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Icon(
                Icons.more_vert,
                color: secondaryTextColor,
                size: 20,
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
}

enum ProjectStatus {
  planned,
  inProgress,
  completed,
  onHold,
}
