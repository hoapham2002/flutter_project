import 'package:flutter/material.dart';

class EmailValidationScreen extends StatefulWidget {
  const EmailValidationScreen({super.key});

  @override
  State<EmailValidationScreen> createState() => _EmailValidationScreenState();
}

class _EmailValidationScreenState extends State<EmailValidationScreen> {
  final TextEditingController _emailController = TextEditingController();

  String _message = "";
  Color _messageColor = Colors.red;

  void _checkEmail() {
    setState(() {
      final email = _emailController.text;

      if (email.isEmpty) {
        _message = "Email không hợp lệ";
        _messageColor = Colors.red;
      } else if (!email.contains("@")) {
        _message = "Email không đúng định dạng";
        _messageColor = Colors.red;
      } else {
        _message = "Bạn đã nhập email hợp lệ";
        _messageColor = Colors.green;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thực hành 02"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(color: _messageColor),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _checkEmail,
                child: const Text("Kiểm tra"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
