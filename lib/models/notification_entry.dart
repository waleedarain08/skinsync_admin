import 'package:flutter/material.dart';
import 'common_models.dart';

class NotificationEntry {
  final TextEditingController titleController;
  final TextEditingController messageController;
  final TextEditingController timingValueController;
  String timingUnit; // minutes | hours | days
  String type; // reminder | care | etc.

  NotificationEntry({
    required this.titleController,
    required this.messageController,
    required this.timingValueController,
    required this.timingUnit,
    required this.type,
  });

  NotificationConfig toConfig() {
    final int? val = int.tryParse(timingValueController.text);
    return NotificationConfig(
      title: titleController.text,
      message: messageController.text,
      timing: val,
      timingUnit: timingUnit,
      type: type,
    );
  }

  void dispose() {
    titleController.dispose();
    messageController.dispose();
    timingValueController.dispose();
  }
}
