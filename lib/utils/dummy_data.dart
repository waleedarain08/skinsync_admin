class TreatmentData {
  static const Map<String, List<String>> categoriesWithSubcategories = {
    "Injectables": [
      "Neurotoxins",
      "Dermal Fillers",
    ],
    "Skin Treatments": [
      "Facials",
      "Chemical Peels",
    ],
    "Laser & Energy": [
      "Resurfacing",
      "Tightening",
    ],
  };

  static List<String> get categories => categoriesWithSubcategories.keys.toList();

  static List<String> getSubcategories(String category) {
    return categoriesWithSubcategories[category] ?? [];
  }

  static const List<String> suggestedAreas = [
    "Upper Face",
    "Mid Face",
    "Lower Face",
    "Neck",
    "Abdomen",
    "Arms",
    "Thighs",
    "Flanks",
  ];

  static const Map<String, List<String>> suggestedSubAreas = {
    "Upper Face": ["Forehead", "Glabella (Frown Lines)", "Crow's Feet"],
    "Mid Face": ["Cheeks", "Under Eye (Tear Trough)", "Nose"],
    "Lower Face": ["Lips", "Chin", "Jawline", "Marionette Lines"],
    "Neck": ["Neck Bands"],
  };

  static List<String> getSubAreas(String area) {
    return suggestedSubAreas[area] ?? [];
  }
}
