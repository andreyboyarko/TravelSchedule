
import Foundation
import Observation
import Combine

@MainActor @Observable final class FiltersViewModel {
    
    // MARK: - Properties
    
    private(set) var visibleButtonStatus = false
    private var cancelLables = Set<AnyCancellable>()
    
    var morningButtonState: TimeOfDirection = TimeOfDirection(status: false,
                                                                        time: .morning)
    var dayButtonState: TimeOfDirection = TimeOfDirection(status: false,
                                                                    time: .day)
    var afternoonButtonState: TimeOfDirection = TimeOfDirection(status: false,
                                                                          time: .afternoon)
    var nightButtonState: TimeOfDirection = TimeOfDirection(status: false,
                                                                      time: .night)
    
    var yesRadioButtonState = false
    var noRadioButtonState = false
    var service: CompanyService
    
    init(service: CompanyService) {
        self.service = service
        setupSubscriptions()
    }
    
    // MARK: - Methods
    
    private func setupSubscriptions() {
        service.buttonStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newState in
                self?.visibleButtonStatus = newState
            }
            .store(in: &cancelLables)
        service.cleanFilterButtonStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newState in
                self?.cleanButtonState()
            }
            .store(in: &cancelLables)
    }
    
    func cleanButtonState() {
        morningButtonState.status = false
        dayButtonState.status = false
        afternoonButtonState.status = false
        nightButtonState.status = false
        
        yesRadioButtonState = false
        noRadioButtonState = false
    }
    
    func checkAllStatesAdded() {
        let firstGroup = [morningButtonState.status, dayButtonState.status, afternoonButtonState.status, nightButtonState.status]
        let secondGroup = [yesRadioButtonState, noRadioButtonState]
        
        if firstGroup.contains(true) && secondGroup.contains(true) {
            service.needChangeButton(status: true)
        } else {
            service.needChangeButton(status: false)
        }
    }
    
    func filterForCompanies() {
        let firstGroup = [morningButtonState, dayButtonState, afternoonButtonState, nightButtonState].filter { $0.status == true }
        
        let secondGroup: Bool = yesRadioButtonState ? true : false
        
        if let companiesList = service.standardCompanies {
            
            let newCompanyList = companiesList.filter { value in
                return value.needSwapStation == secondGroup && firstGroup.contains { $0.time == value.timeOfDay }
            }
            service.set(filterCompany: newCompanyList)
        } else {
            print("[FiltersViewModel]: filterForCompanies - Данных нету")
        }
    }
}

