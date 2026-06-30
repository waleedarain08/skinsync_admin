import 'package:skinsync_admin/utils/enums.dart';

class PostPhotosRequest {
  final bool requirePostTreatmentPhotos;
  final int requiredPostTreatmentPhotoCount;

  const PostPhotosRequest({
    required this.requirePostTreatmentPhotos,
    required this.requiredPostTreatmentPhotoCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'keys': [CreateTreatmentSteps.postTreatmentPhotos.name],
      'require_post_treatment_photos': requirePostTreatmentPhotos,
      'required_post_treatment_photo_count': requiredPostTreatmentPhotoCount,
    };
  }
}
