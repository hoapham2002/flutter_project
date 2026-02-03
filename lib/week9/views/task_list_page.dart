import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/task_model.dart';
import '../services/local_storage_service.dart';
import '../viewmodels/task_viewmodel.dart';
import '../views/add_task_page.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Navigator.canPop(context)) Navigator.pop(context);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF03A9F4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
      ),
    );
  }
}

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});
  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  // Khởi tạo ViewModel duy nhất cho màn hình này
  late final TaskViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = TaskViewModel();
    viewModel.addListener(_onViewModelUpdate);
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelUpdate);
    super.dispose();
  }

  void _onViewModelUpdate() {
    if (mounted) setState(() {});
  }

  void _goToAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddTaskPage(viewModel: viewModel)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header: Back - List - Plus Red
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomBackButton(),
                  const Text(
                    'List',
                    style: TextStyle(color: Color(0xFF2196F3), fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: _goToAddTask,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: Color(0xFFFF5252), shape: BoxShape.circle),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            
            // Danh sách Task
            Expanded(
              child: viewModel.isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: viewModel.tasks.length,
                    itemBuilder: (context, index) {
                      final task = viewModel.tasks[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(task.colorValue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                            const SizedBox(height: 8),
                            Text(task.description, style: const TextStyle(fontSize: 14, color: Color(0xFF544C4C))),
                          ],
                        ),
                      );
                    },
                  ),
            ),
            
            // Bottom Bar
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(Icons.home, color: Color(0xFF2196F3), size: 28),
          const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 24),
          GestureDetector(
            onTap: _goToAddTask,
            child: Container(
              width: 55,
              height: 55,
              decoration: const BoxDecoration(color: Color(0xFF2196F3), shape: BoxShape.circle),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
          const Icon(Icons.description_outlined, color: Colors.grey, size: 24),
          const Icon(Icons.settings_outlined, color: Colors.grey, size: 24),
        ],
      ),
    );
  }
}
