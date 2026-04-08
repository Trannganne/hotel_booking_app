// lib/core/widgets/dropdown_widget.dart
import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String hint;

  const DropdownWidget({
    super.key,
    this.value,
    required this.items,
    required this.onChanged,
    this.hint = '',
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      hint: Text(hint),
      items: items
          .map((e) => DropdownMenuItem<T>(value: e, child: Text(e.toString())))
          .toList(),
      onChanged: onChanged,
      iconEnabledColor: const Color(0xFF0077FF),
      dropdownColor: Colors.white,
    );
  }
}
