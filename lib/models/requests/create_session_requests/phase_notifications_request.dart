import 'dart:convert';

import 'package:skinsync_admin/utils/enums.dart';

class PhaseNotificationsRequest {
   
    final int? stepNumber;
    final PreNoti? preNoti;
    final PostNoti? postNoti;

    PhaseNotificationsRequest({
       
        this.stepNumber,
        this.preNoti,
        this.postNoti,
    });


    Map<String, dynamic> toJson() => {
      'step_number': stepNumber,
    'keys': [CreateTreatmentSteps.phaseNotifications.name],
       
        'pre_noti': preNoti?.toJson(),
        'post_noti': postNoti?.toJson(),
    };
}

class PostNoti {
    final bool? isCatDefault;
    final List<PhaseNotification>? postNotifications;

    PostNoti({
        this.isCatDefault,
        this.postNotifications,
    });

    factory PostNoti.fromRawJson(String str) => PostNoti.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PostNoti.fromJson(Map<String, dynamic> json) => PostNoti(
        isCatDefault: json['is_cat_default'],
        postNotifications: json['post_notifications'] == null ? [] : List<PhaseNotification>.from(json['post_notifications']!.map((x) => PhaseNotification.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'is_cat_default': isCatDefault,
        'post_notifications': postNotifications == null ? [] : List<dynamic>.from(postNotifications!.map((x) => x.toJson())),
    };
}

class PhaseNotification {
    final String? title;
    final String? message;
    final int? timing;
    final String? timingUnit;
    final String? type;

    PhaseNotification({
        this.title,
        this.message,
        this.timing,
        this.timingUnit,
        this.type,
    });

    factory PhaseNotification.fromRawJson(String str) => PhaseNotification.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PhaseNotification.fromJson(Map<String, dynamic> json) => PhaseNotification(
        title: json['title'],
        message: json['message'],
        timing: json['timing'],
        timingUnit: json['timing_unit'],
        type: json['type'],
    );

    Map<String, dynamic> toJson() => {
        'title': title,
        'message': message,
        'timing': timing,
        'timing_unit': timingUnit,
        'type': type,
    };
}

class PreNoti {
    final bool? isCatDefault;
    final List<PhaseNotification>? preNotifications;

    PreNoti({
        this.isCatDefault,
        this.preNotifications,
    });

    factory PreNoti.fromRawJson(String str) => PreNoti.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PreNoti.fromJson(Map<String, dynamic> json) => PreNoti(
        isCatDefault: json['is_cat_default'],
        preNotifications: json['pre_notifications'] == null ? [] : List<PhaseNotification>.from(json['pre_notifications']!.map((x) => PhaseNotification.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'is_cat_default': isCatDefault,
        'pre_notifications': preNotifications == null ? [] : List<dynamic>.from(preNotifications!.map((x) => x.toJson())),
    };
}
