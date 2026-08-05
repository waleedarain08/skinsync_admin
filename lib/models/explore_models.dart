class ReelModel {
  final int? id;
  final String title;
  final String? description;
  final String videoUrl;
  final String? thumbnail;
  final List<String> tags;
  final DateTime? createdAt;

  ReelModel({
    this.id,
    required this.title,
    this.description,
    required this.videoUrl,
    this.thumbnail,
    this.tags = const [],
    this.createdAt,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'],
      videoUrl: json['video_url'] ?? '',
      thumbnail: json['thumbnail'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

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

class CommunityPostModel {
  final int? id;
  final String title;
  final String content;
  final String? imageUrl;
  final String? category;
  final List<String> tags;
  final DateTime? createdAt;

  CommunityPostModel({
    this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.category,
    this.tags = const [],
    this.createdAt,
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    return CommunityPostModel(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      category: json['category'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'category': category,
      'tags': tags,
    };
  }
}
