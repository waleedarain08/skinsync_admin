import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/invite_clinic_model.dart';
import 'package:skinsync_admin/models/subscription_plan_model.dart';
import 'package:skinsync_admin/models/treatment_model.dart';

class TreatmentData {
  // Category Hierarchy
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
      baseDurationHours: 0,
      baseDurationMinutes: 30,
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
      baseDurationHours: 1,
      baseDurationMinutes: 0,
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
      baseDurationHours: 0,
      baseDurationMinutes: 45,
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
      baseDurationHours: 1,
      baseDurationMinutes: 30,
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
      baseDurationHours: 0,
      baseDurationMinutes: 30,
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
      baseDurationHours: 1,
      baseDurationMinutes: 0,
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

  static final List<ClinicModel> dummyClinics = [
    ClinicModel(
      id: 1,
      name: "Glow MedSpa NY",
      email: "contact@glowmedspa.com",
      phone: "+1 212-555-0198",
      address: "5th Ave, New York, NY",
      logo: "https://plus.unsplash.com/premium_photo-1661764391621-08f307405c6d?q=80&w=1000",
      status: "Active",
      subscriptionPlan: "Premium",
      totalAppointments: 450,
      rating: 4.8,
      createdAt: "2023-01-15",
    ),
    ClinicModel(
      id: 2,
      name: "Serene Skin Clinic",
      email: "info@sereneskin.com",
      phone: "+1 310-555-0245",
      address: "Beverly Hills, CA",
      logo: "https://images.unsplash.com/photo-1629909613654-28e377c37b09?q=80&w=1000",
      status: "Active",
      subscriptionPlan: "Basic",
      totalAppointments: 120,
      rating: 4.5,
      createdAt: "2023-03-10",
    ),
  ];

  static final List<InviteClinicModel> dummyInviteClinics = [
    InviteClinicModel(
      id: 1,
      name: "Radiant Aesthetics",
      email: "hello@radiantaesthetics.com",
      phone: "+1 415-555-0312",
      address: "San Francisco, CA",
      logo: "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=1000",
      invitationStatus: "Invitation Sent",
      interestedPatientsCount: 12,
      pendingAppointmentsCount: 5,
      invitedDate: "2023-10-01",
    ),
    InviteClinicModel(
      id: 2,
      name: "Elite Wellness Center",
      email: "admin@elitewellness.com",
      phone: "+1 305-555-0456",
      address: "Miami, FL",
      logo: "https://images.unsplash.com/photo-1576091160550-217359f4b88c?q=80&w=1000",
      invitationStatus: "Interested",
      interestedPatientsCount: 24,
      pendingAppointmentsCount: 10,
      invitedDate: "2023-10-05",
    ),
    InviteClinicModel(
      id: 3,
      name: "The Skin Lab",
      email: "booking@skinlab.com",
      phone: "+1 773-555-0789",
      address: "Chicago, IL",
      invitationStatus: "Expired",
      interestedPatientsCount: 0,
      pendingAppointmentsCount: 0,
      invitedDate: "2023-09-20",
    ),
    InviteClinicModel(
      id: 4,
      name: "Aura Medical Spa",
      email: "aura@medspa.com",
      phone: "+1 702-555-0999",
      address: "Las Vegas, NV",
      logo: "https://images.unsplash.com/photo-1576091160550-217359f4b88c?q=80&w=1000",
      invitationStatus: "Pending Onboarding",
      interestedPatientsCount: 45,
      pendingAppointmentsCount: 15,
      invitedDate: "2023-10-10",
      lat: "36.1699",
      long: "-115.1398",
      ownerName: "Sarah Johnson",
      ownerEmail: "sarah@medspa.com",
      website: "https://auramedspa.com",
      description: "A premier medical spa in the heart of Las Vegas.",
    ),
    InviteClinicModel(
      id: 5,
      name: "DermaCare Plus",
      email: "support@dermacare.com",
      phone: "+1 206-555-0111",
      address: "Seattle, WA",
      invitationStatus: "Awaiting Response",
      interestedPatientsCount: 8,
      pendingAppointmentsCount: 2,
      invitedDate: "2023-10-12",
    ),
    InviteClinicModel(
      id: 6,
      name: "Luxe Skin Institute",
      email: "luxury@skinsync.com",
      phone: "+1 617-555-0222",
      address: "Boston, MA",
      invitationStatus: "Not Invited",
      interestedPatientsCount: 3,
      pendingAppointmentsCount: 1,
      invitedDate: "2023-10-14",
    ),
  ];

  static final List<SubscriptionPlanModel> dummySubscriptionPlans = [
    SubscriptionPlanModel(
      id: 1,
      name: "Basic Plan",
      basePrice: 49.99,
      isActive: true,
      benefits: [
        PlanBenefit(title: "Up to 5 injectors", description: "Standard access"),
        PlanBenefit(title: "First time join offer", freeMonths: 1),
      ],
    ),
    SubscriptionPlanModel(
      id: 2,
      name: "Premium Plan",
      basePrice: 149.99,
      isActive: true,
      benefits: [
        PlanBenefit(title: "Unlimited injectors", description: "Full access"),
        PlanBenefit(title: "Priority support", description: "24/7"),
        PlanBenefit(title: "First time join offer", freeMonths: 3),
      ],
    ),
    SubscriptionPlanModel(
      id: 3,
      name: "Gold Plan",
      basePrice: 299.99,
      isActive: true,
      benefits: [
        PlanBenefit(title: "Custom branding", description: "White label"),
        PlanBenefit(title: "AI Simulator analytics", description: "Advanced insights"),
        PlanBenefit(title: "First time join offer", freeMonths: 6),
      ],
    ),
  ];
}
