// lib/core/widgets/counter_widget.dart
import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;

  const CounterWidget({
    super.key,
    this.initialValue = 1,
    required this.onChanged,
  });

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  void increment() {
    setState(() {
      value++;
    });
    widget.onChanged(value);
  }

  void decrement() {
    if (value > 1) {
      setState(() {
        value--;
      });
      widget.onChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF0077FF)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: decrement,
            icon: const Icon(Icons.remove, color: Color(0xFF0077FF)),
          ),
          Text(value.toString(), style: const TextStyle(fontSize: 16)),
          IconButton(
            onPressed: increment,
            icon: const Icon(Icons.add, color: Color(0xFF0077FF)),
          ),
        ],
      ),
    );
  }
}
