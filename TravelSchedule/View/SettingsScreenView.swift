import SwiftUI

/// Экран настроек приложения:
/// – управление темой (светлая/тёмная)
/// – переход к пользовательскому соглашению
/// – футер с информацией о версии
struct SettingsScreenView: View {
    
    /// Глобальные настройки темы (через Environment)
    @Environment(ThemeManager.self) var themeManager
    
    /// Навигационный стек для внутренних экранов настроек
    @State private var navigationPath: NavigationPath = NavigationPath()
    
    /// Показывать или скрывать нижний таббар (передаётся родителем)
    @Binding var hideTabBar: Bool
    
    var body: some View {
        
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack {
                    settings           // Основные настройки
                    Spacer()
                    footer             // Информация о приложении
                }
                .padding()
                
                // Навигация по строковым маршрутам
                .navigationDestination(for: String.self) { route in
                    if route == "UserAgreement" {
                        userAgreementScreen
                    }
                }
            }
            .background(Color.background)
        }
        // Управление скрытием/показом таб-бара
        .onChange(of: navigationPath) { _, newValue in
            withAnimation(.easeInOut(duration: 0.25)) {
                hideTabBar = !newValue.isEmpty
            }
        }
    }
    
    // MARK: - Экран соглашения
    
    /// Вспомогательное View для пользовательского соглашения
    private var userAgreementScreen: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack {
                NavigationBarView(title: "Пользовательское соглашение") {
                    navigationPath.removeLast()
                }
                .background(Color.background)
                
                AgreementView(hideTabBar: $hideTabBar)
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Футер
    
    /// Информация о приложении, версия, API
    private var footer: some View {
        VStack(spacing: 10) {
            Text("Приложение использует API «Яндекс.Расписания»")
            Text("Версия 1.0 (beta)")
        }
        .font(.custom("SFPro-Regula", size: 12))
        .padding(.bottom, 60)
    }
    
    // MARK: - Основные настройки
    
    /// Переключатели и кнопки настроек: тема, пользовательское соглашение
    private var settings: some View {
        @Bindable var themeManager = themeManager
        
        return VStack(spacing: 30) {
            
            // Переключатель темы: светлая / тёмная
            HStack {
                Text("Темная тема")
                    .font(.custom("SFPro-Regula", size: 17))
                
                Spacer()
                
                Toggle("", isOn: $themeManager.isDarkMode)
            }
            
            // Переход к пользовательскому соглашению
            HStack {
                Text("Пользовательское соглашение")
                    .font(.custom("SFPro-Regula", size: 17))
                
                Spacer()
                
                Button {
                    navigationPath.append("UserAgreement")
                } label: {
                    Image("NextButton")
                }
            }
        }
    }
}
