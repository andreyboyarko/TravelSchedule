import SwiftUI

/// Отображает чекбокс времени суток (утро/день/вечер/ночь)
struct TimeCheckView: View {
    
    /// Вью-модель фильтра
    @Bindable var viewModel: CompanyListViewModel
    
    /// Текущее состояние чекбокса (включён/выключен)
    let isOn: Bool
    
    /// Тип времени суток
    let timeOfDay: TimeOfDay
    
    var body: some View {
        
        VStack {
            // Подставляем нужную иконку
            (isOn ? Image("CheckBoxOn") : Image("OffCheckBox"))
        }
        .onTapGesture {
            // Переключаем состояние конкретной кнопки времени
            switch timeOfDay {
                
            case .morning:
                viewModel.morningButtonState.status.toggle()
                
            case .day:
                viewModel.dayButtonState.status.toggle()
                
            case .afternoon:
                viewModel.afternoonButtonState.status.toggle()
                
            case .night:
                viewModel.nightButtonState.status.toggle()
                
            case .none:
                // Теоретически этот кейс не должен вызываться
                print("Нет данных")
            }
            
            // Обновляем состояние кнопки "Применить"
            viewModel.checkAllStatesAdded()
        }
    }
}
