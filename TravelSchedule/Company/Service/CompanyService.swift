

import Observation
import Combine

@Observable final class CompanyService {
    
    // MARK: - Properties
    
    private let buttonStatusSubject = CurrentValueSubject<Bool, Never>(false)
    private let cleanFilterButtonStateSubject = CurrentValueSubject<Bool, Never>(false)
    private let filteredCompaniesSubject = CurrentValueSubject<[CompanyModel]?, Never>(nil)
    
    var buttonStatusPublisher: AnyPublisher<Bool, Never> {
        buttonStatusSubject.eraseToAnyPublisher()
    }
    var cleanFilterButtonStatePublisher: AnyPublisher<Bool, Never> {
        cleanFilterButtonStateSubject.eraseToAnyPublisher()
    }
    var filterCompaniesPublisher: AnyPublisher <[CompanyModel]?, Never> {
        filteredCompaniesSubject.eraseToAnyPublisher()
    }
    var standardCompanies: [CompanyModel]?
    
    // MARK: - Methods

    func needChangeButton(status: Bool) {
        buttonStatusSubject.send(status)
    }
    
    func set(filterCompany: [CompanyModel]) {
        filteredCompaniesSubject.send(filterCompany)
    }
    
    func set(basicCompanies: [CompanyModel]) {
        self.standardCompanies = basicCompanies
    }
    
    func reset() {
        buttonStatusSubject.send(false)
        cleanFilterButtonStateSubject.send(false)
    }
}

