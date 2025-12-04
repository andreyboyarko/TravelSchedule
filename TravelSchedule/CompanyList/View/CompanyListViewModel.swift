

import Foundation
import Observation

@Observable class CompanyListViewModel {
    
    var model: CompanyList
    var companies: [Company]?
    var filterCompanies: [Company]?
    var visibleButtonStatus = false
    
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
    
    init() {
        self.model = CompanyList()
    }
    
    func getCompany(from: Direction, to: Direction) {
        companies = model.returnCompany(from: from, to: to)
        filterCompanies = companies
    }
    
    func checkAllStatesAdded() {
        let firstGroup = [morningButtonState.status, dayButtonState.status, afternoonButtonState.status, nightButtonState.status]
        let secondGroup = [yesRadioButtonState, noRadioButtonState]
        
        if firstGroup.contains(true) && secondGroup.contains(true) {
            visibleButtonStatus = true
        } else {
            visibleButtonStatus = false
        }
    }
    
    func filterForCompanies() {
        let firstGroup = [morningButtonState, dayButtonState, afternoonButtonState, nightButtonState].filter { $0.status == true }
        
        let secondGroup: Bool = yesRadioButtonState ? true : false
        
        if let companyArray = companies {
            filterCompanies = companyArray.filter { value in
                return value.needSwapStation == secondGroup &&  firstGroup.contains { $0.time == value.timeOfDay }
            }
        }
    }
}
