//
//  BillViewModel.swift
//  TouchBistroBillChallenge
//
//  Created by Alex Mitchell on 2025-03-11.
//

import Foundation
import Combine
import TBBillKit

@MainActor
class BillViewModel: ObservableObject {
    @Published private(set) var billItems: [ItemCategory: OrderedSet<BillItem>] = [:]
    @Published private(set) var subtotal: Decimal = 0.0
    @Published private(set) var taxTotal: Decimal = 0.0
    @Published private(set) var discountTotal: Decimal = 0.0
    @Published private(set) var finalTotal: Decimal = 0.0

    private let billCalculator: BillCalculating
    private var taxes: Set<Tax> = []
    private var appliedDiscounts: Set<Discount> = []
    private var discountApplicationOrder: DiscountApplicationOrder = .fixedAmountFirst

    init(billCalculator: BillCalculating) {
        self.billCalculator = billCalculator
    }

    /// Used for displaying ordered
    var orderedCategories: [ItemCategory] {
        billItems.keys.sorted { $0.rawValue < $1.rawValue }
    }
    
    func addItem(_ item: BillItem) {
        let existingItem = billItems[item.category]?.modifyFirst(where: { $0 == item }) { $0.increaseQuantity() }

        if existingItem == nil {
            let newItem = BillItem(id: item.id, name: item.name, category: item.category, price: item.price, quantity: 1, exemptTaxes: item.exemptTaxes)
            billItems[item.category, default: OrderedSet()].append(newItem)
        }

        updateBill()
    }
    
    func removeItem(_ item: BillItem) {
        let existingItem = billItems[item.category]?.modifyFirst(where: { $0 == item }) { $0.decreaseQuantity() }

        if let existingItem {
            billItems[item.category]?.removeIf(existingItem, condition: {$0.quantity == 0 })
        }

        if billItems[item.category]?.isEmpty == true {
            billItems.removeValue(forKey: item.category)  // Remove category if empty
        }

        updateBill()
    }
    
    func updateTaxes(_ taxes: Set<Tax>) {
        self.taxes = taxes
        if !billItems.isEmpty {
            updateBill()
        }
    }

    func applyDiscounts(_ discounts: Set<Discount>, applicationOrder: DiscountApplicationOrder) {
        self.appliedDiscounts = discounts
        self.discountApplicationOrder = applicationOrder
        if !billItems.isEmpty {
            updateBill()
        }
    }

    private func updateBill() {
        let (subtotal, finalTotal, taxTotal, discountTotal) = billCalculator.calculateBill(
            for: billItems,
            taxes: taxes,
            discounts: appliedDiscounts,
            discountOrder: discountApplicationOrder
        )
        
        self.subtotal = subtotal
        self.taxTotal = taxTotal
        self.discountTotal = discountTotal
        self.finalTotal = finalTotal
    }
}
