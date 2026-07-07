import 'package:skinsync_admin/utils/enums.dart';

class PhotoMilestone {
  final int numberOfDays;
  final int requiredPhotos;

  const PhotoMilestone({
    required this.numberOfDays,
    required this.requiredPhotos,
  });

  Map<String, dynamic> toJson() {
    return {
      'number_of_days': numberOfDays,
      'required_photos': requiredPhotos,
    };
  }
}

class PostPhotosRequest {
  final bool requirePostTreatmentPhotos;
  final List<PhotoMilestone> photoMilestone;

  const PostPhotosRequest({
    required this.requirePostTreatmentPhotos,
    required this.photoMilestone,
  });

  Map<String, dynamic> toJson() {
    return {
      'step_number': 7,
      'keys': [CreateTreatmentSteps.postTreatmentPhotos.name],
      'require_post_treatment_photos': requirePostTreatmentPhotos,
      'photo_milestone': photoMilestone.map((m) => m.toJson()).toList(),
    };
  }
}