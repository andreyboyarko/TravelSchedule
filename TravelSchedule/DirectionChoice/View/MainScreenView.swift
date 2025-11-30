
import SwiftUI

/// Главный экран приложения:
/// – сторисы
/// – выбор направления (откуда / куда)
/// – кнопка «Найти» с переходом к списку компаний
struct MainScreenView: View {
    
    /// Флаг, прячем ли таббар (управляет `AppTabBar`)
    @Binding var hideTabBar: Bool
    
    /// Навигационный стек для всего MainScreen
    @State private var navigationPath = NavigationPath()
    
    /// Какое направление (from/to) сейчас редактируется
    @State private var activeDirection: DirectionType? = nil
    
    /// Вью-модель списка компаний
    @State var companyViewModel = CompanyListViewModel()
    
    /// Общая вью-модель выбора города/станции
    @State var viewModel = SelectCityViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                // Истории вверху экрана
                StoriesFeedView()
                
                // Блок выбора направления
                SelectDirectionView(
                    viewModel: viewModel,
                    navigationPath: $navigationPath,
                    activeDirection: $activeDirection
                )
                
                // Кнопка поиска рейсов
                Button(action: {
                    // Обновляем вью-модель на каждый новый поиск
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
                // Кнопка доступна только если выбраны оба направления
                .opacity(viewModel.allDirectionAdds ? 1 : 0)
                .disabled(!viewModel.allDirectionAdds)
                
                Spacer()
            }
            
            // MARK: - Навигация по DirectionType (откуда / куда)
            .navigationDestination(for: DirectionType.self) { direction in
                ZStack {
                    Color.appBackground
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        NavigationBarView(title: "Выбор города") {
                            navigationPath.removeLast()
                        }
                        .background(Color.appBackground)
                        
                            CityView(
                            hideTabBar: $hideTabBar,
                            navigationPath: $navigationPath,
                            viewModel: viewModel,
                            directionType: direction
                        )
                        .navigationBarHidden(true)
                    }
                }
                .onAppear {
                    activeDirection = direction
                }
            }
            
            // MARK: - Навигация по строковым "роутам"
            .navigationDestination(for: String.self) { route in
                
                // Экран выбора станции
                if route == "SelectStation" {
                    ZStack {
                        Color.appBackground
                            .ignoresSafeArea()
                        
                        VStack(spacing: 0) {
                            NavigationBarView(title: "Выбор станции") {
                                navigationPath.removeLast()
                            }
                            .background(Color.appBackground)
                            
                            SelectStationView(
                                hideTabBar: $hideTabBar,
                                viewModel: viewModel,
                                navigationPath: $navigationPath
                            )
                            .navigationBarHidden(true)
                        }
                    }
                    
                // Экран списка компаний
                } else if route == "CompanyList" {
                    
                    // Переходим только если оба направления заданы
                    if let from = viewModel.directionFrom,
                       let to   = viewModel.directionTo {
                        ZStack {
                            Color.appBackground
                                .ignoresSafeArea()
                            
                            VStack(spacing: 0) {
                                NavigationBarView(title: "") {
                                    navigationPath.removeLast()
                                }
                                .background(Color.appBackground)
                                
                                CompanyListView(
                                    viewModel: companyViewModel,
                                    navigationPath: $navigationPath,
                                    directionTo: to,
                                    directionFrom: from
                                )
                                .navigationBarHidden(true)
                            }
                        }
                    }
                    
                // Экран фильтров
                } else if route == "FilterScreen" {
                    ZStack {
                        Color.appBackground
                            .ignoresSafeArea()
                        
                        VStack(spacing: 0) {
                            NavigationBarView(title: "") {
                                navigationPath.removeLast()
                            }
                            .background(Color.appBackground)
                            
                            RouteFilterView(
                                navigationPath: $navigationPath,
                                viewModel: companyViewModel
                            )
                            .navigationBarHidden(true)
                        }
                    }
                    
                // Экран деталки компании (заглушка)
                } else if route == "CompanyDetail" {
                    ZStack {
                        Color.appBackground
                            .ignoresSafeArea()
                        
                        VStack(spacing: 0) {
                            NavigationBarView(title: "Информация о компании") {
                                navigationPath.removeLast()
                            }
                            .background(Color.appBackground)
                            
                            Spacer()
                            
                            Text("Информация о компании")
                                .font(.custom("SFPro-Bold", size: 17))
                                .navigationBarHidden(true)
                            
                            Spacer()
                        }
                    }
                }
            }
            .background(Color.appBackground)
        }
        // MARK: - Логика скрытия таббара
        .onChange(of: navigationPath) { oldValue, newValue in
            let shouldHide = !newValue.isEmpty
            
            // Не дергаем анимацию, если состояние не поменялось
            guard hideTabBar != shouldHide else { return }
            
            withAnimation(.easeInOut(duration: 0.25)) {
                hideTabBar = shouldHide
            }
        }
    }
}
