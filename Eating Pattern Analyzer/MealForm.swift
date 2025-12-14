//
//  ContentView.swift
//  Eating Pattern Analyzer
//
//  Created by Anshdeep Singh on 12/13/25.
//

import SwiftUI

struct MealForm: View {
    // Form States
    @State private var mealDate: Date = Date()
    @State private var foodName: String = ""
    @State private var quantity: String = ""
    
    @State private var foods: [FoodItem] = []
    @State private var selectedTags: Set<MealTag> = []
    
    // UI States
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("When did you eat?", selection: $mealDate, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section("Food") {
                    TextField("Food name", text: $foodName)
                    TextField("Quantity (e.g. 2 slices)", text: $quantity)
                    
                    Button {
                        addFood()
                    } label: {
                        Label("Add Food", systemImage: "plus.circle.fill")
                    }
                    .disabled(foodName.isEmpty)
                }
                
                if !foods.isEmpty {
                    Section("Added Items") {
                        ForEach(foods) { food in
                            HStack {
                                Text(food.name)
                                Spacer()
                                Text(food.quantity)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .onDelete(perform: deleteFood)
                    }
                }
                
                Section("Tags") {
                    FlowLayout {
                        ForEach(MealTag.allCases, id: \.self) { tag in
                            TagChip(tag: tag, isSelected: selectedTags.contains(tag)) {
                                if selectedTags.contains(tag) {
                                    selectedTags.remove(tag)
                                } else {
                                    selectedTags.insert(tag)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section {
                    Button {
                        saveMeal()
                    } label: {
                        Text("Save Meal")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(foods.isEmpty)
                }
                
                
                
            }
            .navigationTitle("Log Todays Meal")
        }
    }
    
    private func addFood() {
        foods.append(FoodItem(
            id: UUID(),
            name: foodName,
            quantity: quantity.isEmpty ? "-" : quantity
        ))
        foodName = ""
        quantity = ""
    }
    
    private func deleteFood(offset: IndexSet) {
        foods.remove(atOffsets: offset)
    }
    
    private func saveMeal() {
        // TODO: Convert from state intoo Meal model
        //TODO: Store data locally using SwiftData
        
        dismiss()
    }
    
    struct FlowLayout<Content: View>: View {
        let content: Content
        
        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        var body: some View {
            HStack {
                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    struct TagChip: View {
        let tag: MealTag
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(tag.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(isSelected ? Color.accentColor : Color(.systemGray5))
                    .foregroundStyle(isSelected ? .white : .primary)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    MealForm()
}

// This is my first swift app, so some comments may seem obvious, but they are only here for my reference & for my learning.

// Identifiable protocol indicates that each struct instance has a unique id
// Codable protocol makes conversion to external data formats easy
struct Meal: Identifiable, Codable {
    let id: UUID
    let date: Date
    let foods: [FoodItem]
    let tags: [MealTag]
}

struct FoodItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let quantity: String
}

// String is interestingly not a protocol, but a raw-value type. Confusing how it's listed with the other protocols.
// CaseIterable protocol indicates that enum can iterate over all cases with: MealTag.allCases
enum MealTag: String, Codable, CaseIterable {
    case snack
    case meal
    case lateNight
    case stress
    case social
    case healthy
}
