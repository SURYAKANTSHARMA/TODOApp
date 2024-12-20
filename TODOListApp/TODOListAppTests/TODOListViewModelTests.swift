//
//  TODOListAppTests.swift
//  TODOListAppTests
//
//  Created by Suryakant Sharma on 20/12/24.
//

import Testing
import XCTest
@testable import TODOListApp

class TODOListViewModelTests: XCTestCase {
    
    var viewModel: TODOListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = TODOListViewModel()
        UserDefaults.standard.removeObject(forKey: "todoItems")
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testAddItem() {
        let item = ItemModel(id: UUID(), title: "Test Item", isCompleted: false)
        viewModel.add(item)
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.items.first?.title, "Test Item")
    }
    
    func testRemoveItem() {
        let item = ItemModel(id: UUID(), title: "Test Item", isCompleted: false)
        viewModel.add(item)
        viewModel.removeItem(indexSet: IndexSet(integer: 0))
        XCTAssertTrue(viewModel.items.isEmpty)
    }
    
    func testUpdateItem() {
        let item = ItemModel(id: UUID(), title: "Test Item", isCompleted: false)
        viewModel.add(item)
        let updatedItem = ItemModel(id: item.id, title: "Updated Item", isCompleted: false)
        viewModel.update(updatedItem)
        XCTAssertEqual(viewModel.items.first?.title, "Updated Item")
    }
    
    func testRemoveAllItems() {
        let item1 = ItemModel(id: UUID(), title: "Test Item 1", isCompleted: false)
        let item2 = ItemModel(id: UUID(), title: "Test Item 2", isCompleted: false)
        viewModel.add(item1)
        viewModel.add(item2)
        viewModel.removeAll()
        XCTAssertTrue(viewModel.items.isEmpty)
    }
    
    func testToggleItemCompletion() {
        let item = ItemModel(id: UUID(), title: "Test Item", isCompleted: false)
        viewModel.add(item)
        viewModel.toggle(item)
        XCTAssertTrue(viewModel.items.first?.isCompleted ?? false)
    }
    
    func testMoveItem() {
        let item1 = ItemModel(id: UUID(), title: "Test Item 1", isCompleted: false)
        let item2 = ItemModel(id: UUID(), title: "Test Item 2", isCompleted: false)
        viewModel.add(item1)
        viewModel.add(item2)
        viewModel.move(from: IndexSet(integer: 0), to: 1)
        XCTAssertEqual(viewModel.items.first?.title, "Test Item 2")
    }
    
    func testPersistence() {
        let item = ItemModel(id: UUID(), title: "Test Item", isCompleted: false)
        viewModel.add(item)
        viewModel = TODOListViewModel() // Reinitialize to test loading
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.items.first?.title, "Test Item")
    }
}
