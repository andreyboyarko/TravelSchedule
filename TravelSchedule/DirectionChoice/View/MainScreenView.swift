import SwiftUI

struct MainScreenView: View {
    
    // MARK: - Properties
    
    @Environment(ThemeManager.self) private var themeManager
    @Binding private var hideTabBar: Bool
    
    @State private var navigationPath = NavigationPath()
    @State private var companyInfoViewModel: CompanyInfoViewModel
    @State private var companyViewModel: CompanyListViewModel
    @State private var filtersViewModel: FiltersViewModel
    @State private var chooseDirectionViewModel: SelectDirectionViewModel
    @State private var chooseCityViewModel: SelectCityViewModel
    @State private var chooseStationViewModel: SelectStationViewModel
    @State private var storiesLentViewModel: StoriesLentViewModel
    @State private var storiesFeedViewModel: StoriesFVM
    
    var storiesService: StoriesService
    var errorViewModel: ErrorViewModel
    
    init(hideTabBar: Binding<Bool>, storiesService: StoriesService,
         errorViewModel: ErrorViewModel) {
        
        self._hideTabBar = hideTabBar
        self.errorViewModel = errorViewModel
        self.storiesService = storiesService
        
        let directionService = DirectionsService()
        
        self._chooseCityViewModel = State(
            initialValue: SelectCityViewModel(directionService: directionService)
        )
        self._chooseStationViewModel = State(initialValue: SelectStationViewModel(directionService: directionService))
        self._chooseDirectionViewModel = State(initialValue: SelectDirectionViewModel(directionService: directionService))
        
        let companyService = CompanyService()
        
        self._companyInfoViewModel = State(initialValue: CompanyInfoViewModel(service: directionService))
        self._filtersViewModel = State(initialValue: FiltersViewModel(service: companyService))
        self._companyViewModel = State(initialValue: CompanyListViewModel(service: companyService, directionService: directionService))
        
        self._storiesFeedViewModel = State(initialValue: StoriesFVM(service: storiesService))
        self._storiesLentViewModel = State(initialValue: StoriesLentViewModel(service: storiesService))
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                StoriesFeedView(hideTabBar: $hideTabBar, navigationPath: $navigationPath, viewModel: storiesFeedViewModel)
                
                ChooseDirectionView(chooseDirectionViewModel: chooseDirectionViewModel, navigationPath: $navigationPath)
                
                searchButton
                Spacer()
            }
            .onAppear{
                companyViewModel.resetFilterButton(status: true)
            }
            .navigationDestination(for: DirectionType.self) { direction in
                createView(
                    with: "Выбор города",
                    and: CityView(
                        navigationPath: $navigationPath,
                        viewModel: chooseCityViewModel)
                )
            }
            .navigationDestination(for: String.self) { route in
                switch route {
                case "SelectStation":
                    createView(
                        with: "Выбор станции",
                        and: SelectStationView(
                            hideTabBar: $hideTabBar,
                            navigationPath: $navigationPath, viewModel: chooseStationViewModel
                        )
                    )
                case "CompanyList":
                    createView(
                        with: "",
                        and:
                            CompanyListView(
                                viewModel: companyViewModel,
                                navigationPath: $navigationPath, companyInfoViewModel: $companyInfoViewModel
                            )
                    )
                case "FilterScreen":
                    createView(
                        with: "",
                        and: RouteFilterView(
                            navigationPath: $navigationPath,
                            viewModel: filtersViewModel
                        )
                    )
                case "CompanyDetail":
                    createView(
                        with: "Информация о перевозчике",
                        and: CompanyInfoView(viewModel: companyInfoViewModel, companyListViewModel: companyViewModel))
                case "Stories":
                    StoriesViewerView(viewModel: storiesLentViewModel)
                        .navigationBarHidden(true)
                default:
                    fallbackView(message: "Неизвестный маршрут")
                }
            }
            .background(Color.appBackground)
        }
        .onChange(of: navigationPath) { oldValue, newValue in
            withAnimation(.easeInOut(duration: 0.25)) {
                hideTabBar = !newValue.isEmpty
            }
        }
    }
    
    // MARK: - Subviews
    
    private var searchButton: some View {
        Button(action: {
            navigationPath.append("CompanyList")
        }) {
            Text("Найти")
                .font(.custom("SFPro-Bold", size: 17))
                .foregroundColor(.white)
                .frame(maxWidth: 150, maxHeight: 60)
                .background(.blueUniversal)
                .cornerRadius(16)
        }
        .opacity(chooseDirectionViewModel.allDirectionAdds ?? false ? 1 : 0)
        .disabled(!(chooseDirectionViewModel.allDirectionAdds ?? false))
    }
    
    private func createView(with title: String, and view: some View) -> some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                NavigationBarView(title: title) {
                    navigationPath.removeLast()
                }
                .background(Color.background)
                view
                    .navigationBarHidden(true)
            }
        }
    }
    
    private func fallbackView(message: String) -> some View {
        ZStack {
            Color.background.ignoresSafeArea()
            Text(message)
                .font(.custom("SFPro-Regular", size: 17))
        }
    }
}
