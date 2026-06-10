import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/free_system_plan_model.dart';
import 'package:skinsync_admin/models/invite_clinic_model.dart';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/models/subscription_plan_model.dart';
import 'package:skinsync_admin/models/treatment_model.dart';

final List<ProductModel> dummyProducts = [
  ProductModel(
    id: 101,
    image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop",
    name: "Botox Cosmetic 100 Unit Vial",
    brand: "Allergan",
    sku: "ALL-BTX-100U-V",
    global_sku: "ALL-BTX-100U-V",
    product_purpose: "variable",
    unit_type: "units",
    unit: "Units",
    category: "variable",
    enforce_lot_tracking: true,
    description: "Preservative-free sterile, vacuum-dried powder for reconstitution. Contains 100 units.",
    status: "Active",
  ),
  ProductModel(
    id: 102,
    image: "https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?q=80&w=1000&auto=format&fit=crop",
    name: "Perfect Derma Peel Kit",
    brand: "Bella Medical",
    sku: "BEL-PDP-KIT",
    global_sku: "BEL-PDP-KIT",
    product_purpose: "required",
    unit_type: "vial",
    unit: "Vial",
    category: "required",
    enforce_lot_tracking: true,
    description: "Synergistic blend of 5 powerful acids to treat acne, hyperpigmentation, and aging.",
    status: "Active",
  ),
  ProductModel(
    id: 103,
    image: "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=1000&auto=format&fit=crop",
    name: "Nitrile Gloves - Large",
    brand: "McKesson",
    sku: "MCK-GLV-LG",
    global_sku: "MCK-GLV-LG",
    product_purpose: "setup/supply",
    unit_type: "box",
    unit: "Box",
    category: "setup/supply",
    enforce_lot_tracking: false,
    description: "Powder-free, textured fingertips, medical-grade nitrile gloves.",
    status: "Active",
  ),
  ProductModel(
    id: 104,
    image: "https://images.unsplash.com/photo-1620916566398-39f1143ab7be?q=80&w=1000&auto=format&fit=crop",
    name: "Physical Tinted SPF 44",
    brand: "Regimen MD",
    sku: "RMD-SPF-44",
    global_sku: "RMD-SPF-44",
    product_purpose: "retail/sale",
    unit_type: "pieces",
    unit: "Pieces",
    category: "retail/sale",
    enforce_lot_tracking: false,
    description: "Water-resistant, medical-grade physical sunscreen with universal tint.",
    status: "Active",
  ),
  ProductModel(
    id: 105,
    image: "https://images.unsplash.com/photo-1516549655169-df83a0774514?q=80&w=1000&auto=format&fit=crop",
    name: "Candela GentleMax Pro",
    brand: "Candela",
    sku: "CAN-GMP-PRO",
    global_sku: "CAN-GMP-PRO",
    product_purpose: "device",
    unit_type: "pieces",
    unit: "Pieces",
    category: "device",
    enforce_lot_tracking: false,
    description: "Dual wavelength laser system combining Alexandrite and Nd:YAG lasers.",
    status: "Active",
  ),
  // Original Injectables
  ProductModel(id: 1, name: "Botox®", category: "Injectables", unit: "Units (U)", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Botulinum toxin type A", brand: "Allergan", global_sku: "ALL-BTX-O", product_purpose: "variable", unit_type: "units", enforce_lot_tracking: true, status: "Active"),
  ProductModel(id: 2, name: "Dysport®", category: "Injectables", unit: "Units (U)", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "AbobotulinumtoxinA", brand: "Galderma", global_sku: "GAL-DSP-O", product_purpose: "variable", unit_type: "units", enforce_lot_tracking: true, status: "Active"),
  ProductModel(id: 3, name: "Xeomin®", category: "Injectables", unit: "Units (U)", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "IncobotulinumtoxinA", brand: "Merz", global_sku: "MRZ-XEO-O", product_purpose: "variable", unit_type: "units", enforce_lot_tracking: true, status: "Active"),
  ProductModel(id: 4, name: "Jeuveau®", category: "Injectables", unit: "Units (U)", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "PrabotulinumtoxinA-xvfs", brand: "Evolus", global_sku: "EVO-JEV-O", product_purpose: "variable", unit_type: "units", enforce_lot_tracking: true, status: "Active"),
  
  // Dermal Fillers
  ProductModel(id: 5, name: "Juvederm Voluma", category: "Dermal Fillers", unit: "Syringe", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Hyaluronic acid filler for cheeks", brand: "Allergan", global_sku: "ALL-JVD-O", product_purpose: "variable", unit_type: "syringe", enforce_lot_tracking: true, status: "Active"),
  ProductModel(id: 6, name: "Juvederm Ultra XC", category: "Dermal Fillers", unit: "Syringe", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Hyaluronic acid filler for lips", brand: "Allergan", global_sku: "ALL-JVD-UXC", product_purpose: "variable", unit_type: "syringe", enforce_lot_tracking: true, status: "Active"),
  ProductModel(id: 7, name: "Restylane Lyft", category: "Dermal Fillers", unit: "Syringe", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Hyaluronic acid filler", brand: "Galderma", global_sku: "GAL-RST-L", product_purpose: "variable", unit_type: "syringe", enforce_lot_tracking: true, status: "Active"),
  ProductModel(id: 8, name: "Restylane Defyne", category: "Dermal Fillers", unit: "Syringe", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Hyaluronic acid filler", brand: "Galderma", global_sku: "GAL-RST-D", product_purpose: "variable", unit_type: "syringe", enforce_lot_tracking: true, status: "Active"),
  ProductModel(id: 9, name: "RHA Collection", category: "Dermal Fillers", unit: "Syringe", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Resilient hyaluronic acid", brand: "Revance", global_sku: "REV-RHA-O", product_purpose: "variable", unit_type: "syringe", enforce_lot_tracking: true, status: "Active"),

  // Skin Boosters
  ProductModel(id: 10, name: "Skinvive", category: "Skin Boosters", unit: "Syringe", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "HA injectable gel for skin smoothness", brand: "Allergan", global_sku: "ALL-SKV-O", product_purpose: "variable", unit_type: "syringe", enforce_lot_tracking: true, status: "Active"),
  ProductModel(id: 11, name: "Profhilo", category: "Skin Boosters", unit: "Syringe", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Remodeling HA", brand: "IBSA", global_sku: "IBS-PRF-O", product_purpose: "variable", unit_type: "syringe", enforce_lot_tracking: true, status: "Active"),
  ProductModel(id: 12, name: "Sculptra", category: "Skin Boosters", unit: "Vial", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Poly-L-lactic acid", brand: "Galderma", global_sku: "GAL-SCL-O", product_purpose: "variable", unit_type: "vial", enforce_lot_tracking: true, status: "Active"),
  ProductModel(id: 13, name: "Radiesse", category: "Skin Boosters", unit: "Syringe", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Calcium hydroxylapatite", brand: "Merz", global_sku: "MRZ-RAD-O", product_purpose: "variable", unit_type: "syringe", enforce_lot_tracking: true, status: "Active"),

  // PRP / Regenerative
  ProductModel(id: 14, name: "PRP Kit", category: "PRP / Regenerative", unit: "Kit", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Platelet-rich plasma preparation kit", brand: "Eclipse", global_sku: "ECL-PRP-K", product_purpose: "required", unit_type: "box", enforce_lot_tracking: true, status: "Active"),
  ProductModel(id: 15, name: "PRF Kit", category: "PRP / Regenerative", unit: "Kit", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Platelet-rich fibrin preparation kit", brand: "Eclipse", global_sku: "ECL-PRF-K", product_purpose: "required", unit_type: "box", enforce_lot_tracking: true, status: "Active"),

  // Topicals
  ProductModel(id: 16, name: "Medical Grade Numbing Cream", category: "Topicals", unit: "Tube", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Lidocaine/Prilocaine compound", brand: "McKesson", global_sku: "MCK-NUM-C", product_purpose: "required", unit_type: "pieces", enforce_lot_tracking: false, status: "Active"),
  ProductModel(id: 17, name: "Post Procedure Healing Gel", category: "Topicals", unit: "Tube", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Soothing aftercare gel", brand: "Regimen MD", global_sku: "RMD-PPH-G", product_purpose: "required", unit_type: "pieces", enforce_lot_tracking: false, status: "Active"),
  ProductModel(id: 18, name: "Antiseptic Solution", category: "Topicals", unit: "Bottle", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Skin preparation solution", brand: "McKesson", global_sku: "MCK-ANT-S", product_purpose: "setup/supply", unit_type: "pieces", enforce_lot_tracking: false, status: "Active"),

  // Devices / Consumables
  ProductModel(id: 19, name: "Microneedling Cartridge", category: "Devices / Consumables", unit: "Piece", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Sterile needle head", brand: "Candela", global_sku: "CAN-MNC-O", product_purpose: "required", unit_type: "pieces", enforce_lot_tracking: false, status: "Active"),
  ProductModel(id: 20, name: "Cannula 25G", category: "Devices / Consumables", unit: "Piece", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Blunt-tip cannula", brand: "BD", global_sku: "BD-CAN-25G", product_purpose: "setup/supply", unit_type: "pieces", enforce_lot_tracking: false, status: "Active"),
  ProductModel(id: 21, name: "Cannula 27G", category: "Devices / Consumables", unit: "Piece", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Blunt-tip cannula", brand: "BD", global_sku: "BD-CAN-27G", product_purpose: "setup/supply", unit_type: "pieces", enforce_lot_tracking: false, status: "Active"),
  ProductModel(id: 22, name: "Syringe 1ml", category: "Devices / Consumables", unit: "Piece", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Luer lock syringe", brand: "BD", global_sku: "BD-SYR-1ML", product_purpose: "setup/supply", unit_type: "pieces", enforce_lot_tracking: false, status: "Active"),
  ProductModel(id: 23, name: "Syringe 3ml", category: "Devices / Consumables", unit: "Piece", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Luer lock syringe", brand: "BD", global_sku: "BD-SYR-3ML", product_purpose: "setup/supply", unit_type: "pieces", enforce_lot_tracking: false, status: "Active"),
  ProductModel(id: 24, name: "Gauze Pack", category: "Devices / Consumables", unit: "Pack", image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop", description: "Sterile gauze sponges", brand: "McKesson", global_sku: "MCK-GAU-P", product_purpose: "setup/supply", unit_type: "box", enforce_lot_tracking: false, status: "Active"),
];

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
    "Face": ["Upper Face", "Mid Face", "Lower Face", "Full Face"],
    "Neck": ["Full Neck", "Neck Bands", "Neck Tightening Area"],
    "Scalp": ["Hairline", "Crown", "Full Scalp"],
    "Hands": ["Left Hand", "Right Hand", "Full Hands"],
    "Body": ["Upper Body", "Mid Body", "Lower Body"],
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

  static List<ProductModel> get dummyInventoryProducts => dummyProducts;

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
      categoryName: "Injectables",
      categoryPath: "Injectables > Neurotoxins",
      status: 'active',
      sideAreas: [
        SideAreaModel(
          name: "Upper Face",
          subAreas: [
            SubAreaModel(name: "Forehead", basePrice: 12.0),
            SubAreaModel(name: "Crow's Feet", basePrice: 12.0),
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
      categoryName: "Injectables",
      categoryPath: "Injectables > Dermal Fillers",
      status: 'active',
      sideAreas: [
        SideAreaModel(
          name: "Mid Face",
          subAreas: [
            SubAreaModel(name: "Cheeks", basePrice: 800.0),
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
      categoryName: "Skin Treatments",
      categoryPath: "Skin Treatments > Facials",
      status: 'deactive',
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
      categoryName: "Laser & Energy",
      categoryPath: "Laser & Energy > Resurfacing",
      status: 'active',
      sideAreas: [
        SideAreaModel(
          name: "Body",
          subAreas: [
            SubAreaModel(name: "Arms", basePrice: 150.0),
            SubAreaModel(name: "Thighs", basePrice: 200.0),
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
      categoryName: "Skin Treatments",
      categoryPath: "Skin Treatments > Chemical Peels",
      status: 'active',
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
      categoryName: "Skin Treatments",
      categoryPath: "Skin Treatments > Facials",
      status: 'active',
      sideAreas: [
        SideAreaModel(
          name: "Face",
          subAreas: [
            SubAreaModel(name: "Full Face", basePrice: 350.0),
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
      logo: "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=1000",
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

  static final FreeSystemPlanModel dummyFreeSystemPlan = FreeSystemPlanModel(
    id: 0,
    name: "Free System Plan",
    durationMonths: 2,
    doctorSeats: 2,
    staffSeats: 5,
    standardBookingCommissionPercent: 12,
    dynamicBookingCommissionPercent: 18,
    technologyFeePerTreatment: 8,
    benefits: [
      PlanBenefit(title: "Initial free access", enabled: true),
      PlanBenefit(title: "Basic patient records", enabled: true),
    ],
  );

  static final List<SubscriptionPlanModel> dummySubscriptionPlans = [
    SubscriptionPlanModel(
      id: 1,
      name: "Basic Plan",
      basePrice: 49.99,
      doctorSeats: 5,
      unlimitedDoctors: false,
      staffSeats: 10,
      unlimitedStaff: false,
      standardBookingCommissionPercent: 10,
      dynamicBookingCommissionPercent: 15,
      technologyFeePerTreatment: 5,
      isActive: true,
      benefits: [
        PlanBenefit(title: "Patient records and treatment history", enabled: true),
        PlanBenefit(title: "Automated invoices", enabled: true),
      ],
    ),
    SubscriptionPlanModel(
      id: 2,
      name: "Premium Plan",
      basePrice: 149.99,
      doctorSeats: 0,
      unlimitedDoctors: true,
      staffSeats: 30,
      unlimitedStaff: false,
      standardBookingCommissionPercent: 8,
      dynamicBookingCommissionPercent: 12,
      technologyFeePerTreatment: 3,
      isActive: true,
      benefits: [
        PlanBenefit(title: "AI consultation and treatment recommendation tools", enabled: true),
        PlanBenefit(title: "Before/after simulations", enabled: true),
        PlanBenefit(title: "Dynamic pricing system", enabled: true),
      ],
    ),
    SubscriptionPlanModel(
      id: 3,
      name: "Gold Plan",
      basePrice: 299.99,
      doctorSeats: 0,
      unlimitedDoctors: true,
      staffSeats: 0,
      unlimitedStaff: true,
      standardBookingCommissionPercent: 5,
      dynamicBookingCommissionPercent: 10,
      technologyFeePerTreatment: 2,
      isActive: true,
      benefits: [
        PlanBenefit(title: "Multi-user clinic access", enabled: true),
        PlanBenefit(title: "Priority onboarding and support", enabled: true),
        PlanBenefit(title: "Custom branding", enabled: true),
      ],
    ),
  ];
}
