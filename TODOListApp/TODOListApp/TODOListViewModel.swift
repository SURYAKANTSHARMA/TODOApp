//
//  TODOListViewModel.swift
//  TODOListApp
//
//  Created by Suryakant Sharma on 20/12/24.
//

import Foundation
import Combine

struct ItemModel: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool
}


class TODOListViewModel: ObservableObject {
    
    @Published var items = [ItemModel]()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadItems()
        $items
            .sink { [weak self] items in
                self?.saveItems(items)
            }
            .store(in: &cancellables)
    }
    
    func add(_ item: ItemModel) {
        items.append(item)
    }
    
    func remove(_ item: ItemModel) {
        items.removeAll { $0.id == item.id }
    }
    
    func update(_ item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        }
    }
    
    func removeAll() {
        items.removeAll()
    }
    
    func toggle(_ item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
    
    private func saveItems(_ items: [ItemModel]) {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "todoItems")
        }
    }
    
    func loadItems() {
        if let savedItems = UserDefaults.standard.data(forKey: "todoItems"),
           let decodedItems = try? JSONDecoder().decode([ItemModel].self, from: savedItems) {
            items = decodedItems
        }
    }
    
    func edit(_ item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        }
    }
}
