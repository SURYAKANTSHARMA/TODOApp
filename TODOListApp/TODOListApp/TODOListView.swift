//
//  ContentView.swift
//  TODOListApp
//
//  Created by Suryakant Sharma on 20/12/24.
//

import SwiftUI

struct TODOListView: View {
    
    @State private var navigationPath = NavigationPath()
    @StateObject private var viewModel = TODOListViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                if viewModel.items.isEmpty {
                    emptyListView
                } else {
                    todoListView
                }
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
           
            .navigationTitle("TODO List 📝 ")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        navigationPath.append(Optional<ItemModel>.none)
                    }) {
                        Text("Add")
                    }
                }
            }
        }
        .navigationDestination(for: Optional<ItemModel>.self) { model in
                switch model {
                case .none:
                    NewEditTodoItemView(item: .constant(nil))
                        .environmentObject(viewModel)
                case .some(let item):
                    NewEditTodoItemView(item: Binding(
                        get: { item },
                        set: { if let item = $0 {
                              viewModel.update(item)
                            }
                        })
                    )
                    .environmentObject(viewModel)
            }
        }
            
    }
}

#Preview {
    NavigationStack {
        TODOListView()
    }
}

	
extension TODOListView {
    
    private var emptyListView: some View {
        VStack {
            Text("There are not item!")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            Text("Are you a productive person? I think you should click the add button and add a bunch of items to your todo list!")
                .padding(.bottom, 10)
            Button(action: {
                navigationPath.append(Optional<ItemModel>.none)
            }) {
                Text("Add Something  🧠")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
    }
    
    private var todoListView: some View {
        ForEach(viewModel.items) { item in
            HStack {
                Text(item.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(item.isCompleted ? .gray : .primary)
                    .swipeActions(edge: .leading) { // Swipe from left
                        Button {
                            print("Edit: \(item)")
                            navigationPath.append(Optional<ItemModel>.some(item))
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                Spacer()
                
                Button(action: {
                    viewModel.toggle(item)
                }) {
                    Image(systemName: item.isCompleted ? "checkmark.square" : "square")
                        .imageScale(.large)
                        .foregroundStyle(item.isCompleted ? .green : .gray)
                }
            }
            
        }
        .onDelete(perform: viewModel.removeItem)
        .onMove(perform: viewModel.move)
    }
}
