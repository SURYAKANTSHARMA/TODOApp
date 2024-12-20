//
//  NewEditTodoItemView.swift
//  TODOListApp
//
//  Created by Suryakant Sharma on 20/12/24.
//

import SwiftUI



struct NewEditTodoItemView: View {
    
    @State private var title = ""
    @State private var isCompleted = false
    
    @Binding var item: ItemModel?
    @EnvironmentObject var todoList: TODOListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var isEditing: Bool {
        item != nil
    }
    
    init(item: Binding<ItemModel?>) {
        self._item = item
        self._title = State(initialValue: item.wrappedValue?.title ?? "")
        self._isCompleted = State(initialValue: item.wrappedValue?.isCompleted ?? false)
    }
    
    var body: some View {
        NavigationView {
            formView
                .navigationTitle(isEditing ? "Edit Item" : "Add New Item")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        toolbarButton
                    }
                }
        }
    }
}

extension NewEditTodoItemView {
    private var toolbarButton: some View {
        Button(isEditing ? "Save" : "Add") {
            if isEditing {
                if let item = item {
                    todoList.update(ItemModel(
                        id: item.id,
                        title: title,
                        isCompleted: isCompleted))
                    presentationMode.wrappedValue.dismiss()
                }
            } else {
                todoList.add(ItemModel(
                    title: title,
                    isCompleted: isCompleted))
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private var formView: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Enter title", text: $title)
            }
            
            Section(header: Text("Is Completed")) {
                Toggle("Is Completed", isOn: $isCompleted)
            }
        }
    }
}

#Preview {
    NewEditTodoItemView(item: .constant(nil))
        .environmentObject(TODOListViewModel())
}
