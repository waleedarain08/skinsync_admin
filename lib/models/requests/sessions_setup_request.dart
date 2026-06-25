class SessionsSetupRequest {
  final int totalSessions;

  const SessionsSetupRequest({required this.totalSessions});

  Map<String, dynamic> toJson() {
    return {'step_number': 14, 'total_sessions': totalSessions};
  }
}
