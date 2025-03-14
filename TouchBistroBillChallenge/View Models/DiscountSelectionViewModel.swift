//
//  DiscountSelectionViewModel.swift
//  TouchBistroBillChallenge
//
//  Created by Alex Mitchell on 2025-03-13.
//

import Foundation
import TBBillKit

@MainActor
class DiscountSelectionViewModel: ObservableObject {
    private(set) var discounts: OrderedSet<Discount>
    @Published var selectedDiscounts: Set<Discount>
    @Published var applicationOrder: DiscountApplicationOrder
    
    init(discounts: [Discount: Bool], applicationOrder: DiscountApplicationOrder = .fixedAmountFirst) {
        self.discounts = OrderedSet(discounts.keys.map { $0 })
        self.selectedDiscounts = Set(discounts.compactMap { $0.value == true ? $0.key : nil })
        self.applicationOrder = applicationOrder
    }
    
    func toggleDiscount(_ discount: Discount) {
        guard discounts.contains(discount) else { return }
        if selectedDiscounts.contains(discount) {
            selectedDiscounts.remove(discount)
        } else {
            selectedDiscounts.insert(discount)
        }
    }
    
    func toggleDiscountApplicationOrder() {
        applicationOrder = (applicationOrder == .percentageFirst) ? .fixedAmountFirst : .percentageFirst
    }
}
