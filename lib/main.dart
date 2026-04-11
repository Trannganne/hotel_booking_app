import 'package:flutter/material.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_textfield.dart';
import '../core/widgets/dropdown.dart';
import 'core/widgets/counter.dart';
import 'screens/khachhang/trangchu/trangchu_screen.dart';
import 'screens/admin/quanly_dondatphong/ql_don_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: const QLDonDatPhongScreen(),
    );
  }
}

class TestWidgetsScreen extends StatelessWidget {
  const TestWidgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    int counterValue = 1;
    String? selectedValue;

    return Scaffold(
      appBar: AppBar(title: const Text('Test Widgets')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Custom TextField"),
            CustomTextField(controller: textController, labelText: "Nhập tên"),
            const SizedBox(height: 20),

            const Text("Custom Button"),
            CustomButton(
              text: "Nhấn tôi nhiều lên đi",
              onPressed: () {
                print("Button clicked");
              },
            ),
            const SizedBox(height: 20),

            const Text("Dropdown Widget"),
            DropdownWidget<String>(
              hint: "Chọn phòng",
              value: selectedValue,
              items: ["Phòng 1", "Phòng 2", "Phòng 3"],
              onChanged: (val) {
                selectedValue = val;
                print("Chọn: $val");
              },
            ),
            const SizedBox(height: 20),

            const Text("Counter Widget"),
            CounterWidget(
              initialValue: counterValue,
              onChanged: (val) {
                counterValue = val;
                print("Counter: $val");
              },
            ),
          ],
        ),
      ),
    );
  }
}
