

import Foundation

struct City {
    
    private let cityList = SelectPlaceModel.mockCities
    
    func getCityList() -> [String] {
        cityList.map { $0.city }
    }
    
    func getStation(for city: String) -> [String] {
        let a = cityList.filter { $0.city == city }
        return a.flatMap { $0.trainStations }
    }
}

