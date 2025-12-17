import SwiftUI

/// Отображает чекбокс времени суток (утро/день/вечер/ночь)
struct TimeCheckView: View {

    /// ViewModel фильтров (где лежат morning/day/afternoon/night состояния)
    @Bindable var viewModel: FiltersViewModel

    /// Текущее состояние чекбокса (включён/выключен)
    let isOn: Bool

    /// Тип времени суток
    let timeOfDay: TimeOfDay

    var body: some View {
        VStack {
            Image(isOn ? "CheckBoxOn" : "OffCheckBox")
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
                print("[TimeCheckView]: неизвестный статус")
            }

            // Обновляем состояние кнопки "Применить"
            viewModel.checkAllStatesAdded()
        }
    }
}
