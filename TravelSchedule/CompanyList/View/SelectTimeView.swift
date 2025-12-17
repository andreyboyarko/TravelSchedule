

import SwiftUI

private enum Constants {
    static let morning = "Утро 06:00 - 12:00"
    static let day = "День 12:00 - 18:00"
    static let afternoon = "Вечер 18:00 - 00:00"
    static let night = "Ночь 00:00 - 06:00"
    static let empty = "Данных нет"
}

struct ChooseTimeView: View {
    
    // MARK: - Properties

    @Bindable var viewModel: FiltersViewModel
    let timeOfDay: TimeOfDay
    @State var imageState: String = "OffCheckBox"
    
    // MARK: - Body

    var body: some View {
        switch timeOfDay {
        case .morning:
            createTimeButton(text: Constants.morning,
                             viewModel: viewModel,
                             buttonStatus: viewModel.morningButtonState.status,
                             timeOfDay: .morning)
        case .day:
            createTimeButton(text: Constants.day,
                             viewModel: viewModel,
                             buttonStatus: viewModel.dayButtonState.status,
                             timeOfDay: .day)
            
        case .afternoon:
            createTimeButton(text: Constants.afternoon,
                             viewModel: viewModel,
                             buttonStatus: viewModel.afternoonButtonState.status,
                             timeOfDay: .afternoon)
            
        case .night:
            createTimeButton(text: Constants.night,
                             viewModel: viewModel,
                             buttonStatus: viewModel.nightButtonState.status,
                             timeOfDay: .night)
        case .none:
            Text("Данных нету")
        }
    }
    
    // MARK: - Sub Methods

    private func createTimeButton(text: String, viewModel: FiltersViewModel, buttonStatus: Bool, timeOfDay: TimeOfDay) -> some View {
        HStack {
            Text(text)
                .font(.custom("SFPro-Regula", size: 17))
            Spacer()
            TimeCheckView(viewModel: viewModel,
                           isOn: buttonStatus,
                           timeOfDay: timeOfDay)
        }
    }
}
