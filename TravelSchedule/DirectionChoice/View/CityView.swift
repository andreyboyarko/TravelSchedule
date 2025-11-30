

import SwiftUI

struct CityView: View {
    
    @Binding var hideTabBar: Bool
    @Binding var navigationPath: NavigationPath
    
    @State private var searchText: String = ""
    
    var viewModel: SelectCityViewModel
    var directionType: DirectionType
    
    var body: some View {
        
        ZStack {
            VStack {
                searchBar
                Spacer().frame(height: 12)
                cityContent
            }
            .padding(.top, -11)
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
                viewModel.filterCity(by: newValue)
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
    
    private var cityContent: some View {
        ZStack {
            if let cityList = viewModel.cityList {
                cityListView(cityList)
            }
            notFoundView
        }
    }
    
    private func cityListView(_ list: [String]) -> some View {
        List(list, id: \.self) { city in
            CityRowView( navigationPath: $navigationPath,
                         place: city,
                         viewModel: viewModel)
            .listRowBackground(Color.appBackground)
            .padding(.vertical, 7)
        }
        .onAppear {
            viewModel.directionType = directionType
        }
        .listStyle(PlainListStyle())
        .padding(.top, -8)
        .scrollContentBackground(.hidden)
        .background(Color.background)
        .opacity(viewModel.listIsEmpty ? 0 : 1)
    }
    
    private var notFoundView: some View {
        VStack {
            Spacer()
            Text("Город не найден")
                .font(.custom("SFPro-Bold", size: 24))
                .opacity(viewModel.listIsEmpty ? 1 : 0)
            Spacer()
            Spacer()
        }
    }
}

