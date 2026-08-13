import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/utils/exception.dart';

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
  Future<BaseApiResponseModel> createReel(CreateReelRequest reel) async {
    final jsonResponse = await _api.post(
      Endpoint.explorerReels,
      body: reel.toJson(),
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!(response.isSuccess)) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> updateReelStatus(int id, String status) async {
    final jsonResponse = await _api.put(
      Endpoint.updateReel,
      pathParams: {'id': id.toString()},
      body: {'status': status},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!(response.isSuccess)) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> deleteReel(int id) async {
    final jsonResponse = await _api.delete(
      Endpoint.deleteReel,
      pathParams: {'id': id.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!(response.isSuccess)) {
      throw BadRequestException(response.message);
    }
    return response;
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
    if (category != null && category.isNotEmpty)
      queryParams['category'] = category;

    final response = await _api.get(
      Endpoint.explorerCommunity,
      queryParams: queryParams,
    );
    return CommunityPostsListResponse.fromJson(response);
  }

  @override
  Future<BaseApiResponseModel> createPost(
    CreateCommunityPostRequest post,
  ) async {
    final jsonResponse = await _api.post(
      Endpoint.explorerCommunity,
      body: post.toJson(),
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!(response.isSuccess)) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> updatePostStatus(int id, String status) async {
    final jsonResponse = await _api.patch(
      Endpoint.updatePost,
      pathParams: {'id': id.toString()},
      body: {'status': status},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!(response.isSuccess)) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> deletePost(int id) async {
    final jsonResponse = await _api.delete(
      Endpoint.deletePost,
      pathParams: {'id': id.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!(response.isSuccess)) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<List<PostCategoryModel>> fetchPostCategories() async {
    final response = await _api.get(Endpoint.postCategories);
    return PostCategoryListResponse.fromJson(response).data ?? [];
  }

  @override
  Future<BaseApiResponseModel> createPostCategory(String name) async {
    final jsonResponse = await _api.post(
      Endpoint.postCategories,
      body: {'name': name},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!(response.isSuccess)) {
      throw BadRequestException(response.message);
    }
    return response;
  }
}
