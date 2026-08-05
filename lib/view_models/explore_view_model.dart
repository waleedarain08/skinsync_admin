import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/models/explore_models.dart';
import 'package:skinsync_admin/models/requests/community_post_request.dart';
import 'package:skinsync_admin/models/requests/reel_request.dart';
import 'package:skinsync_admin/repositories/explore_repository.dart';
import 'package:skinsync_admin/services/locator.dart';
import 'package:skinsync_admin/services/media_service.dart';
import 'package:skinsync_admin/utils/exception.dart';
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
  final String? pickedImageUrl;
  final String? pickedVideoUrl;
  final String? pickedThumbnailUrl;

  ExploreState({
    super.loading = false,
    this.reels = const [],
    this.posts = const [],
    this.reelsTotalPages = 1,
    this.postsTotalPages = 1,
    this.reelsCurrentPage = 1,
    this.postsCurrentPage = 1,
    this.pageSize = 20,
    this.pickedImageUrl,
    this.pickedVideoUrl,
    this.pickedThumbnailUrl,
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
    String? pickedImageUrl,
    String? pickedVideoUrl,
    String? pickedThumbnailUrl,
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
      pickedImageUrl: pickedImageUrl ?? this.pickedImageUrl,
      pickedVideoUrl: pickedVideoUrl ?? this.pickedVideoUrl,
      pickedThumbnailUrl: pickedThumbnailUrl ?? this.pickedThumbnailUrl,
    );
  }

  ExploreState clearFiles() {
    return ExploreState(
      loading: loading,
      reels: reels,
      posts: posts,
      reelsTotalPages: reelsTotalPages,
      postsTotalPages: postsTotalPages,
      reelsCurrentPage: reelsCurrentPage,
      postsCurrentPage: postsCurrentPage,
      pageSize: pageSize,
      pickedImageUrl: null,
      pickedVideoUrl: null,
      pickedThumbnailUrl: null,
    );
  }
}

class ExploreViewModel extends BaseViewModel<ExploreState> {
  ExploreViewModel() : super(ExploreState());

  final ExploreRepository _repository = locator<ExploreRepository>();
  final ImagePicker _picker = ImagePicker();
  final MediaService _mediaService = MediaService();

  Future<void> fetchReels({int page = 1}) async {
    await runSafely(
      showLoading: false,
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
      showLoading: false,
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

  Future<void> pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    await runSafely(
      showLoading: false,
      onLoadingChange: (l) => state = state.copyWith(loading: l),
      () async {
        final String? url = await _mediaService.uploadImage('explore/posts/', image);
        if (url == null) {
          throw const UnknownException('Failed to upload image');
        }
        state = state.copyWith(pickedImageUrl: url);
      },
    );
  }

  Future<void> pickAndUploadThumbnail() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    await runSafely(
      showLoading: false,
      onLoadingChange: (l) => state = state.copyWith(loading: l),
      () async {
        final String? url = await _mediaService.uploadImage('explore/reels/thumbnails/', image);
        if (url == null) {
          throw const UnknownException('Failed to upload thumbnail');
        }
        state = state.copyWith(pickedThumbnailUrl: url);
      },
    );
  }

  Future<void> pickAndUploadVideo() async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );
    
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;

    await runSafely(
      showLoading: false,
      onLoadingChange: (l) => state = state.copyWith(loading: l),
      () async {
        final String? url = await _mediaService.uploadFile('explore/reels/', file);
        if (url == null) {
          throw const UnknownException('Failed to upload video');
        }
        state = state.copyWith(pickedVideoUrl: url);
      },
    );
  }

  void clearPickedFiles() {
    state = state.clearFiles();
  }

  Future<bool> createReel(CreateReelRequest reel) async {
    return await runSafely(
      onLoadingChange: (l) => state = state.copyWith(loading: l),
      () async {
        await _repository.createReel(reel);
        EasyLoading.showSuccess('Reel created successfully');
        clearPickedFiles();
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
        clearPickedFiles();
        await fetchPosts();
        return true;
      },
    ) ?? false;
  }

  Future<void> toggleReelVisibility(int id, String currentStatus) async {
    final newStatus = currentStatus == 'Active' ? 'In Active' : 'Active';
    await runSafely(
      showLoading: false,
      onLoadingChange: (l) => state = state.copyWith(loading: l),
      () async {
        await _repository.updateReelStatus(id, newStatus);
        EasyLoading.showSuccess('Reel status updated to $newStatus');
        await fetchReels(page: state.reelsCurrentPage);
      },
    );
  }

  Future<void> deleteReel(int id) async {
    await runSafely(
      showLoading: false,
      onLoadingChange: (l) => state = state.copyWith(loading: l),
      () async {
        await _repository.deleteReel(id);
        EasyLoading.showSuccess('Reel deleted successfully');
        await fetchReels(page: state.reelsCurrentPage);
      },
    );
  }

  Future<void> togglePostVisibility(int id, String currentStatus) async {
    final newStatus = currentStatus == 'Active' ? 'In Active' : 'Active';
    await runSafely(
      showLoading: false,
      onLoadingChange: (l) => state = state.copyWith(loading: l),
      () async {
        await _repository.updatePostStatus(id, newStatus);
        EasyLoading.showSuccess('Post status updated to $newStatus');
        await fetchPosts(page: state.postsCurrentPage);
      },
    );
  }

  Future<void> deletePost(int id) async {
    await runSafely(
      showLoading: false,
      onLoadingChange: (l) => state = state.copyWith(loading: l),
      () async {
        await _repository.deletePost(id);
        EasyLoading.showSuccess('Post deleted successfully');
        await fetchPosts(page: state.postsCurrentPage);
      },
    );
  }
}
