
import SwiftUI

struct SettingsScreenView: View {
    
    // MARK: - Properties

    @Environment(ThemeManager.self) var themeManager
    @State private var navigationPath: NavigationPath = NavigationPath()
    @Binding var hideTabBar: Bool
    @State var viewModel = SettingsViewModel(model: UserAgreementModel())
    
    // MARK: - Body

    var body: some View {
        
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                VStack {
                    settings
                    Spacer()
                    footer
                }
                .padding()
                .navigationDestination(for: String.self) { route in
                    if route == "UserAgreement" {
                        ZStack {
                            Color.background
                                .ignoresSafeArea()
                            VStack{
                                NavigationBarView(title: "Пользовательское соглашение") {
                                    navigationPath.removeLast()
                                }
                                .background(Color.appBackground)
                                AgreementView(hideTabBar: $hideTabBar, viewModel: viewModel)
                            }
                                .navigationBarHidden(true)
                        }
                    }
                }
            }
            .background(Color.background)
        }
        .onChange(of: navigationPath) { _, newValue in
            withAnimation(.easeInOut(duration: 0.25)) {
                hideTabBar = !newValue.isEmpty
            }
        }
    }
    
    // MARK: - Subviews

    private var footer: some View {
        VStack(spacing: 10) {
            Text(viewModel.userAgreement.nameOfApi)
            Text(viewModel.userAgreement.version)
        }
        .font(.custom("SFPro-Regula", size: 12))
        .padding(.bottom, 60)
    }
    
    private var settings: some View {
        @Bindable var themeManager = themeManager

        return VStack(spacing: 30) {
            HStack {
                Text("Темная тема")
                    .font(.custom("SFPro-Regula", size: 17))
                Spacer()
                Toggle("", isOn: $themeManager.isDarkMode)
            }
            HStack {
                Text("Пользовательское соглашение")
                    .font(.custom("SFPro-Regula", size: 17))
                Spacer()
                Button(action: {
                    navigationPath.append("UserAgreement")
                }) {
                    Image("NextButton")
                }
            }
        }
    }
}

