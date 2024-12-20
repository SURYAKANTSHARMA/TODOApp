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
    @State private var animate = false
    
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
                .padding(.bottom, 16)
            Button(action: {
                navigationPath.append(Optional<ItemModel>.none)
            }) {
                Text("Add Something  🧠")
                    .font(.headline)
                    .padding(animate ? 10 : 20)
                    .background(animate ? Color.blue : .red)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onAppear(perform: animation)
                    .scaleEffect(animate ? 1.1 : 1.0)
                    .offset(animate ? .init(width: 0, height: -7) : .zero)
                    .shadow(
                        color: animate ? Color.blue.opacity(0.7) : .red.opacity(0.7),
                        radius: animate ? 30 : 10,
                        x: 0,
                        y: animate ? 10 : 20
                    )

                     
            }
        }
        .padding()
    }
    
    private func animation() {
        guard !animate else { return }
        withAnimation(
            Animation
                .easeInOut(duration: 2.0)
                .repeatForever()
        ) {
            animate.toggle()
        }
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
