import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.backgroundColor,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      backgroundColor: backgroundColor ?? const Color(0xFF0077FF),
      elevation: 0,

      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            )
          : null,

      actions: actions,

      bottom: bottom, // quan trọng
    );
  }

  @override
  Size get preferredSize {
    // nếu có TabBar thì AppBar cao hơn
    if (bottom != null) {
      return const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
    }
    return const Size.fromHeight(kToolbarHeight);
  }
}
