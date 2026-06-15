# Inventory (Product Catalog) CRUD API Documentation

This document outlines the requests and responses for the Global Product Catalog (Inventory) management system.

## Data Models

### Product Structure
| Field | Type | Description |
| :--- | :--- | :--- |
| `id` | `int` | Internal database identifier |
| `name` | `String` | Human-readable product name |
| `brand` | `String?` | Manufacturer or brand name (e.g. Allergan, Galderma) |
| `global_sku` | `String?` | Unique global catalog identifier |
| `sku` | `String?` | Clinic-specific SKU (if applicable) |
| `category` | `String?` | Product category (e.g. Neurotoxin, Dermal Filler, Consumable) |
| `product_purpose` | `String?` | Clinical use case |
| `unit` | `String` | Base unit of measure (e.g. Units, ml, Vial, Syringe) |
| `unit_type` | `String?` | Measurement classification |
| `quantity` | `int?` | Available stock level |
| `status` | `String` | `Active` or `Inactive` |
| `image` | `String` | URL to product image |
| `description` | `String` | Detailed product specifications |
| `enforce_lot_tracking`| `bool` | Flag to require lot number and expiration entry during use |

---

## Endpoints

### 1. List All Products
Retrieves the complete global product catalog.

*   **URL:** `/admin/products`
*   **Method:** `GET`
*   **Success Response (200):**
    ```json
    {
      "success": true,
      "data": [
        {
          "id": 1,
          "name": "Botox Cosmetic",
          "brand": "Allergan",
          "global_sku": "ALGN-BTX-100",
          "category": "Neurotoxin",
          "unit": "Units",
          "quantity": 5000,
          "status": "Active",
          "enforce_lot_tracking": true
        }
      ]
    }
    ```

### 2. Create Product
Adds a new product to the global inventory.

*   **URL:** `/admin/products`
*   **Method:** `POST`
*   **Request Body:**
    ```json
    {
      "name": "Juvederm Ultra XC",
      "brand": "Allergan",
      "global_sku": "ALGN-JUV-U",
      "description": "Cross-linked hyaluronic acid dermal filler.",
      "unit": "ml",
      "category": "Dermal Filler",
      "image": "https://storage.skinsyncai.com/products/juvederm.png",
      "status": "Active",
      "enforce_lot_tracking": true
    }
    ```

### 3. Update Product
Modifies details of an existing catalog item.

*   **URL:** `/admin/products/{id}`
*   **Method:** `PATCH`
*   **Request Body:**
    ```json
    {
      "name": "Updated Product Name",
      "quantity": 150,
      "status": "Inactive"
    }
    ```

### 4. Delete Product
Archives or removes a product from the global catalog.

*   **URL:** `/admin/products/{id}`
*   **Method:** `DELETE`

---

## Technical Specifications

### Clinical Units
Common unit values used in the system:
*   `Units` (for Neurotoxins)
*   `ml` (for Fillers/Topicals)
*   `Vial` (for Lyophilized products)
*   `Syringe` (for Pre-filled items)
*   `Box` (for Consumables)

### Lot Tracking Rules
If `enforce_lot_tracking` is `true`, the clinical app will force practitioners to scan or enter a lot number and expiration date before the product can be deducted from inventory during a treatment session.
