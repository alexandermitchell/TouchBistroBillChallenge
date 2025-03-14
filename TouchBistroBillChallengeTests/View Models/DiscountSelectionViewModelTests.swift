//
//  DiscountSelectionViewModelTests.swift
//  TouchBistroBillChallengeTests
//
//  Created by Alex Mitchell on 2025-03-14.
//

import XCTest
@testable import TouchBistroBillChallenge
@testable import TBBillKit

@MainActor
final class DiscountSelectionViewModelTests: XCTestCase {
    
    var viewModel: DiscountSelectionViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = DiscountSelectionViewModel(
            discounts: [Discount.tenPercentOff: false, Discount.fiveDollarsOff: true],
            applicationOrder: .percentageFirst
        )
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    /// Test initial state
    func testInitialState() {
        XCTAssertEqual(viewModel.selectedDiscounts.count, 1)
        XCTAssertTrue(viewModel.selectedDiscounts.contains(Discount.fiveDollarsOff))
        XCTAssertEqual(viewModel.applicationOrder, .percentageFirst)
    }

    /// Test selecting a discount adds it to `selectedDiscounts`
    func testToggleDiscount_AddsExistingDiscount() {
        let discount = Discount.tenPercentOff
        viewModel.toggleDiscount(discount)
        
        XCTAssertTrue(viewModel.selectedDiscounts.contains(discount))
    }

    /// Test deselecting a discount removes it from `selectedDiscounts`
    func testToggleDiscount_RemovesDiscount() {
        let discount = Discount.tenPercentOff
        viewModel.toggleDiscount(discount)
        
        XCTAssertTrue(viewModel.selectedDiscounts.contains(discount))
        
        viewModel.toggleDiscount(discount)
        
        XCTAssertFalse(viewModel.selectedDiscounts.contains(discount))
    }

    /// Test toggling a non-existent tax does nothing
    func testTogglingApplicationOrder() {
        XCTAssertEqual(viewModel.applicationOrder, .percentageFirst)
        viewModel.toggleDiscountApplicationOrder()
        XCTAssertEqual(viewModel.applicationOrder, .fixedAmountFirst)
    }
}
