class SendNotesRequest {
  final String notes;

  SendNotesRequest({required this.notes});

  Map<String, dynamic> toJson() {
    return {
      'notes': notes,
    };
  }
}
