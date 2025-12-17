

import SwiftUI

struct CompanyListView: View {
    
    // MARK: - Properties

    @Bindable var viewModel: CompanyListViewModel
    @Binding var navigationPath: NavigationPath
    @Binding var companyInfoViewModel: CompanyInfoViewModel
    
    private let columns = [
        GridItem(.flexible())
    ]
    
    // MARK: - Body

    var body: some View {
        ZStack {
            if !viewModel.needToShowAlert && !viewModel.needToShowErrorView {
                VStack {
                    directionText
                    companiesGrid
                }
                fallbackView
                searchButton
            } else if viewModel.needToShowAlert {
                ErrorView(viewModel: ErrorViewModel(actualStatus: .NoInternetConnection))
            } else {
                ErrorView(viewModel: ErrorViewModel(actualStatus: .ServerError))
            }
        }
        .task {
            if viewModel.filterCompanies == nil {
                await viewModel.getNewSchedual()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var directionText: some View {
        if let to = viewModel.to,
           let from = viewModel.from {
            return Text("\(from.city) (\(from.trainStations)) →  \(to.city) (\(to.trainStations))")
                .font(.custom("SFPro-Bold", size: 24))
                .padding()
        } else {
            return Text("Не удалось загрузить направление")
                .font(.custom("SFPro-Bold", size: 24))
                .padding()
        }
        
    }
    
    private var companiesGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                if let companiesList =
                    viewModel.filterCompanies,companiesList.count > 0 {
                    ForEach(companiesList) { companies in
                        CompanyCellView(navigationPath: $navigationPath, viewModel: companyInfoViewModel, companyModel: companies)
                            .padding(.horizontal)
                    }
                }
                Color.clear
                    .frame(height: 100)
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var searchButton: some View {
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
            .background(.blueUniversal)
            .cornerRadius(16)
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
    }
    
    private var fallbackView: some View {
        ZStack {
            Color.clear
            
            // Показываем только когда массив есть И он пустой
            if let companies = viewModel.filterCompanies, companies.isEmpty {
                VStack {
                    Spacer()
                    Text("Вариантов нет")
                        .font(.custom("SFPro-Bold", size: 24))
                    Spacer()
                }
                .transition(
                    .asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.8)),
                        removal: .opacity
                    )
                )
                .animation(.bouncy(duration: 0.5), value: companies.isEmpty)
                .onAppear {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                }
            }
        }
    }
}


