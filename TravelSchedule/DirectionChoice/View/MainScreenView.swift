
import SwiftUI

///Главный экран приложения:
/// – сторисы
///– выбор направления (откуда / куда)
///– кнопка «Найти» с переходом к списку компаний
///
///
struct MainScreenView: View {
    @Environment(ThemeManager.self) private var themeManager
    
    @Binding var hideTabBar: Bool
    
    @State private var navigationPath = NavigationPath()
    @State private var activeDirection: DirectionType? = nil
    @State private var companyViewModel = CompanyListViewModel()
    @State private var viewModel = SelectCityViewModel()
    
    var storiesViewModel: StoriesVM      // 👈 ПОЛУЧАЕМ извне
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                StoriesPlayerView(
                    hideTabBar: $hideTabBar,
                    navigationPath: $navigationPath,
                    viewModel: storiesViewModel
                )
                
                SelectDirectionView(
                    viewModel: viewModel,
                    navigationPath: $navigationPath,
                    activeDirection: $activeDirection
                )
                
                Button(action: {
                    companyViewModel = CompanyListViewModel()
                    navigationPath.append("CompanyList")
                }) {
                    Text("Найти")
                        .font(.custom("SFPro-Bold", size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: 150, maxHeight: 60)
                        .background(Color.appBlue)
                        .cornerRadius(16)
                }
                .opacity(viewModel.allDirectionAdds ? 1 : 0)
                .disabled(!viewModel.allDirectionAdds)
                
                Spacer()
            }
            // DirectionType
            .navigationDestination(for: DirectionType.self) { direction in
                // твой экран выбора города
            }
            // String routes
            .navigationDestination(for: String.self) { route in
                if route == "SelectStation" {
                    // ...
                } else if route == "CompanyList" {
                    // ...
                } else if route == "FilterScreen" {
                    // ...
                } else if route == "CompanyDetail" {
                    // ...
                } else if route == "Stories" {          // 👈 ВАЖНО
                    if let actualStory = storiesViewModel.actualStory {
                        StoriesViewerView(
                            stories: actualStory,
                            viewModel: storiesViewModel
                        )
                        .navigationBarHidden(true)
                    } else {
                        ZStack {
                            Color.black.ignoresSafeArea()
                            Text("Нет информации о сторис")
                                .foregroundColor(.white)
                        }
                    }
                } else {
                    EmptyView()
                }
            }
            .background(Color.appBackground)
        }
        .onChange(of: navigationPath) { oldValue, newValue in
            withAnimation(.easeInOut(duration: 0.25)) {
                hideTabBar = !newValue.isEmpty
            }
        }
    }
}
