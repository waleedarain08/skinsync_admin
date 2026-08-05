import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/explore_models.dart';
import 'package:skinsync_admin/models/requests/community_post_request.dart';
import 'package:skinsync_admin/models/requests/reel_request.dart';
import 'package:skinsync_admin/repositories/explore_repository.dart';
import 'package:skinsync_admin/services/locator.dart';
import 'package:skinsync_admin/view_models/base_state_model.dart';
import 'package:skinsync_admin/view_models/base_view_model.dart';

final exploreViewModelProvider = NotifierProvider<ExploreViewModel, ExploreState>(ExploreViewModel.new);

class ExploreState extends BaseStateModel {
  final List<ReelModel> reels;
  final List<CommunityPostModel> posts;
  final int reelsTotalPages;
  final int postsTotalPages;
  final int reelsCurrentPage;
  final int postsCurrentPage;
  final int pageSize;

  ExploreState({
    super.loading = false,
    this.reels = const [],
    this.posts = const [],
    this.reelsTotalPages = 1,
    this.postsTotalPages = 1,
    this.reelsCurrentPage = 1,
    this.postsCurrentPage = 1,
    this.pageSize = 20,
  });

  ExploreState copyWith({
    bool? loading,
    List<ReelModel>? reels,
    List<CommunityPostModel>? posts,
    int? reelsTotalPages,
    int? postsTotalPages,
    int? reelsCurrentPage,
    int? postsCurrentPage,
    int? pageSize,
  }) {
    return ExploreState(
      loading: loading ?? this.loading,
      reels: reels ?? this.reels,
      posts: posts ?? this.posts,
      reelsTotalPages: reelsTotalPages ?? this.reelsTotalPages,
      postsTotalPages: postsTotalPages ?? this.postsTotalPages,
      reelsCurrentPage: reelsCurrentPage ?? this.reelsCurrentPage,
      postsCurrentPage: postsCurrentPage ?? this.postsCurrentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

class ExploreViewModel extends BaseViewModel<ExploreState> {
  ExploreViewModel() : super(ExploreState());

  final ExploreRepository _repository = locator<ExploreRepository>();

  Future<void> fetchReels({int page = 1}) async {
    await runSafely(
      onLoadingChange: (l) => state = state.copyWith(loading: l),
      () async {
        final response = await _repository.fetchReels(page: page, limit: state.pageSize);
        state = state.copyWith(
          reels: response.data ?? [],
          reelsTotalPages: response.totalPages,
          reelsCurrentPage: response.page,
        );
      },
    );
  }

  Future<void> fetchPosts({int page = 1}) async {
    await runSafely(
      onLoadingChange: (l) => state = state.copyWith(loading: l),
      () async {
        final response = await _repository.fetchPosts(page: page, limit: state.pageSize);
        state = state.copyWith(
          posts: response.data ?? [],
          postsTotalPages: response.totalPages,
          postsCurrentPage: response.page,
        );
      },
    );
  }

  Future<bool> createReel(CreateReelRequest reel) async {
    return await runSafely(
      onLoadingChange: (l) => state = state.copyWith(loading: l),
      () async {
        await _repository.createReel(reel);
        EasyLoading.showSuccess('Reel created successfully');
        await fetchReels();
        return true;
      },
    ) ?? false;
  }

  Future<bool> createPost(CreateCommunityPostRequest post) async {
    return await runSafely(
      onLoadingChange: (l) => state = state.copyWith(loading: l),
      () async {
        await _repository.createPost(post);
        EasyLoading.showSuccess('Post created successfully');
        await fetchPosts();
        return true;
      },
    ) ?? false;
  }
}
