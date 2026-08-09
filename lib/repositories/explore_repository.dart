import '../models/requests/community_post_request.dart';
import '../models/requests/reel_request.dart';
import '../models/responses/community_posts_list_response.dart';
import '../models/responses/post_category_list_response.dart';
import '../models/responses/reels_list_response.dart';

abstract class ExploreRepository {
  Future<ReelsListResponse> fetchReels({
    int page = 1,
    int limit = 20,
    String? search,
  });
  Future<void> createReel(CreateReelRequest reel);
  Future<void> updateReelStatus(int id, String status);
  Future<void> deleteReel(int id);
  Future<CommunityPostsListResponse> fetchPosts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
  });
  Future<void> createPost(CreateCommunityPostRequest post);
  Future<void> updatePostStatus(int id, String status);
  Future<void> deletePost(int id);
  Future<List<PostCategoryModel>> fetchPostCategories();
  Future<void> createPostCategory(String name);
}
