import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'custom_side_menu.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);
  static const id = "TasksScreen";

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<Map<String, dynamic>> tasks = [
    {"title": "Check Emails & Respond to Clients", "date": "Today 10:00 AM - 11:00 AM", "isChecked": true},
    {"title": "Team Meetings & Strategy Planning", "date": "Today 11:00 AM - 2:00 PM", "isChecked": false},
    {"title": "Work on Creative Assets", "date": "Today 3:00 PM - 5:00 PM", "isChecked": false},
    {"title": "Client Reporting & Documentation", "date": "Tomorrow 10:00 PM", "isChecked": false},
  ];

  final TextEditingController _taskController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> _addButtonHover = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _continueButtonHover = ValueNotifier<bool>(false);

  void _addTask(String taskTitle) {
    if (taskTitle.trim().isEmpty) return;
    setState(() {
      tasks.insert(0, {
        "title": taskTitle.trim(),
        "date": DateFormat('MMM dd, yyyy – hh:mm a').format(DateTime.now()),
        "isChecked": false
      });
    });
    _taskController.clear();
  }

  @override
  void dispose() {
    _addButtonHover.dispose();
    _continueButtonHover.dispose();
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomSideMenu(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5A2E6E), Color(0xFFD3A8E0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.menu, color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.purple.shade100,
                child: const Text(
                  "Tasks",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taskController,
                        style: const TextStyle(fontFamily: 'Poppins'),
                        decoration: InputDecoration(
                          hintText: "Add a new task...",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: _addTask,
                      ),
                    ),
                    const SizedBox(width: 8),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => _addButtonHover.value = true,
                      onExit: (_) => _addButtonHover.value = false,
                      child: GestureDetector(
                        onTap: () => _addTask(_taskController.text),
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _addButtonHover,
                          builder: (context, isHovered, child) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(isHovered ? 0.3 : 0.2),
                                    spreadRadius: isHovered ? 2 : 1,
                                    blurRadius: isHovered ? 5 : 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Color(0xFF5A2E6E),
                                size: 24,
                              ),
                            ).animate(
                              effects: isHovered
                                  ? [
                                      ScaleEffect(
                                        begin: const Offset(1, 1),
                                        end: const Offset(1.1, 1.1),
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      ),
                                    ]
                                  : [],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(tasks[index]["title"] + index.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => setState(() => tasks.removeAt(index)),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.red),
                        ),
                        child: _buildTaskItem(index),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => _continueButtonHover.value = true,
                  onExit: (_) => _continueButtonHover.value = false,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/next'),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _continueButtonHover,
                      builder: (context, isHovered, child) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 180,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD3A8E0), Color(0xFF5A2E6E)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(isHovered ? 0.3 : 0.2),
                                spreadRadius: isHovered ? 3 : 2,
                                blurRadius: isHovered ? 7 : 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ).animate(
                          effects: isHovered
                              ? [
                                  ScaleEffect(
                                    begin: const Offset(1, 1),
                                    end: const Offset(1.05, 1.05),
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  ),
                                ]
                              : [],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskItem(int index) {
    final task = tasks[index];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => task['isChecked'] = !task['isChecked']),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF5A2E6E), width: 2),
                color: task['isChecked'] ? const Color(0xFF5A2E6E) : Colors.transparent,
              ),
              child: task['isChecked']
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    decoration: task['isChecked'] ? TextDecoration.lineThrough : TextDecoration.none,
                    color: task['isChecked'] ? Colors.grey : Colors.black,
                  ),
                  child: Text(task['title']),
                ),
                Text(
                  task['date'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => setState(() => tasks.removeAt(index)),
          ),
        ],
      ),
    );
  }
}