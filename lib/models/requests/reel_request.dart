class CreateReelRequest {
  final String title;
  final String? description;
  final String videoUrl;
  final String? thumbnail;
  final List<String> tags;

  CreateReelRequest({
    required this.title,
    this.description,
    required this.videoUrl,
    this.thumbnail,
    this.tags = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'video_url': videoUrl,
      'thumbnail': thumbnail,
      'tags': tags,
    };
  }
}
