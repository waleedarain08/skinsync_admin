# Treatment CRUD API Documentation

This document outlines the requests and responses for the Treatment management system, following the **Session-based Architecture** and dynamic configuration engine.

## Data Models

### Treatment Structure
| Field | Type | Description |
| :--- | :--- | :--- |
| `id` | `int?` | Unique identifier |
| `global_sku` | `String` | Unique identifier (Format: `TRT-XXXX-XXXX`) |
| `name` | `String` | Internal name of the treatment |
| `patient_display_name`| `String` | Aesthetic name shown to patients |
| `description` | `String` | Detailed clinical explanation |
| `short_description` | `String` | Short overview shown on list pages |
| `category_id` | `String` | Associated parent/sub-category ID |
| `category_name` | `String` | Associated category name |
| `category_path` | `String` | Breadcrumb category route |
| `icon` | `String?` | Key or URL for icon resource |
| `image` | `String?` | Key or URL for hero image resource |
| `base_price` | `double` | Minimum baseline price for 1 session |
| `unit_prices` | `Map<String, double>?` | Override price per product unit of measure |
| `side_areas` | `List<SideArea>` | Nested regional anatomical sub-pricing |
| `status` | `String` | Current template state (`draft` \| `active` \| `deactive`) |
| `use_in_ai_simulator` | `bool` | Toggle compatibility with the Face Simulator |
| `enable_by_default` | `bool` | Auto-assign treatment to new clinics |
| `prep_time` | `int` | Preparation duration (minutes) |
| `cleanup_time` | `int` | Post-treatment sanitization duration (minutes) |
| `allow_clinic_override`| `bool` | Allow clinics to override durations & protocols |
| `allow_provider_override`| `bool` | Allow providers to override pricing at checkout |
| `online_bookable` | `bool` | Available in patient portal booking |
| `manual_approval_required`| `bool` | Requires provider triage review before booking |
| `minimum_booking_notice`| `int` | Lead time needed to book (hours) |
| `maximum_days_in_advance`| `int` | Max booking search range (days) |
| `pre_notification_source`| `String` | Inheritance source (`category` \| `custom`) |
| `post_notification_source`| `String` | Inheritance source (`category` \| `custom`) |
| `pre_notifications` | `List<Notification>` | Reminders sent before sessions |
| `post_notifications` | `List<Notification>` | Care/instruction sets sent after sessions |
| `session_source` | `String` | Inheritance source (`category` \| `custom`) |
| `total_sessions` | `int` | Number of planned sessions (Min: 1) |
| `sessions` | `List<Session>` | Detail session definitions with follow-ups |
| `downtime_level` | `String` | Healing window category (`None` \| `Low` \| `Moderate` \| `High`) |
| `provider_roles_source`| `String` | Inheritance source (`category` \| `custom`) |
| `allowed_roles` | `List<String>` | Authorized clinical roles (e.g., `Injector`, `Aesthetician`, `MD`) |
| `pre_treatment_attachments`| `List<Attachment>` | PDF instructions and media attachments |
| `post_treatment_attachments`| `List<Attachment>` | Aftercare guidelines and media attachments |
| `pre_treatment_consent_form`| `Attachment?` | PDF clinical consent forms |
| `product_usages` | `List<ProductUsage>`| Inventory consumables mapped to this treatment |
| `require_post_treatment_photos`| `bool` | Prompts patient to submit post-care photos |
| `required_post_treatment_photo_count`| `int` | Number of photos requested (Min: 1) |

---

## Endpoints

### 1. List All Treatments
Retrieves the paginated and filterable library of treatments.

*   **URL:** `/admin/treatments`
*   **Method:** `GET`
*   **Query Parameters:**
    *   `page`: Page index (Default: `1`)
    *   `search`: Filter by name or SKU
    *   `category_id`: Refine results to specific sub-categories
    *   `status`: Filter by status (`active` \| `draft` \| `deactive`)
*   **Success Response (200):**
    ```json
    {
      "status": true,
      "message": "Treatments fetched successfully",
      "data": [
        {
          "id": 1,
          "global_sku": "TRT-A1B2-C3D4",
          "name": "Botox Cosmetic",
          "patient_display_name": "Wrinkle Relaxer",
          "base_price": 150.0,
          "total_sessions": 1,
          "enable_by_default": true,
          "status": "active"
        }
      ]
    }
    ```

### 2. Get Treatment Detail
Retrieves full configuration details for a specific treatment template.

