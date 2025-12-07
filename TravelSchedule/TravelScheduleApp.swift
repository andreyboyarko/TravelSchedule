

import SwiftUI

@main
struct TravelScheduleApp: App {
    
    private var themeManager = ThemeManager()
    
    init() {
        configureTabBar()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(themeManager)
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
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
