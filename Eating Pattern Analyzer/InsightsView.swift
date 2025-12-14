//
//  InsightsView.swift
//  Eating Pattern Analyzer
//
//  Created by Anshdeep Singh on 12/14/25.
//

import SwiftUI
import SwiftData
import Charts

struct InsightsView: View {
    @Query(sort: \Meal.date) private var meals: [Meal]
    
    private var viewModel: AnalyticsViewModel {
        AnalyticsViewModel(meals: meals)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                header
                
                if meals.isEmpty {
                    emptyState
                } else {
                    summaryCards
                    timeChart
                    detectedPatterns
                }
            }
            .padding()
        }
        .navigationTitle("Insights")
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Your Eating Patterns")
                .font(.largeTitle.bold())
            
            Text("Insights based on your logged meals")
                .foregroundStyle(.secondary)
        }
    }
    
    private var summaryCards: some View {
        VStack(spacing: 12) {
            InsightCard(
                title: "Late-Night Eating",
                value: "\(Int(viewModel.lateNightPercentage * 100))%",
                description: "of meals after 9PM"
            )
            
            InsightCard(
                title: "Most Active Time",
                value: mostCommonHourText,
                description: "peak eating window"
            )
        }
    }
    
    private var mostCommonHourText: String {
        let sorted = viewModel.mealsByHour.sorted { $0.value > $1.value }
        guard let hour = sorted.first?.key else { return "-" }
        return "\(hour):00"
    }
    
    struct InsightCard: View {
        let title: String
        let value: String
        let description: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                
                Text(value)
                    .font(.largeTitle.bold())
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var timeChart: some View {
        VStack(alignment: .leading) {
            Text("Eating Time Distribution")
                .font(.headline)
            
            Chart {
                ForEach(viewModel.mealsByHour.sorted(by: { $0.key < $1.key }), id: \.key) { hour, count in
                    BarMark(x: .value("Hour", hour), y: .value("Meals", count))
                }
            }
            .chartXScale(domain: 0...23)
            .chartXAxis {
                AxisMarks(values: .stride(by: 3)) { value in
                    AxisValueLabel {
                        if let hour = value.as(Int.self) {
                            Text("\(hour)")
                        }
                    }
                }
            }
            .animation(.easeInOut, value: viewModel.mealsByHour)
        }
    }
    
    private var detectedPatterns: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Detected Patterns")
                .font(.headline)
            
            ForEach(viewModel.detectedPatterns, id: \.self) { pattern in
                Label(pattern, systemImage: "exclamationnmark.triangle.fill")
                    .foregroundStyle(.orange)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.bar")
                .font(.largeTitle)
            
            Text("No insights yet")
                .font(.headline)
            
            Text("Log a few meals to start seeing patterns")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 300)
    }
}

#Preview {
    InsightsView()
}
