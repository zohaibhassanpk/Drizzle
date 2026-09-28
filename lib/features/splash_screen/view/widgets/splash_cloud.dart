import 'package:flutter/material.dart';

/// A simple cloud decoration used by the splash screen.
class SplashCloud extends StatelessWidget {
  const SplashCloud({
    super.key,
    required this.width,
    this.color = Colors.white,
  });

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final height = width * 0.36;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: width,
              height: height * 0.55,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(height),
              ),
            ),
          ),
          Positioned(
            bottom: height * 0.25,
            left: width * 0.18,
            child: _CloudCircle(size: height * 0.9, color: color),
          ),
          Positioned(
            bottom: height * 0.2,
            left: width * 0.48,
            child: _CloudCircle(size: height * 0.72, color: color),
          ),
        ],
      ),
    );
  }
}

class _CloudCircle extends StatelessWidget {
  const _CloudCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
