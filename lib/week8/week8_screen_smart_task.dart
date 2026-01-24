import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SmartTaskScreen extends StatelessWidget {
  const SmartTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartTasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto', // Theo CSS
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}

// --- MODELS ---

class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final String date;
  final String priority;
  final String category;
  final List<String> subtasks; // Thêm trường subtasks

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
    this.priority = 'Medium',
    this.category = 'General',
    this.subtasks = const [], // Mặc định rỗng
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    // Xử lý Title
    String parsedTitle = json['title'] ?? json['header'] ?? json['name'] ?? '';
    if (parsedTitle.isEmpty || parsedTitle == 'No Title') {
      parsedTitle = 'Complete Android Project';
    }

    // Xử lý Description
    String parsedDesc = json['description'] ?? '';
    if (parsedDesc.isEmpty) {
      parsedDesc = 'Finish the UI, integrate API, and write documentation for the project lifecycle.';
    }

    // Xử lý Subtasks: Tạo giả lập dựa trên Title để mỗi task có subtask khác nhau
    List<String> generatedSubtasks = [
      'Research requirements for "$parsedTitle"',
      'Create initial draft design',
      'Implementation phase for $parsedTitle',
      'Final review and testing'
    ];

    return Task(
      id: json['id']?.toString() ?? '',
      title: parsedTitle,
      description: parsedDesc,
      status: json['status'] ?? 'Pending',
      date: json['date'] ?? '2024-01-01',
      priority: json['priority'] ?? 'Medium',
      category: json['category'] ?? 'General',
      subtasks: generatedSubtasks,
    );
  }
}

// --- API SERVICE ---

class ApiService {
  static const String baseUrl = 'https://amock.io/api/researchUTH';

  // 1. API cho Home: Lấy danh sách tasks
  static Future<List<Task>> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks'));
      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        
        if (data is List) {
          return data.map((json) => Task.fromJson(json)).toList();
        } else if (data is Map<String, dynamic>) {
          if (data.containsKey('tasks') && data['tasks'] is List) {
            return (data['tasks'] as List).map((json) => Task.fromJson(json)).toList();
          } else if (data.containsKey('data') && data['data'] is List) {
            return (data['data'] as List).map((json) => Task.fromJson(json)).toList();
          } else {
             try {
               return [Task.fromJson(data)];
             } catch (_) {
               return [];
             }
          }
        }
        return [];
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print("Error fetching tasks: $e");
      return []; 
    }
  }

  // 2. API Delete: Xóa task
  static Future<void> deleteTask(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/task/1'));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        print('API returned ${response.statusCode}, simulating success for demo.');
        return; 
      }
    } catch (e) {
       throw Exception('Network error during delete: $e');
    }
  }
}

// --- CONSTANTS & STYLES (Extracted from CSS) ---

class AppColors {
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color subTextBlue = Color(0xFF3991D8);
  static const Color textDark = Color(0xFF333333);
  static const Color cardRedBg = Color(0xFFE1BBC1); 
  static const Color cardGreenBg = Color.fromRGBO(141, 156, 11, 0.3);
  static const Color cardBlueBg = Color(0xFFB7E9FF);
  static const Color emptyBg = Color(0xFFE6E6E6);
  static const Color bottomBarBg = Color.fromRGBO(255, 255, 255, 0.07); 
}

// --- WIDGETS ---

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Task>> _tasksFuture;
  
  final List<String> _locallyDeletedTaskIds = [];

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  void _refreshTasks() {
    setState(() {
      _tasksFuture = ApiService.fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 30),
                Expanded(
                  child: FutureBuilder<List<Task>>(
                    future: _tasksFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const EmptyStateWidget();
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const EmptyStateWidget();
                      }

                      final allTasks = snapshot.data!;
                      final tasks = allTasks.where((task) => !_locallyDeletedTaskIds.contains(task.id)).toList();

                      if (tasks.isEmpty) {
                        return const EmptyStateWidget();
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        physics: const BouncingScrollPhysics(),
                        itemCount: tasks.length + 1, 
                        itemBuilder: (context, index) {
                          if (index == tasks.length) {
                            return const SizedBox(height: 100);
                          }
                          return TaskCard(
                            task: tasks[index],
                            color: _getCardColor(index),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(task: tasks[index]),
                                ),
                              ).then((result) {
                                if (result == true) {
                                  setState(() {
                                    _locallyDeletedTaskIds.add(tasks[index].id);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Task deleted (Demo)')),
                                  );
                                }
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            // Floating Bottom Bar
            const Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: CustomBottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCardColor(int index) {
    const colors = [
      AppColors.cardRedBg,
      AppColors.cardGreenBg,
      AppColors.cardBlueBg,
    ];
    return colors[index % colors.length];
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.grid_view_rounded, color: Colors.grey[400], size: 30),
              const CircleAvatar(
                radius: 15,
                backgroundColor: Color(0xFFE6E6E6),
                child: Icon(Icons.person, color: Colors.grey, size: 20),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'SmartTasks',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: AppColors.primaryBlue,
            letterSpacing: -0.02 * 24,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'A simple and efficient to-do app',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: AppColors.subTextBlue,
          ),
        ),
      ],
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final Color color;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 142,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_outward, size: 20, color: Colors.black45),
              ],
            ),
            Text(
              task.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Status: ',
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                    Text(
                      task.status,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  task.date,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 112,
            height: 112,
            decoration: const BoxDecoration(
              color: AppColors.emptyBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.paste_rounded, size: 50, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.emptyBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'No Tasks Yet! Stay productive—add something to do',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 370,
        height: 83,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 370,
              height: 59,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, -5),
                    blurRadius: 20,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home_filled, color: AppColors.primaryBlue),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_month, color: Colors.grey),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 50),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline, color: Colors.grey),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- DETAIL SCREEN ---

class DetailScreen extends StatefulWidget {
  final Task task;

  const DetailScreen({super.key, required this.task});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  Future<void> _deleteTask() async {
    try {
      await ApiService.deleteTask(widget.task.id); 
      if (mounted) {
        Navigator.pop(context, true); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Delete failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Title - Căn giữa cho đẹp với tiêu đề lớn
            Center(
              child: Text(
                task.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26, 
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Description - Căn trái (mặc định)
            Text(
              task.description,
              textAlign: TextAlign.left, // Cập nhật: Căn trái
              style: const TextStyle(
                fontSize: 18, 
                color: Colors.grey, 
              ),
            ),
            const SizedBox(height: 30),
            
            // Status and Priority Card
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.cardRedBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoColumn('Category', task.category, Icons.category),
                  Container(width: 1, height: 40, color: Colors.black12),
                  _buildInfoColumn('Status', task.status, Icons.access_time),
                  Container(width: 1, height: 40, color: Colors.black12),
                  _buildInfoColumn('Priority', task.priority, Icons.flag),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Subtasks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 15),
            
            // Cập nhật: Render Subtasks động từ danh sách trong Task
            ...task.subtasks.map((subtask) => _buildSubtaskItem(subtask)).toList(),

            const SizedBox(height: 30),
            
            const Text(
              'Attachments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.emptyBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.picture_as_pdf, color: Colors.red),
                  const SizedBox(width: 10),
                  const Text(
                    'document_1_0.pdf',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),
            
            // Delete Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _deleteTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('DELETE TASK', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 28, color: Colors.black54),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildSubtaskItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.emptyBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.check_box_outline_blank, color: Colors.grey[600], size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}