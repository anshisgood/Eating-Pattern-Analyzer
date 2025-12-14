# 🍽️ Eating Pattern Analyzer

A native iOS app that helps users **understand their eating patterns**
through meal logging, contextual tagging, and explainable, rule-based
insights without calorie counting or opaque machine learning.

Built with **Swift**, **SwiftUI**, **SwiftData**, and **Swift Charts**.

---

## Motivation

Many eating-tracking apps focus heavily on calories or restrictive
metrics. This project explores a different approach:\
**behavioral awareness**.

By logging _what_ and _when_ users eat, along with contextual tags
(like stress, late-night, or social), the app surfaces patterns that
help users reflect on habits in a non-judgmental, explainable way.

---

## Features

### 📝 Meal Logging

- SwiftUI form to log meals with:
  - Date & time
  - Multiple food items and quantities
  - Contextual tags (e.g. stress, lateNight, snack, healthy)
- Clean, low-friction input designed for daily use

### 📋 Meal History

- Persistent meal storage using **SwiftData**
- Meals displayed in a **sectioned list grouped by day**
- Swipe-to-delete with confirmation dialog
- Automatic UI updates via `@Query`

### 📊 Insights & Analytics

- **Eating time distribution** visualized with Swift Charts (hourly
  histogram)
- Rule-based pattern detection, including:
  - Frequent late-night eating
  - Stress-related eating patterns
  - Irregular eating schedules

---

## Architecture

- **SwiftUI** for UI and navigation
- **TabView** with independent `NavigationStack`s
- **SwiftData** for local persistence and reactive updates
- **MVVM architecture** to separate analytics logic from UI
- **Swift Charts** for data visualization

```
    RootTabView
     ├─ MealFormView
     ├─ MealHistoryView
     └─ InsightsView
         └─ AnalyticsViewModel
```
---

## Tech Stack

- **Language:** Swift
- **UI:** SwiftUI
- **Persistence:** SwiftData
- **Data Visualization:** Swift Charts
- **Architecture:** MVVM

---

## 🚀 Getting Started

1.  Clone the repository:

    ```bash
    git clone https://github.com/anshisgood/Eating-Pattern-Analyzer.git
    ```

2.  Open the project in **Xcode 15+**

3.  Run on an iOS simulator or device (iOS 17+)

No external dependencies required.

---

## Disclaimer

This app is **not a medical or diagnostic tool**.\
It is intended for personal reflection and educational purposes only.
