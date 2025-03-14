//
//  TaxSelectionViewModelTests.swift
//  TouchBistroBillChallengeTests
//
//  Created by Alex Mitchell on 2025-03-14.
//

import XCTest
@testable import TouchBistroBillChallenge
@testable import TBBillKit

@MainActor
final class TaxSelectionViewModelTests: XCTestCase {
    
    var viewModel: TaxSelectionViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = TaxSelectionViewModel(
            taxes: [
                Tax.salesTax: false,
                Tax.alcoholTax: false
            ]
        )
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    /// Test initial state
    func testInitialState() {
        XCTAssertTrue(viewModel.selectedTaxes.isEmpty)
    }

    /// Test selecting a tax adds it to `selectedTaxes`
    func testToggleTax_AddsTax() {
        let tax = Tax.alcoholTax
        
        viewModel.toggleTax(tax)
        
        XCTAssertTrue(viewModel.selectedTaxes.contains(tax))
    }

    /// Test deselecting a tax removes it from `selectedTaxes`
    func testToggleTax_RemovesTax() {
        let tax = Tax.salesTax
        
        viewModel.toggleTax(tax) // Add tax
        viewModel.toggleTax(tax) // Remove tax
        
        XCTAssertFalse(viewModel.selectedTaxes.contains(tax))
    }

    /// Test selecting multiple taxes
    func testToggleMultipleTaxes() {
        let tax1 = Tax.salesTax
        let tax2 = Tax.alcoholTax

        viewModel.toggleTax(tax1)
        viewModel.toggleTax(tax2)

        XCTAssertEqual(viewModel.selectedTaxes.count, 2)
        XCTAssertTrue(viewModel.selectedTaxes.contains(tax1))
        XCTAssertTrue(viewModel.selectedTaxes.contains(tax2))
    }

    /// Test toggling a non-existent tax does nothing
    func testTogglingNonExistentTax() {
        let tax = Tax(id: UUID(), name: "Service Tax", rate: 0.08, applicableCategories: [.food])

        viewModel.toggleTax(tax) // Add

        XCTAssertFalse(viewModel.selectedTaxes.contains(tax))
    }
}

