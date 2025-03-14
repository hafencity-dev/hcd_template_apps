import 'package:flutter/material.dart';

class TasksTab extends StatelessWidget {
  final Color darkBgColor;
  final Color cardBgColor;
  final Color mainColor;
  final Color accentColor;
  final Color textColor;
  final Color secondaryTextColor;

  const TasksTab({
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
                      Icons.check_circle_outline,
                      color: mainColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width:.0),
                  Text(
                    'Aufgaben',
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

        // Task categories
        Padding(
          padding: const EdgeInsets.all(16),
          child: _buildTaskCategories(),
        ),

        // Task list
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildTaskSection('Heute', [
                _buildTaskItem(
                  'UI Design überarbeiten',
                  'Website Redesign',
                  TaskPriority.high,
                  false,
                ),
                _buildTaskItem(
                  'Team Meeting vorbereiten',
                  'Allgemein',
                  TaskPriority.medium,
                  true,
                ),
              ]),
              
              const SizedBox(height: 24),
              
              _buildTaskSection('Morgen', [
                _buildTaskItem(
                  'API-Dokumentation erstellen',
                  'Backend Services',
                  TaskPriority.medium,
                  false,
                ),
                _buildTaskItem(
                  'Login-Seite implementieren',
                  'Website Redesign',
                  TaskPriority.medium,
                  false,
                ),
              ]),
              
              const SizedBox(height: 24),
              
              _buildTaskSection('Diese Woche', [
                _buildTaskItem(
                  'Kundenfeedback einarbeiten',
                  'Mobile App',
                  TaskPriority.low,
                  false,
                ),
                _buildTaskItem(
                  'Usability Tests durchführen',
                  'Website Redesign',
                  TaskPriority.high,
                  false,
                ),
                _buildTaskItem(
                  'Performance Optimierung',
                  'Backend Services',
                  TaskPriority.medium,
                  false,
                ),
              ]),
              
              const SizedBox(height: 60), // Bottom padding for FAB
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCategories() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCategoryChip('Alle', true),
          ),
          Expanded(
            child: _buildCategoryChip('Persönlich', false),
          ),
          Expanded(
            child: _buildCategoryChip('Team', false),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? mainColor : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : secondaryTextColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskSection(String title, List<Widget> tasks) {
    return Column(
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
        const SizedBox(height: 12),
        ...tasks,
      ],
    );
  }

  Widget _buildTaskItem(
    String title,
    String project,
    TaskPriority priority,
    bool isCompleted,
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted ? Colors.green : Colors.white30,
                width: 2,
              ),
            ),
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: isCompleted
                    ? Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.green,
                      )
                    : SizedBox(width: 14, height: 14),
              ),
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
                    color: isCompleted ? secondaryTextColor : textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.folder_outlined,
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        priorityText,
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: secondaryTextColor,
              size: 18,
            ),
            onPressed: () {},
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

enum TaskPriority {
  high,
  medium,
  low,
}