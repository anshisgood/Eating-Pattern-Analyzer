//
//  ContentView.swift
//  Eating Pattern Analyzer
//
//  Created by Anshdeep Singh on 12/13/25.
//

import SwiftUI
import SwiftData

// THIS STRUCT IS TEMPORARY, ONLY FOR XCODE PREVIEWS SO IT ALL RUNS ON THE SAME MEMORY, DELETE DURING PUBLISHING **********************************
struct RootView: View {
    var body: some View {
        NavigationStack {
            MealForm()
        }
    }
}

struct MealForm: View {
    // Form States
    @State private var mealDate: Date = Date()
    @State private var foodName: String = ""
    @State private var quantity: String = ""
    
    @State private var foods: [FoodItem] = []
    @State private var selectedTags: Set<MealTag> = []
    
    // SwiftData
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            NavigationLink("hello") {
                HistoryView()
            }
            Form {
                // Header
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What did you eat today?")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Log your meals to better understand your eating patterns.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 12)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
                .overlay(Divider().opacity(0.2), alignment: .bottom)
                
                // Add Food Item
                Section("Food") {
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Food name", text: $foodName)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 0))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Quantity (e.g. 2 slices)", text: $quantity)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 0))
                    
                    
                    
                    Button {
                        addFood()
                    } label: {
                        Label("Add Food", systemImage: "plus.circle.fill")
                    }
                    .disabled(foodName.isEmpty)
                }
                
                // Food Items Display
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
                
                // Select Date & Time
                Section("Time") {
                    DatePicker("", selection: $mealDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                }
                
                // Select Tag(s)
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
                
                // Submit Meal
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
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func addFood() {
        foods.append(FoodItem(
            id: UUID(),
            name: foodName,
            quantity: quantity.isEmpty ? "-" : quantity
        ))
        // reset:
        foodName = ""
        quantity = ""
    }
    
    private func deleteFood(offset: IndexSet) {
        foods.remove(atOffsets: offset)
    }
    
    private func saveMeal() {
        let meal = Meal(
            date: mealDate,
            foods: foods,
            tags: Array(selectedTags)
        )
        
        modelContext.insert(meal)
        // reset:
        foods.removeAll()
        selectedTags.removeAll()
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
        
        private let size: CGFloat = 50
        
        var body: some View {
            Button(action: action) {
                Text(tag.rawValue)
                    .font(.caption)
                    .frame(width: size, height: size)
                    .background(Circle().fill(isSelected ? Color.accentColor : Color(.systemGray5)))
                    .foregroundStyle(isSelected ? .white : .primary)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: Meal.self, inMemory: true)
}

@Model
class Meal {
    var id: UUID
    var date: Date
    var foods: [FoodItem]
    var tags: [MealTag]
    
    init(id: UUID = UUID(), date: Date, foods: [FoodItem], tags: [MealTag]) {
        self.id = id
        self.date = date
        self.foods = foods
        self.tags = tags
    }
}

@Model
class FoodItem {
    var id: UUID
    var name: String
    var quantity: String
    
    init(id: UUID = UUID(), name: String, quantity: String) {
        self.id = id
        self.name = name
        self.quantity = quantity
    }
}

enum MealTag: String, Codable, CaseIterable {
    case snack
    case meal
    case lateNight
    case stress
    case social
    case healthy
}
