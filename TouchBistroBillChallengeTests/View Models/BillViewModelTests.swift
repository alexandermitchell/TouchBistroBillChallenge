//
//  BillViewModelTests.swift
//  TouchBistroBillChallengeTests
//
//  Created by Alex Mitchell on 2025-03-14.
//

import XCTest
@testable import TouchBistroBillChallenge
@testable import TBBillKit

@MainActor
final class BillViewModelTests: XCTestCase {
    
    var billViewModel: BillViewModel!
    var mockBillCalculator: MockBillCalculator!

    override func setUp() {
        super.setUp()
        mockBillCalculator = MockBillCalculator()
        billViewModel = BillViewModel(billCalculator: mockBillCalculator)
    }

    override func tearDown() {
        billViewModel = nil
        mockBillCalculator = nil
        super.tearDown()
    }
    
    /// Calling updateBill updates bill total amounts
    func testCalculateBillValuesSet() {
        XCTAssertEqual(billViewModel.subtotal, 0.00)
        XCTAssertEqual(billViewModel.finalTotal, 0.00)
        XCTAssertEqual(billViewModel.taxTotal, 0.00)
        XCTAssertEqual(billViewModel.discountTotal, 0.00)
        
        mockBillCalculator.subtotal = 5.00
        mockBillCalculator.finalTotal = 10.00
        mockBillCalculator.taxTotal = 3.00
        mockBillCalculator.discountTotal = 2.00
        
        // Simulate updateBill being called
        let item = BillItem(id: UUID(), name: "Burger", category: .food, price: 15.0)
        billViewModel.addItem(item)
        
        XCTAssertEqual(billViewModel.subtotal, 5.00)
        XCTAssertEqual(billViewModel.finalTotal, 10.00)
        XCTAssertEqual(billViewModel.taxTotal, 3.00)
        XCTAssertEqual(billViewModel.discountTotal, 2.00)
    }

    /// Adding a single item to the bill
    func testAddItem() {
        let item = BillItem(id: UUID(), name: "Pizza", category: .food, price: 20.0)

        billViewModel.addItem(item)

        XCTAssertEqual(billViewModel.billItems[.food]?.count, 1)
        XCTAssertEqual(billViewModel.billItems[.food]?.first?.quantity, 1)
    }

    /// Adding the same item increases quantity
    func testAddDuplicateItem_IncreasesQuantity() {
        let item = BillItem(id: UUID(), name: "Pizza", category: .food, price: 20.0)

        billViewModel.addItem(item)
        billViewModel.addItem(item)

        XCTAssertEqual(billViewModel.billItems[.food]?.count, 1) // Still 1 entry
        XCTAssertEqual(billViewModel.billItems[.food]?.first?.quantity, 2) // Quantity should be 2
    }

    /// Removing an item decreases quantity
    func testRemoveItem_DecreasesQuantity() {
        let item = BillItem(id: UUID(), name: "Burger", category: .food, price: 15.0)

        billViewModel.addItem(item)
        billViewModel.addItem(item)  // Quantity = 2
        billViewModel.removeItem(item)  // Quantity = 1

        XCTAssertEqual(billViewModel.billItems[.food]?.count, 1)
        XCTAssertEqual(billViewModel.billItems[.food]?.first?.quantity, 1)
    }

    /// Removing an item completely removes it when quantity reaches 0
    func testRemoveItem_DeletesWhenQuantityIsZero() {
        let item = BillItem(id: UUID(), name: "Burger", category: .food, price: 15.0)

        billViewModel.addItem(item)
        billViewModel.removeItem(item)

        XCTAssertNil(billViewModel.billItems[.food]) // Category should be removed
    }
    
    /// Applying discounts with no items added does not change bill total amounts
    func testApplyDiscounts_WhenNoItemsAddedNoBillUpdate() {
        let discount1 = Discount(id: UUID(), name: "10% Off", type: .percentage(0.10))
        billViewModel.applyDiscounts([discount1], applicationOrder: .percentageFirst)
        
        mockBillCalculator.subtotal = 2.00
        mockBillCalculator.finalTotal = 5.00
        mockBillCalculator.taxTotal = 3.00
        mockBillCalculator.discountTotal = 4.00
        
        XCTAssertEqual(billViewModel.subtotal, 0.00)
        XCTAssertEqual(billViewModel.finalTotal, 0.00)
        XCTAssertEqual(billViewModel.taxTotal, 0.00)
        XCTAssertEqual(billViewModel.discountTotal, 0.00)
    }
    
    /// Applying taxes with no items added does not change bill total amounts
    func testApplyTaxes_WhenNoItemsAddedNoBillUpdate() {
        let tax1 = Tax(id: UUID(), name: "Sales Tax", rate: 0.10, applicableCategories: [.food])
        billViewModel.updateTaxes([tax1])
        
        mockBillCalculator.subtotal = 2.00
        mockBillCalculator.finalTotal = 5.00
        mockBillCalculator.taxTotal = 3.00
        mockBillCalculator.discountTotal = 4.00
        
        XCTAssertEqual(billViewModel.subtotal, 0.00)
        XCTAssertEqual(billViewModel.finalTotal, 0.00)
        XCTAssertEqual(billViewModel.taxTotal, 0.00)
        XCTAssertEqual(billViewModel.discountTotal, 0.00)
    }
}

class MockBillCalculator: BillCalculating {
    var subtotal: Decimal = 0.00
    var finalTotal: Decimal = 0.00
    var taxTotal: Decimal = 0.00
    var discountTotal: Decimal = 0.00
    
    func calculateBill(for items: [TBBillKit.ItemCategory : OrderedCollections.OrderedSet<TBBillKit.BillItem>], taxes: Set<TBBillKit.Tax>, discounts: Set<TBBillKit.Discount>, discountOrder: TBBillKit.DiscountApplicationOrder) -> (subtotal: Decimal, finalTotal: Decimal, taxTotal: Decimal, discountTotal: Decimal) {
        return (subtotal, finalTotal, taxTotal, discountTotal)
    }
}

