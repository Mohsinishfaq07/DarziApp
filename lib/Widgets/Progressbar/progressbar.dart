import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Circleloading extends StatelessWidget {
  final double size;

  const Circleloading({super.key, this.size = 40.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.orange,
        highlightColor: Colors.blue,
        child: SizedBox(
          width: 40,
          height: 40,
          child: const CircularProgressIndicator(strokeWidth: 4),
        ),
      ),
    );
  }
}
