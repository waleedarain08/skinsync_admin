import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/explore_models.dart';
import 'package:skinsync_admin/models/requests/community_post_request.dart';
import 'package:skinsync_admin/models/requests/reel_request.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/explore_view_model.dart';
import 'package:skinsync_admin/widgets/app_page_header.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/number_paginator.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});
  static const String routeName = '/explore';

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(exploreViewModelProvider.notifier).fetchReels();
      ref.read(exploreViewModelProvider.notifier).fetchPosts();
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
              subtitle: 'Manage community posts and video reels for the consumer application.',
              actions: [
                CustomPrimaryButton(
                  onTap: () => _showAddDialog(context),
                  icon: Icons.add_circle_outline,
                  label: _tabController.index == 0 ? 'Add New Reel' : 'Add New Post',
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
                children: [
                  _ReelsTab(),
                  _CommunityTab(),
                ],
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
    final videoUrlController = TextEditingController();
    final tagsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Reel', style: context.fonts.black20w600),
        content: SizedBox(
          width: context.w(500),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BuildTextField(label: 'Title', controller: titleController, hintText: 'Enter reel title'),
                context.verticalSpace(16),
                BuildTextField(label: 'Description', controller: descController, hintText: 'Enter reel description', maxLines: 3),
                context.verticalSpace(16),
                BuildTextField(label: 'Video URL', controller: videoUrlController, hintText: 'Enter video URL'),
                context.verticalSpace(16),
                BuildTextField(label: 'Tags (comma separated)', controller: tagsController, hintText: 'e.g. skin, care, routine'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: context.fonts.grey14w600)),
          CustomPrimaryButton(
            label: 'Create Reel',
            width: context.w(120),
            onTap: () {
              final reel = CreateReelRequest(
                title: titleController.text,
                description: descController.text,
                videoUrl: videoUrlController.text,
                tags: tagsController.text.split(',').map((e) => e.trim()).toList(),
              );
              ref.read(exploreViewModelProvider.notifier).createReel(reel).then((success) {
                if (success) Navigator.pop(context);
              });
            },
          ),
        ],
      ),
    );
  }

  void _showAddPostDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final imageUrlController = TextEditingController();
    final categoryController = TextEditingController();
    final tagsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Community Post', style: context.fonts.black20w600),
        content: SizedBox(
          width: context.w(500),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BuildTextField(label: 'Title', controller: titleController, hintText: 'Enter post title'),
                context.verticalSpace(16),
                BuildTextField(label: 'Content', controller: contentController, hintText: 'Enter post content', maxLines: 5),
                context.verticalSpace(16),
                BuildTextField(label: 'Image URL', controller: imageUrlController, hintText: 'Enter image URL'),
                context.verticalSpace(16),
                BuildTextField(label: 'Category', controller: categoryController, hintText: 'Enter category'),
                context.verticalSpace(16),
                BuildTextField(label: 'Tags (comma separated)', controller: tagsController, hintText: 'e.g. advice, community, help'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: context.fonts.grey14w600)),
          CustomPrimaryButton(
            label: 'Create Post',
            width: context.w(120),
            onTap: () {
              final post = CreateCommunityPostRequest(
                title: titleController.text,
                content: contentController.text,
                imageUrl: imageUrlController.text,
                category: categoryController.text,
                tags: tagsController.text.split(',').map((e) => e.trim()).toList(),
              );
              ref.read(exploreViewModelProvider.notifier).createPost(post).then((success) {
                if (success) Navigator.pop(context);
              });
            },
          ),
        ],
      ),
    );
  }
}

