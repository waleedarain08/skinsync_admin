# Inventory (Product Catalog) CRUD & In-Memory Mode Documentation

This document outlines the current data models, UI logic, and in-memory simulated flow for the Global Product Catalog (Inventory) management system inside Skinsync Admin.

---

## 🛠️ Unified Architecture & Mode

To facilitate instant offline responsiveness and mock testing before backend readiness, the **Product Module** has been updated to run entirely on **In-Memory Dummy Data**. 

*   **Bypassed Endpoints:** Bypasses listing, creation, updates, and deletion endpoints.
*   **Active Category API:** The `GET /api/admin/categories` endpoint remains **fully active** and integrated with the hierarchical dialog picker.
*   **State Persistence:** In-memory lists mutate instantly during runtime, allowing seamless Create, Read, Update, and Delete actions with real-time UI refreshes.

---

## 📋 Data Models

### Product Structure
| Field | Type | Description |
| :--- | :--- | :--- |
| `id` | `int` | Internal identifier (auto-incremented in-memory) |
| `name` | `String` | Product name |
| `brand` | `String?` | Manufacturer or brand name (e.g. Allergan, Galderma) |
| `global_sku` | `String?` | Unique global catalog identifier |
| `sku` | `String?` | Clinic-specific SKU |
| `barcode` | `String?` | Barcode or UPC code of the product |
| `product_purpose`| `String?`| The usage type/clinical purpose of the product |
| `category` | `String?` | String representing full selected hierarchy path (e.g., `Full Body Laser > Arm Laser`) |
| `selected_category_ids` | `List<int>?` | Full chain of category IDs representing hierarchy, allowing precise backend taxonomy mapping |
| `status` | `String` | `Active` or `Inactive` |
| `image` | `String` | URL to product image |
| `description` | `String` | Product specifications |
| `enforce_lot_tracking`| `bool` | Flag requiring lot/expiration logging at clinic levels |
| `clinic_cost` | `double?` | Price paid by the clinic per bulk purchase Unit Type |
| `retail_price_per_unit` | `double?` | Retail price charged to patients per billable unit (e.g. per ml) |
| `supplier` | `String?` | Vendor or supplier of this product batch |
| `lot_number` | `String?` | Manufacturing lot/batch code |
| `expiration_date` | `String?` | Expiration date of this product batch (ISO 8601) |

### 📦 Dynamic Packaging & Billing Fields (Section 2 & 3)
To handle multi-tiered packaging (e.g., 1 Carton ➔ 8 Boxes ➔ 5 Syringes ➔ 4 ml), the following fields are actively managed and calculated:

| Field | Type | Description |
| :--- | :--- | :--- |
| `unit_type` | `String?` | Bulk purchase unit (e.g. `Carton`, `Case`, `Box`) |
| `box_quantity` | `int?` | Inner boxes inside one Unit Type |
| `item_quantity_per_box`| `int?`| Quantity of physical items (e.g., syringes) per inner box |
| `package_type` | `String?` | The base physical item (e.g., `Syringe`, `Vial`, `Piece`) |
| `billable_unit` | `String?` | Measurement for consumption/billing (e.g., `ml`, `mg`, `units`) |
| `billable_quantity_per_item` | `double?` | Volume/potency contained in a single physical syringe/vial (e.g., 4.0 ml) |
| `total_billable_quantity` | `double?` | **[Read-Only]** Automatically calculated total capacity of the bulk unit (`box_quantity` × `item_quantity_per_box` × `billable_quantity_per_item`) |

---

## 🎨 Interactive UI & Business Rules

### 1. Dynamic Formula Footer
At the bottom of Section 2, the dialog dynamically displays a visual packaging equation in real-time as users enter counts:
`Total [Package Type]s in 1 [Unit Type] = [Box Quantity] boxes × [Item Quantity] [Package Type]s = [Total] [Package Type]s.`

### 2. Auto-Calculated Capacity
Total Billable Quantity is locked (`readOnly: true`) and auto-calculated in real-time as users type. For example:
- `Box Quantity` = 8
- `Item Quantity` = 5
- `Billable Qty per Item` = 4.0 ml
- **Result:** `Total Billable Quantity` automatically pre-fills with **`160.0`**.

### 3. Left-to-Right Hierarchical Category Selector
Clicking `+` next to Category queries the active category provider and displays a left-to-right columns selector supporting **unlimited recursive nesting levels**. 
*   **Breadcrumb Generation:** Automatically merges selected level names into a clean path (`Parent > Subcategory > Child`).
*   **Lineage Storage:** Populates `selectedCategoryIds` with the full selection lineage (e.g., `[1, 2, 3]`).
*   **Clear Option:** The `Clear Category` button clears selection and paths, indicating that a product is non-category-specific.

