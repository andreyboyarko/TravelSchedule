
import Foundation
import Observation
import Combine

@MainActor @Observable final class SelectCityViewModel {
    
    // MARK: - Properties

    var listIsEmpty: Bool = false
    var cityList: [SelectPlaceModel]?
    
    private let model: City
    private let directionService: DirectionsService
    
    init(directionService: DirectionsService) {
        self.model = City()
        self.directionService = directionService
    }
    
    // MARK: - Methods

    func needCityArray() async {
        cityList = model.getCityList()
        if let list = cityList, !list.isEmpty {
            listIsEmpty = false
        }
    }
    
    func filterCity(by word: String) {
        guard let cityList else { return }
        
        if word.isEmpty {
            Task{
                await needCityArray()
            }
            return
        }
        
        let newList = cityList.filter {
            $0.cityName.localizedCaseInsensitiveContains(word)
        }
        
        if newList.isEmpty {
            listIsEmpty = true
        } else {
            self.cityList = newList
        }
    }
    
    func setSelectedCity(_ place: SelectPlaceModel) {
        directionService.selectedCity = place
    }
}
