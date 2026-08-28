import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/form_model.dart';
import 'package:skinsync_admin/utils/enums.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/forms_view_model.dart';
import 'package:skinsync_admin/widgets/app_loader.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/dailogbox/add_form_dialog.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/pagination_footer.dart';
import 'package:skinsync_admin/widgets/status_toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';

class FormsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/forms';
  const FormsScreen({super.key});

  @override
  ConsumerState<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends ConsumerState<FormsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});

        if (_tabController.index == 0) {
          ref
              .read(formsViewModelProvider.notifier)
              .getForms('consent', initial: true);
        } else {
          ref
              .read(formsViewModelProvider.notifier)
              .getForms('compliance', initial: true);
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(formsViewModelProvider.notifier)
          .getForms('consent', initial: true);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(formsViewModelProvider);

    return GradientScaffold(
      body: Padding(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: CustomColors.purple,
              unselectedLabelColor: CustomColors.grey,
              indicatorColor: CustomColors.purple,
              indicatorWeight: 3,
              labelStyle: context.fonts.black16w600,
              tabs: const [
                Tab(text: 'Consent Forms'),
                Tab(text: 'Compliance Forms'),
              ],
            ),
            context.verticalSpace(24),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFormsGrid(
                    context,
                    state.consentForms ?? [],
                    'consent',
                    state.loading,
                    state.consentPage,
                    state.consentTotalPages,
                  ),
                  _buildFormsGrid(
                    context,
                    state.complianceForms ?? [],
                    'compliance',
                    state.loading,
                    state.compliancePage,
                    state.complianceTotalPages,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Forms Management', style: context.fonts.level1Heading),
        context.verticalSpace(6),
        Text(
          'Manage and upload legal consent and clinical compliance documentation.',
          style: context.fonts.grey13w500,
        ),
      ],
    );
  }

  Widget _buildFormsGrid(
    BuildContext context,
    List<FormModel> forms,
    String type,
    bool isLoading,
    int currentPage,
    int totalPages,
  ) {
    if (isLoading && forms.isEmpty) {
      return const Center(child: AppLoader());
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.sizeOf(context).width > 1200 ? 4 : 3,
              crossAxisSpacing: context.w(24),
              mainAxisSpacing: context.w(24),
              // LOWER value = GREATER height. (Change from 1.2 to 0.95)
              childAspectRatio: 0.95,
            ),
            itemCount: forms.length + 1, // +1 for the "Add New" card
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddFormCard(context, type);
              }
              return _buildFormCard(context, forms[index - 1], type);
            },
          ),
        ),
        if (totalPages > 1)
          Padding(
            padding: context.appEdgeInsets(top: 24),
            child: PaginationFooter(
              currentPage: currentPage,
              totalPages: totalPages,
              onPageChanged: (page) {
                ref
                    .read(formsViewModelProvider.notifier)
                    .getForms(type, page: page);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAddFormCard(BuildContext context, String type) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AddFormDialog(type: type),
        );
      },
      borderRadius: context.borderRadius(all: 16),
      child: BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: context.appEdgeInsets(all: 16),
              decoration: BoxDecoration(
                color: CustomColors.purple.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: CustomColors.purple,
                size: 32,
              ),
            ),
            context.verticalSpace(16),
            Text(
              'Add New ${type == 'consent' ? 'Consent' : 'Compliance'}',
              style: context.fonts.purple14w600,
            ),
            context.verticalSpace(4),
            Text('Upload PDF file', style: context.fonts.grey12w400),
          ],
        ),
      ),
    );
  }

 Widget _buildFormCard(BuildContext context, FormModel form, String type) {
  return InkWell(
    onTap: () {
      showDialog(
        context: context,
        builder: (context) => AddFormDialog(
          type: type,
          form: form, // Pass form instance to prefill
        ),
      );
    },
    borderRadius: context.borderRadius(all: 16),
    child: BorderdContainerWidget(
      enableHover: true,
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: PDF Icon + Delete Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: context.appEdgeInsets(all: 10),
                decoration: BoxDecoration(
                  color: CustomColors.red.withValues(alpha: 0.1),
                  borderRadius: context.borderRadius(all: 8),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: CustomColors.red,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: () => _confirmDelete(context, form, type),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: CustomColors.red,
                  size: 20,
                ),
              ),
            ],
          ),
          const Spacer(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                form.title ?? 'Untitled Form',
                style: context.fonts.black14w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              context.verticalSpace(4),
              Text(
                'SKU: ${form.globalSku ?? "N/A"}',
                style: context.fonts.grey11w600,
              ),
              context.verticalSpace(8),
            ],
          ),
          const Spacer(),

          Align(
            alignment: Alignment.centerRight,
            child: StatusToggleSwitch(
              status: form.status?.toLowerCase() ?? 'inactive',
              onChanged: (String newStatusStr) async {
                if (form.id == null) return;

                final newStatus = newStatusStr.toLowerCase() == 'active'
                    ? Status.active
                    : Status.inactive;

                final success = await ref
                    .read(formsViewModelProvider.notifier)
                    .updateFormStatus(form.id!, newStatus);

                if (success) {
                  ref.read(formsViewModelProvider.notifier).getForms(type);
                }
              },
              width: context.w(100),
              height: context.h(32),
            ),
          ),
          const Spacer(),

          TextButton.icon(
            onPressed: () {
              if (form.url != null) {
                launchUrl(Uri.parse(form.url!));
              }
            },
            icon: const Icon(Icons.visibility_outlined, size: 16),
            label: const Text('View PDF'),
            style: TextButton.styleFrom(
              foregroundColor: CustomColors.purple,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    ),
  );
}
  Future<void> _confirmDelete(
    BuildContext context,
    FormModel form,
    String type,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => StandardDialog(
        title: 'Delete Form',
        width: context.w(400),
        content: Text(
          "Are you sure you want to delete '${form.title}'?",
          style: context.fonts.grey14w400,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: CustomColors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && form.id != null) {
      await ref
          .read(formsViewModelProvider.notifier)
          .deleteForm(form.id!, type);
    }
  }
}
