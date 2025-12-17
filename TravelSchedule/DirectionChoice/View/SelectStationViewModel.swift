

import Observation
import Foundation
import Combine

@MainActor @Observable final class SelectStationViewModel {
    
    // MARK: - Properties
    
    var listIsEmpty: Bool = false
    var stationList: [SelectStationModel]?
    var needToShowAlert: Bool = false
    var needToShowErrorView: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private var noInternetView: ErrorView?
    private let directionService: DirectionsService
    
    init(directionService: DirectionsService) {
        self.directionService = directionService
        
        directionService.stationsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newStations in
                self?.stationList = newStations
            }
            .store(in: &cancellables)
        
        directionService.needToShowNoInternetViewPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.needToShowAlert = status
            }
            .store(in: &cancellables)
        directionService.neeToShowErrorConnectionViewPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.needToShowErrorView = status
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    func filterStation(by word: String) {
        guard let stationList else { return }
        
        if word.isEmpty {
            Task{
                await needStationForCity()
            }
            return
        }
        
        let newList = stationList.filter { $0.nameOfStation.localizedCaseInsensitiveContains(word) }
        
        if newList.isEmpty {
            listIsEmpty = true
        } else {
            self.stationList = newList
        }
    }
    
    func needStationForCity() async {
        
        await directionService.updateStationList()
        if let stationList, !stationList.isEmpty {
            listIsEmpty = false
        }
    }
    
    func tryContainsDestination(){
        directionService.containsDestinationIfCan()
    }
    
    func tryActiveIfAdds() {
        directionService.activeIfAllAdds()
    }
    
    func setStation(with name: SelectStationModel) {
        directionService.selectedStation = name
    }
}


