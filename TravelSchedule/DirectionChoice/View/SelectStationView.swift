
import SwiftUI

struct SelectStationView: View {
    
    // MARK: - Bindings & ViewModel
    @Binding var hideTabBar: Bool
    
    /// Общая вью-модель выбора направления/городов/станций
    var viewModel: SelectCityViewModel
    
    @Binding var navigationPath: NavigationPath
    
    // MARK: - Local State
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                
                // MARK: - Search Bar
                HStack {
                    Image(searchText.isEmpty ? "SearchBarFirst" : "SearchBarSecond")
                    
                    TextField(
                        "",
                        text: $searchText,
                        prompt: Text("Введите запрос")
                    )
                    .textFieldStyle(.plain)
                    .foregroundColor(.appText)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .onChange(of: searchText) { _, newValue in
                        viewModel.filterStation(by: newValue)
                    }
                    
                    // Кнопка сброса поиска
                    Image("CancelButton")
                        .onTapGesture {
                            searchText = ""
                        }
                        .opacity(searchText.isEmpty ? 0 : 1)
                }
                .padding(.horizontal, 12)
                .background(Color.appBackForField)
                .frame(height: 36)
                .cornerRadius(10)
                .padding()
                
                Spacer().frame(height: 12)
                
                // MARK: - Список станций + заглушка
                ZStack {
                    
                    // Список станций
                    if let stationList = viewModel.stationList {
                        List(stationList, id: \.self) { station in
                            StationRowView(
                                navigationPath: $navigationPath,
                                station: station,
                                viewModel: viewModel
                            )
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.appBackground)
                            .padding(.vertical, 7)
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                        .padding(.top, -10)
                        .opacity(viewModel.listIsEmpty ? 0 : 1)
                        
                    } else {
                        Text("Data has no added") // Заглушка, если данных нет совсем
                    }
                    
                    // MARK: - Заглушка "Станция не найдена"
                    VStack {
                        Spacer()
                        Text("Станция не найдена")
                            .font(.custom("SFPro-Bold", size: 24))
                            .opacity(viewModel.listIsEmpty ? 1 : 0)
                        Spacer()
                        Spacer()
                    }
                }
            }
            .padding(.top, -10)
        }
    }
}
