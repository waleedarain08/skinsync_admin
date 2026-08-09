class CreateCommunityPostRequest {
  final String title;
  final String content;
  final String? imageUrl;
  final String? category;
  final List<String> tags;

  CreateCommunityPostRequest({
    required this.title,
    required this.content,
    this.imageUrl,
    this.category,
    this.tags = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'category_name': category,
      'tags': tags,
    };
  }
}
