import 'package:flutter/material.dart';

class RatingBarWidget extends StatelessWidget {
  final double rating;
  final double iconSize;
  final Color color;

  const RatingBarWidget({
    super.key,
    required this.rating,
    this.iconSize = 16,
    this.color = const Color(0xFFF59E0B),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (rating >= index + 1) {
          return Icon(Icons.star, size: iconSize, color: color);
        } else if (rating >= index + 0.5) {
          return Icon(Icons.star_half, size: iconSize, color: color);
        } else {
          return Icon(Icons.star_border, size: iconSize, color: Colors.grey.shade400);
        }
      }),
    );
  }
}
