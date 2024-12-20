//
//  TODOListViewModel.swift
//  TODOListApp
//
//  Created by Suryakant Sharma on 20/12/24.
//

import Foundation
import SwiftUI

struct ItemModel: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var isCompleted: Bool
}

class TODOListViewModel: ObservableObject {
    
    @Published var items = [ItemModel]()
    
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
    
    func loadItems() {
        
    }
}
