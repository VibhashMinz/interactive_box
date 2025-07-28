import 'package:flutter/material.dart';

class BoxTile extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  final double size;

  const BoxTile({
    super.key,
    required this.color,
    required this.onTap,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          // borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
