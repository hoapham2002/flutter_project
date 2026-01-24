import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:async'; // <--- Thêm dòng này

class FirebasePracticeScreen extends StatelessWidget {
  const FirebasePracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Chat Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
      home: const AuthGate(),
    );
  }
}

// --- CỔNG ĐIỀU HƯỚNG (AUTH GATE) ---
// Tự động kiểm tra: Đã đăng nhập -> Vào Chat, Chưa -> Vào Login
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Đang chờ kiểm tra
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Đã có user -> Vào Chat
        if (snapshot.hasData) {
          return const ChatScreen();
        }
        // Chưa có user -> Vào Login
        return const LoginRegisterScreen();
      },
    );
  }
}

// --- MÀN HÌNH ĐĂNG NHẬP / ĐĂNG KÝ ---
class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = true; // Trạng thái đang là Login hay Register
  bool isLoading = false;
  String errorMessage = '';

  // Xử lý Đăng nhập / Đăng ký
  Future<void> _authenticate() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
      // Thành công -> AuthGate tự chuyển màn hình, không cần Navigator
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.message ?? "Lỗi không xác định");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mark_chat_unread_outlined,
                size: 80,
                color: Colors.indigo,
              ),
              const SizedBox(height: 20),
              Text(
                isLogin ? "Đăng Nhập" : "Tạo Tài Khoản",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 30),

              // Khung nhập liệu
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: "Mật khẩu",
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 12),

                      // Hiển thị lỗi
                      if (errorMessage.isNotEmpty)
                        Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),

                      const SizedBox(height: 20),

                      // Nút bấm
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isLoading ? null : _authenticate,
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  isLogin ? "VÀO CHAT NGAY" : "ĐĂNG KÝ",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(
                  isLogin
                      ? "Chưa có tài khoản? Đăng ký ngay"
                      : "Đã có tài khoản? Đăng nhập",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- MÀN HÌNH CHAT CHÍNH (CÓ REMOTE CONFIG) ---
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final ScrollController _scrollController = ScrollController();

  // Biến Remote Config
  bool _showBanner = false;
  String _bannerText = "";

  @override
  void initState() {
    super.initState();
    _setupRemoteConfig();
  }

  // Cấu hình Remote Config
  Future<void> _setupRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    
    try {
      // Cấu hình fetch
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(seconds: 1), 
      ));

      // Set mặc định
      await remoteConfig.setDefaults({
        "show_banner": false,
        "banner_text": "Thông báo hệ thống",
      });

      // Lấy dữ liệu lần đầu
      await remoteConfig.fetchAndActivate();
      _updateConfigState(remoteConfig);

      // --- PHẦN FIX LỖI WEB ---
      // 1. Thử lắng nghe Realtime (Dùng try-catch để nếu Web lỗi thì không sập app)
      try {
        remoteConfig.onConfigUpdated.listen((event) async {
          await remoteConfig.activate();
          _updateConfigState(remoteConfig);
        }, onError: (e) {
          debugPrint("Lỗi Stream Web (Bỏ qua): $e");
        });
      } catch (e) {
        // Bỏ qua lỗi stream trên web
      }

      // 2. Dùng Timer tự động lấy lại sau mỗi 5 giây (Giải pháp dự phòng cho Web)
      Timer.periodic(const Duration(seconds: 5), (timer) async {
        // Kiểm tra nếu màn hình đã đóng thì tắt timer để đỡ tốn pin
        if (!mounted) {
          timer.cancel();
          return;
        }
        
        // Tải config mới
        bool updated = await remoteConfig.fetchAndActivate();
        if (updated) {
          debugPrint("Đã cập nhật config mới từ Timer");
          _updateConfigState(remoteConfig);
        }
      });

    } catch (e) {
      debugPrint("Lỗi chung Remote Config: $e");
    }
  }

  void _updateConfigState(FirebaseRemoteConfig remoteConfig) {
    if (mounted) {
      setState(() {
        _showBanner = remoteConfig.getBool('show_banner');
        _bannerText = remoteConfig.getString('banner_text');
      });
    }
  }

  // Gửi tin nhắn
  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'text': _messageController.text.trim(),
        'senderId': currentUser?.uid,
        'senderEmail': currentUser?.email,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
      // Cuộn xuống dưới cùng sau khi gửi
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi gửi tin: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phòng Chat Chung"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- BANNER REMOTE CONFIG ---
          if (_showBanner)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              color: Colors.amber[100],
              child: Row(
                children: [
                  const Icon(Icons.campaign, color: Colors.deepOrange),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _bannerText,
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showBanner = false; // Tắt banner trên máy này
                      });
                    },
                    child: const Icon(Icons.close, color: Colors.deepOrange),
                  ),
                ],
              ),
            ),

          // --- DANH SÁCH TIN NHẮN ---
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(
                    child: Text("Lỗi tải tin nhắn: ${snapshot.error}"),
                  );
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());

                final docs = snapshot.data!.docs;
                if (docs.isEmpty)
                  return const Center(child: Text("Chưa có tin nhắn nào."));

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true, // Tin mới nhất ở dưới
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    bool isMe = data['senderId'] == currentUser?.uid;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 10,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.indigo : Colors.grey[200],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isMe
                                ? const Radius.circular(12)
                                : const Radius.circular(0),
                            bottomRight: isMe
                                ? const Radius.circular(0)
                                : const Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['senderEmail']?.split('@')[0] ??
                                  'Ẩn danh', // Chỉ hiện tên trước @
                              style: TextStyle(
                                fontSize: 10,
                                color: isMe ? Colors.white70 : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data['text'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                color: isMe ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // --- THANH NHẬP LIỆU ---
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.indigo,
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
