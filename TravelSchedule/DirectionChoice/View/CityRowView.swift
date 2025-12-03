

import SwiftUI

struct CityRowView: View {
    
    // MARK: - Properties
    @Binding var navigationPath: NavigationPath
    
    /// Название города (строка в списке)
    let place: String
    
    /// Общая ViewModel для выбора города/станции/направления
    var viewModel: SelectCityViewModel
    
    
    // MARK: - Body
    var body: some View {
        HStack {
            // Название города
            Text(place)
                .foregroundColor(.appText)
            
            Spacer()
            
            // Кнопка перехода к станции
            Button(action: {
                viewModel.selectedCity = place     // Запоминаем выбранный город
                viewModel.needStationForCity()    // Подгружаем список станций
                navigationPath.append("SelectStation")
            }) {
                Image("NextButton")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.vertical, 8)
        .listRowSeparator(.hidden)
    }
}