class _ReelsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreViewModelProvider);
    
    if (state.loading && state.reels.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: CustomColors.purple));
    }

    if (state.reels.isEmpty) {
       return _buildDummyReels(context);
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
            itemBuilder: (context, index) => _ReelCard(reel: state.reels[index]),
          ),
        ),
        if (state.reelsTotalPages > 1)
          Padding(
            padding: context.appEdgeInsets(vertical: 24),
            child: NumberPaginator(
              totalPages: state.reelsTotalPages,
              currentPage: state.reelsCurrentPage - 1,
              onPageChanged: (pageIndex) {
                ref.read(exploreViewModelProvider.notifier).fetchReels(page: pageIndex + 1);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildDummyReels(BuildContext context) {
    final List<ReelModel> dummyReels = [
      ReelModel(title: 'Morning Routine', description: 'Essential morning skin care', videoUrl: '', tags: ['skincare', 'morning']),
      ReelModel(title: 'Acne Treatment', description: 'How to deal with acne', videoUrl: '', tags: ['acne', 'health']),
      ReelModel(title: 'Glow Up Tips', description: 'Get that natural glow', videoUrl: '', tags: ['beauty', 'glow']),
      ReelModel(title: 'Night Care', description: 'Restorative night routine', videoUrl: '', tags: ['night', 'care']),
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: context.w(20),
        mainAxisSpacing: context.h(20),
        childAspectRatio: 0.75,
      ),
      itemCount: dummyReels.length,
      itemBuilder: (context, index) => _ReelCard(reel: dummyReels[index]),
    );
  }
}

class _ReelCard extends StatelessWidget {
  final ReelModel reel;
  const _ReelCard({required this.reel});

  @override
  Widget build(BuildContext context) {
    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: CustomColors.lightPurple.withValues(alpha: 0.3),
                borderRadius: context.appBorderRadius(topLeft: 12, topRight: 12),
              ),
              child: const Center(child: Icon(Icons.play_circle_outline, size: 48, color: CustomColors.purple)),
            ),
          ),
          Padding(
            padding: context.appEdgeInsets(all: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reel.title, style: context.fonts.black14w600, maxLines: 1, overflow: TextOverflow.ellipsis),
                context.verticalSpace(4),
                Text(reel.description ?? '', style: context.fonts.grey12w400, maxLines: 2, overflow: TextOverflow.ellipsis),
                context.verticalSpace(8),
                Wrap(
                  spacing: 4,
                  children: reel.tags.map((tag) => Chip(
                    label: Text(tag, style: context.fonts.purple9w800ls1),
                    backgroundColor: CustomColors.lightPurple.withValues(alpha: 0.2),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreViewModelProvider);
    
    if (state.loading && state.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: CustomColors.purple));
    }

    if (state.posts.isEmpty) {
      return _buildDummyPosts(context);
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: state.posts.length,
            separatorBuilder: (context, index) => context.verticalSpace(16),
            itemBuilder: (context, index) => _PostListItem(post: state.posts[index]),
          ),
        ),
        if (state.postsTotalPages > 1)
          Padding(
            padding: context.appEdgeInsets(vertical: 24),
            child: NumberPaginator(
              totalPages: state.postsTotalPages,
              currentPage: state.postsCurrentPage - 1,
              onPageChanged: (pageIndex) {
                ref.read(exploreViewModelProvider.notifier).fetchPosts(page: pageIndex + 1);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildDummyPosts(BuildContext context) {
    final List<CommunityPostModel> dummyPosts = [
      CommunityPostModel(title: 'My Journey with Rosacea', content: 'Sharing my personal experience and what worked for me...', category: 'Experience', tags: ['rosacea', 'support']),
      CommunityPostModel(title: 'Best Sunscreens 2024', content: 'A comprehensive guide to picking the right sunscreen...', category: 'Guide', tags: ['sunscreen', 'protection']),
      CommunityPostModel(title: 'Diet and Skin Health', content: 'How what you eat affects your skin texture and clarity...', category: 'Health', tags: ['diet', 'glow']),
    ];

    return ListView.separated(
      itemCount: dummyPosts.length,
      separatorBuilder: (context, index) => context.verticalSpace(16),
      itemBuilder: (context, index) => _PostListItem(post: dummyPosts[index]),
    );
  }
}

class _PostListItem extends StatelessWidget {
  final CommunityPostModel post;
  const _PostListItem({required this.post});

  @override
  Widget build(BuildContext context) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.w(120),
            height: context.h(80),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 8),
            ),
            child: const Icon(Icons.image_outlined, color: CustomColors.grey),
          ),
          context.horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(post.title, style: context.fonts.black16w600),
                    if (post.category != null)
                      Container(
                        padding: context.appEdgeInsets(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: CustomColors.purple.withValues(alpha: 0.1),
                          borderRadius: context.appBorderRadius(all: 4),
                        ),
                        child: Text(post.category!, style: context.fonts.purple11w600),
                      ),
                  ],
                ),
                context.verticalSpace(8),
                Text(post.content, style: context.fonts.grey14w400, maxLines: 2, overflow: TextOverflow.ellipsis),
                context.verticalSpace(8),
                Wrap(
                  spacing: 8,
                  children: post.tags.map((tag) => Text('#$tag', style: context.fonts.purple11w600)).toList(),
                ),
              ],
            ),
          ),
          context.horizontalSpace(16),
          Column(
            children: [
              IconButton(icon: const Icon(Icons.edit_outlined, color: CustomColors.purple), onPressed: () {}),
              IconButton(icon: const Icon(Icons.delete_outline, color: CustomColors.red), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
