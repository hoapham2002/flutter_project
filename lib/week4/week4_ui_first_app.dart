import 'package:flutter/material.dart';

class UiFirstApp extends StatefulWidget {
  const UiFirstApp({super.key});

  @override
  State<UiFirstApp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<UiFirstApp> {
  String _displayText = "Hello";

  void _changeText() {
    setState(() {
      _displayText = "I'm Pham Xuan Hoa"; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My First App"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _displayText,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            
            const SizedBox(height: 50), 

            SizedBox(
              width: 150,
              height: 45,
              child: ElevatedButton(
                onPressed: _changeText, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Say Hi!",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}