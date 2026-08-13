import '../models/requests/community_post_request.dart';
import '../models/requests/reel_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/community_posts_list_response.dart';
import '../models/responses/post_category_list_response.dart';
import '../models/responses/reels_list_response.dart';

abstract class ExploreRepository {
  Future<ReelsListResponse> fetchReels({
    int page = 1,
    int limit = 20,
    String? search,
  });
  Future<BaseApiResponseModel> createReel(CreateReelRequest reel);
  Future<BaseApiResponseModel> updateReelStatus(int id, String status);
  Future<BaseApiResponseModel> deleteReel(int id);
  Future<CommunityPostsListResponse> fetchPosts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
  });
  Future<BaseApiResponseModel> createPost(CreateCommunityPostRequest post);
  Future<BaseApiResponseModel> updatePostStatus(int id, String status);
  Future<BaseApiResponseModel> deletePost(int id);
  Future<List<PostCategoryModel>> fetchPostCategories();
  Future<BaseApiResponseModel> createPostCategory(String name);
}