*   **URL:** `/admin/treatments/{id}`
*   **Method:** `GET`
*   **Success Response (200):**
    ```json
    {
      "status": true,
      "message": "Treatments fetched successfully",
      "data": {
        "id": 1,
        "global_sku": "TRT-A1B2-C3D4",
        "name": "Botox Cosmetic",
        "patient_display_name": "Wrinkle Relaxer",
        "description": "Smooth fine lines and wrinkles in the upper face.",
        "short_description": "Anti-aging injectable treatment.",
        "category_id": "12",
        "category_name": "Neurotoxins",
        "category_path": "Injectables > Neurotoxins",
        "base_price": 150.0,
        "status": "active",
        "use_in_ai_simulator": true,
        "enable_by_default": true,
        "prep_time": 10,
        "cleanup_time": 5,
        "allow_clinic_override": false,
        "allow_provider_override": true,
        "online_bookable": true,
        "manual_approval_required": false,
        "minimum_booking_notice": 24,
        "maximum_days_in_advance": 90,
        "pre_notification_source": "custom",
        "post_notification_source": "category",
        "pre_notifications": [
          {
            "title": "Avoid Blood Thinners",
            "message": "Please avoid aspirin or ibuprofen for 48 hours prior.",
            "timing": 48,
            "timing_unit": "hours",
            "type": "reminder"
          }
        ],
        "post_notifications": [],
        "session_source": "category",
        "total_sessions": 1,
        "sessions": [
          {
            "session_number": 1,
            "follow_ups": [
              {
                "type": "virtual",
                "duration_value": 15,
                "duration_unit": "minutes",
                "interval_value": 14,
                "interval_unit": "days",
                "is_image_required": true,
                "notes": "Verify full neurotoxin activation"
              }
            ]
          }
        ],
        "downtime_level": "None",
        "provider_roles_source": "category",
        "allowed_roles": ["Injector", "MD"],
        "pre_treatment_attachments": [],
        "post_treatment_attachments": [],
        "pre_treatment_consent_form": {
          "url": "https://storage.skinsyncai.com/forms/botox_consent.pdf",
          "name": "Botox Legal Consent.pdf",
          "type": "pdf"
        },
        "product_usages": [
          {
            "product_id": 101,
            "product_name": "Botox Cosmetic 100 Unit Vial",
            "usage_type": "Variable",
            "min_quantity": 1.0,
            "max_quantity": 100.0,
            "deduction_timing": "On_Completion",
            "allow_substitution": false,
            "per_unit_duration": 0.5,
            "notes": "Dilute with 2.5ml preservative-free saline"
          }
        ],
        "side_areas": [
          {
            "id": 1,
            "name": "Upper Face",
            "sub_areas": [
              {
                "name": "Forehead",
                "base_price": 12.0
              }
            ]
          }
        ],
        "require_post_treatment_photos": false,
        "required_post_treatment_photo_count": 0
      }
    }
    ```

### 3. Create Treatment
Creates a new medical aesthetic procedure.

*   **URL:** `/admin/treatments`
*   **Method:** `POST`
*   **Request Body:** Same schema as Treatment Detail data structure.
*   **Success Response (200):**
    ```json
    {
      "status": true,
      "message": "Treatment created successfully",
      "data": {
        "id": 1,
        "global_sku": "TRT-A1B2-C3D4",
        "name": "Botox Cosmetic",
        "status": "active"
      }
    }
    ```

### 4. Update Treatment
Modifies an existing Treatment and handles runtime updates for any dependent clinics.

*   **URL:** `/admin/treatments/{id}`
*   **Method:** `PUT` / `PATCH`
*   **Request Body:** (Same as Create)

### 5. Delete Treatment
Performs soft-deletion of a treatment.

*   **URL:** `/admin/treatments/{id}`
*   **Method:** `DELETE`

---

## Nested Objects Reference

### SideArea & SubArea Structure
```json
{
  "name": "Anatomical Zone (e.g. Face)",
  "sub_areas": [
    {
      "name": "Forehead",
      "base_price": 12.0,
      "unit_prices": {
        "Units": 12.0
      },
      "children": []
    }
  ]
}
```

### ProductUsage Structure
```json
{
  "product_id": 101,
  "product_name": "Product Display Name",
  "unit": "Units | Syringe | Vial",
  "usage_type": "Required | Optional | Variable | Setup | Post Care | Device",
  "deduction_timing": "On Completion | Manual | Post Confirmation",
  "allow_substitution": true,
  "min_quantity": 10.0,
  "max_quantity": 50.0,
  "per_unit_duration": 0.5,
  "notes": "Reconstitute before injection"
}
```

### Attachment Schema
```json
{
  "url": "https://storage.skinsyncai.com/uploads/guidelines.pdf",
  "name": "Aftercare Guidelines.pdf",
  "type": "pdf | image | video | other"
}
```
