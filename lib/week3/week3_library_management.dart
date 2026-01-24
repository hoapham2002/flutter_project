import 'package:flutter/material.dart';

/// =======================
/// MODEL BOOK
/// =======================
class Book {
  final String id;
  final String title;
  bool isSelected;
  String? borrowedBy;

  Book({
    required this.id,
    required this.title,
    this.isSelected = false,
    this.borrowedBy,
  });
}

/// =======================
/// MODEL STAFF
/// =======================
class Staff {
  final String name;
  final List<String> borrowedBookIds;

  Staff({
    required this.name,
    List<String>? borrowedBookIds,
  }) : borrowedBookIds = borrowedBookIds ?? [];
}

/// =======================
/// MAIN SCREEN
/// =======================
class LibraryManagementScreen extends StatefulWidget {
  const LibraryManagementScreen({super.key});

  @override
  State<LibraryManagementScreen> createState() =>
      _LibraryManagementScreenState();
}

class _LibraryManagementScreenState extends State<LibraryManagementScreen> {
  int _currentIndex = 0;

  final TextEditingController _staffController = TextEditingController();
  final TextEditingController _bookController = TextEditingController();

  /// Danh sách sách
  final List<Book> books = [
    Book(id: '1', title: 'Sách 01'),
    Book(id: '2', title: 'Sách 02'),
    Book(id: '3', title: 'Sách 03'),
  ];

  /// Danh sách nhân viên (KHÔNG BỊ MẤT)
  final List<Staff> staffs = [];

  /// =======================
  /// LOGIC
  /// =======================

  void _addBook() {
    if (_bookController.text.trim().isEmpty) {
      _showSnackBar("Tên sách không được rỗng");
      return;
    }

    setState(() {
      books.add(
        Book(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _bookController.text.trim(),
        ),
      );
      _bookController.clear();
    });
  }

  Staff _getOrCreateStaff(String name) {
    final index = staffs.indexWhere((s) => s.name == name);

    if (index != -1) return staffs[index];

    final staff = Staff(name: name);
    staffs.add(staff);
    return staff;
  }

  void _borrowBooks() {
    final staffName = _staffController.text.trim();

    if (staffName.isEmpty) {
      _showSnackBar("Vui lòng nhập tên nhân viên");
      return;
    }

    final selectedBooks = books.where((b) => b.isSelected).toList();

    if (selectedBooks.isEmpty) {
      _showSnackBar("Chưa chọn sách nào");
      return;
    }

    setState(() {
      final staff = _getOrCreateStaff(staffName);

      for (var book in selectedBooks) {
        book.borrowedBy = staff.name;
        book.isSelected = false;

        if (!staff.borrowedBookIds.contains(book.id)) {
          staff.borrowedBookIds.add(book.id);
        }
      }
    });

    _showSnackBar(
        "Nhân viên $staffName đã mượn ${selectedBooks.length} sách");
  }

  List<Book> _booksOfStaff(Staff staff) {
    return books
        .where((b) => staff.borrowedBookIds.contains(b.id))
        .toList();
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  /// =======================
  /// TAB: QUẢN LÝ
  /// =======================
  Widget _buildManageTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nhân viên',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _staffController,
            decoration:
                const InputDecoration(hintText: 'Nhập tên nhân viên'),
          ),

          const SizedBox(height: 16),

          const Text('Thêm sách mới',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _bookController,
                  decoration:
                      const InputDecoration(hintText: 'Tên sách'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _addBook, child: const Text('Thêm'))
            ],
          ),

          const SizedBox(height: 16),

          const Text('Chọn sách để mượn',
              style: TextStyle(fontWeight: FontWeight.bold)),
          ...books.map(
            (b) => CheckboxListTile(
              title: Text(b.title),
              subtitle:
                  b.borrowedBy != null ? Text('Đã mượn') : null,
              value: b.isSelected,
              onChanged: (v) {
                setState(() {
                  b.isSelected = v ?? false;
                });
              },
            ),
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _borrowBooks,
              child: const Text('Xác nhận mượn sách'),
            ),
          ),
        ],
      ),
    );
  }

  /// =======================
  /// TAB: SÁCH
  /// =======================
  Widget _buildBookTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: books
          .map(
            (b) => Card(
              child: ListTile(
                leading: const Icon(Icons.book),
                title: Text(b.title),
                subtitle: Text(
                  b.borrowedBy == null
                      ? 'Chưa mượn'
                      : 'Nhân viên: ${b.borrowedBy}',
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  /// =======================
  /// TAB: NHÂN VIÊN
  /// =======================
  Widget _buildStaffTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: staffs.map((staff) {
        final staffBooks = _booksOfStaff(staff);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 8),
                    Text(
                      staff.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Số sách đã mượn: ${staffBooks.length}'),
                const SizedBox(height: 8),
                const Text('Danh sách sách:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                ...staffBooks.map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.book, size: 16),
                        const SizedBox(width: 6),
                        Text(b.title),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// =======================
  /// BUILD
  /// =======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý thư viện')),
      body: [
        _buildManageTab(),
        _buildBookTab(),
        _buildStaffTab(),
      ][_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Quản lý'),
          BottomNavigationBarItem(
              icon: Icon(Icons.book), label: 'DS Sách'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Nhân viên'),
        ],
      ),
    );
  }
}
