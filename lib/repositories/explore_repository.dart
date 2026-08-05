import '../models/requests/community_post_request.dart';
import '../models/requests/reel_request.dart';
import '../models/responses/community_posts_list_response.dart';
import '../models/responses/reels_list_response.dart';

abstract class ExploreRepository {
  Future<ReelsListResponse> fetchReels({int page = 1, int limit = 20});
  Future<void> createReel(CreateReelRequest reel);
  Future<CommunityPostsListResponse> fetchPosts({int page = 1, int limit = 20});
  Future<void> createPost(CreateCommunityPostRequest post);
}
