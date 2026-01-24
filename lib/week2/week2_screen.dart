// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Thực hành 02',
//       theme: ThemeData(
//         useMaterial3: true,
//       ),
//       home: const PracticeScreen(),
//     );
//   }
// }

// class PracticeScreen extends StatefulWidget {
//   const PracticeScreen({super.key});

//   @override
//   State<PracticeScreen> createState() => _PracticeScreenState();
// }

// class _PracticeScreenState extends State<PracticeScreen> {
//   // 1. Khai báo biến trạng thái (State)
//   final TextEditingController _controller = TextEditingController(); // Quản lý ô nhập liệu
//   String? _errorMessage; // Biến lưu lỗi (null là không có lỗi)
//   int _quantity = 0; // Số lượng item cần vẽ

//   // Hàm xử lý khi nhấn nút Tạo
//   void _handleCreate() {
//     // Lấy text từ ô nhập và cố gắng chuyển sang số
//     String input = _controller.text;
//     int? number = int.tryParse(input);

//     setState(() {
//       if (number != null && number > 0) {
//         // Hợp lệ: Cập nhật số lượng, xóa lỗi
//         _quantity = number;
//         _errorMessage = null;
//       } else {
//         // Không hợp lệ: Reset số lượng, hiện lỗi
//         _quantity = 0;
//         _errorMessage = "Dữ liệu bạn nhập không hợp lệ";
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose(); // Giải phóng bộ nhớ khi tắt màn hình
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               // Tiêu đề
//               const Text(
//                 "Thực hành 02",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 40),

//               // Khu vực nhập liệu và nút bấm
//               Row(
//                 children: [
//                   // Ô nhập liệu
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         hintText: "Nhập vào số lượng",
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: const BorderSide(color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   // Nút bấm
//                   ElevatedButton(
//                     onPressed: _handleCreate,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue, // Màu xanh giống hình
//                       foregroundColor: Colors.white, // Màu chữ trắng
//                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text("Tạo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               ),

//               // Thông báo lỗi (Chỉ hiện khi _errorMessage khác null)
//               if (_errorMessage != null) ...[
//                 const SizedBox(height: 10),
//                 Align(
//                   alignment: Alignment.centerLeft, // Căn trái cho đẹp giống form
//                   child: Text(
//                     _errorMessage!,
//                     style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],

//               const SizedBox(height: 20),

//               // Danh sách kết quả (List)
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _quantity,
//                   itemBuilder: (context, index) {
//                     // index chạy từ 0, nên hiển thị cần + 1
//                     return Container(
//                       margin: const EdgeInsets.only(bottom: 10), // Khoảng cách giữa các item
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFEF5350), // Màu đỏ
//                         borderRadius: BorderRadius.circular(25), // Bo tròn
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         "${index + 1}",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Practice3Screen(),
    );
  }
}

class Practice3Screen extends StatefulWidget {
  const Practice3Screen({super.key});

  @override
  State<Practice3Screen> createState() => _Practice3ScreenState();
}

class _Practice3ScreenState extends State<Practice3Screen> {
  // 1. Khai báo các Controller để quản lý văn bản nhập vào
  final TextEditingController _controllerA = TextEditingController();
  final TextEditingController _controllerB = TextEditingController();

  // 2. Các biến trạng thái (State)
  String? _selectedOperator; // Lưu phép tính đang chọn (+, -, *, /)
  double? _result; // Lưu kết quả tính toán (null là chưa có kết quả)

  @override
  void initState() {
    super.initState();
    // Lắng nghe sự kiện khi người dùng gõ phím để tự động tính lại (nếu muốn realtime)
    _controllerA.addListener(_calculateResult);
    _controllerB.addListener(_calculateResult);
  }

  @override
  void dispose() {
    _controllerA.dispose();
    _controllerB.dispose();
    super.dispose();
  }

  // 3. Hàm xử lý tính toán
  void _calculateResult() {
    // Nếu chưa chọn phép tính thì chưa làm gì cả
    if (_selectedOperator == null) return;

    // Lấy dữ liệu từ 2 ô nhập liệu
    String textA = _controllerA.text;
    String textB = _controllerB.text;

    // Chuyển đổi sang số thực (double)
    double? numA = double.tryParse(textA);
    double? numB = double.tryParse(textB);

    // Nếu cả 2 đều là số hợp lệ thì mới tính
    if (numA != null && numB != null) {
      double tempResult = 0;
      switch (_selectedOperator) {
        case '+':
          tempResult = numA + numB;
          break;
        case '-':
          tempResult = numA - numB;
          break;
        case '*':
          tempResult = numA * numB;
          break;
        case '/':
          // Xử lý chia cho 0
          if (numB != 0) {
            tempResult = numA / numB;
          } else {
             // Trường hợp chia 0, ta tạm gán kết quả là 0 hoặc xử lý riêng
             // Ở đây mình cứ để tính ra Infinity (vô cực) mặc định của Dart
             tempResult = double.infinity; 
          }
          break;
      }
      
      // Cập nhật giao diện
      setState(() {
        _result = tempResult;
      });
    } else {
      // Nếu nhập sai (nhập chữ cái), reset kết quả
      setState(() {
        _result = null;
      });
    }
  }

  // Hàm cập nhật khi bấm chọn phép tính
  void _onOperatorSelected(String operator) {
    setState(() {
      _selectedOperator = operator;
    });
    _calculateResult(); // Tính ngay lập tức khi vừa bấm chọn
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Thực hành 03",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // --- Ô nhập số thứ 1 ---
              _buildInputField(_controllerA, "Nhập số A"),
              
              const SizedBox(height: 20),

              // --- Hàng nút bấm phép tính ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOperatorButton("+", Colors.red),
                  _buildOperatorButton("-", Colors.orange),
                  _buildOperatorButton("*", Colors.blue),
                  _buildOperatorButton("/", Colors.black87),
                ],
              ),

              const SizedBox(height: 20),

              // --- Ô nhập số thứ 2 ---
              _buildInputField(_controllerB, "Nhập số B"),

              const SizedBox(height: 30),

              // --- Hiển thị kết quả ---
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _result != null 
                      ? "Kết quả: ${_formatResult(_result!)}" // Format cho đẹp (bỏ số 0 thừa)
                      : "Kết quả: ",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget con: Ô nhập liệu (Viết tách ra để tái sử dụng code cho gọn)
  Widget _buildInputField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true), // Cho phép nhập số thập phân
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  // Widget con: Nút phép tính
  Widget _buildOperatorButton(String op, Color color) {
    bool isSelected = _selectedOperator == op;

    return GestureDetector(
      onTap: () => _onOperatorSelected(op),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: isSelected 
              ? Border.all(color: Colors.black, width: 3) // Viền đen đậm nếu đang chọn
              : null,
          boxShadow: [
            if(isSelected) 
              BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
          ]
        ),
        alignment: Alignment.center,
        child: Text(
          op,
          style: const TextStyle(
            color: Colors.white, 
            fontSize: 24, 
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  // Hàm phụ: Format số (Ví dụ 8.0 -> 8, còn 8.5 -> 8.5)
  String _formatResult(double number) {
    if (number == number.roundToDouble()) {
      return number.toInt().toString();
    }
    return number.toString();
  }
}