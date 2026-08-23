import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/clinic_subscription_plan_model.dart';
import 'package:skinsync_admin/models/clinic_web_request_model.dart';
import 'package:skinsync_admin/models/founder_clinic_model.dart';

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
      clinicName: 'Glow Skin Clinic',
      ownerEmail: 'owner@glowskin.com',
      contactName: 'Amir Khan',
      contactNumber: '+923001234567',
      clinicLocation: '123 Main St, Karachi',
      status: 'Inactive',
      createdAt: DateTime.parse('2026-08-06T09:26:08.41Z'),
      clinicOrPracticeName: 'Glow Skin Clinic',
      clinicType: 'Dermatology',
      clinicWebsite: 'https://glowskin.com',
      primaryClinicAddress: '123 Main St, Karachi',
      numberOfLocations: '1',
      firstAndLastName: 'Amir Khan',
      professionalTitle: 'Owner',
      businessEmailAddress: 'owner@glowskin.com',
      phoneNumber: '+923001234567',
      approximateNumberOfProviders: '5',
      approximateMonthlyPatientVolume: '200',
      currentSchedulingEhrCrmOrPracticeManagementSoftware: 'None',
      skinsyncAiCapabilities: ['AI diagnosis', 'Scheduling'],
      howDidYouHearAboutSkinsyncAi: 'Google',
      authorizedToCreateAccount: true,
      agreeToTermsOfServiceAndPrivacyPolicy: true,
    ),
    ClinicWebRequestModel(
      id: 102,
      clinicName: 'Vivid Glow Center',
      ownerEmail: 'admin@vividglow.com',
      contactName: 'Marcus Thorne',
      contactNumber: '+1 305-555-0915',
      clinicLocation: 'Miami, FL',
      status: 'Active',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      clinicOrPracticeName: 'Vivid Glow Center',
      clinicType: 'Cosmetic Injectables',
      clinicWebsite: 'https://vividglowcenter.com',
      primaryClinicAddress: 'Miami, FL',
      numberOfLocations: '3',
      firstAndLastName: 'Marcus Thorne',
      professionalTitle: 'Director',
      businessEmailAddress: 'admin@vividglow.com',
      phoneNumber: '+1 305-555-0915',
      approximateNumberOfProviders: '12',
      approximateMonthlyPatientVolume: '500',
      currentSchedulingEhrCrmOrPracticeManagementSoftware: 'Zenoti',
      skinsyncAiCapabilities: ['AI diagnosis', 'Advanced Analytics'],
      howDidYouHearAboutSkinsyncAi: 'Social Media',
      authorizedToCreateAccount: true,
      agreeToTermsOfServiceAndPrivacyPolicy: true,
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

  static final List<ClinicSubscriptionPlanModel> dummySubscriptionPlans = [
    ClinicSubscriptionPlanModel(
      id: 0,
      name: 'Free Plan',
      basePrice: 0.00,
      doctorSeats: 2,
      staffSeats: 5,
      standardBookingCommissionPercent: 12,
      dynamicBookingCommissionPercent: 18,
      technologyFeePerTreatment: 8,
      isActive: true,
      benefits: [
        PlanBenefit(title: 'Initial free access', enabled: true),
        PlanBenefit(title: 'Basic patient records', enabled: true),
      ],
    ),
    ClinicSubscriptionPlanModel(
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
    ClinicSubscriptionPlanModel(
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
    ClinicSubscriptionPlanModel(
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
