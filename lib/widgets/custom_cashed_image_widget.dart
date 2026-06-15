import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/color_constant.dart';

class CustomCachedImage extends StatefulWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  /// Custom error widget (optional)
  final Widget Function(VoidCallback retry)? errorBuilder;

  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorBuilder,
  });

  @override
  State<CustomCachedImage> createState() => _CustomCachedImageState();
}

class _CustomCachedImageState extends State<CustomCachedImage> {
  Key _imageKey = UniqueKey();

  void _retry() {
    setState(() {
      _imageKey = UniqueKey();
    });
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: CustomColors.purple.withValues(alpha: 0.2),
      highlightColor: CustomColors.purple.withValues(alpha: 0.1),
      child: Container(
        height: widget.height,
        width: widget.width,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      key: _imageKey,
      imageUrl: widget.imageUrl,
      height: widget.height,
      width: widget.width,
      fit: widget.fit,
      placeholder: (context, url) => _buildShimmer(),
      errorWidget: (context, url, error) {
        if (widget.errorBuilder != null) {
          return widget.errorBuilder!(_retry);
        }
        return Container(
          height: widget.height,
          width: widget.width,
          color: Colors.grey.shade200,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                const SizedBox(height: 8),
                TextButton(onPressed: _retry, child: const Text('Retry')),
              ],
            ),
          ),
        );
      },
    );

    if (widget.borderRadius != null) {
      return ClipRRect(borderRadius: widget.borderRadius!, child: image);
    }

    return image;
  }
}
