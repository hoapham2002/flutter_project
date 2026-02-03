import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/task_model.dart';
import '../services/local_storage_service.dart';
import '../viewmodels/task_viewmodel.dart';

class TaskViewModel extends ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();
  List<Task> _tasks = [];
  bool _isLoading = true;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  TaskViewModel() {
    init();
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    _tasks = await _storageService.loadTasks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, String description) async {
    final colors = [
      const Color(0xFFBBDEFB),
      const Color(0xFFE1BBC1),
      const Color(0xFFDDE1B6),
    ];
    
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      colorValue: colors[_tasks.length % colors.length].value,
    );

    _tasks.add(newTask);
    await _storageService.saveTasks(_tasks);
    notifyListeners(); // Thông báo cập nhật UI ngay lập tức
  }
}