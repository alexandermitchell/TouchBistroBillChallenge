//
//  MenuOrderView.swift
//  TouchBistroBillChallenge
//
//  Created by Alex Mitchell on 2025-03-11.
//

import SwiftUI
import TBBillKit

struct MenuOrderView: View {
    @ObservedObject var billViewModel: BillViewModel
    @StateObject private var taxSelectionViewModel: TaxSelectionViewModel
    @StateObject private var discountSelectionViewModel: DiscountSelectionViewModel
    @State private var showTaxes = false
    @State private var showDiscounts = false
    
    init(billViewModel: BillViewModel) {
        self.billViewModel = billViewModel
        _taxSelectionViewModel = StateObject(wrappedValue: TaxSelectionViewModel(
            taxes: [Tax.salesTax: true, Tax.alcoholTax: true]
        ))
        _discountSelectionViewModel = StateObject(
            wrappedValue: DiscountSelectionViewModel(
                discounts: [Discount.tenPercentOff: false, Discount.fiveDollarsOff: false],
                applicationOrder: .percentageFirst
            )
        )
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                topButtons
                
                HStack(spacing: 8) {
                    menuList
                    orderList
                }
                .frame(maxHeight: .infinity)
                
                billSummary
            }
            .padding()
            .navigationTitle("Menu Order")
        }
    }
    
    private var topButtons: some View {
        HStack {
            Button("Taxes") {
                showTaxes.toggle()
            }
            .fullScreenCover(isPresented: $showTaxes, content: {
                TaxSelectionView(viewModel: taxSelectionViewModel, onSelectionChanged: { selectedTaxes in
                    billViewModel.updateTaxes(selectedTaxes)
                })
            })
            Spacer()
            Button("Discounts") {
                showDiscounts.toggle()
            }
            .fullScreenCover(isPresented: $showDiscounts, content: {
                DiscountSelectionView(viewModel: discountSelectionViewModel) { selectedDiscounts, applicationOrder in
                    billViewModel.applyDiscounts(selectedDiscounts, applicationOrder: applicationOrder)
                }
            })
        }
    }
    
    private var menuList: some View {
        List {
            ForEach(Menu.orderedCategories, id: \.self) { category in
                Section(
                    header: Text(category.rawValue)
                        .font(.system(size: 16, weight: .medium))
                ) {
                    ForEach(Menu.defaultMenu[category] ?? []) { item in
                        Button(action: {
                            billViewModel.addItem(item)
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(item.name)")
                                        .font(.system(size: 18, weight: .medium))
                                    Text(item.price.formatted(.currency(code: "USD")))
                                        .font(.system(size: 14, weight: .light))
                                }
                                Spacer()
                                Image(systemName: "plus")
                                    .foregroundColor(.gray)
                                    .frame(width: 20, height: 20)
                                
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    private var orderList: some View {
        List {
            Section(
                header: Text("Bill")
                    .font(.system(size: 20, weight: .semibold))
            ) {
                ForEach(billViewModel.orderedCategories, id: \.self) { category in
                    Section(
                        header: Text("\(category.rawValue)")
                            .font(.system(size: 16, weight: .regular))
                    ) {
                        ForEach(billViewModel.billItems[category] ?? OrderedSet()) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(item.name)")
                                        .font(.system(size: 18, weight: .medium))
                                    Text(item.price.formatted(.currency(code: "USD")))
                                        .font(.system(size: 14, weight: .light))
                                }
                                

                                Spacer()
                                
                                VStack(alignment: .center, spacing: 5) {
                                    Button(action: { billViewModel.addItem(item) }) {
                                        Image(systemName: "plus")
                                            .foregroundColor(.gray)
                                            .frame(width: 20, height: 20)
                                    }
                                    .frame(width: 20, height: 20)
                                    .buttonStyle(.plain)  // Prevents interference with list cell taps
                                    .contentShape(Rectangle()) // Expands tappable area

                                    
                                    Text("\(item.quantity)")
                                        .font(.system(size: 14, weight: .semibold))
                                    
                                    Button(action: { billViewModel.removeItem(item) }) {
                                        Image(systemName: item.quantity == 1 ? "trash" : "minus")
                                            .foregroundColor(.gray)
                                            .frame(width: 20, height: 20)
                                    }
                                    .frame(width: 20, height: 20)
                                    .buttonStyle(.plain)
                                    .contentShape(Rectangle())
                                }
                                .frame(height: 80)
                                .padding(.horizontal, 8)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Capsule())
                                .contentShape(Rectangle())
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
    private var billSummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Subtotal:")
                    .font(.system(size: 18, weight: .light))
                Text("\(billViewModel.subtotal, format: .currency(code: "USD"))")
                    .font(.system(size: 20, weight: .semibold))
            }
            HStack {
                Text("Tax:")
                    .font(.system(size: 18, weight: .light))
                Text("\(billViewModel.taxTotal, format: .currency(code: "USD"))")
                    .font(.system(size: 20, weight: .semibold))
            }
            HStack {
                Text("Discounts:")
                    .font(.system(size: 18, weight: .light))
                Text("\(billViewModel.discountTotal, format: .currency(code: "USD"))")
                    .font(.system(size: 20, weight: .semibold))
            }
            HStack {
                Text("Total:")
                    .font(.system(size: 18, weight: .light))
                Text("\(billViewModel.finalTotal, format: .currency(code: "USD"))")
                    .font(.system(size: 20, weight: .semibold))
            }
        }
        .padding()
    }
}

private final class Menu {
    let items: [ItemCategory : [BillItem]]
    init(items: [ItemCategory : [BillItem]] = Menu.defaultMenu) {
        self.items = items
    }
    
    static let defaultMenu: [ItemCategory : [BillItem]] = [
        .alcohol : [
            BillItem(name: "Beer", category: .alcohol, price: 10.0),
            BillItem(name: "Wine", category: .alcohol, price: 12.0)
        ],
        .beverage : [BillItem(name: "Soda", category: .beverage, price: 5.0)],
        .food : [
            BillItem(name: "Burger", category: .food, price: 15.0),
            BillItem(name: "Tax Free Dog", category: .food, price: 9.0, exemptTaxes: Set(Tax.defaultTaxes.map({$0.id})))
        ]
    ]
    
    static var orderedCategories: [ItemCategory] =
        defaultMenu.keys.sorted { $0.rawValue < $1.rawValue }
    
}

#Preview {
    MenuOrderView(billViewModel: BillViewModel(billCalculator: BillCalculator(taxCalculator: TaxCalculator(), discountCalculator: DiscountCalculator())))
}
