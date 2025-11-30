

import SwiftUI

struct CompanyListView: View {
    
    @Bindable var viewModel: CompanyListViewModel
    @Binding var navigationPath: NavigationPath
    
    let directionTo: Direction
    let directionFrom: Direction
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        ZStack {
            VStack {
                Text("\(directionFrom.city) (\(directionFrom.trainStations)) →  \(directionTo.city) (\(directionTo.trainStations))")
                    .font(.custom("SFPro-Bold", size: 24))
                    .padding()
                ScrollView {
                    LazyVGrid(columns: columns) {
                        if let companiesList = viewModel.filterCompanies,  companiesList.count > 0 {
                            ForEach(companiesList) { companies in
                                CompanyCellView(navigationPath: $navigationPath, image: companies.image,
                                                nameOfCompany: companies.companyName,
                                                needSwapStation: companies.needSwapStation,
                                                swapStation: companies.swapStation,
                                                date: companies.date,
                                                allTimePath: companies.allTimePath,
                                                timeToStart: companies.timeToStart,
                                                timeToOver: companies.timeToOver)
                                .padding(.horizontal)
                            }
                        }
                        Color.clear
                            .frame(height: 100)
                    }
                }
                .scrollIndicators(.hidden)
            }
            
            if let companies = viewModel.filterCompanies, companies.isEmpty {
                VStack {
                    Spacer()
                    Text("Вариантов нет")
                        .font(.custom("SFPro-Bold", size: 24))
                    Spacer()
                }
            }
            
            VStack {
                Spacer()
                Button(action: {
                    navigationPath.append("FilterScreen")
                }) {
                    HStack {
                        Text("Уточнить время")
                            .font(.custom("SFPro-Bold", size: 17))
                        if viewModel.visibleButtonStatus {
                            Image("Counter")
                            
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 60)
                }
                .foregroundColor(.white)
                .background(Color.appBlue)
                .cornerRadius(16)
                .padding(.horizontal)
                .padding(.vertical, 5)
            }
        }
        .onAppear {
            if viewModel.companies == nil {
                viewModel.getCompany(from: directionFrom, to: directionTo)
            }
        }
    }
}

