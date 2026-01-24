import 'dart:async';
import 'package:flutter/material.dart';

class NavigationOop extends StatelessWidget {
  const NavigationOop({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

// ======================= SPLASH SCREEN =======================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Image(
              image: AssetImage('assets/images/logo_gtvt.png'),
              width: 250,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16), // khoảng cách giữa ảnh và chữ
            Text(
              "UTH SmartTasks",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2196F3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================= ONBOARDING SCREEN =======================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  // Cập nhật dữ liệu: Thêm trường "image" chứa đường dẫn ảnh
  final List<Map<String, String>> contents = [
    {
      "image": "assets/images/logo_gtvt.png", // Ảnh slide 1
      "title": "Easy Time Management",
      "desc":
          "With management based on priority and daily tasks, it will give you convenience in managing and determining the tasks that must be done first.",
    },
    {
      "image": "assets/images/logo_gtvt.png", // Ảnh slide 2
      "title": "Increase Work Effectiveness",
      "desc":
          "Time management and the determination of more important tasks will give your job statistics better and always improve.",
    },
    {
      "image": "assets/images/logo_gtvt.png", // Ảnh slide 3
      "title": "Reminder Notification",
      "desc":
          "The advantage of this application is that it also provides reminders for you so you don't forget to keep doing your assignments well.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              // --- Header: Dots và nút Skip ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      contents.length,
                      (index) => buildDot(index),
                    ),
                  ),
                  // Logic Skip mới: Nhảy tới trang cuối
                  if (_currentIndex < contents.length - 1)
                    TextButton(
                      onPressed: () {
                        _controller.animateToPage(
                          contents.length - 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text(
                        "skip",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    )
                  else
                    const SizedBox(height: 48, width: 40),
                ],
              ),

              const SizedBox(height: 20),

              // --- PageView Slider ---
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // HIỂN THỊ ẢNH MINH HỌA (Thay cho Icon cũ)
                          SizedBox(
                            height: 300, // Chiều cao cố định cho ảnh
                            child: Image.asset(
                              contents[i]["image"]!,
                              fit: BoxFit.contain, // Giữ tỷ lệ ảnh
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            contents[i]["title"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            contents[i]["desc"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // --- Bottom Actions ---
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    if (_currentIndex > 0)
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _controller.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      )
                    else
                      const SizedBox(width: 48),

                    const SizedBox(width: 20),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentIndex == contents.length - 1) {
                            print("Get Started clicked");
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          _currentIndex == contents.length - 1
                              ? "Get Started"
                              : "Next",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildDot(int index) {
    return Container(
      height: 8,
      width: 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentIndex == index ? Colors.blue : Colors.white,
      ),
    );
  }
}
