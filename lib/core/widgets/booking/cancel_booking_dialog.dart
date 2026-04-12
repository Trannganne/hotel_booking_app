import 'package:flutter/material.dart';

import 'booking_constants.dart';

/// Dialog chọn lý do hủy phòng.
///
/// Hàm trả về chuỗi lý do người dùng chọn hoặc nhập.
Future<String?> showCancelBookingDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (_) => const _CancelBookingDialog(),
  );
}

class _CancelBookingDialog extends StatefulWidget {
  const _CancelBookingDialog();

  @override
  State<_CancelBookingDialog> createState() => _CancelBookingDialogState();
}

class _CancelBookingDialogState extends State<_CancelBookingDialog> {
  final TextEditingController otherReasonController = TextEditingController();

  String? selectedReason = 'Lý do cá nhân';

  final List<String> reasons = const [
    'Lý do cá nhân',
    'Thay đổi kế hoạch du lịch',
    'Tìm được phòng tốt hơn',
    'Lý do khác',
  ];

  @override
  void dispose() {
    otherReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'LÝ DO HỦY PHÒNG',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 16),
            ...reasons.map(_buildReasonItem),
            const SizedBox(height: 12),
            const Text(
              'Lưu ý: Không được hoàn tiền khi hủy phòng này.',
              style: TextStyle(
                color: BookingColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _resolveResult());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BookingColors.danger,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Hủy đặt phòng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tạo một dòng radio cho lý do hủy.
  Widget _buildReasonItem(String reason) {
    final bool isOther = reason == 'Lý do khác';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Radio<String>(
            value: reason,
            groupValue: selectedReason,
            onChanged: (value) => setState(() => selectedReason = value),
          ),
          Expanded(
            child: isOther
                ? TextField(
                    controller: otherReasonController,
                    onTap: () => setState(() => selectedReason = reason),
                    decoration: InputDecoration(
                      hintText: 'Lý do khác',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  )
                : Text(
                    reason,
                    style: const TextStyle(
                      fontSize: 16,
                      color: BookingColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// Trả về kết quả cuối cùng cho dialog.
  String _resolveResult() {
    if (selectedReason == 'Lý do khác') {
      return otherReasonController.text.trim();
    }
    return selectedReason ?? '';
  }
}
