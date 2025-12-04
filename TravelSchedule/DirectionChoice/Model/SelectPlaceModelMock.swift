import Foundation

extension SelectPlaceModel {
    static let mockCities: [SelectPlaceModel] = [
        // Москва
        SelectPlaceModel(
            city: "Москва",
            trainStations: [
                "Курский вокзал",
                "Казанский вокзал",
                "Ленинградский вокзал",
                "Ярославский вокзал"
            ]
        ),
        
        // Санкт-Петербург
        SelectPlaceModel(
            city: "Санкт Петербург",
            trainStations: [
                "Московский вокзал",
                "Ладожский вокзал",
                "Витебский вокзал",
                "Финляндский вокзал"
            ]
        ),
        
        // Сочи
        SelectPlaceModel(
            city: "Сочи",
            trainStations: [
                "Сочи",
                "Адлер",
                "Хоста",
                "Лазаревская"
            ]
        ),
        
        // Горный воздух (курорт на Сахалине, рядом с Южно-Сахалинском)
        SelectPlaceModel(
            city: "Горный воздух",
            trainStations: [
                "Южно-Сахалинск",
                "Холмск",
                "Томари"
            ]
        ),
        
        // Краснодар
        SelectPlaceModel(
            city: "Краснодар",
            trainStations: [
                "Краснодар-1",
                "Краснодар-2",
                "Краснодар-Сортировочный"
            ]
        ),
        
        // Казань
        SelectPlaceModel(
            city: "Казань",
            trainStations: [
                "Казань-Пассажирская",
                "Восстание-Пассажирская",
                "Казань-2"
            ]
        ),
        
        // Омск
        SelectPlaceModel(
            city: "Омск",
            trainStations: [
                "Омск-Пассажирский",
                "Омск-Северный",
                "Омск-Восточный"
            ]
        )
    ]
}
