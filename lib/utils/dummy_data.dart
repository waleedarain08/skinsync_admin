import 'package:skinsync_admin/models/treatment_model.dart';

class TreatmentData {
  // Category Hierarchy (Simplified for now, UI will handle icon defaults)
  static const Map<String, List<String>> categoriesWithSubcategories = {
    "Injectables": ["Neurotoxins", "Dermal Fillers"],
    "Skin Treatments": ["Facials", "Chemical Peels"],
    "Laser & Energy": ["Resurfacing", "Tightening"],
  };

  static List<String> get categories => categoriesWithSubcategories.keys.toList();

  // Area Hierarchy
  static const Map<String, List<String>> areasWithSubAreas = {
    "Upper Face": ["Forehead", "Glabella (Frown Lines)", "Crow's Feet"],
    "Mid Face": ["Cheeks", "Under Eye (Tear Trough)", "Nose"],
    "Lower Face": ["Lips", "Chin", "Jawline", "Marionette Lines"],
    "Neck": ["Neck Bands"],
    "Abdomen": [],
    "Arms": [],
    "Thighs": [],
    "Flanks": [],
  };

  static List<String> get suggestedAreas => areasWithSubAreas.keys.toList();

  static List<String> getSubAreas(String area) {
    return areasWithSubAreas[area] ?? [];
  }

  // Consumable Types
  static const List<String> consumableTypes = [
    "Syringes",
    "Units",
    "Vials",
    "Threads",
    "Bottles",
    "Sessions",
    "ML",
    "Packs",
  ];

  static final List<TreatmentModel> dummyTreatments = [
    TreatmentModel(
      id: 1,
      name: "Botox Cosmetic",
      patientDisplayName: "Wrinkle Relaxer",
      description: "Smooth fine lines and wrinkles in the upper face.",
      shortDescription: "Anti-aging injectable treatment.",
      basePrice: 150.0,
      image: "https://images.unsplash.com/photo-1614850523296-d8c1af93d400?q=80&w=1000&auto=format&fit=crop",
      category: "Injectables",
      subcategory: "Neurotoxins",
      materialName: "Units",
      maxMaterialQuantity: 50,
      isActive: true,
      sideAreas: [
        SideAreaModel(
          name: "Upper Face",
          subAreas: [
            SubAreaModel(name: "Forehead", maxMaterialQuantity: 50, basePrice: 12.0),
            SubAreaModel(name: "Crow's Feet", maxMaterialQuantity: 24, basePrice: 12.0),
          ],
        ),
      ],
    ),
    TreatmentModel(
      id: 2,
      name: "Juvederm Voluma",
      patientDisplayName: "Cheek Filler",
      description: "Dermal filler for cheek augmentation.",
      shortDescription: "Volumizing dermal filler.",
      basePrice: 800.0,
      image: "https://images.unsplash.com/photo-1620331311520-246422ff83f9?q=80&w=1000&auto=format&fit=crop",
      category: "Injectables",
      subcategory: "Dermal Fillers",
      materialName: "Syringes",
      maxMaterialQuantity: 2,
      isActive: true,
      sideAreas: [
        SideAreaModel(
          name: "Mid Face",
          subAreas: [
            SubAreaModel(name: "Cheeks", maxMaterialQuantity: 2, basePrice: 800.0),
          ],
        ),
      ],
    ),
    TreatmentModel(
      id: 3,
      name: "HydraFacial",
      patientDisplayName: "Deep Cleansing Facial",
      description: "Cleanse, extract, and hydrate the skin.",
      shortDescription: "Refreshing skin treatment.",
      basePrice: 199.0,
      image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop",
      category: "Skin Treatments",
      subcategory: "Facials",
      isActive: false,
    ),
    TreatmentModel(
      id: 4,
      name: "Laser Hair Removal",
      patientDisplayName: "Permanent Hair Reduction",
      description: "Permanent hair reduction for smooth skin.",
      shortDescription: "Long-term hair removal.",
      basePrice: 250.0,
      image: "https://images.unsplash.com/photo-1512290923902-8a9f81dc2069?q=80&w=1000&auto=format&fit=crop",
      category: "Laser & Energy",
      subcategory: "Resurfacing",
      isActive: true,
      sideAreas: [
        SideAreaModel(
          name: "Body",
          subAreas: [
            SubAreaModel(name: "Arms", maxMaterialQuantity: 1, basePrice: 150.0),
            SubAreaModel(name: "Thighs", maxMaterialQuantity: 1, basePrice: 200.0),
          ],
        ),
      ],
    ),
    TreatmentModel(
      id: 5,
      name: "Chemical Peel",
      patientDisplayName: "Skin Resurfacing",
      description: "Exfoliate and improve skin texture.",
      shortDescription: "Chemical exfoliation treatment.",
      basePrice: 125.0,
      image: "https://images.unsplash.com/photo-1512290923902-8a9f81dc2069?q=80&w=1000&auto=format&fit=crop",
      category: "Skin Treatments",
      subcategory: "Chemical Peels",
      isActive: true,
    ),
    TreatmentModel(
      id: 6,
      name: "Microneedling",
      patientDisplayName: "Collagen Induction Therapy",
      description: "Stimulate collagen production for rejuvenation.",
      shortDescription: "Skin rejuvenation treatment.",
      basePrice: 350.0,
      image: "https://images.unsplash.com/photo-1616394584738-fc6e612e71b9?q=80&w=1000&auto=format&fit=crop",
      category: "Skin Treatments",
      subcategory: "Facials",
      isActive: true,
      sideAreas: [
        SideAreaModel(
          name: "Face",
          subAreas: [
            SubAreaModel(name: "Full Face", maxMaterialQuantity: 1, basePrice: 350.0),
          ],
        ),
      ],
    ),
  ];
}
