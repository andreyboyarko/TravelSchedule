import SwiftUI

/// Вью для выбора необходимости пересадок (да / нет).
/// Используется в экране фильтрации маршрутов.
struct NeedSwapTransportView: View {
    
    /// Текущее состояние радиокнопки (включена / выключена).
    /// Значение приходит извне и определяет, какая иконка отображается.
    let isOn: Bool
    
    /// ViewModel экрана фильтров.
    /// Используется для обновления состояния выбранных опций.
    @Bindable var viewModel: FiltersViewModel
    
    /// Тип опции (с пересадками / без пересадок),
    /// определяет, какое состояние будет переключено при нажатии.
    let needSwap: SwapOption
    
    var body: some View {
        VStack {
            isOn
            ? Image("RadioButtonOn")
            : Image("RadioButtonOff")
        }
        .onTapGesture {
            handleTap()
        }
    }
    
    // MARK: - Private methods
    
    /// Обрабатывает нажатие на радиокнопку.
    ///
    /// Логика гарантирует, что одновременно может быть выбрана
    /// только одна опция (`yes` или `no`).
    private func handleTap() {
        if needSwap == .yes {
            viewModel.yesRadioButtonState.toggle()
            viewModel.noRadioButtonState = !viewModel.yesRadioButtonState
        } else {
            viewModel.noRadioButtonState.toggle()
            viewModel.yesRadioButtonState = !viewModel.noRadioButtonState
        }
        
        // Проверяем, заполнены ли все необходимые фильтры
        viewModel.checkAllStatesAdded()
    }
}
