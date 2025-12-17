

import Observation
import Combine

@Observable final class DirectionsService {
    
    // MARK: - Properties

    private let networkService: NetworkService
    
    private let allDirectionAddsSubject = CurrentValueSubject<Bool?,Never>(nil)
    private let finalDirectionToSubject = CurrentValueSubject<String?,Never>(nil)
    private var finalDirectionFrom: String? {
        finalDirectionFromSubject.value
    }
    private var finalDirectionTo: String? {
        finalDirectionToSubject.value
    }
    private let directionToSubject = CurrentValueSubject<DirectionModel?,Never>(nil)
    private var directionTo: DirectionModel? {
        directionToSubject.value
    }
    private let directionFromSubject = CurrentValueSubject<DirectionModel?,Never>(nil)
    private let finalDirectionFromSubject = CurrentValueSubject<String?,Never>(nil)
    private let stationsSubject = CurrentValueSubject<[SelectStationModel], Never>([])
    private let scheduleFromSubject = CurrentValueSubject<[CompanyModel]?, Never>(nil)
    private let needCleanScheduleSubject = CurrentValueSubject<Bool, Never>(false)
    private let companyDetailSubject = CurrentValueSubject<CompanyInfoModel?, Never>(nil)
    private let needToShowNoInternetViewSubject = CurrentValueSubject<Bool, Never>(false)
    private let needToShowErrorSubject = CurrentValueSubject<Bool, Never>(false)
    
    var allDirectionAddsPublisher: AnyPublisher<Bool?,Never> {
        allDirectionAddsSubject.eraseToAnyPublisher()
    }
    var finalDirectionToPublisher: AnyPublisher<String?,Never> {
        finalDirectionToSubject.eraseToAnyPublisher()
    }
    var finalDirectionFromPublisher: AnyPublisher<String?,Never> {
        finalDirectionFromSubject.eraseToAnyPublisher()
    }
    var directionToPublisher: AnyPublisher<DirectionModel?,Never> {
        directionToSubject.eraseToAnyPublisher()
    }
    var directionFromPublisher: AnyPublisher<DirectionModel?,Never> {
        directionFromSubject.eraseToAnyPublisher()
    }
    var directionFrom: DirectionModel? {
        directionFromSubject.value
    }
    var stationsPublisher: AnyPublisher<[SelectStationModel], Never> {
        stationsSubject.eraseToAnyPublisher()
    }
    var schedulePublisher: AnyPublisher <[CompanyModel]?, Never> {
        scheduleFromSubject.eraseToAnyPublisher()
    }
    var needCleanSchedulePublisher: AnyPublisher<Bool, Never> {
        needCleanScheduleSubject.eraseToAnyPublisher()
    }
    var companyDetailPublisher : AnyPublisher <CompanyInfoModel?, Never> {
        companyDetailSubject.eraseToAnyPublisher()
    }
    var needToShowNoInternetViewPublisher: AnyPublisher<Bool, Never> {
        needToShowNoInternetViewSubject.eraseToAnyPublisher()
    }
    var neeToShowErrorConnectionViewPublisher: AnyPublisher<Bool, Never> {
        needToShowErrorSubject.eraseToAnyPublisher()
    }
    
    var directionType: DirectionType?
    var selectedCity: SelectPlaceModel?
    var selectedStation: SelectStationModel?
    
    private var toCode: String?
    private var fromCode: String?
    
    init() {
        self.networkService = NetworkService()
    }
    
    // MARK: - Methods

    func swapDirections() {
        // Меняем направления местами
        let tempFrom = directionFrom
        directionFromSubject.send(directionTo)
        directionToSubject.send(tempFrom)
        
        // Обновляем строковые представления
        finalDirectionFromSubject.send(directionFrom.map { $0.city + "(" + $0.trainStations + ")" })
        finalDirectionToSubject.send( directionTo.map { $0.city + "(" + $0.trainStations + ")" })
        
        let oldToCode = toCode
        self.toCode = fromCode
        fromCode = oldToCode
    }
    
    func activeIfAllAdds() {
        guard let from = finalDirectionFrom, let to = finalDirectionTo else { return }
        allDirectionAddsSubject.send(true)
    }
    
    func containsDestinationIfCan() {
        guard let city = selectedCity?.cityName, let station = selectedStation, let direction = directionType else { return }
        
        if direction == .to {
            finalDirectionToSubject.send(station.fullName)
            directionToSubject.send(DirectionModel(city: city,
                                                   trainStations: station.nameOfStation,
                                                   direction: .to))
            toCode = station.code
            stationsSubject.send([])
        } else if direction == .from {
            finalDirectionFromSubject.send(station.fullName)
            directionFromSubject.send(DirectionModel(city: city,
                                                     trainStations: station.nameOfStation,
                                                     direction: .from))
            fromCode = station.code
            stationsSubject.send([])
        }
    }
    
    private func cleanStateErrorViews() {
        needToShowErrorSubject.send(false)
        needToShowNoInternetViewSubject.send(false)
    }
    
    func cleanSchedule() {
        needCleanScheduleSubject.send(false)
        scheduleFromSubject.send(nil)
    }
    
    // MARK: Network Service methods
    
    func updateStationList() async {
        cleanStateErrorViews()
        
        guard let selectedCity = selectedCity else {
            print("[DirectionsService]: updateStationList - Город не выбран")
            return
        }
        
        do {
            let stations = try await networkService.fetchNearestStations(for: selectedCity)
            
            needToShowNoInternetViewSubject.send(false)
            stationsSubject.send(stations)
        } catch let networkError as ErrorType {
            switch networkError {
                
            case .ServerError:
                needToShowErrorSubject.send(true)
            case .NoInternetConnection:
                needToShowNoInternetViewSubject.send(true)
                
            default:
                print("[DirectionsService]: updateStationList - Неизвестная ошибка")
            }
        } catch {
            print("[DirectionsService]: updateStationList - Неизвестная ошибка: \(error)")
        }
    }
    
    func getNewSchedualBetweenStation() async {
        cleanStateErrorViews()
        do {
            guard let toCode = toCode, let fromCode = fromCode else { return }
            
            let scheduleNew = try await networkService.fetchSchedualBetweenStations(from: fromCode, to: toCode)
            
            scheduleFromSubject.send(scheduleNew)
            needCleanScheduleSubject.send(true)
            
        } catch let networkError as ErrorType {
            switch networkError {
                
            case .ServerError:
                needToShowErrorSubject.send(true)
            case .NoInternetConnection:
                needToShowNoInternetViewSubject.send(true)
                
            default:
                print("[DirectionsService]: getNewSchedualBetweenStation - Неизвестная ошибка")
            }
        } catch {
            print("[DirectionsService]: getNewSchedualBetweenStation - Неизвестная ошибка: \(error)")
        }
    }
    
    func set(selectedCompanies: String ) async {
        cleanStateErrorViews()
        do {
            let result = try await networkService.fetchCarrier(code: selectedCompanies)
            companyDetailSubject.send(result)
        } catch let networkError as ErrorType {
            switch networkError {
                
            case .ServerError:
                needToShowErrorSubject.send(true)
            case .NoInternetConnection:
                needToShowNoInternetViewSubject.send(true)
                
            default:
                print("[DirectionsService]: set(selectedCompanies) - Неизвестная ошибка")
            }
        } catch {
            print("[DirectionsService]: set(selectedCompanies) - Неизвестная ошибка: \(error)")
        }
    }
}


