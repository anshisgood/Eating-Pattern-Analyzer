//
//  Eating_Pattern_AnalyzerApp.swift
//  Eating Pattern Analyzer
//
//  Created by Anshdeep Singh on 12/13/25.
//

import SwiftUI
import SwiftData

@main
struct Eating_Pattern_AnalyzerApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: Meal.self)
    }
}
