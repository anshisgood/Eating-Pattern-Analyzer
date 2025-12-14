//
//  AnalyticsView.swift
//  Eating Pattern Analyzer
//
//  Created by Anshdeep Singh on 12/14/25.
//

import Foundation
import SwiftData

@MainActor
final class AnalyticsViewModel: ObservableObject {
    let meals: [Meal]
    
    init(meals: [Meal]) {
        self.meals = meals
    }
    
    // Time-Based Analysis
    var mealsByHour: [Int: Int] {
        var counts: [Int: Int] = [:]
        
        for meal in meals {
            let hour = Calendar.current.component(.hour, from: meal.date)
            counts[hour, default: 0] += 1
        }
        return counts
    }
    
    var lateNightPercentage: Double {
        guard !meals.isEmpty else { return 0 }
        
        let lateMeals = meals.filter {
            Calendar.current.component(.hour, from: $0.date) >= 21
        }
        return Double(lateMeals.count) / Double(meals.count)
    }
    
    // Tag Analysis
    var tagCounts: [MealTag: Int] {
        var counts: [MealTag: Int] = [:]
        
        for meal in meals {
            for tag in meal.tags {
                counts[tag, default: 0] += 1
            }
        }
        return counts
    }
    
    // Rule-Based Pattern Detection
    var detectedPatterns: [String] {
        var patterns: [String] = []
        
        if lateNightPercentage > 0.3 {
            patterns.append("Frequent late-night eating detected")
        }
        
        if stressMealsLast7Days >= 3 {
            patterns.append("Stress-related eating pattern detected")
        }
        
        if isIrregularSchedule {
            patterns.append("Irregular eating schedule")
        }
        
        return patterns
    }
    
    private var stressMealsLast7Days: Int {
        let last7Days = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        
        return meals.filter {
            $0.date >= last7Days && $0.tags.contains(.stress)
        }.count
    }
    
    private var isIrregularSchedule: Bool {
        let mealsPerDay = Dictionary(grouping: meals) {
            Calendar.current.startOfDay(for: $0.date)
        }.mapValues { $0.count }
        
        let values = mealsPerDay.values
        guard values.count > 1 else { return false }
        
        let avg = Double(values.reduce(0, +)) / Double(values.count)
        let variance = values.map { pow(Double($0) - avg, 2) }.reduce(0, +) / Double(values.count)
        
        return variance > 2.0
    }
}
