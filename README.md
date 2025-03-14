# TouchBistro Coding Challenge Submission

**Name:** **Alex Mitchell**  
**Production iOS Experience:** **8 years** using both Swift and Objective-C

---

## Application Design

### **Main App Design**
The main app follows a structured **MVVM (Model-View-ViewModel) architecture**, ensuring separation of concerns, testability, and scalability. Key components include:

- **`BillViewModel`** - Manages adding/removing items from the bill. Serves as the single source of truth for the active bill, using `@Published` properties for reactive UI updates. It invokes `BillCalculator` whenever there are changes.
- **`TaxSelectionViewModel` & `DiscountSelectionViewModel`** - Handles tax and discount selection, ensuring that `BillViewModel` is updated upon user interaction.

### **UI Implementation**
The UI is built with **SwiftUI**, utilizing:
- **Two lists (side-by-side)** for menu items and bill items, improving clarity.
- **Full Screen Modal sheets** for tax and discount selection, offering an intuitive user experience.
- **SwiftUI’s state management (`@ObservedObject`, `@StateObject`)** to efficiently propagate updates across views.

---

## TBBillKit Package Design

### **Deterministic Outputs**
TBBillKit ensures **deterministic outputs** by:
- Using **pure functions** (e.g., `calculateBill`) that always return the same result given the same inputs.
- Avoiding side effects and global state, ensuring outputs are predictable and testable.
- Keeping tax and discount calculations **stateless**, meaning each calculation is computed based only on the provided bill items, taxes, and discounts.

### **Use of `OrderedSet` from Apple's OrderedCollections**
I utilized `OrderedSet` for `BillItem` calculations to optimize performance and maintain data integrity:
- **Preserves insertion order** while ensuring uniqueness.
- **Enables efficient updates** when modifying item quantities without requiring full array reallocation.
- **Improves lookup performance** compared to a standard array (`O(1)` for lookups vs. `O(n)`).

### **Why `BillItem` Has a `quantity` Property**
Rather than storing duplicate `BillItem` instances when the same item is added multiple times, **each `BillItem` has a `quantity` property**. This provides several benefits:
- **Prevents redundant tax and discount calculations** by grouping identical items.
- **Optimizes performance** by updating the existing entry instead of inserting a new one.
- **Ensures correct display in the UI**, where the order list shows grouped items with their respective quantity.

This approach enhances the **efficiency of tax and discount calculations**, minimizes redundant operations, and ensures the bill remains reactive and up to date.

---

