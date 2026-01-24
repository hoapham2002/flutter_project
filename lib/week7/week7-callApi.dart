import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import intl for currency formatting


class CallApi extends StatelessWidget {
  const CallApi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProductDetailScreen(),
    );
  }
}

// 1. Create a Model Class to match the JSON data
class Product {
  final String name;
  final int price; // Dùng int cho đơn giản, sẽ ép kiểu từ double nếu cần
  final String description;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // Lấy trường 'name'
      name: json['name'] ?? 'Tên sản phẩm lỗi',
      
      // Lấy trường 'price'. Xử lý an toàn cả số nguyên (int) và số thực (double)
      price: (json['price'] is double) 
          ? (json['price'] as double).toInt() 
          : (json['price'] as int? ?? 0),
          
      // QUAN TRỌNG: API trả về 'des', không phải 'description'
      description: json['des'] ?? 'Không có mô tả.',
      
      // QUAN TRỌNG: API trả về 'imgURL', không phải 'image' hay 'imageUrl'
      imageUrl: json['imgURL'] ?? 'https://via.placeholder.com/300',
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> futureProduct;

  @override
  void initState() {
    super.initState();
    futureProduct = fetchProduct();
  }

  // 2. Function to fetch data from the API
  // Thay thế hàm fetchProduct cũ bằng hàm này
  Future<Product> fetchProduct() async {
    print("Bắt đầu gọi API...");
    try {
      final response = await http.get(
        Uri.parse('https://mock.apidog.com/m1/890655-872447-default/v2/product'),
      );

      print("Trạng thái Server: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        // 1. Decode dữ liệu thô
        final decodedData = jsonDecode(utf8.decode(response.bodyBytes));
        
        print("Dữ liệu nhận được: $decodedData"); // Xem log này ở Console

        // 2. Kiểm tra xem dữ liệu có nằm trong key 'data' không
        // Các API mock thường trả về dạng { "data": { "name":... } }
        Map<String, dynamic> productData;
        
        if (decodedData is Map<String, dynamic> && decodedData.containsKey('data')) {
           productData = decodedData['data']; // Lấy phần lõi bên trong
        } else {
           productData = decodedData; // Dữ liệu nằm ngay bên ngoài
        }

        return Product.fromJson(productData);
      } else {
        throw Exception('Server lỗi: ${response.statusCode}');
      }
    } catch (e) {
      print("LỖI CHI TIẾT: $e"); // Quan trọng: Đọc dòng này để biết lỗi gì
      throw Exception('Lỗi gọi API: $e');
    }
  }

  // Helper to format currency like "4.000.000đ"
  String formatCurrency(int price) {
    final formatCurrency = NumberFormat("#,###", "vi_VN");
    return "${formatCurrency.format(price)}đ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.blue, // The blue back button
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
              onPressed: () {
                // Navigator.pop(context); // Enable if you have navigation
              },
            ),
          ),
        ),
        title: const Text(
          'Product detail',
          style: TextStyle(
            color: Colors.blue, 
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: const [
           // Space for right icons if needed
           SizedBox(width: 16),
        ],
      ),
      body: FutureBuilder<Product>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final product = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(
                      product.imageUrl,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 300,
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.error)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Price
                  Text(
                    'Giá: ${formatCurrency(product.price)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Description Box
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100], // Light gray background
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.5, // Line height for better readability
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No data found'));
        },
      ),
    );
  }
}