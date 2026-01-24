import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class _CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 40, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ListUiComponent extends StatelessWidget {
  const ListUiComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter UI Library',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = [
      {
        'name': 'Layout & Structure',
        'desc': 'Xây khung và bố cục giao diện',
        'items': ['Scaffold', 'Row', 'Column', 'Center'],
      },
      {
        'name': 'Basic Elements & Display',
        'desc': 'Hiển thị nội dung cơ bản',
        'items': ['Text', 'RichText', 'Image', 'Icon', 'CircleAvatar'],
      },
      {
        'name': 'Input & Form Controls',
        'desc': 'Nhập liệu và tương tác người dùng',
        'items': ['TextField', 'Checkbox', 'DropdownButton'],
      },
      {
        'name': 'Buttons & Actions',
        'desc': 'Kích hoạt hành động',
        'items': ['ElevatedButton', 'TextButton', 'FloatingActionButton'],
      },
      {
        'name': 'Navigation & Routing',
        'desc': 'Điều hướng giữa các màn hình',
        'items': ['Navigator', 'BottomNavigationBar', 'Drawer'],
      },
      {
        'name': 'Lists & Scrolling',
        'desc': 'Danh sách và nội dung cuộn',
        'items': [
          'ListView',
          'GridView',
          'SingleChildScrollView',
          'PageView',
          'CustomScrollView',
        ],
      },
      {
        'name': 'Dialogs, Popups & Overlays',
        'desc': 'Thông báo & tương tác tạm thời',
        'items': ['AlertDialog', 'SnackBar', 'BottomSheet'],
      },
      {
        'name': 'Gesture & User Interaction',
        'desc': 'Bắt cử chỉ người dùng',
        'items': ['GestureDetector', 'InkWell', 'Dismissible'],
      },
      {
        'name': 'Animation & Motion',
        'desc': 'Hiệu ứng và chuyển động',
        'items': ['AnimatedContainer', 'AnimatedOpacity', 'AnimatedSwitcher'],
      },
      {
        'name': 'Media & Assets',
        'desc': 'Hình ảnh, âm thanh, video',
        'items': ['Image.asset', 'Image.network', 'CircleAvatar'],
      },

      {
        'name': 'Theming & Responsive Design',
        'desc': 'Giao diện thích ứng & chủ đề',
        'items': ['Theme', 'MediaQuery', 'LayoutBuilder'],
      },
      {
        'name': 'Custom & Advanced UI',
        'desc': 'Vẽ, cắt, tối ưu UI',
        'items': [
          'CustomPaint',
          'ClipRRect',
          'RepaintBoundary',
          'CustomScrollView',
        ],
      },
      {
        'name': 'Async UI & State Listening',
        'desc': 'Dữ liệu bất đồng bộ',
        'items': ['FutureBuilder', 'StreamBuilder', 'ValueListenableBuilder'],
      },
      {
        'name': 'Debug & Utility',
        'desc': 'Hỗ trợ debug & phát triển',
        'items': ['SafeArea', 'Placeholder', 'RepaintBoundary'],
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('UI Components List')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return _buildGroupCard(
            context,
            group['name'] as String,
            group['desc'] as String,
            group['items'] as List<String>,
          );
        },
      ),
    );
  }

  Widget _buildGroupCard(
    BuildContext context,
    String title,
    String desc,
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blueGrey,
            ),
          ),
        ),
        ...items.map(
          (item) => GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ComponentDetailScreen(title: item),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        desc,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ComponentDetailScreen extends StatefulWidget {
  final String title;
  const ComponentDetailScreen({super.key, required this.title});
  @override
  State<ComponentDetailScreen> createState() => _ComponentDetailScreenState();
}

class _ComponentDetailScreenState extends State<ComponentDetailScreen> {
  String _inputText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(child: _buildExample(widget.title)),
      ),
    );
  }

  Widget _buildExample(String title) {
    switch (title) {
      // Layout & Structure
      case 'Scaffold':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Scaffold là widget khung chính của một màn hình',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('SnackBar từ Scaffold')),
                );
              },
              child: const Text('Show SnackBar'),
            ),
          ],
        );
      case 'Row':
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Row: sắp xếp widget theo chiều ngang',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                3,
                (i) => Container(
                  width: 80,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue[(i + 1) * 200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Item ${i + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      case 'Column':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Column: sắp xếp widget theo chiều dọc',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...List.generate(
              3,
              (i) => Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green[(i + 1) * 200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Item ${i + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      case 'Center':
        return Container(
          width: 200,
          height: 120,
          color: Colors.grey.shade300,
          child: const Center(
            child: Text(
              'Centered',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );

      // Basic Elements & Display
      case 'Icon':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.home, size: 60, color: Colors.blue),
            SizedBox(height: 10),
            Text('Icon dùng để hiển thị biểu tượng'),
          ],
        );
      case 'Text':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Flutter Text Widget',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Text dùng để hiển thị nội dung văn bản trên giao diện.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Có thể đổi màu, cỡ chữ, độ đậm.',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        );
      case 'RichText':
        return RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 24),
            children: [
              TextSpan(text: 'The ', style: TextStyle(fontSize: 32)),
              TextSpan(
                text: 'quick ',
                style: TextStyle(decoration: TextDecoration.lineThrough),
              ),
              TextSpan(
                text: 'Brown ',
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '\nfox ',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              TextSpan(text: 'j u m p s '),
              TextSpan(
                text: 'over ',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              TextSpan(
                text: '\nthe ',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              TextSpan(text: 'lazy ', style: TextStyle(fontSize: 16)),
              TextSpan(text: 'dog.'),
            ],
          ),
        );
      case 'Image':
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Image.network (ảnh từ Internet)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Ảnh từ Internet
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://vtiacademy.edu.vn/upload/images/hinhanh/seo/cac-tinh-nang-noi-bat-cua-lap-trinh-flutter.jpg',
                width: 180,
                height: 100,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 80),
              ),
            ),

            const SizedBox(height: 4),
            const Text(
              'https://vtiacademy.edu.vn/upload/images/hinhanh/seo/cac-tinh-nang-noi-bat-cua-lap-trinh-flutter.jpg',
              style: TextStyle(fontSize: 12, color: Colors.blue),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            const Text(
              'Image.asset (ảnh từ máy cục bộ)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Ảnh local
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/sample.png',
                width: 180,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 4),
            const Text(
              'assets/images/sample.png',
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ],
        );

      // Input & Form Controls
      case 'Checkbox':
        bool checked = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: checked,
                  onChanged: (v) => setState(() => checked = v!),
                ),
                Text(checked ? 'Checked' : 'Unchecked'),
              ],
            );
          },
        );
      case 'DropdownButton':
        String value = 'A';
        return StatefulBuilder(
          builder: (context, setState) {
            return DropdownButton<String>(
              value: value,
              items: [
                'A',
                'B',
                'C',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => value = v!),
            );
          },
        );
      case 'TextField':
        return Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Thông tin nhập',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: (v) => setState(() => _inputText = v),
            ),
            const SizedBox(height: 20),
            Text(
              _inputText.isEmpty
                  ? 'Tự động cập nhật dữ liệu theo textfield'
                  : _inputText,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );

      // Buttons & Actions
      case 'ElevatedButton':
        return ElevatedButton(
          onPressed: () {},
          child: const Text('Elevated Button'),
        );
      case 'TextButton':
        return TextButton(onPressed: () {}, child: const Text('Text Button'));
      case 'FloatingActionButton':
        return FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        );

      // Navigation & Routing
      case 'Navigator':
        return ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const Scaffold(body: Center(child: Text('New Screen'))),
              ),
            );
          },
          child: const Text('Go to new screen'),
        );
      case 'Drawer':
        return const Text(
          'Drawer thường được dùng trong Scaffold\n(menu trượt từ cạnh màn hình)',
          textAlign: TextAlign.center,
        );
      case 'BottomNavigationBar':
        return const Text(
          'BottomNavigationBar dùng để chuyển tab chính\n(thường nằm trong Scaffold)',
          textAlign: TextAlign.center,
        );

      // Lists & Scrolling
      case 'ListView':
        return SizedBox(
          height: 150,
          child: ListView(
            children: const [
              ListTile(title: Text('Item 1')),
              ListTile(title: Text('Item 2')),
              ListTile(title: Text('Item 3')),
              ListTile(title: Text('Item 4')),
              ListTile(title: Text('Item 5')),
              ListTile(title: Text('Item 6')),
            ],
          ),
        );
      case 'GridView':
        return SizedBox(
          height: 150,
          child: GridView.count(
            crossAxisCount: 3,
            children: List.generate(
              6,
              (i) => Card(child: Center(child: Text('Item $i'))),
            ),
          ),
        );
      case 'SingleChildScrollView':
        return SizedBox(
          height: 150,
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                10,
                (i) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('Line $i'),
                ),
              ),
            ),
          ),
        );

      // Dialogs, Popups & Overlays
      case 'AlertDialog':
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('AlertDialog'),
                content: const Text('Đây là hộp thoại thông báo'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Show AlertDialog'),
        );
      case 'SnackBar':
        return ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('This is a SnackBar')));
          },
          child: const Text('Show SnackBar'),
        );
      case 'BottomSheet':
        return ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (_) => Container(
                padding: const EdgeInsets.all(16),
                child: const Text('This is a BottomSheet'),
              ),
            );
          },
          child: const Text('Show BottomSheet'),
        );

      // Gesture & User Interaction
      case 'GestureDetector':
        return GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Tapped')));
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue,
            child: const Text('Tap me', style: TextStyle(color: Colors.white)),
          ),
        );
      case 'InkWell':
        return InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.touch_app),
                SizedBox(width: 8),
                Text('InkWell'),
              ],
            ),
          ),
        );
      case 'Dismissible':
        return SizedBox(
          height: 80,
          child: Dismissible(
            key: const ValueKey('item'),
            background: Container(color: Colors.red),
            child: const ListTile(title: Text('Swipe to dismiss')),
            onDismissed: (_) {},
          ),
        );

      // Animation & Motion
      case 'AnimatedContainer':
        bool big = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              onTap: () => setState(() => big = !big),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: big ? 120 : 80,
                height: big ? 120 : 80,
                decoration: BoxDecoration(
                  color: big ? Colors.orange : Colors.blue,
                  borderRadius: BorderRadius.circular(big ? 60 : 10),
                ),
                child: const Center(
                  child: Text('Tap', style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          },
        );
      case 'AnimatedOpacity':
        bool visible = true;
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  opacity: visible ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.visibility, size: 60),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => visible = !visible),
                  child: const Text('Toggle'),
                ),
              ],
            );
          },
        );
      case 'AnimatedSwitcher':
        bool toggle = true;
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: toggle
                      ? const Icon(
                          Icons.favorite,
                          key: ValueKey(1),
                          color: Colors.red,
                          size: 60,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          key: ValueKey(2),
                          size: 60,
                        ),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => toggle = !toggle),
                  child: const Text('Switch'),
                ),
              ],
            );
          },
        );

      // Media & Assets
      case 'Image.network':
        return Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                'https://giaothongvantaitphcm.edu.vn/wp-content/uploads/2025/01/Logo-GTVT.png',
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 100),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'GTVT Logo from Network',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        );
      case 'Image.asset':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.image),
            Text('Image.asset (cần khai báo trong pubspec.yaml)'),
          ],
        );
      case 'CircleAvatar':
        return const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue,
          child: Icon(Icons.person, color: Colors.white),
        );

      // Cupertino (iOS Style)
      // Theming & Responsive Design
      case 'Theme':
        return Builder(
          builder: (context) {
            final theme = Theme.of(context);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Primary color from Theme',
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Button uses Theme'),
                ),
              ],
            );
          },
        );
      case 'MediaQuery':
        final size = MediaQuery.of(context).size;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Width: ${size.width.toStringAsFixed(0)}'),
            Text('Height: ${size.height.toStringAsFixed(0)}'),
          ],
        );
      case 'LayoutBuilder':
        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: 100,
              height: 100,
              color: constraints.maxWidth > 300 ? Colors.green : Colors.blue,
              child: const Center(
                child: Text('Resize me', style: TextStyle(color: Colors.white)),
              ),
            );
          },
        );

      // Custom & Advanced UI
      case 'CustomPaint':
        return CustomPaint(
          size: const Size(120, 120),
          painter: _CirclePainter(),
        );
      case 'ClipRRect':
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 120,
            height: 120,
            color: Colors.orange,
            child: const Center(child: Text('Clipped')),
          ),
        );
      case 'CustomScrollView':
        return SizedBox(
          height: 200,
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(pinned: true, title: Text('SliverAppBar')),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(title: Text('Item $index')),
                  childCount: 5,
                ),
              ),
            ],
          ),
        );

      // Async UI & State Listening
      case 'FutureBuilder':
        return FutureBuilder(
          future: Future.delayed(
            const Duration(seconds: 2),
            () => 'Data Loaded!',
          ),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting)
              return const CircularProgressIndicator();
            return Text(
              snap.data.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          },
        );
      case 'StreamBuilder':
        return StreamBuilder<int>(
          stream: Stream.periodic(const Duration(seconds: 1), (count) => count),
          builder: (context, snapshot) {
            return Text(
              'Counter: ${snapshot.data ?? 0}',
              style: const TextStyle(fontSize: 20),
            );
          },
        );
      case 'ValueListenableBuilder':
        final notifier = ValueNotifier<int>(0);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: notifier,
              builder: (context, value, _) {
                return Text('Value: $value');
              },
            ),
            ElevatedButton(
              onPressed: () => notifier.value++,
              child: const Text('Increment'),
            ),
          ],
        );

      // Debug & Utility
      case 'SafeArea':
        return SafeArea(
          child: Container(
            color: Colors.green,
            padding: const EdgeInsets.all(16),
            child: const Text('Nội dung nằm trong SafeArea'),
          ),
        );
      case 'Placeholder':
        return const SizedBox(height: 100, width: 200, child: Placeholder());
      case 'RepaintBoundary':
        return RepaintBoundary(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange,
            child: const Text('RepaintBoundary'),
          ),
        );
      default:
        return Column(
          children: [
            const Icon(Icons.construction, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            Text(
              'Ví dụ minh họa cho $title đang được cập nhật...',
              textAlign: TextAlign.center,
            ),
          ],
        );
    }
  }
}

class AnimationExample extends StatefulWidget {
  const AnimationExample({super.key});
  @override
  State<AnimationExample> createState() => _AnimationExampleState();
}

class _AnimationExampleState extends State<AnimationExample> {
  bool _big = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _big = !_big),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: _big ? 200 : 100,
        height: _big ? 200 : 100,
        decoration: BoxDecoration(
          color: _big ? Colors.orange : Colors.blue,
          borderRadius: BorderRadius.circular(_big ? 100 : 20),
        ),
        child: const Center(
          child: Text('Tap Me', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
