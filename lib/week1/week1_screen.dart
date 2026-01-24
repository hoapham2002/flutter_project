import 'package:flutter/material.dart';


class Week1Screen extends StatelessWidget {
  const Week1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thực hành 02',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const PracticeScreen(),
    );
  }
}

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  // 1. Khai báo biến trạng thái (State)
  final TextEditingController _controller = TextEditingController(); // Quản lý ô nhập liệu
  String? _errorMessage; // Biến lưu lỗi (null là không có lỗi)
  int _quantity = 0; // Số lượng item cần vẽ

  // Hàm xử lý khi nhấn nút Tạo
  void _handleCreate() {
    // Lấy text từ ô nhập và cố gắng chuyển sang số
    String input = _controller.text;
    int? number = int.tryParse(input);

    setState(() {
      if (number != null && number > 0) {
        // Hợp lệ: Cập nhật số lượng, xóa lỗi
        _quantity = number;
        _errorMessage = null;
      } else {
        // Không hợp lệ: Reset số lượng, hiện lỗi
        _quantity = 0;
        _errorMessage = "Dữ liệu bạn nhập không hợp lệ";
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Giải phóng bộ nhớ khi tắt màn hình
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Tiêu đề
              const Text(
                "Thực hành 02",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // Khu vực nhập liệu và nút bấm
              Row(
                children: [
                  // Ô nhập liệu
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Nhập vào số lượng",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Nút bấm
                  ElevatedButton(
                    onPressed: _handleCreate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Màu xanh giống hình
                      foregroundColor: Colors.white, // Màu chữ trắng
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Tạo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),

              // Thông báo lỗi (Chỉ hiện khi _errorMessage khác null)
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft, // Căn trái cho đẹp giống form
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Danh sách kết quả (List)
              Expanded(
                child: ListView.builder(
                  itemCount: _quantity,
                  itemBuilder: (context, index) {
                    // index chạy từ 0, nên hiển thị cần + 1
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10), // Khoảng cách giữa các item
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF5350), // Màu đỏ
                        borderRadius: BorderRadius.circular(25), // Bo tròn
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}