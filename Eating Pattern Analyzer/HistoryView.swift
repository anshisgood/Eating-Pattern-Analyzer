//
//  HistoryView.swift
//  Eating Pattern Analyzer
//
//  Created by Anshdeep Singh on 12/14/25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \Meal.date, order: .reverse)
    private var meals: [Meal]
    
    private var groupedMeals: [Date: [Meal]] {
        Dictionary(grouping: meals) { meal in
            Calendar.current.startOfDay(for: meal.date)
        }
    }
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var pendingDelete: (day: Date, offsets: IndexSet)?
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        List {
            ForEach(groupedMeals.keys.sorted(by: >), id: \.self) { day in
                Section {
                    ForEach(groupedMeals[day] ?? []) { meal in
                        NavigationLink {
                            MealDetailView(meal: meal)
                        } label: {
                            MealRowView(meal: meal)
                        }
                    }
                    .onDelete { indexSet in
                        pendingDelete = (day: day, offsets: indexSet)
                        showDeleteConfirmation = true
                    }
                } header: {
                    Text(sectionTitle(date: day))
                }
            }
        }
        .navigationTitle("Meal History")
        .listStyle(.insetGrouped)
        .confirmationDialog("Delete Meal?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { confirmDelete() }
            Button("Cancel", role: .cancel) { pendingDelete = nil }
        }
    }
    
    private func confirmDelete() {
        guard
            let pendingDelete,
            let mealsForDay = groupedMeals[pendingDelete.day]
        else { return }
        
        for index in pendingDelete.offsets {
            modelContext.delete(mealsForDay[index])
        }
        
        self.pendingDelete = nil
    }

    private func sectionTitle(date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            return date.formatted(.dateTime.month().day())
        }
    }
    
    struct MealRowView: View {
        let meal: Meal
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                // Time
                Text(meal.date.formatted(date: .omitted, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: 60, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 6) {
                    // Foods
                    Text(meal.foods.map(\.name).joined(separator: ", "))
                        .font(.body)
                        .lineLimit(2)
                    
                    // Tags
                    if !meal.tags.isEmpty {
                        HStack(spacing: 6) {
                            ForEach(meal.tags, id: \.self) { tag in
                                Text(tag.rawValue)
                                    .font(.caption2)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color(.systemGray6))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 6)
        }
    }
    
    struct MealDetailView: View {
        let meal: Meal
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text(meal.date.formatted(date: .complete, time: .shortened))
                    .font(.headline)
                
                Text("Foods")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                ForEach(meal.foods) { food in
                    HStack {
                        Text(food.name)
                        Spacer()
                        Text(food.quantity)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Meal Details")
        }
    }
}

#Preview {
    HistoryView()
}

