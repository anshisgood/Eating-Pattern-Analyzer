//
//  ContentView.swift
//  Eating Pattern Analyzer
//
//  Created by Anshdeep Singh on 12/13/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
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
