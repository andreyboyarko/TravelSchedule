import SwiftUI

struct AppTabBar: View {
    
    // MARK: - Properties
    
    @State private var selectedTab: Int = 0
    @State private var hideTabBar = false
    @State var errorViewModel = ErrorViewModel(actualStatus: .NoProblems)
    @State var storiesService = StoriesService(model: StoriesDataProvider())
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    if errorViewModel.actualStatus == .NoProblems {
                        MainScreenView(hideTabBar: $hideTabBar, storiesService: storiesService, errorViewModel: errorViewModel)
                    } else {
                        ErrorView(viewModel: errorViewModel)
                    }
                case 1:
                    SettingsScreenView(hideTabBar: $hideTabBar)
                default:
                    MainScreenView(hideTabBar: $hideTabBar, storiesService: storiesService, errorViewModel: errorViewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            
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
                    .background(Color.background)
                    .overlay(
                        Rectangle()
                            .fill(Color.сolor)
                            .frame(height: 1),
                        alignment: .top
                    )
                }
            }
        }
    }
    
    // MARK: - Sub Methods
    
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

