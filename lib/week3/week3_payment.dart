import 'package:flutter/material.dart';

class PaymentMethod {
  final String id;
  final String name;
  final String iconAsset;
  final String bannerAsset;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.iconAsset,
    required this.bannerAsset,
  });
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // --- XỬ LÝ NULLABLE ---
  PaymentMethod? selectedMethod;

  final List<PaymentMethod> methods = [
    PaymentMethod(
      id: 'paypal',
      name: 'PayPal',
      iconAsset: 'https://cdn-icons-png.flaticon.com/512/174/174861.png',
      bannerAsset:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/PayPal.svg/2560px-PayPal.svg.png',
    ),
    PaymentMethod(
      id: 'googlepay',
      name: 'GooglePay',
      iconAsset: 'https://cdn-icons-png.flaticon.com/512/6124/6124998.png',
      bannerAsset:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Google_Pay_Logo.svg/2560px-Google_Pay_Logo.svg.png',
    ),
    PaymentMethod(
      id: 'applepay',
      name: 'ApplePay',
      iconAsset: 'https://cdn-icons-png.flaticon.com/512/5968/5968434.png',
      bannerAsset:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b0/Apple_Pay_logo.svg/2560px-Apple_Pay_logo.svg.png',
    ),
  ];

  @override
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chọn hình thức thanh toán")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: selectedMethod == null
                    ? const Icon(Icons.wallet, size: 100, color: Colors.grey)
                    : Image.network(selectedMethod!.bannerAsset, height: 80),
              ),
            ),

            /// ✅ RadioGroup chuẩn
            RadioGroup<String>(
              groupValue: selectedMethod?.id,
              onChanged: (value) {
                setState(() {
                  selectedMethod = methods.firstWhere((m) => m.id == value);
                });
              },
              child: Column(children: methods.map(_buildItem).toList()),
            ),

            const SizedBox(height: 20),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(PaymentMethod method) {
    final bool isSelected = selectedMethod?.id == method.id;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.transparent,
          width: 2,
        ),
      ),
      child: RadioListTile<String>(
        value: method.id,
        title: Text(method.name),
        secondary: Image.network(method.iconAsset, width: 30),
      ),
    );
  }

  Widget _buildContinueButton() {
  final bool enabled = selectedMethod != null;

  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: enabled
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Đã chọn ${selectedMethod!.name}"),
                ),
              );
            }
          : null,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey.shade300; // ❌ chưa chọn
            }
            return Colors.blue; // ✅ đã chọn
          },
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          const StadiumBorder(),
        ),
      ),
      child: const Text("Continue"),
    ),
  );
}

}
