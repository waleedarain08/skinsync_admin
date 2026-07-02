import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/category_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/nested_category_selector.dart';

class CategoryStep extends ConsumerWidget {
  const CategoryStep({super.key});

  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(treatmentViewModelProvider.notifier);
    final categoryState = ref.watch(categoryViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Categorization'),
        context.verticalSpace(8),
        Text(
          'Organize treatments to help patients find them easily. Select or create categories at any level.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(32),
        NestedCategorySelector(
          categories: categoryState.categories,
          initialCategoryId: viewModel.categoryIdController.text,
          onSelected: viewModel.onCategorySelected,
        ),
        context.verticalSpace(32),
        if (viewModel.categoryPathController.text.isNotEmpty)
          Container(
            padding: context.appEdgeInsets(all: 16),
            decoration: BoxDecoration(
              color: CustomColors.purple.withValues(alpha: 0.05),
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(
                color: CustomColors.purple.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: CustomColors.purple,
                  size: 20,
                ),
                context.horizontalSpace(12),
                Expanded(
                  child: Text(
                    'Selected Path: ${viewModel.categoryPathController.text}',
                    style: context.fonts.black14w600.copyWith(
                      color: CustomColors.purple,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}