import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/task_model.dart';
import '../services/local_storage_service.dart';
import '../viewmodels/task_viewmodel.dart';

class LocalStorageService {
  static const String _key = 'tasks_list';

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(tasks.map((t) => t.toMap()).toList());
    await prefs.setString(_key, encodedData);
  }

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_key);
    
    if (encodedData == null) {
      // Dữ liệu mẫu ban đầu theo hình ảnh
      return [
        Task(
          id: '1',
          title: 'Complete Android Project',
          description: 'Finish the UI, integrate API, and write documentation',
          colorValue: const Color(0xFFBBDEFB).value,
        ),
        Task(
          id: '2',
          title: 'Complete Android Project',
          description: 'Finish the UI, integrate API, and write documentation',
          colorValue: const Color(0xFFE1BBC1).value,
        ),
        Task(
          id: '3',
          title: 'Complete Android Project',
          description: 'Finish the UI, integrate API, and write documentation',
          colorValue: const Color(0xFFDDE1B6).value,
        ),
      ];
    }

    final List<dynamic> decodedData = json.decode(encodedData);
    return decodedData.map((item) => Task.fromMap(item)).toList();
  }
}