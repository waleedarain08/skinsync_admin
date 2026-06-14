# Anatomical Areas CRUD API Documentation

This document outlines the requests and responses for the Anatomical Body Areas management system.

## Data Models

### Area Structure (3-Level Hierarchy)
| Field | Type | Description |
| :--- | :--- | :--- |
| `name` | `String` | Human-readable name of the area |
| `global_sku` | `String` | Unique clinical identifier (Format: XXXX-0000) |
| `icon` | `String?` | Icon identifier or URL |
| `sub_areas` | `List<SubArea>` | Level 2 hierarchy objects |
| `children` | `List<ChildArea>` | Level 3 hierarchy objects |

---

## Endpoints

### 1. List All Areas
Retrieves the complete anatomical hierarchy tree.

*   **URL:** `/admin/areas`
*   **Method:** `GET`
*   **Success Response (200):**
    ```json
    {
      "success": true,
      "data": [
        {
          "name": "Face",
          "global_sku": "FACE-1000",
          "icon": "face",
          "sub_areas": [
            {
              "name": "Upper Face",
              "global_sku": "FACE-1100",
              "icon": "upper_face_icon",
              "children": [
                {
                  "name": "Forehead",
                  "global_sku": "FACE-1110",
                  "icon": "forehead_icon"
                }
              ]
            }
          ]
        }
      ]
    }
    ```

### 2. Get Area Detail
Retrieves the full branch for a specific area.

*   **URL:** `/admin/areas/{global_sku}`
*   **Method:** `GET`
*   **Success Response (200):**
    ```json
    {
      "success": true,
      "data": {
        "name": "Face",
        "global_sku": "FACE-1000",
        "icon": "face",
        "sub_areas": []
      }
    }
    ```

### 3. Create Root Area
Creates a new Level 1 anatomical zone.

*   **URL:** `/admin/areas`
*   **Method:** `POST`
*   **Request Body:**
    ```json
    {
      "name": "Neck",
      "global_sku": "NECK-2000",
      "icon": "neck_icon"
    }
    ```

### 4. Create Sub-Area (Level 2)
Adds a sub-grouping under a root area.

*   **URL:** `/admin/areas/{parent_sku}/sub-areas`
*   **Method:** `POST`
*   **Request Body:**
    ```json
    {
      "name": "Front of Neck",
      "global_sku": "NECK-2100",
      "icon": "front_neck_icon"
    }
    ```

### 5. Create Child Area (Level 3)
Adds a specific target site under a sub-area.

*   **URL:** `/admin/areas/{parent_sku}/children`
*   **Method:** `POST`
*   **Request Body:**
    ```json
    {
      "name": "Neck Bands",
      "global_sku": "NECK-2110",
      "icon": "neck_bands_icon"
    }
    ```

### 6. Update Node
Updates the name, SKU, or icon for any existing node.

*   **URL:** `/admin/areas/{global_sku}`
*   **Method:** `PUT` / `PATCH`
*   **Request Body:**
    ```json
    {
      "name": "Updated Anatomical Name",
      "global_sku": "UPDT-1234",
      "icon": "new_icon_ref"
    }
    ```

### 7. Delete Node
Removes an anatomical node and all its descendants.

*   **URL:** `/admin/areas/{global_sku}`
*   **Method:** `DELETE`

---

## Technical Specifications

### Primary Key
Since the `id` field was removed, the `global_sku` serves as the **unique primary identifier** for all anatomical nodes across all levels. All updates and deletions must target this SKU.

### Hierarchy Rules
*   **Level 1**: Root Areas (e.g., Face, Body).
*   **Level 2**: Sub-Areas (Regional groupings like Mid Face).
*   **Level 3**: Child Areas (Precise clinical sites like Cheeks).

### SKU Format
The recommended format is `AAAA-0000` (4 alphabetic characters followed by a hyphen and 4 digits).
