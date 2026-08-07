class SendNotesRequest {
  final String email;
  final String notes;

  SendNotesRequest({
    required this.email,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'notes': notes,
    };
  }
}
