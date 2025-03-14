//
//  TaxSelectionView.swift
//  TouchBistroBillChallenge
//
//  Created by Alex Mitchell on 2025-03-11.
//

import SwiftUI
import TBBillKit

struct TaxSelectionView: View {
    @ObservedObject var viewModel: TaxSelectionViewModel
    @Environment(\.dismiss) private var dismiss
    var onSelectionChanged: (Set<Tax>) -> Void
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Taxes")) {
                    ForEach(viewModel.taxes) { tax in
                        HStack {
                            Text(tax.name)
                            Spacer()
                            if viewModel.selectedTaxes.contains(tax) {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.toggleTax(tax)
                        }
                    }
                }
            }
            .navigationTitle("Select Taxes")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onSelectionChanged(viewModel.selectedTaxes)
                        dismiss()
                    }
                }
            }
        }
    }
}
