import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/free_system_plan_model.dart';
import 'package:skinsync_admin/models/responses/appointment_types_list_response.dart';
import 'package:skinsync_admin/models/responses/booking_methods_list_response.dart';
import 'package:skinsync_admin/models/subscription_plan_model.dart';

class BookingConfigData {
  static const List<BookingMethodModel> dummyBookingMethods = [
    BookingMethodModel(
      id: 1,
      key: 'online',
      title: 'Online',
      description: 'Allows customers to browse available time slots and book their own appointments directly through the Skinsync mobile application.',
    ),
    BookingMethodModel(
      id: 2,
      key: 'walk_in',
      title: 'Walk-in',
      description: 'Enables clinic administrators and front-desk staff to manually register and schedule appointments for customers who visit the clinic in person.',
    ),
    BookingMethodModel(
      id: 3,
      key: 'personal',
      title: 'Personal',
      description: 'Provides a private scheduling channel for clinic staff to manage internal administrative tasks, professional blocks, or private clinical sessions.',
    ),
  ];

  static const List<AppointmentTypeModel> dummyAppointmentTypes = [
    AppointmentTypeModel(
      id: 1,
      key: 'consultation',
      title: 'Consultation',
      description: 'A comprehensive evaluation to discuss clinical needs and treatment planning with the specialist.',
      timing: 'Before Treatment',
      maxDuration: 30,
      appointmentModes: ['In-Person', 'Virtual'],
    ),
    AppointmentTypeModel(
      id: 2,
      key: 'treatment',
      title: 'Treatment',
      description: 'The primary session for the selected clinical procedure and therapy application.',
      timing: 'Primary Session',
      maxDuration: 60,
      appointmentModes: ['In-Person'],
    ),
    AppointmentTypeModel(
      id: 3,
      key: 'follow_up',
      title: 'Follow-up',
      description: 'Reviewing results and monitoring progress following the completion of the procedure.',
      timing: 'After Treatment',
      maxDuration: 15,
      appointmentModes: ['In-Person', 'Virtual'],
    ),
  ];
}

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
