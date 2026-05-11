# Treatment Module API Documentation

This document outlines the required API structure, data models, and integration logic for the SkinSync Admin Panel "Treatments" module.

**Important Note:** Pricing is managed exclusively via the Clinic Portal. The Admin Panel does not handle, display, or update any treatment prices.

## 1. Data Models

### 1.1 Treatment Object
| Field | Type | Description | Required |
| :--- | :--- | :--- | :--- |
| `id` | Integer | Unique identifier | Yes (Response) |
| `name` | String | Internal administrative name | Yes |
| `patient_display_name` | String | Name visible to patients in app | Yes |
| `description` | String | Full clinical description (HTML/Markdown support preferred) | Yes |
| `short_description` | String | Brief summary for listing cards | Yes |
| `category` | String | Parent category (e.g., "Injectables") | Yes |
| `subcategory` | String | Child category (e.g., "Neurotoxins") | Yes |
| `image` | String (URL) | Banner image for details screen | Yes |
| `icon` | String (URL) | Icon for listing and navigation | Yes |
| `material_name` | String | Unit/Consumable name (e.g., "Syringes", "Units") | Optional |
| `max_material_quantity` | Integer | Max allowed units for the material (Default: 0) | Optional |
| `is_active` | Boolean | Status toggle for system visibility | Yes |
| `use_in_ai_simulator` | Boolean | Visibility toggle for the AI Simulator feature | Yes |
| `combinable_treatment_ids` | List<Int> | IDs of treatments that can be performed in the same session | Optional |
| `side_areas` | List<Object> | List of anatomical target zones (see 1.2) | Optional |

### 1.2 Side Area Object
| Field | Type | Description | Required |
| :--- | :--- | :--- | :--- |
| `id` | Integer | Unique ID | Yes |
| `name` | String | Area name (e.g., "Forehead") | Yes |
| `max_units` | Integer | Maximum safety limit for units in this area | Optional |

---

## 2. API Endpoints

### 2.1 Get Treatments Directory (Listing)
`GET /api/v1/admin/treatments`

**Query Parameters:**
* `search`: String (Filter by name/description)
* `category`: String
* `subcategory`: String
* `is_active`: Boolean
* `page`: Integer (Pagination)
* `limit`: Integer

**Response JSON:**
```json
{
  "success": true,
  "data": {
    "total": 48,
    "items": [
      {
        "id": 1,
        "name": "Botox Cosmetic",
        "patient_display_name": "Wrinkle Relaxer",
        "category": "Injectables",
        "subcategory": "Neurotoxins",
        "image": "https://cdn.skinsync.com/treatments/botox_banner.jpg",
        "is_active": true,
        "side_areas": [{"id": 1, "name": "Forehead"}]
      }
    ]
  }
}
```

### 2.2 Create New Treatment
`POST /api/v1/admin/treatments`
*Note: Use Multipart/form-data if uploading images directly, or JSON if passing URLs.*

**Request JSON:**
```json
{
  "name": "Botox Cosmetic",
  "patient_display_name": "Wrinkle Relaxer",
  "description": "Full clinical description...",
  "short_description": "Anti-aging injectable.",
  "category": "Injectables",
  "subcategory": "Neurotoxins",
  "material_name": "Units",
  "max_material_quantity": 50,
  "is_active": true,
  "use_in_ai_simulator": true,
  "combinable_treatment_ids": [4, 12, 18],
  "side_areas": [
    {
      "name": "Forehead",
      "max_units": 50
    }
  ]
}
```

### 2.3 Update Treatment (Edit)
`PATCH /api/v1/admin/treatments/{id}`

**Request JSON:**
*(Allows partial updates)*
```json
{
  "is_active": false,
  "name": "Updated Name"
}
```

### 2.4 Delete Treatment
`DELETE /api/v1/admin/treatments/{id}`

---

## 3. Taxonomy & Master Data

### 3.1 Get Categories Hierarchy
`GET /api/v1/admin/taxonomy/categories`

**Expected Response:**
```json
{
  "items": [
    {
      "name": "Injectables",
      "icon": "https://cdn.skinsync.com/icons/syringe.png",
      "subcategories": [
        {"name": "Neurotoxins", "icon": null},
        {"name": "Dermal Fillers", "icon": null}
      ]
    }
  ]
}
```

### 3.2 Get Body Areas Hierarchy
`GET /api/v1/admin/taxonomy/body-areas`

**Expected Response:**
```json
{
  "items": [
    {
      "name": "Upper Face",
      "icon": "https://cdn.skinsync.com/icons/face.png",
      "sub_areas": [
        {"name": "Forehead", "icon": null},
        {"name": "Glabella", "icon": null}
      ]
    }
  ]
}
```

---

## 4. Logical Constraints (Integration Notes)

1. **No Pricing**: All pricing fields have been removed from the Admin API. Pricing is handled separately per clinic in the Clinic Portal.
2. **Active/Inactive Status**: Inactive treatments should still be returned in the Admin GET listing but flagged so the frontend can display the "INACTIVE" badge.
3. **AI Simulator Logic**: If `use_in_ai_simulator` is true, the backend must ensure the treatment is compatible with the AI mapping engine.
4. **Combinable Treatments**: This field is a list of IDs. When returning a Treatment object, the backend should ideally return a simplified object for combinable items (ID + Name) to avoid deep nesting.
5. **Image Handling**: Frontend sends `File` objects for `image` and `icon`. Backend should store these in S3/Cloud storage and return the permanent URLs in the response.

## 5. Error Responses

**Validation Error (422):**
```json
{
  "success": false,
  "error": "Validation Failed",
  "details": {
    "name": ["The internal treatment name is already taken."],
    "category": ["Selected category is invalid."]
  }
}
```

**Authentication Error (401):**
```json
{
  "success": false,
  "error": "Unauthorized Access",
  "message": "Admin token expired or invalid."
}
```
