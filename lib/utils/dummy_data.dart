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
      image: "https://images.unsplash.com/photo-1614850523296-d8c1af93d400?q=80&w=1000&auto=format&fit=crop",
      category: "Injectables",
      subcategory: "Neurotoxins",
      materialName: "Units",
      maxMaterialQuantity: 50,
      isActive: true,
      sideAreas: [
        SideAreaModel(name: "Forehead", maxUnits: 50),
        SideAreaModel(name: "Crow's Feet", maxUnits: 24),
      ],
    ),
    TreatmentModel(
      id: 2,
      name: "Juvederm Voluma",
      patientDisplayName: "Cheek Filler",
      description: "Dermal filler for cheek augmentation.",
      shortDescription: "Volumizing dermal filler.",
      image: "https://images.unsplash.com/photo-1620331311520-246422ff83f9?q=80&w=1000&auto=format&fit=crop",
      category: "Injectables",
      subcategory: "Dermal Fillers",
      materialName: "Syringes",
      maxMaterialQuantity: 2,
      isActive: true,
      sideAreas: [
        SideAreaModel(name: "Cheeks", maxUnits: 2),
      ],
    ),
    TreatmentModel(
      id: 3,
      name: "HydraFacial",
      patientDisplayName: "Deep Cleansing Facial",
      description: "Cleanse, extract, and hydrate the skin.",
      shortDescription: "Refreshing skin treatment.",
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
      image: "https://images.unsplash.com/photo-1512290923902-8a9f81dc2069?q=80&w=1000&auto=format&fit=crop",
      category: "Laser & Energy",
      subcategory: "Resurfacing",
      isActive: true,
      sideAreas: [
        SideAreaModel(name: "Arms"),
        SideAreaModel(name: "Thighs"),
      ],
    ),
    TreatmentModel(
      id: 5,
      name: "Chemical Peel",
      patientDisplayName: "Skin Resurfacing",
      description: "Exfoliate and improve skin texture.",
      shortDescription: "Chemical exfoliation treatment.",
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
      image: "https://images.unsplash.com/photo-1616394584738-fc6e612e71b9?q=80&w=1000&auto=format&fit=crop",
      category: "Skin Treatments",
      subcategory: "Facials",
      isActive: true,
      sideAreas: [
        SideAreaModel(name: "Full Face"),
      ],
    ),
  ];
}
