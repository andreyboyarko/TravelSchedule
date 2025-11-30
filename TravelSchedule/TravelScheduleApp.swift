

import SwiftUI

@main
struct TravelScheduleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

private func configureTabBar() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.clear
    appearance.shadowColor = .clear
    
    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
}
}
