class AppFormatter {
  // Đổi thành static và bỏ dấu "_" ở đầu tên hàm
  static String formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    return '$day/$month/$year';
  }

  // Đổi thành static và bỏ dấu "_" ở đầu tên hàm
  static String formatCurrency(int value) {
    final text = value.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      final reverseIndex = text.length - i;
      buffer.write(text[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }

    return 'VND ${buffer.toString()}';
  }

  static String countNights(DateTime checkIn, DateTime checkOut) {
    final nights = checkOut.difference(checkIn).inDays;

    return nights.toString();
  }
}