//import SwiftUI
//
///// Экран настроек приложения:
///// – управление темой (светлая/тёмная)
///// – переход к пользовательскому соглашению
///// – футер с информацией о версии
//struct SettingsScreenView: View {
//
//    // MARK: - Types
//
//    private enum Route: Hashable {
//        case userAgreement
//    }
//
//    private enum Constants {
//        static let titleDarkTheme = "Темная тема"
//        static let titleUserAgreement = "Пользовательское соглашение"
//        static let apiInfo = "Приложение использует API «Яндекс.Расписания»"
//        static let versionInfo = "Версия 1.0 (beta)"
//        static let footerBottomPadding: CGFloat = 60
//        static let rowFontName = "SFPro-Regula"
//        static let rowFontSize: CGFloat = 17
//        static let footerFontSize: CGFloat = 12
//        static let rowsSpacing: CGFloat = 30
//        static let tabBarAnimationDuration: CGFloat = 0.25
//    }
//
//    // MARK: - Properties
//
//    @Environment(ThemeManager.self) private var themeManager
//    @Binding var hideTabBar: Bool
//    @State private var navigationPath = NavigationPath()
//
//    // MARK: - Body
//
//    var body: some View {
//        NavigationStack(path: $navigationPath) {
//            ZStack {
//                Color.background.ignoresSafeArea()
//
//                VStack {
//                    settings
//                    Spacer()
//                    footer
//                }
//                .padding()
//                .navigationDestination(for: Route.self) { route in
//                    switch route {
//                    case .userAgreement:
//                        userAgreementScreen
//                    }
//                }
//            }
//            .background(Color.background)
//        }
//        .onChange(of: navigationPath) { _, newValue in
//            withAnimation(.easeInOut(duration: Constants.tabBarAnimationDuration)) {
//                hideTabBar = !newValue.isEmpty
//            }
//        }
//    }
//
//    // MARK: - Subviews
//
//    private var userAgreementScreen: some View {
//        ZStack {
//            Color.background.ignoresSafeArea()
//
//            VStack {
//                NavigationBarView(title: Constants.titleUserAgreement) {
//                    if !navigationPath.isEmpty {
//                        navigationPath.removeLast()
//                    }
//                }
//                .background(Color.background)
//
//                    AgreementView(hideTabBar: $hideTabBar, viewModel: viewModel)
//            }
//            .navigationBarHidden(true)
//        }
//    }
//
//    private var footer: some View {
//        VStack(spacing: 10) {
//            Text(Constants.apiInfo)
//            Text(Constants.versionInfo)
//        }
//        .font(.custom(Constants.rowFontName, size: Constants.footerFontSize))
//        .padding(.bottom, Constants.footerBottomPadding)
//    }
//
//    private var settings: some View {
//        @Bindable var themeManager = themeManager
//
//        return VStack(spacing: Constants.rowsSpacing) {
//            HStack {
//                Text(Constants.titleDarkTheme)
//                    .font(.custom(Constants.rowFontName, size: Constants.rowFontSize))
//                Spacer()
//                Toggle("", isOn: $themeManager.isDarkMode)
//            }
//
//            HStack {
//                Text(Constants.titleUserAgreement)
//                    .font(.custom(Constants.rowFontName, size: Constants.rowFontSize))
//                Spacer()
//                Button {
//                    navigationPath.append(Route.userAgreement)
//                } label: {
//                    Image("NextButton")
//                }
//            }
//        }
//    }
//}
//
//
////import SwiftUI
////
/////// Экран настроек приложения:
/////// – управление темой (светлая/тёмная)
/////// – переход к пользовательскому соглашению
/////// – футер с информацией о версии
////struct SettingsScreenView: View {
////    
////    /// Глобальные настройки темы (через Environment)
////    @Environment(ThemeManager.self) var themeManager
////    
////    /// Навигационный стек для внутренних экранов настроек
////    @State private var navigationPath: NavigationPath = NavigationPath()
////    
////    /// Показывать или скрывать нижний таббар (передаётся родителем)
////    @Binding var hideTabBar: Bool
////    
////    var body: some View {
////        
////        NavigationStack(path: $navigationPath) {
////            ZStack {
////                Color.background.ignoresSafeArea()
////                
////                VStack {
////                    settings           // Основные настройки
////                    Spacer()
////                    footer             // Информация о приложении
////                }
////                .padding()
////                
////                // Навигация по строковым маршрутам
////                .navigationDestination(for: String.self) { route in
////                    if route == "UserAgreement" {
////                        userAgreementScreen
////                    }
////                }
////            }
////            .background(Color.background)
////        }
////        // Управление скрытием/показом таб-бара
////        .onChange(of: navigationPath) { _, newValue in
////            withAnimation(.easeInOut(duration: 0.25)) {
////                hideTabBar = !newValue.isEmpty
////            }
////        }
////    }
////    
////    // MARK: - Экран соглашения
////    
////    /// Вспомогательное View для пользовательского соглашения
////    private var userAgreementScreen: some View {
////        ZStack {
////            Color.background.ignoresSafeArea()
////            
////            VStack {
////                NavigationBarView(title: "Пользовательское соглашение") {
////                    navigationPath.removeLast()
////                }
////                .background(Color.background)
////                
////                AgreementView(hideTabBar: $hideTabBar)
////            }
////            .navigationBarHidden(true)
////        }
////    }
////    
////    // MARK: - Футер
////    
////    /// Информация о приложении, версия, API
////    private var footer: some View {
////        VStack(spacing: 10) {
////            Text("Приложение использует API «Яндекс.Расписания»")
////            Text("Версия 1.0 (beta)")
////        }
////        .font(.custom("SFPro-Regula", size: 12))
////        .padding(.bottom, 60)
////    }
////    
////    // MARK: - Основные настройки
////    
////    /// Переключатели и кнопки настроек: тема, пользовательское соглашение
////    private var settings: some View {
////        @Bindable var themeManager = themeManager
////        
////        return VStack(spacing: 30) {
////            
////            // Переключатель темы: светлая / тёмная
////            HStack {
////                Text("Темная тема")
////                    .font(.custom("SFPro-Regula", size: 17))
////                
////                Spacer()
////                
////                Toggle("", isOn: $themeManager.isDarkMode)
////            }
////            
////            // Переход к пользовательскому соглашению
////            HStack {
////                Text("Пользовательское соглашение")
////                    .font(.custom("SFPro-Regula", size: 17))
////                
////                Spacer()
////                
////                Button {
////                    navigationPath.append("UserAgreement")
////                } label: {
////                    Image("NextButton")
////                }
////            }
////        }
////    }
////}
