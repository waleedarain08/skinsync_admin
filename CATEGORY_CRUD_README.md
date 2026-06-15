# Category CRUD API Documentation

This document outlines the requests and responses for the Category management system, following the **Session-based Architecture**.

## Data Models

### Category Structure
| Field | Type | Description |
| :--- | :--- | :--- |
| `id` | `String` | Unique identifier |
| `name` | `String` | Internal name of the category |
| `icon` | `String?` | Icon key or URL |
| `parent_id` | `String?` | ID of parent category (for nested hierarchy) |
| `total_sessions` | `int` | Default session count (Min: 1) |
| `default_sessions` | `List<Session>` | Template sessions with nested follow-ups |
| `pre_notifications` | `List<Notification>` | Default pre-treatment alerts |
| `post_notifications` | `List<Notification>` | Default post-treatment alerts |
| `downtime_presets` | `DowntimePresets` | Booking restriction durations |
| `default_roles` | `List<String>` | Authorized provider roles |
| `consent_form_url` | `String?` | Default legal documentation URL |
| `consent_form_name` | `String?` | Display name of the default PDF |

---

## Endpoints

### 1. List All Categories
Retrieves the hierarchical tree of categories.

*   **URL:** `/admin/categories`
*   **Method:** `GET`
*   **Success Response (200):**
    ```json
    {
      "success": true,
      "data": [
        {
          "id": "1",
          "name": "Injectables",
          "icon": "syringe",
          "total_sessions": 1,
          "children": []
        }
      ]
    }
    ```

### 2. Get Category Detail
Retrieves full configuration details for a specific category.

*   **URL:** `/admin/categories/{id}`
*   **Method:** `GET`
*   **Success Response (200):**
    ```json
    {
      "success": true,
      "data": {
        "id": "1",
        "name": "Laser Hair Removal",
        "icon": "spa",
        "total_sessions": 6,
        "consent_form_url": "https://storage.skinsyncai.com/forms/laser_consent_template.pdf",
        "consent_form_name": "Standard Laser Consent.pdf",
        "default_sessions": [
          {
            "session_number": 1,
            "follow_ups": [
              {
                "type": "virtual",
                "duration_value": 15,
                "duration_unit": "minutes",
                "interval_value": 24,
                "interval_unit": "hours",
                "is_image_required": true,
                "notes": "Post-first-session safety check"
              }
            ]
          },
          {
            "session_number": 2,
            "follow_ups": [
              {
                "type": "in_person",
                "duration_value": 30,
                "duration_unit": "minutes",
                "interval_value": 7,
                "interval_unit": "days",
                "is_image_required": false,
                "notes": "Weekly progress review"
              }
            ]
          }
        ],
        "pre_notifications": [
          {
            "title": "Preparation Reminder",
            "message": "Please shave the treatment area 24 hours before your session.",
            "timing": 24,
            "timing_unit": "hours",
            "type": "instruction"
          }
        ],
        "post_notifications": [
          {
            "title": "Post-Care Alert",
            "message": "Avoid direct sun exposure and apply soothing gel for the next 48 hours.",
            "timing": 2,
            "timing_unit": "hours",
            "type": "care"
          }
        ],
        "downtime_presets": {
          "none": 0,
          "low": 2,
          "moderate": 5,
          "high": 10
        },
        "default_roles": ["Injector", "Aesthetician", "MD"]
      }
    }
    ```

### 3. Create Category
Creates a new category template.

*   **URL:** `/admin/categories`
*   **Method:** `POST`
*   **Request Body:**
    ```json
    {
      "name": "Laser Hair Removal",
      "icon": "spa",
      "parent_id": null,
      "total_sessions": 6,
      "consent_form_url": "https://storage.skinsyncai.com/forms/default_consent.pdf",
      "consent_form_name": "General Laser Consent.pdf",
      "default_sessions": [
        {
          "session_number": 1,
          "follow_ups": [
            {
              "type": "virtual",
              "duration_value": 15,
              "duration_unit": "minutes",
              "interval_value": 24,
              "interval_unit": "hours",
              "is_image_required": true,
              "notes": "Post-first-session check"
            }
          ]
        }
      ],
      "pre_notifications": [
        {
          "title": "Shave Area",
          "message": "Please shave the treatment area 24 hours before.",
          "timing": 24,
          "timing_unit": "hours",
          "type": "instruction"
        }
      ],
      "post_notifications": [
        {
          "title": "Sun Protection",
          "message": "Avoid direct sun exposure for 48 hours.",
          "timing": 4,
          "timing_unit": "hours",
          "type": "care"
        }
      ],
      "downtime_presets": {
        "none": 0,
        "low": 1,
        "moderate": 3,
        "high": 7
      },
      "default_roles": ["Injector", "Aesthetician"]
    }
    ```

### 3. Update Category
Modifies an existing category and its inheritance templates.

*   **URL:** `/admin/categories/{id}`
*   **Method:** `PUT` / `PATCH`
*   **Request Body:** (Same as Create)

### 4. Delete Category
Removes a category (and recursively handles children).

*   **URL:** `/admin/categories/{id}`
*   **Method:** `DELETE`

---

## Nested Objects Reference

### Session Object
```json
{
  "session_number": 1,
  "follow_ups": [
    {
      "type": "virtual",
      "duration_value": 30,
      "duration_unit": "minutes",
      "interval_value": 7,
      "interval_unit": "days",
      "is_image_required": true,
      "notes": "Follow-up notes"
    }
  ]
}
```

### Follow-Up Config
```json
{
  "type": "virtual | in_person",
  "duration_value": 30,
  "duration_unit": "minutes | hours",
  "interval_value": 7,
  "interval_unit": "days | weeks",
  "is_image_required": true,
  "notes": "Clinical instructions"
}
```

### Notification Config
```json
{
  "title": "Alert Title",
  "message": "Message body",
  "timing": 12,
  "timing_unit": "hours | days | minutes",
  "type": "reminder | warning | instruction | care | recovery"
}
```

### Downtime Presets
```json
{
  "none": 0,
  "low": 2,
  "moderate": 5,
  "high": 10
}
```
*Values represent the number of days a booking restriction is applied.*
