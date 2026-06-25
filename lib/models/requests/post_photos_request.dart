class PostPhotosRequest {
  final bool requirePostTreatmentPhotos;
  final int requiredPostTreatmentPhotoCount;

  const PostPhotosRequest({
    required this.requirePostTreatmentPhotos,
    required this.requiredPostTreatmentPhotoCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'step_number': 10,
      'require_post_treatment_photos': requirePostTreatmentPhotos,
      'required_post_treatment_photo_count': requiredPostTreatmentPhotoCount,
    };
  }
}
