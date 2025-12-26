
import Observation
import Foundation
import Combine

@MainActor @Observable class SelectDirectionViewModel {
    
    // MARK: - Properties
    
    var finalDirectionTo: String?
    var finalDirectionFrom: String?
    var allDirectionAdds: Bool?
    var needCleanData: Bool?
    private var cancelLables = Set<AnyCancellable>()
    private let directionService: DirectionsService
    
    init(directionService: DirectionsService) {
        self.directionService = directionService
        addSubscribing()
    }
    
    // MARK: - Sub Methods
    
    private func addSubscribing() {
        directionService.finalDirectionToPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] directionTo in
                self?.finalDirectionTo = directionTo
            }
            .store(in: &cancelLables)
        directionService.finalDirectionFromPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] directionFrom in
                self?.finalDirectionFrom = directionFrom
            }
            .store(in: &cancelLables)
        directionService.allDirectionAddsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newStatus in
                self?.allDirectionAdds = newStatus
            }
            .store(in: &cancelLables)
        directionService.needCleanSchedulePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.needCleanData = status
            }
            .store(in: &cancelLables)
    }
    
    func needSwapDirection(){
        directionService.swapDirections()
    }
    
    func set(direction: DirectionType){
        directionService.directionType = direction
    }
    
    func needCleanSchedualList(){
        directionService.cleanSchedule()
    }
}
