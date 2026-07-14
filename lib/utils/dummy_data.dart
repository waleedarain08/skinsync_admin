import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/free_system_plan_model.dart';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/models/subscription_plan_model.dart';

final List<ProductModel> dummyProducts = [
  ProductModel(
    id: 101,
    image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop',
    name: 'Botox Cosmetic 100 Unit Vial',
    brand: 'Allergan',
    sku: 'ALL-BTX-100U-V',
    globalSku: 'ALL-BTX-100U-V',
    productPurpose: 'variable',
    unitType: 'units',
    unit: 'Units',
    category: 'variable',
    enforceLotTracking: true,
    description: 'Preservative-free sterile, vacuum-dried powder for reconstitution. Contains 100 units.',
    status: 'Active',
  ),
  ProductModel(
    id: 102,
    image: 'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?q=80&w=1000&auto=format&fit=crop',
    name: 'Perfect Derma Peel Kit',
    brand: 'Bella Medical',
    sku: 'BEL-PDP-KIT',
    globalSku: 'BEL-PDP-KIT',
    productPurpose: 'required',
    unitType: 'vial',
    unit: 'Vial',
    category: 'required',
    enforceLotTracking: true,
    description: 'Synergistic blend of 5 powerful acids to treat acne, hyperpigmentation, and aging.',
    status: 'Active',
  ),
  ProductModel(
    id: 103,
    image: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=1000&auto=format&fit=crop',
    name: 'Nitrile Gloves - Large',
    brand: 'McKesson',
    sku: 'MCK-GLV-LG',
    globalSku: 'MCK-GLV-LG',
    productPurpose: 'setup/supply',
    unitType: 'box',
    unit: 'Box',
    category: 'setup/supply',
    enforceLotTracking: false,
    description: 'Powder-free, textured fingertips, medical-grade nitrile gloves.',
    status: 'Active',
  ),
  ProductModel(
    id: 104,
    image: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?q=80&w=1000&auto=format&fit=crop',
    name: 'Physical Tinted SPF 44',
    brand: 'Regimen MD',
    sku: 'RMD-SPF-44',
    globalSku: 'RMD-SPF-44',
    productPurpose: 'retail/sale',
    unitType: 'pieces',
    unit: 'Pieces',
    category: 'retail/sale',
    enforceLotTracking: false,
    description: 'Water-resistant, medical-grade physical sunscreen with universal tint.',
    status: 'Active',
  ),
  ProductModel(
    id: 105,
    image: 'https://images.unsplash.com/photo-1516549655169-df83a0774514?q=80&w=1000&auto=format&fit=crop',
    name: 'Candela GentleMax Pro',
    brand: 'Candela',
    sku: 'CAN-GMP-PRO',
    globalSku: 'CAN-GMP-PRO',
    productPurpose: 'device',
    unitType: 'pieces',
    unit: 'Pieces',
    category: 'device',
    enforceLotTracking: false,
    description: 'Dual wavelength laser system combining Alexandrite and Nd:YAG lasers.',
    status: 'Active',
  ),
  // Original Injectables
  ProductModel(id: 1, name: 'Botox®', category: 'Injectables', unit: 'Units (U)', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Botulinum toxin type A', brand: 'Allergan', globalSku: 'ALL-BTX-O', productPurpose: 'variable', unitType: 'units', enforceLotTracking: true, status: 'Active'),
  ProductModel(id: 2, name: 'Dysport®', category: 'Injectables', unit: 'Units (U)', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'AbobotulinumtoxinA', brand: 'Galderma', globalSku: 'GAL-DSP-O', productPurpose: 'variable', unitType: 'units', enforceLotTracking: true, status: 'Active'),
  ProductModel(id: 3, name: 'Xeomin®', category: 'Injectables', unit: 'Units (U)', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'IncobotulinumtoxinA', brand: 'Merz', globalSku: 'MRZ-XEO-O', productPurpose: 'variable', unitType: 'units', enforceLotTracking: true, status: 'Active'),
  ProductModel(id: 4, name: 'Jeuveau®', category: 'Injectables', unit: 'Units (U)', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'PrabotulinumtoxinA-xvfs', brand: 'Evolus', globalSku: 'EVO-JEV-O', productPurpose: 'variable', unitType: 'units', enforceLotTracking: true, status: 'Active'),
  
  // Dermal Fillers
  ProductModel(id: 5, name: 'Juvederm Voluma', category: 'Dermal Fillers', unit: 'Syringe', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Hyaluronic acid filler for cheeks', brand: 'Allergan', globalSku: 'ALL-JVD-O', productPurpose: 'variable', unitType: 'syringe', enforceLotTracking: true, status: 'Active'),
  ProductModel(id: 6, name: 'Juvederm Ultra XC', category: 'Dermal Fillers', unit: 'Syringe', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Hyaluronic acid filler for lips', brand: 'Allergan', globalSku: 'ALL-JVD-UXC', productPurpose: 'variable', unitType: 'syringe', enforceLotTracking: true, status: 'Active'),
  ProductModel(id: 7, name: 'Restylane Lyft', category: 'Dermal Fillers', unit: 'Syringe', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Hyaluronic acid filler', brand: 'Galderma', globalSku: 'GAL-RST-L', productPurpose: 'variable', unitType: 'syringe', enforceLotTracking: true, status: 'Active'),
  ProductModel(id: 8, name: 'Restylane Defyne', category: 'Dermal Fillers', unit: 'Syringe', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Hyaluronic acid filler', brand: 'Galderma', globalSku: 'GAL-RST-D', productPurpose: 'variable', unitType: 'syringe', enforceLotTracking: true, status: 'Active'),
  ProductModel(id: 9, name: 'RHA Collection', category: 'Dermal Fillers', unit: 'Syringe', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Resilient hyaluronic acid', brand: 'Revance', globalSku: 'REV-RHA-O', productPurpose: 'variable', unitType: 'syringe', enforceLotTracking: true, status: 'Active'),

  // Skin Boosters
  ProductModel(id: 10, name: 'Skinvive', category: 'Skin Boosters', unit: 'Syringe', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'HA injectable gel for skin smoothness', brand: 'Allergan', globalSku: 'ALL-SKV-O', productPurpose: 'variable', unitType: 'syringe', enforceLotTracking: true, status: 'Active'),
  ProductModel(id: 11, name: 'Profhilo', category: 'Skin Boosters', unit: 'Syringe', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Remodeling HA', brand: 'IBSA', globalSku: 'IBS-PRF-O', productPurpose: 'variable', unitType: 'syringe', enforceLotTracking: true, status: 'Active'),
  ProductModel(id: 12, name: 'Sculptra', category: 'Skin Boosters', unit: 'Vial', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Poly-L-lactic acid', brand: 'Galderma', globalSku: 'GAL-SCL-O', productPurpose: 'variable', unitType: 'vial', enforceLotTracking: true, status: 'Active'),
  ProductModel(id: 13, name: 'Radiesse', category: 'Skin Boosters', unit: 'Syringe', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Calcium hydroxylapatite', brand: 'Merz', globalSku: 'MRZ-RAD-O', productPurpose: 'variable', unitType: 'syringe', enforceLotTracking: true, status: 'Active'),

  // PRP / Regenerative
  ProductModel(id: 14, name: 'PRP Kit', category: 'PRP / Regenerative', unit: 'Kit', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Platelet-rich plasma preparation kit', brand: 'Eclipse', globalSku: 'ECL-PRP-K', productPurpose: 'required', unitType: 'box', enforceLotTracking: true, status: 'Active'),
  ProductModel(id: 15, name: 'PRF Kit', category: 'PRP / Regenerative', unit: 'Kit', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Platelet-rich fibrin preparation kit', brand: 'Eclipse', globalSku: 'ECL-PRF-K', productPurpose: 'required', unitType: 'box', enforceLotTracking: true, status: 'Active'),

  // Topicals
  ProductModel(id: 16, name: 'Medical Grade Numbing Cream', category: 'Topicals', unit: 'Tube', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Lidocaine/Prilocaine compound', brand: 'McKesson', globalSku: 'MCK-NUM-C', productPurpose: 'required', unitType: 'pieces', enforceLotTracking: false, status: 'Active'),
  ProductModel(id: 17, name: 'Post Procedure Healing Gel', category: 'Topicals', unit: 'Tube', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Soothing aftercare gel', brand: 'Regimen MD', globalSku: 'RMD-PPH-G', productPurpose: 'required', unitType: 'pieces', enforceLotTracking: false, status: 'Active'),
  ProductModel(id: 18, name: 'Antiseptic Solution', category: 'Topicals', unit: 'Bottle', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Skin preparation solution', brand: 'McKesson', globalSku: 'MCK-ANT-S', productPurpose: 'setup/supply', unitType: 'pieces', enforceLotTracking: false, status: 'Active'),

  // Devices / Consumables
  ProductModel(id: 19, name: 'Microneedling Cartridge', category: 'Devices / Consumables', unit: 'Piece', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Sterile needle head', brand: 'Candela', globalSku: 'CAN-MNC-O', productPurpose: 'required', unitType: 'pieces', enforceLotTracking: false, status: 'Active'),
  ProductModel(id: 20, name: 'Cannula 25G', category: 'Devices / Consumables', unit: 'Piece', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Blunt-tip cannula', brand: 'BD', globalSku: 'BD-CAN-25G', productPurpose: 'setup/supply', unitType: 'pieces', enforceLotTracking: false, status: 'Active'),
  ProductModel(id: 21, name: 'Cannula 27G', category: 'Devices / Consumables', unit: 'Piece', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Blunt-tip cannula', brand: 'BD', globalSku: 'BD-CAN-27G', productPurpose: 'setup/supply', unitType: 'pieces', enforceLotTracking: false, status: 'Active'),
  ProductModel(id: 22, name: 'Syringe 1ml', category: 'Devices / Consumables', unit: 'Piece', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Luer lock syringe', brand: 'BD', globalSku: 'BD-SYR-1ML', productPurpose: 'setup/supply', unitType: 'pieces', enforceLotTracking: false, status: 'Active'),
  ProductModel(id: 23, name: 'Syringe 3ml', category: 'Devices / Consumables', unit: 'Piece', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Luer lock syringe', brand: 'BD', globalSku: 'BD-SYR-3ML', productPurpose: 'setup/supply', unitType: 'pieces', enforceLotTracking: false, status: 'Active'),
  ProductModel(id: 24, name: 'Gauze Pack', category: 'Devices / Consumables', unit: 'Pack', image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', description: 'Sterile gauze sponges', brand: 'McKesson', globalSku: 'MCK-GAU-P', productPurpose: 'setup/supply', unitType: 'box', enforceLotTracking: false, status: 'Active'),
];

class TreatmentData {
  // Category Hierarchy
  static const Map<String, List<String>> categoriesWithSubcategories = {
    'Injectables': ['Neurotoxins', 'Dermal Fillers'],
    'Skin Treatments': ['Facials', 'Chemical Peels'],
    'Laser & Energy': ['Resurfacing', 'Tightening'],
  };

  static List<String> get categories => categoriesWithSubcategories.keys.toList();

  // Area Hierarchy
  static const Map<String, List<String>> areasWithSubAreas = {
    'Face': ['Upper Face', 'Mid Face', 'Lower Face', 'Full Face'],
    'Neck': ['Full Neck', 'Neck Bands', 'Neck Tightening Area'],
    'Scalp': ['Hairline', 'Crown', 'Full Scalp'],
    'Hands': ['Left Hand', 'Right Hand', 'Full Hands'],
    'Body': ['Upper Body', 'Mid Body', 'Lower Body'],
  };

  static List<String> get suggestedAreas => areasWithSubAreas.keys.toList();

  static List<String> getSubAreas(String area) {
    return areasWithSubAreas[area] ?? [];
  }

  // Consumable Types
  static const List<String> consumableTypes = [
    'Syringes',
    'Units',
    'Vials',
    'Threads',
    'Bottles',
    'Sessions',
    'ML',
    'Packs',
  ];

  static List<ProductModel> get dummyInventoryProducts => dummyProducts;

  // static final List<TreatmentListData> dummyTreatments = [
  //   TreatmentListData(
  //     id: 1,
  //     globalSku: 'TRT-A1B2-C3D4',
  //     patientDisplayName: 'Botox Cosmetic',
  //     // patientDisplayName: 'Wrinkle Relaxer',
  //     description: 'Smooth fine lines and wrinkles in the upper face.',
  //     shortDescription: 'Anti-aging injectable treatment.',
  //     // basePrice: 150.0,
  //     // baseDurationHours: 0,
  //     // baseDurationMinutes: 30,
  //     image: 'https://images.unsplash.com/photo-1614850523296-d8c1af93d400?q=80&w=1000&auto=format&fit=crop',
  //     // categoryName: 'Injectables',
  //     // categoryPath: 'Injectables > Neurotoxins',
  //     status: 'active',
  //     // sideAreas: [
  //     //   SideAreaModel(
  //     //     name: 'Upper Face',
  //     //     subAreas: [
  //     //       SubAreaModel(name: 'Forehead', basePrice: 12.0),
  //     //       SubAreaModel(name: "Crow's Feet", basePrice: 12.0),
  //     //     ],
  //     //   ),
  //     // ],
  //   ),
  //   TreatmentListData(
  //     id: 2,
  //     globalSku: 'TRT-9X8Y-Z7W6',
  //     patientDisplayName: 'Juvederm Voluma',
  //     // patientDisplayName: 'Cheek Filler',
  //     description: 'Dermal filler for cheek augmentation.',
  //     shortDescription: 'Volumizing dermal filler.',
  //     // basePrice: 800.0,
  //     // baseDurationHours: 1,
  //     // baseDurationMinutes: 0,
  //     image: 'https://images.unsplash.com/photo-1620331311520-246422ff83f9?q=80&w=1000&auto=format&fit=crop',
  //     // categoryName: 'Injectables',
  //     // categoryPath: 'Injectables > Dermal Fillers',
  //     status: 'active',
  //     // sideAreas: [
  //     //   SideAreaModel(
  //     //     name: 'Mid Face',
  //     //     subAreas: [
  //     //       SubAreaModel(name: 'Cheeks', basePrice: 800.0),
  //     //     ],
  //     //   ),
  //     // ],
  //   ),
  //   TreatmentListData(
  //     id: 3,
  //     globalSku: 'TRT-AB12-CD34',
  //     patientDisplayName: 'HydraFacial',
  //     // patientDisplayName: 'Deep Cleansing Facial',
  //     description: 'Cleanse, extract, and hydrate the skin.',
  //     shortDescription: 'Refreshing skin treatment.',
  //     // basePrice: 199.0,
  //     // baseDurationHours: 0,
  //     // baseDurationMinutes: 45,
  //     image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop',
  //     // categoryName: 'Skin Treatments',
  //     // categoryPath: 'Skin Treatments > Facials',
  //     status: 'deactive',
  //   ),
  //   TreatmentListData(
  //     id: 4,
  //     globalSku: 'TRT-5Y6Z-W4V3',
  //     patientDisplayName: 'Laser Hair Removal',
  //     // patientDisplayName: 'Permanent Hair Reduction',
  //     description: 'Permanent hair reduction for smooth skin.',
  //     shortDescription: 'Long-term hair removal.',
  //     // basePrice: 250.0,
  //     // baseDurationHours: 1,
  //     // baseDurationMinutes: 30,
  //     image: 'https://images.unsplash.com/photo-1512290923902-8a9f81dc2069?q=80&w=1000&auto=format&fit=crop',
  //     // categoryName: 'Laser & Energy',
  //     // categoryPath: 'Laser & Energy > Resurfacing',
  //     status: 'active',
  //     // sideAreas: [
  //     //   SideAreaModel(
  //     //     name: 'Body',
  //     //     subAreas: [
  //     //       SubAreaModel(name: 'Arms', basePrice: 150.0),
  //     //       SubAreaModel(name: 'Thighs', basePrice: 200.0),
  //     //     ],
  //     //   ),
  //     // ],
  //   ),
  //   TreatmentListData(
  //     id: 5,
  //     patientDisplayName: 'Chemical Peel',
  //     // patientDisplayName: 'Skin Resurfacing',
  //     description: 'Exfoliate and improve skin texture.',
  //     shortDescription: 'Chemical exfoliation treatment.',
  //     // basePrice: 125.0,
  //     // baseDurationHours: 0,
  //     // baseDurationMinutes: 30,
  //     image: 'https://images.unsplash.com/photo-1512290923902-8a9f81dc2069?q=80&w=1000&auto=format&fit=crop',
  //     // categoryName: 'Skin Treatments',
  //     // categoryPath: 'Skin Treatments > Chemical Peels',
  //     status: 'active',
  //   ),
  //   TreatmentListData(
  //     id: 6,
  //     patientDisplayName: 'Microneedling',
  //     // patientDisplayName: 'Collagen Induction Therapy',
  //     description: 'Stimulate collagen production for rejuvenation.',
  //     shortDescription: 'Skin rejuvenation treatment.',
  //     // basePrice: 350.0,
  //     // baseDurationHours: 1,
  //     // baseDurationMinutes: 0,
  //     image: 'https://images.unsplash.com/photo-1616394584738-fc6e612e71b9?q=80&w=1000&auto=format&fit=crop',
  //     // categoryName: 'Skin Treatments',
  //     // categoryPath: 'Skin Treatments > Facials',
  //     status: 'active',
  //     // sideAreas: [
  //     //   SideAreaModel(
  //     //     name: 'Face',
  //     //     subAreas: [
  //     //       SubAreaModel(name: 'Full Face', basePrice: 350.0),
  //     //     ],
  //     //   ),
  //     // ],
  //   ),
  // ];

  static final List<ClinicModel> dummyClinics = [
    ClinicModel(
      id: 1,
      name: 'Glow MedSpa NY',
      email: 'contact@glowmedspa.com',
      phone: '+1 212-555-0198',
      address: '5th Ave, New York, NY',
      logo: 'https://plus.unsplash.com/premium_photo-1661764391621-08f307405c6d?q=80&w=1000',
      status: 'Active',
      createdAt: DateTime.parse('2023-01-15'),
    ),
    ClinicModel(
      id: 2,
      name: 'Serene Skin Clinic',
      email: 'info@sereneskin.com',
      phone: '+1 310-555-0245',
      address: 'Beverly Hills, CA',
      logo: 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?q=80&w=1000',
      status: 'Active',
      createdAt: DateTime.parse('2023-01-15'),
    ),
  ];

  static final FreeSystemPlanModel dummyFreeSystemPlan = FreeSystemPlanModel(
    id: 0,
    name: 'Free System Plan',
    durationMonths: 2,
    doctorSeats: 2,
    staffSeats: 5,
    standardBookingCommissionPercent: 12,
    dynamicBookingCommissionPercent: 18,
    technologyFeePerTreatment: 8,
    benefits: [
      PlanBenefit(title: 'Initial free access', enabled: true),
      PlanBenefit(title: 'Basic patient records', enabled: true),
    ],
  );

  static final List<SubscriptionPlanModel> dummySubscriptionPlans = [
    SubscriptionPlanModel(
      id: 1,
      name: 'Basic Plan',
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
        PlanBenefit(title: 'Patient records and treatment history', enabled: true),
        PlanBenefit(title: 'Automated invoices', enabled: true),
      ],
    ),
    SubscriptionPlanModel(
      id: 2,
      name: 'Premium Plan',
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
        PlanBenefit(title: 'AI consultation and treatment recommendation tools', enabled: true),
        PlanBenefit(title: 'Before/after simulations', enabled: true),
        PlanBenefit(title: 'Dynamic pricing system', enabled: true),
      ],
    ),
    SubscriptionPlanModel(
      id: 3,
      name: 'Gold Plan',
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
        PlanBenefit(title: 'Multi-user clinic access', enabled: true),
        PlanBenefit(title: 'Priority onboarding and support', enabled: true),
        PlanBenefit(title: 'Custom branding', enabled: true),
      ],
    ),
  ];
}
