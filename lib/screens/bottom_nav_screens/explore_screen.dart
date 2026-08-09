import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/explore_models.dart';
import 'package:skinsync_admin/models/requests/community_post_request.dart';
import 'package:skinsync_admin/models/requests/reel_request.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/explore_view_model.dart';
import 'package:skinsync_admin/widgets/app_loader.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';
import 'package:skinsync_admin/widgets/app_page_header.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/logo_and_name_widget.dart';
import 'package:skinsync_admin/widgets/number_paginator.dart';
import 'package:skinsync_admin/widgets/select_or_create_dropdown_widget.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});
  static const String routeName = '/explore';

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen>
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
          ref.read(exploreViewModelProvider.notifier).fetchReels();
        } else {
          ref.read(exploreViewModelProvider.notifier).fetchPosts();
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(exploreViewModelProvider.notifier).fetchReels();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Padding(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppPageHeader(
              title: 'Explore Management',
              subtitle:
                  'Manage community posts and video reels for the consumer application.',
              actions: [
                CustomPrimaryButton(
                  onTap: () => _showAddDialog(context),
                  icon: Icons.add_circle_outline,
                  label: _tabController.index == 0
                      ? 'Add New Reel'
                      : 'Add New Post',
                  width: context.w(200),
                ),
              ],
            ),
            context.verticalSpace(32),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: CustomColors.purple,
              unselectedLabelColor: CustomColors.grey,
              indicatorColor: CustomColors.purple,
              labelStyle: context.fonts.black16w600,
              tabs: const [
                Tab(text: 'Video Reels'),
                Tab(text: 'Community Posts'),
              ],
            ),
            context.verticalSpace(24),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_ReelsTab(), _CommunityTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    if (_tabController.index == 0) {
      _showAddReelDialog(context);
    } else {
      _showAddPostDialog(context);
    }
  }

  void _showAddReelDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final tagsController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(exploreViewModelProvider);
          return AlertDialog(
            title: Text('Add New Reel', style: context.fonts.black20w600),
            content: SizedBox(
              width: context.w(600),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BuildTextField(
                      label: 'Title',
                      controller: titleController,
                      hintText: 'Enter reel title',
                    ),
                    context.verticalSpace(16),
                    BuildTextField(
                      label: 'Description',
                      controller: descController,
                      hintText: 'Enter reel description',
                      maxLines: 3,
                    ),
                    context.verticalSpace(16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilePicker(
                            label: 'Thumbnail',
                            url: state.pickedThumbnailUrl,
                            icon: Icons.image_outlined,
                            onTap: () => ref
                                .read(exploreViewModelProvider.notifier)
                                .pickAndUploadThumbnail(),
                            isImage: true,
                          ),
                        ),
                        context.horizontalSpace(16),
                        Expanded(
                          child: _buildFilePicker(
                            label: 'Video File',
                            url: state.pickedVideoUrl,
                            icon: Icons.movie_outlined,
                            onTap: () => ref
                                .read(exploreViewModelProvider.notifier)
                                .pickAndUploadVideo(),
                          ),
                        ),
                      ],
                    ),
                    context.verticalSpace(16),
                    BuildTextField(
                      label: 'Tags (comma separated)',
                      controller: tagsController,
                      hintText: 'e.g. skin, care, routine',
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ref
                      .read(exploreViewModelProvider.notifier)
                      .clearPickedFiles();
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: context.fonts.grey14w600),
              ),
              CustomPrimaryButton(
                label: 'Create Reel',
                width: context.w(120),
                isLoading:
                    state.loading &&
                    (state.pickedVideoUrl != null ||
                        state.pickedThumbnailUrl != null),
                onTap: () {
                  if (state.pickedVideoUrl == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload a video')),
                    );
                    return;
                  }
                  final reel = CreateReelRequest(
                    title: titleController.text,
                    description: descController.text,
                    videoUrl: state.pickedVideoUrl!,
                    thumbnail: state.pickedThumbnailUrl,
                    tags: tagsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList(),
                  );
                  ref
                      .read(exploreViewModelProvider.notifier)
                      .createReel(reel)
                      .then((success) {
                        if (success) Navigator.pop(context);
                      });
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddPostDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String? selectedCategory;
    final tagsController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(exploreViewModelProvider);
          return AlertDialog(
            title: Text(
              'Add New Community Post',
              style: context.fonts.black20w600,
            ),
            content: SizedBox(
              width: context.w(500),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BuildTextField(
                      label: 'Title',
                      controller: titleController,
                      hintText: 'Enter post title',
                    ),
                    context.verticalSpace(16),
                    BuildTextField(
                      label: 'Content',
                      controller: contentController,
                      hintText: 'Enter post content',
                      maxLines: 5,
                    ),
                    context.verticalSpace(16),
                    _buildFilePicker(
                      label: 'Post Image',
                      url: state.pickedImageUrl,
                      icon: Icons.image_outlined,
                      onTap: () => ref
                          .read(exploreViewModelProvider.notifier)
                          .pickAndUploadImage(),
                      isImage: true,
                    ),
                    context.verticalSpace(16),
                    StatefulBuilder(
                      builder: (context, setDialogState) {
                        return SelectOrCreateDropdown<String>(
                          label: 'Category',
                          hint: 'Select Category',
                          value: selectedCategory,
                          items: state.postCategories
                              .map((e) => e.name)
                              .toList(),
                          itemLabel: (cat) => cat,
                          onChanged: (val) {
                            setDialogState(() {
                              selectedCategory = val;
                            });
                          },
                          onOpen: () => ref
                              .read(exploreViewModelProvider.notifier)
                              .fetchPostCategories(),

                          onCreate: () => _showCreateCategoryDialog(
                            context,
                            onCategoryAdded: (category) {
                              setDialogState(() {
                                selectedCategory = category;
                              });
                            },
                          ),
                        );
                      },
                    ),
                    context.verticalSpace(16),
                    BuildTextField(
                      label: 'Tags (comma separated)',
                      controller: tagsController,
                      hintText: 'e.g. advice, community, help',
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ref
                      .read(exploreViewModelProvider.notifier)
                      .clearPickedFiles();
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: context.fonts.grey14w600),
              ),
              CustomPrimaryButton(
                label: 'Create Post',
                width: context.w(120),
                isLoading: state.loading && state.pickedImageUrl != null,
                onTap: () {
                  if (state.pickedImageUrl == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload an image')),
                    );
                    return;
                  }
                  final post = CreateCommunityPostRequest(
                    title: titleController.text,
                    content: contentController.text,
                    imageUrl: state.pickedImageUrl!,
                    category: selectedCategory,
                    tags: tagsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList(),
                  );
                  ref
                      .read(exploreViewModelProvider.notifier)
                      .createPost(post)
                      .then((success) {
                        if (success) Navigator.pop(context);
                      });
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCreateCategoryDialog(
    BuildContext context, {
    required Function(String) onCategoryAdded,
  }) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Category', style: context.fonts.black18w600),
          content: BuildTextField(
            label: 'Name',
            controller: controller,
            hintText: 'Enter category name...',
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: CustomPrimaryButton(
                onTap: () {
                  final name = controller.text.trim();

                  if (name.isNotEmpty) {
                    // No API call
                    onCategoryAdded(name);

                    Navigator.pop(context);
                  }
                },
                label: 'Add',
                width: 100.w,
              ),
            ),
            SizedBox(height: 10.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: context.fonts.grey14w600),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilePicker({
    required String label,
    required String? url,
    required IconData icon,
    required VoidCallback onTap,
    bool isImage = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black14w600),
        context.verticalSpace(12),
        InkWell(
          onTap: onTap,
          borderRadius: context.appBorderRadius(all: 12),
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(color: CustomColors.border),
            ),
            child: url != null && url.isNotEmpty
                ? ClipRRect(
                    borderRadius: context.appBorderRadius(all: 12),
                    child: Stack(
                      children: [
                        isImage
                            ? AppNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: CustomColors.green,
                                    size: 32,
                                  ),
                                  context.verticalSpace(4),
                                  Text(
                                    'File Uploaded',
                                    style: context.fonts.black12w600,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      url,
                                      style: context.fonts.grey11w400,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              // Specific clear logic could be added here, but for now we clear all
                              ref
                                  .read(exploreViewModelProvider.notifier)
                                  .clearPickedFiles();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: CustomColors.red,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: CustomColors.lightGrey, size: 32),
                      context.verticalSpace(4),
                      Text('Click to Upload', style: context.fonts.grey12w400),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _ReelsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreViewModelProvider);

    if (state.loading) {
      return const Center(child: AppLoader());
    }

    if (state.reels.isEmpty) {
      return Center(
        child: Text('No reels available', style: context.fonts.grey14w400),
      );
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: context.w(20),
              mainAxisSpacing: context.h(20),
              childAspectRatio: 0.75,
            ),
            itemCount: state.reels.length,
            itemBuilder: (context, index) =>
                _ReelCard(reel: state.reels[index]),
          ),
        ),
        if (state.reelsTotalPages > 1)
          Padding(
            padding: context.appEdgeInsets(vertical: 24),
            child: NumberPaginator(
              totalPages: state.reelsTotalPages,
              currentPage: state.reelsCurrentPage - 1,
              onPageChanged: (pageIndex) {
                ref
                    .read(exploreViewModelProvider.notifier)
                    .fetchReels(page: pageIndex + 1);
              },
            ),
          ),
      ],
    );
  }
}

