# Implementation Plan - Redesign Subscription Screen

The goal is to unify the subscription plan management. Currently, there is a special "Free System Plan" that is handled differently from other "Custom Subscription Tiers". The user wants all plans to be treated equally, allowing them to create and name plans as they wish (including "Free" plans).

## User Review Required

> [!IMPORTANT]
> The "Free System Plan" (which had a `durationMonths` field) will be completely removed. If a "Free" plan is needed, it should be created as a standard plan with `basePrice = 0`. Any existing logic relying on the special "System Default" status will be replaced with uniform plan management.

## Proposed Changes

### Subscription View Model & State

#### [MODIFY] [subscription_view_model.dart](file:///Users/appstirr/Documents/Flutter/skinsync_admin/lib/view_models/subscription_view_model.dart)
- Remove `freeSystemPlan` from `SubscriptionState`.
- Update `SubscriptionViewModel.getSubscriptionPlans` to only fetch the list of `plans`.
- Remove any dummy data or logic referencing `freeSystemPlan`.

### Subscription Plans UI

#### [MODIFY] [subscription_plans.dart](file:///Users/appstirr/Documents/Flutter/skinsync_admin/lib/screens/bottom_nav_screens/subscription_plans.dart)
- Remove the "System Default Tier" section from the UI.
- Delete `_buildFreePlanCard`.
- Update `_buildContent` to display all plans in the grid/list.
- Rename `_buildPaidPlanCard` to `_buildPlanCard` and use it for all items.

### Create Subscription Plan UI

#### [MODIFY] [create_subscription_plan_screen.dart](file:///Users/appstirr/Documents/Flutter/skinsync_admin/lib/screens/create_subscription_plan_screen.dart)
- Remove `freePlanToEdit` parameter.
- Remove `_initFromFreePlan` and `isSystemPlan` logic.
- Simplify the form by removing specialized fields for system plans (like `durationMonths`).
- Ensure all plans have an editable name and base price.

### Models & Data

#### [MODIFY] [dummy_data.dart](file:///Users/appstirr/Documents/Flutter/skinsync_admin/lib/utils/dummy_data.dart)
- Remove `dummyFreeSystemPlan`.

#### [DELETE] [free_system_plan_model.dart](file:///Users/appstirr/Documents/Flutter/skinsync_admin/lib/models/free_system_plan_model.dart)
- Remove the unused model.

## Verification Plan

### Automated Tests
- N/A (Project doesn't seem to have relevant unit tests for this yet, but I will check for regressions in compilation).

### Manual Verification
- Navigate to the Subscription Models screen.
- Verify that there is no "System Default Tier" section.
- Verify that all plans are displayed in a uniform grid.
- Click "Create New Tier" and verify the form is simplified and allows creating any plan.
- Edit an existing plan and verify it works correctly.
- Delete a plan and verify it disappears.
