class CreateBenefitRequest {
  final String sku;
  final String title;
  final String description;

  CreateBenefitRequest({
    required this.sku,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'title': title,
      'description': description,
    };
  }
}
