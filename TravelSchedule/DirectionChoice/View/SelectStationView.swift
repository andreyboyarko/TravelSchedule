import SwiftUI

struct SelectStationView: View {
    
    // MARK: - Properties
    
    @Binding var hideTabBar: Bool
    @Binding var navigationPath: NavigationPath
    var viewModel: SelectStationViewModel
    
    @State private var searchText: String = ""
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            VStack {
                searchBar
                Spacer().frame(height: 12)
                contentView
            }
            .padding(.top, -10)
        }
        .task {
            await viewModel.needStationForCity()
        }
    }
    
    // MARK: - Subviews
    
    private var contentView: some View {
        VStack {
            if !viewModel.needToShowAlert && !viewModel.needToShowErrorView {
                stationList
            } else if viewModel.needToShowAlert {
                ErrorView(viewModel: ErrorViewModel(actualStatus: .NoInternetConnection))
            } else {
                ErrorView(viewModel: ErrorViewModel(actualStatus: .ServerError))
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(searchText.isEmpty ?  "SearchBarFirst" : "SearchBarSecond")
            TextField("",
                      text: $searchText,
                      prompt: Text("Введите запрос")
            )
            .textFieldStyle(.plain)
            .foregroundStyle(.text)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .onChange(of: searchText) { oldValue, newValue in
                viewModel.filterStation(by: newValue)
            }
            Image("CancelButton")
                .onTapGesture {
                    searchText = ""
                }
                .opacity(searchText.isEmpty ? 0 : 1)
        }
        .padding(.horizontal, 12)
        .background(.backForTextField)
        .frame(height: 36)
        .cornerRadius(10)
        .padding()
    }
    
    private var stationList: some View {
        ZStack {
            if let station = viewModel.stationList {
                List(station, id: \.self) { station in
                    StationRowView(navigationPath: $navigationPath, station: station, viewModel: viewModel)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.appBackground)
                        .padding(.vertical, 7)
                }
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
                .padding(.top, -10)
                .scrollContentBackground(.hidden)
                .opacity(viewModel.listIsEmpty ? 0 : 1)
            } else {
                Text("Data has no addede")
            }
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
}
