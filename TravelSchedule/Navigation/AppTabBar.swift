
import SwiftUI

struct AppTabBar: View {
    @State private var selectedTab: Int = 0
    @State private var hideTabBar = false
    @State private var storiesViewModel = StoriesVM()

    var body: some View {
        ZStack {
            // Контент экранов
            Group {
                            if selectedTab == 0 {
                                MainScreenView(
                                    hideTabBar: $hideTabBar,
                                    storiesViewModel: storiesViewModel     // 👈 прокидываем внутрь
                                )
                            } else if selectedTab == 1 {
                                SettingsScreenView(hideTabBar: $hideTabBar)
                            } else {
                                MainScreenView(
                                    hideTabBar: $hideTabBar,
                                    storiesViewModel: storiesViewModel
                                )
                            }
                        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackground)
            .ignoresSafeArea()

            
            // Таббар
            if !hideTabBar {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        tabButton(imageActive: "TabMainScreenActiveItem",
                                  imageInactive: "TabMainScreenUnActiveItem",
                                  index: 0)
                        Spacer().frame(width: 150)
                        tabButton(imageActive: "SettingActiveTab",
                                  imageInactive: "SettingUnActiveTab",
                                  index: 1)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(Color.appBackground)
                    .overlay(
                        Rectangle()
                            .fill(Color.color)
                            .frame(height: 1),
                        alignment: .top
                    )
                }
            }
        }
    }
    
    // Кнопка таббара
    private func tabButton(imageActive: String,
                           imageInactive: String,
                           index: Int) -> some View {
        Button {
            selectedTab = index
        } label: {
            Image(selectedTab == index ? imageActive : imageInactive)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
        }
    }
}

