import 'package:flutter/material.dart';

// Enum để định nghĩa loại hiển thị
enum LoadType {
  listView, // Tối ưu
  column,   // Nặng nếu dữ liệu nhiều
}

class Lazy_column extends StatelessWidget {
  const Lazy_column({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo Chọn Cách Load',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SelectionScreen(),
    );
  }
}

// ==========================================
// MÀN HÌNH 1: MÀN HÌNH CHỌN (MENU)
// ==========================================
class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose List Type"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text(
            //   "Vui lòng chọn phương pháp:",
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 30),
            
            // Nút chọn ListView
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DisplayScreen(type: LoadType.listView),
                  ),
                );
              },
              // icon: const Icon(Icons.flash_on),
              label: const Text("ListView"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            
            const SizedBox(height: 20),

            // Nút chọn Column
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DisplayScreen(type: LoadType.column),
                  ),
                );
              },
              // icon: const Icon(Icons.table_rows),
              label: const Text("Column + Scroll"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade100,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// MÀN HÌNH 2: HIỂN THỊ DỮ LIỆU
// ==========================================
class DisplayScreen extends StatefulWidget {
  final LoadType type;

  const DisplayScreen({super.key, required this.type});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  List<String> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Giả lập load dữ liệu mất 1 chút thời gian
    Future.delayed(const Duration(milliseconds: 500), () {
      _generateData();
    });
  }

  void _generateData() {
    final data = List.generate(10000, (index) => "Item dữ liệu thứ #$index");
    if (mounted) {
      setState(() {
        _items = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == LoadType.listView 
            ? "Đang dùng: ListView" 
            : "Đang dùng: Column Scroll"),
        backgroundColor: widget.type == LoadType.listView ? Colors.green : Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : widget.type == LoadType.listView
              ? _buildListView() // Cách 1: Tối ưu
              : _buildColumnScrollView(), // Cách 2: Không tối ưu cho list dài
    );
  }

  // CÁCH 1: Dùng ListView.builder (Chỉ render cái gì đang nhìn thấy)
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return _buildItemCard(index, Colors.green.shade50);
      },
    );
  }

  // CÁCH 2: Dùng Column bọc trong SingleChildScrollView (Render hết 1000 cái 1 lúc)
  Widget _buildColumnScrollView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: _items.asMap().entries.map((entry) {
          int index = entry.key;
          return _buildItemCard(index, Colors.orange.shade50);
        }).toList(),
      ),
    );
  }

  // Widget hiển thị chung cho cả 2 cách để dễ so sánh
  Widget _buildItemCard(int index, Color bgColor) {
    return Card(
      color: bgColor,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(_items[index]),
        subtitle: Text("Phương pháp: ${widget.type == LoadType.listView ? 'ListView' : 'Column'}"),
      ),
    );
  }
}