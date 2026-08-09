import '../models/requests/community_post_request.dart';
import '../models/requests/reel_request.dart';
import '../models/responses/community_posts_list_response.dart';
import '../models/responses/post_category_list_response.dart';
import '../models/responses/reels_list_response.dart';
import '../repositories/explore_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';

class ExploreService implements ExploreRepository {
  final ApiBaseHelper _api = ApiBaseHelper();

  @override
  Future<ReelsListResponse> fetchReels({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final response = await _api.get(
      Endpoint.explorerReels,
      queryParams: queryParams,
    );
    return ReelsListResponse.fromJson(response);
  }

  @override
  Future<void> createReel(CreateReelRequest reel) async {
    await _api.post(Endpoint.explorerReels, body: reel.toJson());
  }

  @override
  Future<void> updateReelStatus(int id, String status) async {
    await _api.put(
      Endpoint.updateReel,
      pathParams: {'id': id.toString()},
      body: {'status': status},
    );
  }

  @override
  Future<void> deleteReel(int id) async {
    await _api.delete(
      Endpoint.deleteReel,
      pathParams: {'id': id.toString()},
    );
  }

  @override
  Future<CommunityPostsListResponse> fetchPosts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
  }) async {
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (category != null && category.isNotEmpty) queryParams['category'] = category;

    final response = await _api.get(
      Endpoint.explorerCommunity,
      queryParams: queryParams,
    );
    return CommunityPostsListResponse.fromJson(response);
  }

  @override
  Future<void> createPost(CreateCommunityPostRequest post) async {
    await _api.post(Endpoint.explorerCommunity, body: post.toJson());
  }

  @override
  Future<void> updatePostStatus(int id, String status) async {
    await _api.put(
      Endpoint.updatePost,
      pathParams: {'id': id.toString()},
      body: {'status': status},
    );
  }

  @override
  Future<void> deletePost(int id) async {
    await _api.delete(
      Endpoint.deletePost,
      pathParams: {'id': id.toString()},
    );
  }

  @override
  Future<List<PostCategoryModel>> fetchPostCategories() async {
    final response = await _api.get(Endpoint.postCategories);
    return PostCategoryListResponse.fromJson(response).data ?? [];
  }

  @override
  Future<void> createPostCategory(String name) async {
    await _api.post(Endpoint.postCategories, body: {'name': name});
  }
}
