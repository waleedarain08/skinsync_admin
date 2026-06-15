import 'package:flutter/material.dart';

import '../utils/assets.dart';
import '../utils/theme.dart';

class AppLoader extends StatelessWidget {
  final double? size;
  final Color? color;
  final double? value;
  const AppLoader({super.key, this.size, this.color, this.value});

  @override
  Widget build(BuildContext context) {
    final boxSize = size ?? 100.w;
    final imageSize = size ?? 50.w;
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: SizedBox(
        width: boxSize,
        height: boxSize,
        child: Stack(
          children: [
            Center(
              child: Transform.scale(
                scale: 1.6,
                child: CircularProgressIndicator(strokeWidth: 2, value: value),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  PngAssets.splashLogo,
                  width: imageSize,
                  height: imageSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
