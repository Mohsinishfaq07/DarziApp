import 'package:flutter/material.dart';

class Circleloading extends StatelessWidget {
  final double size;

  const Circleloading({super.key, this.size = 40.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(color: Colors.orange),
      ),
    );
  }
}
