import 'dart:convert';
import 'package:http/http.dart' as http;

/// Hàm kiểm tra thanh toán Sepay
/// [noiDungChuyenKhoan] = mã đơn (VD: DH123456)
/// [soTien] = số tiền cần thanh toán
Future<bool> kiemTraThanhToan(String noiDungChuyenKhoan, double soTien) async {
  const String sepayToken =
      "M6SS8QZIE7EIHMYOURVPXJHQOWMYEIXAFOGGAWU7F81Q5T5B0SVBSI21W3FFKDPU";
  const String sepayAccount = "6513796242";

  try {
    final Uri url = Uri.parse(
      "https://my.sepay.vn/userapi/transactions/list?account_number=$sepayAccount&limit=20",
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $sepayToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final transactions = data['transactions'] as List<dynamic>;

      for (var trans in transactions) {
        final content = trans['transaction_content'].toString();
        final amount = double.tryParse(trans['amount_in'].toString()) ?? 0;

        if (content.contains(noiDungChuyenKhoan) && amount >= soTien) {
          return true; // Thanh toán thành công
        }
      }
    }
  } catch (e) {
    print("Lỗi khi kiểm tra thanh toán: $e");
  }

  return false; // Thanh toán chưa thành công hoặc lỗi
}

Future<bool> kiemTraThanhToanDemo() async {
  await Future.delayed(const Duration(seconds: 2)); // Giả lập thời gian chờ

  return true; // Trả về true để giả lập thanh toán thành công
}
