

import SwiftUI

struct RouteFilterView: View {
    
    // MARK: - Properties

    @Binding var navigationPath: NavigationPath
    @Bindable var viewModel: FiltersViewModel
    
    var body: some View {
        VStack {
            timeToStartTitle
            chooseTimeFilters
            transitionTitle
            needSwapFilter
            Spacer()
            turnFiltersButton
        }
        .padding(.horizontal)
    }
    
    // MARK: - Subviews

    private var timeToStartTitle: some View {
        Text("Время отправления")
            .font(.custom("SFPro-Bold", size: 24))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)
    }
    
    private var chooseTimeFilters: some View {
        Group {
            ChooseTimeView(viewModel: viewModel, timeOfDay: .morning)
            ChooseTimeView(viewModel: viewModel, timeOfDay: .day)
            ChooseTimeView(viewModel: viewModel, timeOfDay: .afternoon)
            ChooseTimeView(viewModel: viewModel, timeOfDay: .night)
        }
        .padding(.vertical)
    }
    
    private var transitionTitle: some View {
        Text("Показываем варианты с пересадками")
            .font(.custom("SFPro-Bold", size: 24))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)
    }
    
    private var needSwapFilter: some View {
        Group{
            HStack {
                Text("Да")
                    .font(.custom("SFPro-Regula", size: 17))
                Spacer()
                NeedSwapTransportView(isOn: viewModel.yesRadioButtonState, viewModel: viewModel, needSwap: .yes)
            }
            HStack {
                Text("Нет")
                    .font(.custom("SFPro-Regula", size: 17))
                Spacer()
                NeedSwapTransportView(isOn: viewModel.noRadioButtonState, viewModel: viewModel, needSwap: .no)
            }
        }
        .padding(.vertical)
    }
    
    private var turnFiltersButton: some View {
        VStack {
            Button(action: {
                viewModel.filterForCompanies()
                navigationPath.removeLast()
            }) {
                Text("Применить")
                    .font(.custom("SFPro-Bold", size: 17))
                    .frame(maxWidth: .infinity, maxHeight: 60)
            }
            .foregroundColor(.white)
            .background(.blueUniversal)
            .cornerRadius(16)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .opacity(viewModel.visibleButtonStatus ? 1 : 0)
        }
    }
}
