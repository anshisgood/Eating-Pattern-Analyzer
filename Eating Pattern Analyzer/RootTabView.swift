//
//  RootTabView.swift
//  Eating Pattern Analyzer
//
//  Created by Anshdeep Singh on 12/14/25.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                MealForm()
            }
            .tabItem {
                Label("Log", systemImage: "plus.circle.fill")
            }
            
            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Label("History", systemImage: "clock")
            }
            
            NavigationStack {
                InsightsView()
            }
            .tabItem {
                Label("Insights", systemImage: "chart.bar.xaxis")
            }
        }
    }
}

#Preview {
    RootTabView()
        .modelContainer(for: Meal.self, inMemory: true)
}
