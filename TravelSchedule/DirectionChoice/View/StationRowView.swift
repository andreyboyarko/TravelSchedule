
import SwiftUI

/// Строка со станцией в списке выбора станции
struct StationRowView: View {
    
    /// Навигационный путь из `MainScreenView`
    @Binding var navigationPath: NavigationPath
    
    /// Название станции, отображаемое в ячейке
    let station: String
    
    /// Общая вью-модель выбора города/станции
    var viewModel: SelectCityViewModel
    
    var body: some View {
        HStack {
            // Название станции
            Text(station)
            
            Spacer()
            
            // Кнопка выбора станции
            Button(action: {
                // Запоминаем выбранную станцию
                viewModel.selectedStation = station
                // Формируем итоговое направление (from/to)
                viewModel.containsDestinationIfCan()
                // Проверяем, можно ли активировать кнопку «Найти»
                viewModel.activeIfAllAdds()
                // Сбрасываем стек навигации до корня
                navigationPath = NavigationPath()
            }) {
                Image("NextButton")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
    }
}
