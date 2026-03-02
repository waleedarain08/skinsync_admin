import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

extension ShimmerExtension on Widget {
  Widget withShimmer({Color? baseColor, Color? highlightColor}) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade400,
      highlightColor: highlightColor ?? Colors.grey.shade100,
      child: this,
    );
  }
}
