
import Foundation
import Observation
import Combine

@MainActor @Observable final class CompanyListViewModel {
    
    // MARK: - Properties
    
    private let model: CompanyListModel
    private let service: CompanyService
    private let directionService: DirectionsService
    private var cancelLables = Set<AnyCancellable>()
    var needToShowAlert: Bool = false
    var needToShowErrorView: Bool = false
    var to: DirectionModel?
    var from: DirectionModel?
    
    var filterCompanies: [CompanyModel]?
    var visibleButtonStatus = false
    
    init(service: CompanyService, directionService: DirectionsService) {
        self.model = CompanyListModel()
        self.service = service
        self.directionService = directionService
        setupSubscriptions()
    }
    
    // MARK: - Sub Methods
    
    private func setupSubscriptions() {
        service.buttonStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newState in
                self?.visibleButtonStatus = newState
            }
            .store(in: &cancelLables)
        service.filterCompaniesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filterCompanies in
                self?.filterCompanies = filterCompanies
            }
            .store(in: &cancelLables)
        
        directionService.directionToPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] to in
                self?.to = to
            }
            .store(in: &cancelLables)
        directionService.directionFromPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] from in
                self?.from = from
            }
            .store(in: &cancelLables)
        directionService.schedulePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newSchedule in
                if let newSchedule {
                    self?.filterCompanies = newSchedule
                    self?.service.set(basicCompanies: newSchedule)
                    self?.service.set(filterCompany: newSchedule)
                }
            }
            .store(in: &cancelLables)
        directionService.needToShowNoInternetViewPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.needToShowAlert = status
            }
            .store(in: &cancelLables)
        directionService.neeToShowErrorConnectionViewPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.needToShowErrorView = status
            }
            .store(in: &cancelLables)
    }
    
    // MARK: - Methods

    func resetFilterButton(status: Bool)  {
        
        if status {
            directionService.cleanSchedule()
            service.reset()
            filterCompanies = nil
        }
    }
    
    func setSelectCompany(detail: CompanyModel) async {
        
        if  String(detail.detailInfo.code) != "" {
            await directionService.set(selectedCompanies: String(detail.detailInfo.code))
        }
    }
    
    
    func getNewSchedual() async {
        await directionService.getNewSchedualBetweenStation()
    }
}

