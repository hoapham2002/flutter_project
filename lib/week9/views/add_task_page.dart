import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/task_model.dart';
import '../services/local_storage_service.dart';
import '../viewmodels/task_viewmodel.dart';

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

class AddTaskPage extends StatefulWidget {
  final TaskViewModel viewModel;
  const AddTaskPage({super.key, required this.viewModel});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Back - Add New
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    const CustomBackButton(),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Add New',
                          style: TextStyle(color: Color(0xFF2196F3), fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              const Text('Task', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Do homework',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.black.withOpacity(0.14))),
                ),
              ),
              
              const SizedBox(height: 25),
              const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Don’t give up',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.black.withOpacity(0.14))),
                ),
              ),
              
              const SizedBox(height: 50),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (titleController.text.trim().isNotEmpty) {
                      await widget.viewModel.addTask(
                        titleController.text.trim(), 
                        descController.text.trim()
                      );
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 180,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [BoxShadow(color: const Color(0xFF2196F3).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                    ),
                    child: const Center(
                      child: Text('Add', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}