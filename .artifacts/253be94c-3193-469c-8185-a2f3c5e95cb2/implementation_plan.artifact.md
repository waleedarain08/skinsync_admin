# Add "Set as Default" Switch to Subscription Plan Screens

The goal is to add a "Set as Default" switch to the subscription plan creation/update screens for both clinics and patients. This switch will allow administrators to mark a specific plan as the default one.

## Proposed Changes

### Models and Requests

#### [MODIFY] [clinic_subscription_plan_model.dart](file:///Users/appstirr/Documents/Flutter/skin_sync_mobile_app/skinsync_admin/lib/models/clinic_subscription_plan_model.dart)
- Add `isDefault` boolean field.
- Update `fromJson` and `toJson`.

#### [MODIFY] [patient_subscription_plan_model.dart](file:///Users/appstirr/Documents/Flutter/skin_sync_mobile_app/skinsync_admin/lib/models/patient_subscription_plan_model.dart)
- Add `isDefault` boolean field.
- Update `fromJson` and `toJson`.

#### [MODIFY] [create_clinic_subscription_plan_request.dart](file:///Users/appstirr/Documents/Flutter/skin_sync_mobile_app/skinsync_admin/lib/models/requests/create_clinic_subscription_plan_request.dart)
- Add `isDefault` boolean field.
- Update `toJson` and `fromModel`.

#### [MODIFY] [create_patient_subscription_plan_request.dart](file:///Users/appstirr/Documents/Flutter/skin_sync_mobile_app/skinsync_admin/lib/models/requests/create_patient_subscription_plan_request.dart)
- Add `isDefault` boolean field.
- Update `toJson` and `fromModel`.

### Screens

#### [MODIFY] [create_clinics_subscription_plan_screen.dart](file:///Users/appstirr/Documents/Flutter/skin_sync_mobile_app/skinsync_admin/lib/screens/create_clinics_subscription_plan_screen.dart)
- Add `_isDefault` state variable.
- Initialize `_isDefault` in `initState` if editing an existing plan.
- Add "Set as Default" switch in the UI near "Plan Status".
- Include `isDefault` in the request sent to the view model.

#### [MODIFY] [create_patient_subscription_plan_screen.dart](file:///Users/appstirr/Documents/Flutter/skin_sync_mobile_app/skinsync_admin/lib/screens/create_patient_subscription_plan_screen.dart)
- Add `_isDefault` state variable.
- Initialize `_isDefault` in `initState` if editing an existing plan.
- Add "Set as Default" switch in the UI near "Plan Status".
- Include `isDefault` in the request sent to the view model.

## Verification Plan

### Automated Tests
- N/A (UI and Model changes)

### Manual Verification
- Open the "Create Clinic Subscription Plan" screen and verify the "Set as Default" switch is present and functional.
- Open the "Create Patient Subscription Plan" screen and verify the "Set as Default" switch is present and functional.
- Verify that the value is correctly saved when creating or updating a plan.
