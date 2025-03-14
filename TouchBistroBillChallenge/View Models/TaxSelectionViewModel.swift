//
//  TaxSelectionViewModel.swift
//  TouchBistroBillChallenge
//
//  Created by Alex Mitchell on 2025-03-13.
//

import Foundation
import TBBillKit

@MainActor
class TaxSelectionViewModel: ObservableObject {
    private(set) var taxes: OrderedSet<Tax>
    @Published var selectedTaxes: Set<Tax>
    
    init(taxes: [Tax: Bool]) {
        self.taxes = OrderedSet(taxes.keys.map { $0 })
        self.selectedTaxes = Set(taxes.compactMap { $0.value == true ? $0.key : nil })
    }
    
    func toggleTax(_ tax: Tax) {
        guard taxes.contains(tax) else { return }
        
        if selectedTaxes.contains(tax) {
            selectedTaxes.remove(tax)
        } else {
            selectedTaxes.insert(tax)
        }
    }
}
