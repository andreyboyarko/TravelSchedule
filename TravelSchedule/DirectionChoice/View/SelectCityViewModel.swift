

import Foundation
import Observation

@Observable class SelectCityViewModel {
    
    // MARK: - Выбранные значения
    
    /// Выбранный город
    var selectedCity: String?
    
    /// Выбранная станция
    var selectedStation: String?
    
    /// Готовая модель направления "Откуда"
    var directionFrom: Direction?
    
    /// Строка для отображения выбранного направления "Откуда"
    var finalDirectionFrom: String?
    
    /// Строка для отображения направления "Куда"
    var finalDirectionTo: String?
    
    /// Готовая модель направления "Куда"
    var directionTo: Direction?
    
    /// Какое направление сейчас выбирается: from / to
    var directionType: DirectionType?
    
    
    // MARK: - Состояния UI
    
    /// Все направления заполнены → можно нажимать кнопку "Найти"
    var allDirectionAdds: Bool = false
    
    /// Показывать "Пусто" при отсутствии результатов поиска
    var listIsEmpty: Bool = false
    
    
    // MARK: - Данные
    
    /// Станции выбранного города
    var stationList: [String]?
    
    /// Список всех городов
    var cityList: [String]?
    
    /// Модель, которая отвечает за получение данных (mock или сеть)
    var model: City
    
    
    // MARK: - Инициализация
    
    init() {
        self.model = City()
    }
    
    
    // MARK: - Получение списка городов
    
    /// Загружает массив городов и сбрасывает флаг пустого списка
    func needCityArray() {
        cityList = model.getCityList()
        
        if let list = cityList, !list.isEmpty {
            listIsEmpty = false
        }
    }
    
    
    // MARK: - Получение станций выбранного города
    
    /// Загружает станции для выбранного города
    func needStationForCity() {
        guard let selectedCity else { return }
        
        stationList = model.getStation(for: selectedCity)
        
        if let stationList, !stationList.isEmpty {
            listIsEmpty = false
        }
    }
    
    
    // MARK: - Формирование направления (from/to)
    
    /// Создаёт Direction и его строковое значение, если выбраны город + станция
    func containsDestinationIfCan() {
        guard
            let city = selectedCity,
            let station = selectedStation,
            let direction = directionType
        else { return }
        
        if direction == .to {
            // Формируем направление "Куда"
            finalDirectionTo = "\(city)(\(station))"
            directionTo = Direction(
                city: city,
                trainStations: station,
                direction: .to
            )
            
        } else if direction == .from {
            // Формируем направление "Откуда"
            finalDirectionFrom = "\(city)(\(station))"
            directionFrom = Direction(
                city: city,
                trainStations: station,
                direction: .from
            )
        }
    }
    
    
    // MARK: - Проверка, что оба направления есть
    
    /// Проверяет, выбраны ли оба направления (from + to)
    func activeIfAllAdds() {
        guard
            let from = finalDirectionFrom,
            let to = finalDirectionTo
        else { return }
        
        allDirectionAdds = true
    }
    
    
    // MARK: - Фильтрация городов
    
    /// Фильтрует список городов по запросу пользователя
    func filterCity(by word: String) {
        guard let cityList else { return }
        
        // Если поле пустое — возвращаем полный массив
        if word.isEmpty {
            needCityArray()
            return
        }
        
        let newList = cityList.filter { $0.localizedCaseInsensitiveContains(word) }
        
        if newList.isEmpty {
            listIsEmpty = true
        } else {
            self.cityList = newList
        }
    }
    
    
    // MARK: - Фильтрация станций
    
    /// Фильтрует станции выбранного города
    func filterStation(by word: String) {
        guard let stationList else { return }
        
        if word.isEmpty {
            needStationForCity()
            return
        }
        
        let newList = stationList.filter { $0.localizedCaseInsensitiveContains(word) }
        
        if newList.isEmpty {
            listIsEmpty = true
        } else {
            self.stationList = newList
        }
    }
    
    
    // MARK: - Свап направлений
    
    /// Меняет местами направления "Откуда" и "Куда"
    func swapDirections() {
        // Меняем модели
        let tempFrom = directionFrom
        directionFrom = directionTo
        directionTo = tempFrom
        
        // Перегенерируем строки для отображения
        finalDirectionFrom = directionFrom.map { "\($0.city)(\($0.trainStations))" }
        finalDirectionTo   = directionTo.map { "\($0.city)(\($0.trainStations))" }
    }
}
