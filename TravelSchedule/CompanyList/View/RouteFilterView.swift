

import SwiftUI

struct RouteFilterView: View {
    
    @Binding var navigationPath: NavigationPath
    @Bindable var viewModel: CompanyListViewModel
    
    var body: some View {
        VStack {
            Text("Время отправления")
                .font(.custom("SFPro-Bold", size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
            Group {
                SelectTimeView(viewModel: viewModel, timeOfDay: .morning)
                SelectTimeView(viewModel: viewModel, timeOfDay: .day)
                SelectTimeView(viewModel: viewModel, timeOfDay: .afternoon)
                SelectTimeView(viewModel: viewModel, timeOfDay: .night)
            }
            .padding(.vertical)
            Text("Показываем варианты с пересадками")
                .font(.custom("SFPro-Bold", size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
            Group{
                HStack {
                    Text("Да")
                        .font(.custom("SFPro-Regula", size: 17))
                    Spacer()
                    TransferSelectorView(isOn: viewModel.yesRadioButtonState, viewModel: viewModel, needSwap: .yes)
                }
                HStack {
                    Text("Нет")
                        .font(.custom("SFPro-Regula", size: 17))
                    Spacer()
                    TransferSelectorView(isOn: viewModel.noRadioButtonState, viewModel: viewModel, needSwap: .no)
                }
            }
            .padding(.vertical)
            Spacer()
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
                .background(Color.appBlue)
                .cornerRadius(16)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .opacity(viewModel.visibleButtonStatus ? 1 : 0)
            }
        }
        .padding(.horizontal)
    }
}
