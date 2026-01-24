import 'package:flutter/material.dart';

// Cấu hình chung cho App
class DataFlowNavigation extends StatelessWidget {
  const DataFlowNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTH SmartTasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2196F3),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        // Định nghĩa kiểu nút bấm chung
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Định nghĩa kiểu ô nhập liệu chung
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
      home: const ForgotPasswordScreen(),
    );
  }
}

// ================== 1. MÀN HÌNH NHẬP EMAIL (FORGOT PASSWORD) ==================
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // iconTheme: const IconThemeData(color: Colors.black), // Nút back màu đen nếu có
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Logo_GTVT.png', height: 100),
              const SizedBox(height: 20),
              const Text(
                "SmartTasks",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2196F3),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Forget Password?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your Email, we will send you a verification code.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Your Email",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  // Regex kiểm tra định dạng email cơ bản
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Chuyển sang màn Verify, truyền theo Email
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VerifyCodeScreen(email: _emailController.text),
                        ),
                      );
                    }
                  },
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== 2. MÀN HÌNH NHẬP MÃ (VERIFY CODE) ==================
class VerifyCodeScreen extends StatefulWidget {
  final String email;
  const VerifyCodeScreen({super.key, required this.email});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  // Tạo 5 controller cho 5 ô nhập
  final List<TextEditingController> _controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  // CODE CỨNG ĐỂ KIỂM TRA
  final String _validCode = "12345";

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 4) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus(); // Hết ô thì ẩn phím
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }

  void _verifyAndNext() {
    String code = _controllers.map((c) => c.text).join();
    if (code.length < 5) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Vui lòng nhập đủ 5 số")));
      return;
    }

    if (code == _validCode) {
      // Đúng code -> Chuyển sang tạo mật khẩu, truyền Email và Code
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CreateNewPasswordScreen(email: widget.email, code: code),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mã xác thực sai! (Gợi ý: 12345)")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.blue),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset('assets/images/Logo_GTVT.png', height: 80),
            const SizedBox(height: 20),
            const Text(
              "SmartTasks",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Verify Code",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Enter the code we just sent you on your registered Email",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // 5 Ô Nhập Code
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return SizedBox(
                  width: 50,
                  height: 50,
                  child: // Tìm đoạn TextField trong VerifyCodeScreen và sửa lại như sau:
                  TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center, // Căn giữa ngang
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ), // Chỉnh font to rõ
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    onChanged: (value) => _onCodeChanged(value, index),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: Colors.grey[200],
                      // QUAN TRỌNG: Đặt padding về 0 để số nằm chính giữa ô vuông
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verifyAndNext,
                child: const Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== 3. MÀN HÌNH TẠO MẬT KHẨU MỚI ==================
class CreateNewPasswordScreen extends StatefulWidget {
  final String email;
  final String code;
  const CreateNewPasswordScreen({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.blue),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset('assets/images/Logo_GTVT.png', height: 80),
              const SizedBox(height: 20),
              const Text(
                "SmartTasks",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Create new password",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your new password must be different from previously used password",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              TextFormField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value == null || value.length < 6)
                    return 'Mật khẩu phải từ 6 ký tự trở lên';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _confirmPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Confirm Password",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value != _passController.text)
                    return 'Mật khẩu xác nhận không khớp';
                  return null;
                },
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Chuyển sang màn Confirm, truyền đủ 3 thông tin
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmScreen(
                            email: widget.email,
                            code: widget.code,
                            password: _passController.text,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== 4. MÀN HÌNH CONFIRM (XÁC NHẬN) ==================
class ConfirmScreen extends StatelessWidget {
  final String email;
  final String code;
  final String password;

  const ConfirmScreen({
    super.key,
    required this.email,
    required this.code,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.blue),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset('assets/images/Logo_GTVT.png', height: 80),
            const SizedBox(height: 20),
            const Text(
              "SmartTasks",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Confirm",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "We are here to help you!",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Hiển thị thông tin dạng Read-Only (chỉ đọc)
            _buildInfoField(Icons.person_outline, email),
            const SizedBox(height: 15),
            _buildInfoField(Icons.confirmation_number_outlined, code), // Code
            const SizedBox(height: 15),
            _buildInfoField(
              Icons.lock_outline,
              "********",
            ), // Ẩn pass để giống design

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // KHI ẤN SUBMIT -> HIỆN THÔNG TIN RA MÀN HÌNH MỚI
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuccessResultScreen(
                        email: email,
                        code: code,
                        password: password,
                      ),
                    ),
                  );
                },
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 15),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// ================== 5. MÀN HÌNH KẾT QUẢ (SHOW INFO) ==================
class SuccessResultScreen extends StatelessWidget {
  final String email;
  final String code;
  final String password;

  const SuccessResultScreen({
    super.key,
    required this.email,
    required this.code,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Đổi màu nền để khác biệt
      appBar: AppBar(
        title: const Text("Hoàn Thành"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 20),
              const Text(
                "Đổi Mật Khẩu Thành Công!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              // Hiển thị lại toàn bộ thông tin đã nhập
              _buildResultRow("Email:", email),
              _buildResultRow("Code đã nhập:", code),
              _buildResultRow("Mật khẩu mới:", password),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    // Quay về màn hình đầu tiên
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text("Về trang chủ"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
