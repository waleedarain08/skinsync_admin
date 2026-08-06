import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/clinic_web_request_model.dart';
import 'package:skinsync_admin/models/founder_clinic_model.dart';
import 'package:skinsync_admin/models/free_system_plan_model.dart';
import 'package:skinsync_admin/models/subscription_plan_model.dart';

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

  static final List<ClinicWebRequestModel> dummyWebRequests = [
    ClinicWebRequestModel(
      id: 101,
      clinicName: 'Aura Aesthetics',
      ownerName: 'Dr. Sarah Mitchell',
      email: 'contact@auraaesthetics.com',
      phone: '+1 617-555-0842',
      address: 'Boston, MA',
      website: 'https://auraaesthetics.com',
      specialty: 'Dermatology & Laser',
      yearsInBusiness: '5',
      instagramHandle: '@aura_skin',
      facebookPage: 'Aura Aesthetics Boston',
      message: 'We are looking to integrate AI-driven skin analysis into our daily workflow to improve patient consultation accuracy.',
      status: 'Pending',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ClinicWebRequestModel(
      id: 102,
      clinicName: 'Vivid Glow Center',
      ownerName: 'Marcus Thorne',
      email: 'admin@vividglow.com',
      phone: '+1 305-555-0915',
      address: 'Miami, FL',
      website: 'https://vividglowcenter.com',
      specialty: 'Cosmetic Injectables',
      yearsInBusiness: '12',
      instagramHandle: '@vivid_glow_miami',
      facebookPage: 'Vivid Glow Miami',
      message: 'Interested in the Premium plan for our multiple locations across Florida. We need a robust system for tracking treatment progress.',
      status: 'Approved',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  static final List<FounderClinicModel> dummyFounderClinics = [
    FounderClinicModel(
      id: 201,
      clinicName: 'Elite Aesthetics Group',
      contactName: 'Dr. Julian Thorne',
      email: 'founder@elitegroup.com',
      phone: '+1 212-555-0777',
      address: 'Park Ave, New York, NY',
      city: 'New York',
      state: 'NY',
      zipCode: '10022',
      website: 'https://eliteaesthetics.com',
      currentEmr: 'Zenoti',
      numberOfProviders: '15',
      specialty: 'Full Service Medical Aesthetics',
      instagramHandle: '@elite_aesthetics',
      facebookPage: 'Elite Aesthetics NY',
      founderReason: 'We want to be at the forefront of AI integration in the beauty industry and help shape the future of clinical software.',
      status: 'Pending',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    FounderClinicModel(
      id: 202,
      clinicName: 'Radiance Wellness Hub',
      contactName: 'Sophia Chen',
      email: 'sophia@radiancehub.com',
      phone: '+1 650-555-0333',
      address: 'Palo Alto, CA',
      city: 'Palo Alto',
      state: 'CA',
      zipCode: '94301',
      website: 'https://radiancehub.io',
      currentEmr: 'Mindbody',
      numberOfProviders: '8',
      specialty: 'Holistic Skin Health',
      instagramHandle: '@radiance_paloalto',
      facebookPage: 'Radiance Wellness Hub',
      founderReason: 'As an early adopter of technology, we are eager to provide feedback and contribute to the growth of SkinSync.',
      status: 'Approved',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
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
