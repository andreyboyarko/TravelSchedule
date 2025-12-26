

import Foundation

struct City {
    
    private let cityList = SelectPlaceModel.mockCities
    
    func getCityList() -> [SelectPlaceModel] {
        cityList.map { $0 }
    }
}