class _ReelCard extends ConsumerWidget {
  final ReelModel reel;
  const _ReelCard({required this.reel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CustomColors.lightPurple.withValues(alpha: 0.3),
                    borderRadius: context.appBorderRadius(
                      topLeft: 12,
                      topRight: 12,
                    ),
                  ),
                  child: reel.thumbnail != null && reel.thumbnail!.isNotEmpty
                      ? AppNetworkImage(
                          imageUrl: reel.thumbnail!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : const Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 48,
                            color: CustomColors.purple,
                          ),
                        ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: LogoAndNameWidget(
                    profileLogo: reel.profileLogo ?? '',
                    profileName: reel.profileName ?? 'N/A',
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Column(
                    children: [
                      _CircleActionBtn(
                        icon: reel.status == 'Active'
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: reel.status == 'Active'
                            ? CustomColors.purple
                            : CustomColors.grey,
                        onTap: () {
                          if (reel.id != null) {
                            ref
                                .read(exploreViewModelProvider.notifier)
                                .toggleReelVisibility(reel.id!, reel.status);
                          }
                        },
                      ),
                      context.verticalSpace(8),
                      _CircleActionBtn(
                        icon: Icons.delete_outline,
                        color: CustomColors.red,
                        onTap: () {
                          if (reel.id != null) {
                            _showDeleteConfirm(context, () {
                              ref
                                  .read(exploreViewModelProvider.notifier)
                                  .deleteReel(reel.id!);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                if (reel.status != 'Active')
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: context.appBorderRadius(
                        topLeft: 12,
                        topRight: 12,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'HIDDEN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: context.appEdgeInsets(all: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reel.title,
                  style: context.fonts.black14w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                context.verticalSpace(4),
                Text(
                  reel.description ?? '',
                  style: context.fonts.grey12w400,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                context.verticalSpace(8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: reel.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: CustomColors.lightPurple.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(tag, style: context.fonts.purple9w800ls1),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _CircleActionBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

void _showDeleteConfirm(BuildContext context, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Delete'),
      content: const Text(
        'Are you sure you want to delete this item? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: CustomColors.red),
          ),
        ),
      ],
    ),
  );
}

class _CommunityTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreViewModelProvider);

    if (state.loading) {
      return const Center(child: AppLoader());
    }

    if (state.posts.isEmpty) {
      return Center(
        child: Text(
          'No community posts available',
          style: context.fonts.grey14w400,
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: state.posts.length,
            separatorBuilder: (context, index) => context.verticalSpace(16),
            itemBuilder: (context, index) =>
                _PostListItem(post: state.posts[index]),
          ),
        ),
        if (state.postsTotalPages > 1)
          Padding(
            padding: context.appEdgeInsets(vertical: 24),
            child: NumberPaginator(
              totalPages: state.postsTotalPages,
              currentPage: state.postsCurrentPage - 1,
              onPageChanged: (pageIndex) {
                ref
                    .read(exploreViewModelProvider.notifier)
                    .fetchPosts(page: pageIndex + 1);
              },
            ),
          ),
      ],
    );
  }
}

class _PostListItem extends ConsumerWidget {
  final CommunityPostModel post;
  const _PostListItem({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHidden = post.status != 'Active';
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 16),
      child: Opacity(
        opacity: isHidden ? 0.6 : 1.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: context.w(120),
              height: context.h(120),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 8),
              ),
              child: post.imageUrl != null && post.imageUrl!.isNotEmpty
                  ? AppNetworkImage(imageUrl: post.imageUrl!, fit: BoxFit.cover)
                  : const Icon(Icons.image_outlined, color: CustomColors.grey),
            ),
            context.horizontalSpace(16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LogoAndNameWidget(
                    profileName: post.profileName ?? 'N/A',
                    profileLogo: post.profileLogo ?? '',
                  ),

                  context.verticalSpace(8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(post.title, style: context.fonts.black16w600),
                          if (isHidden) ...[
                            context.horizontalSpace(8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: CustomColors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'HIDDEN',
                                style: context.fonts.white10w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),

                  context.verticalSpace(8),

                  Text(
                    post.content,
                    style: context.fonts.grey14w400,
                    // maxLines: 2,
                    // overflow: TextOverflow.ellipsis,
                  ),

                  context.verticalSpace(8),

                  Wrap(
                    spacing: 8,
                    children: post.tags
                        .map(
                          (tag) =>
                              Text('#$tag', style: context.fonts.purple11w600),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),

            context.horizontalSpace(16),
            Column(
              children: [
                if (post.category != null && post.category!.isNotEmpty)
                  Container(
                    padding: context.appEdgeInsets(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: CustomColors.purple.withValues(alpha: 0.1),
                      borderRadius: context.appBorderRadius(all: 4),
                    ),
                    child: Text(
                      post.category!,
                      style: context.fonts.purple11w600,
                    ),
                  ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    isHidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: CustomColors.purple,
                  ),
                  onPressed: () {
                    if (post.id != null) {
                      ref
                          .read(exploreViewModelProvider.notifier)
                          .togglePostVisibility(post.id!, post.status);
                    }
                  },
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: CustomColors.red,
                  ),
                  onPressed: () {
                    if (post.id != null) {
                      _showDeleteConfirm(context, () {
                        ref
                            .read(exploreViewModelProvider.notifier)
                            .deletePost(post.id!);
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