---

## 🧪 Simulation Endpoints (In-Memory View Model)

### 1. List Products
*   **Simulated URL:** `GET /api/admin/products`
*   **Action:** Fetches directly from the mutable copy of `dummyProducts`.
*   **Mock Response (200 OK):**
    ```json
    {
      "status": true,
      "message": "Products fetched successfully",
      "data": [
        {
          "id": 101,
          "image": "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop",
          "name": "Botox Cosmetic 100 Unit Vial",
          "brand": "Allergan",
          "global_sku": "ALL-BTX-100U-V",
          "sku": "ALL-BTX-100U-V",
          "barcode": "1234567890",
          "product_purpose": "Variable",
          "category": "Injectables > Neurotoxins",
          "selected_category_ids": [1, 12],
          "status": "Active",
          "description": "Preservative-free sterile, vacuum-dried powder for reconstitution. Contains 100 units.",
          "unit_type": "Carton",
          "box_quantity": 8,
          "item_quantity_per_box": 5,
          "package_type": "Syringe",
          "billable_unit": "ml",
          "billable_quantity_per_item": 4.0,
          "total_billable_quantity": 160.0,
          "enforce_lot_tracking": true,
          "clinic_cost": 800.0,
          "retail_price_per_unit": 15.0,
          "supplier": "McKesson",
          "lot_number": "L98765",
          "expiration_date": "2026-12-31T00:00:00.000Z"
        }
      ]
    }
    ```

### 2. Add Product
*   **Simulated URL:** `POST /api/admin/products`
*   **Action:** Generates a unique `id`, appends the new `ProductModel` to the local memory list, and refreshes the catalog instantly.
*   **Simulated Request Body:**
    ```json
    {
      "name": "Dysport 300 Unit Vial",
      "image": "",
      "brand": "Galderma",
      "sku": "GAL-DSP-300U",
      "barcode": "9876543210",
      "product_purpose": "Variable",
      "category": "Injectables > Neurotoxins",
      "selected_category_ids": [1, 12],
      "status": "Active",
      "description": "AbobotulinumtoxinA powder for injection.",
      "unit_type": "Carton",
      "box_quantity": 4,
      "item_quantity_per_box": 5,
      "package_type": "Vial",
      "billable_unit": "units",
      "billable_quantity_per_item": 300.0,
      "total_billable_quantity": 6000.0,
      "enforce_lot_tracking": true,
      "clinic_cost": 650.0,
      "retail_price_per_unit": 10.0,
      "supplier": "Allergan Logistics",
      "lot_number": "D45678",
      "expiration_date": "2027-06-30T00:00:00.000Z"
    }
    ```
*   **Mock Response (200 OK):**
    ```json
    {
      "status": true,
      "message": "Product created successfully",
      "data": {
        "id": 106,
        "image": "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop",
        "name": "Dysport 300 Unit Vial",
        "brand": "Galderma",
        "global_sku": "GAL-DSP-300U",
        "sku": "GAL-DSP-300U",
        "barcode": "9876543210",
        "product_purpose": "Variable",
        "category": "Injectables > Neurotoxins",
        "selected_category_ids": [1, 12],
        "status": "Active",
        "description": "AbobotulinumtoxinA powder for injection.",
        "unit_type": "Carton",
        "box_quantity": 4,
        "item_quantity_per_box": 5,
        "package_type": "Vial",
        "billable_unit": "units",
        "billable_quantity_per_item": 300.0,
        "total_billable_quantity": 6000.0,
        "enforce_lot_tracking": true,
        "clinic_cost": 650.0,
        "retail_price_per_unit": 10.0,
        "supplier": "Allergan Logistics",
        "lot_number": "D45678",
        "expiration_date": "2027-06-30T00:00:00.000Z"
      }
    }
    ```

### 3. Update Product
*   **Simulated URL:** `PATCH /api/admin/products/{id}`
*   **Action:** Locates the modified item in memory, updates its fields, and posts an instant UI refresh.
*   **Simulated Request Body:**
    ```json
    {
      "id": 101,
      "name": "Updated Botox Cosmetic 100 Unit Vial",
      "status": "Inactive"
    }
    ```
*   **Mock Response (200 OK):**
    ```json
    {
      "status": true,
      "message": "Product updated successfully"
    }
    ```

### 4. Delete Product
*   **Simulated URL:** `DELETE /api/admin/products/{id}`
*   **Action:** Removes the selected ID from the in-memory array and updates state.
*   **Mock Response (200 OK):**
    ```json
    {
      "status": true,
      "message": "Product deleted successfully"
    }
    ```
