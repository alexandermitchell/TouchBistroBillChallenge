//
//  TouchBistroBillChallengeApp.swift
//  TouchBistroBillChallenge
//
//  Created by Alex Mitchell on 2025-03-11.
//

import SwiftUI
import TBBillKit

@main
struct TouchBistroBillChallengeApp: App {
    var body: some Scene {
        let billViewModel = BillViewModel(billCalculator: BillCalculator(taxCalculator: TaxCalculator(), discountCalculator: DiscountCalculator()))
        WindowGroup {
            MenuOrderView(billViewModel: billViewModel)
        }
    }
}
