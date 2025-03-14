//
//  DiscountSelectionView.swift
//  TouchBistroBillChallenge
//
//  Created by Alex Mitchell on 2025-03-11.
//

import SwiftUI
import TBBillKit

struct DiscountSelectionView: View {
    @ObservedObject var viewModel: DiscountSelectionViewModel
    @Environment(\.dismiss) private var dismiss
    var onSelectionChanged: (Set<Discount>, DiscountApplicationOrder) -> Void
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Discount Application Order")) {
                    HStack {
                        Text("Apply Percentage Discounts First")
                        Spacer()
                        if viewModel.applicationOrder == .percentageFirst {
                            Image(systemName: "checkmark")
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.toggleDiscountApplicationOrder()
                    }

                    HStack {
                        Text("Apply Fixed Discounts First")
                        Spacer()
                        if viewModel.applicationOrder == .fixedAmountFirst {
                            Image(systemName: "checkmark")
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.toggleDiscountApplicationOrder()
                    }
                }
                Section(header: Text("Discounts")) {
                    ForEach(viewModel.discounts) { discount in
                        HStack {
                            Text(discount.name)
                            Spacer()
                            if viewModel.selectedDiscounts.contains(discount) {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.toggleDiscount(discount)
                        }
                    }
                }
            }
            .navigationTitle("Select Discounts")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onSelectionChanged(viewModel.selectedDiscounts, viewModel.applicationOrder)
                        dismiss()
                    }
                }
            }
        }
    }
}
