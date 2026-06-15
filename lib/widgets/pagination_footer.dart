import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';

class PaginationFooter extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationFooter({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: context.appEdgeInsets(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 2) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          context.horizontalSpace(16),
          Text(
            'Page $currentPage of $totalPages',
            style: context.fonts.grey14w600,
          ),
          context.horizontalSpace(16),
          IconButton(
            onPressed: currentPage < totalPages ? () => onPageChanged(currentPage) : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
