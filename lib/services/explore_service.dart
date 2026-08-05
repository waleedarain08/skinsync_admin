import '../models/requests/community_post_request.dart';
import '../models/requests/reel_request.dart';
import '../models/responses/community_posts_list_response.dart';
import '../models/responses/reels_list_response.dart';
import '../repositories/explore_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';

class ExploreService implements ExploreRepository {
  final ApiBaseHelper _api = ApiBaseHelper();

  @override
  Future<ReelsListResponse> fetchReels({int page = 1, int limit = 20}) async {
    final response = await _api.get(
      Endpoint.explorerReels,
      queryParams: {'page': page.toString(), 'limit': limit.toString()},
    );
    return ReelsListResponse.fromJson(response);
  }

  @override
  Future<void> createReel(CreateReelRequest reel) async {
    await _api.post(Endpoint.explorerReels, body: reel.toJson());
  }

  @override
  Future<CommunityPostsListResponse> fetchPosts({int page = 1, int limit = 20}) async {
    final response = await _api.get(
      Endpoint.explorerCommunity,
      queryParams: {'page': page.toString(), 'limit': limit.toString()},
    );
    return CommunityPostsListResponse.fromJson(response);
  }

  @override
  Future<void> createPost(CreateCommunityPostRequest post) async {
    await _api.post(Endpoint.explorerCommunity, body: post.toJson());
  }
}
