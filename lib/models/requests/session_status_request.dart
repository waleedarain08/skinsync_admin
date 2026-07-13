class SessionStatusRequest {
  final int? sessionId;
  final String? status;

  SessionStatusRequest({this.sessionId, this.status});

  Map<String, dynamic> toJson() => {"session_id": sessionId, "status": status};
}
