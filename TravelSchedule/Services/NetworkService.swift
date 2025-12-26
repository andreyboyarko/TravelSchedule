

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

actor NetworkService {
    
    private let apiKey = "3911a4d8-fa51-46d1-89d4-bceb90a9a37e"
    
    // MARK: - Methods

    func fetchSchedualBetweenStations(from: String, to: String) async throws-> [CompanyModel] {
        
        guard await checkInternetConnection() else {
            throw ErrorType.NoInternetConnection
        }
        
        do {
            let client = await Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = await SchedualBetweenStationsService(client: client, apikey: apiKey)
            let schedual = try await service.getSchedualBetweenStations(from: from, to: to)
            
            return convertToCompanyList(response: schedual)
        } catch {
            throw ErrorType.ServerError
        }
        
    }
    
    func fetchNearestStations(for place: SelectPlaceModel) async throws -> [SelectStationModel] {
        
        guard await checkInternetConnection() else {
            throw ErrorType.NoInternetConnection
        }
        
        guard let lat = Double(place.lat),
              let lng = Double(place.lng),
              let distance = Int(place.distance) else {
            throw NSError(domain: "NetworkService", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Неверные координаты"])
        }
        do {
            let client = await Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            
            let service = await NearestStationsService(client: client, apikey: apiKey)
            
            let stationsResponse = try await service.getNearestStations(
                lat: lat,
                lng: lng,
                distance: distance
            )
            return convertStationsResponse(stationsResponse)
            
        } catch {
            throw ErrorType.ServerError
        }
        
    }
    
    func fetchCarrier(code: String) async throws -> CompanyInfoModel {
        
        guard await checkInternetConnection() else {
            throw ErrorType.NoInternetConnection
        }
        
        do {
            let client = await Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            
            let service = await CarrierService(client: client, apikey: apiKey)
            
            let companyDetail = try await service.getCarrier(code: code, system: "yandex")
                        
            return checkDetail(companyDetail, code: Int(code) ?? 0)
        } catch {
            throw ErrorType.ServerError
        }
        
    }
    
    // MARK: Helpful methods
    
    private func checkDetail(_ detail:Carrier, code: Int) -> CompanyInfoModel {
        
        if let logo = detail.carrier?.logo, let nameOfCompany = detail.carrier?.title, let email = detail.carrier?.email, let phone = detail.carrier?.phone {
            
            return CompanyInfoModel(
                bigLogoName: logo,
                fullCompanyName: nameOfCompany,
                email: email,
                phone: phone,
                code: code)
        }
        
        return  CompanyInfoModel(bigLogoName: "", fullCompanyName: "TrancKargo", email: "transCargo@mail.ru", phone: "+7 (964) - 392 - 99 - 02", code: 0)
    }
    
    private func convertToCompanyList(response: SchedualBetweenStations) -> [CompanyModel] {
        var result: [CompanyModel] = []
        guard let apiSchedual = response.segments else { return result }
        for i in apiSchedual {
            
            guard let departureString = i.departure,
                  let arrivalString = i.arrival,let nameSchedual = i.thread?.title,let phone = i.thread?.carrier?.phone,
                  let email = i.thread?.carrier?.email else {
                continue
            }
            let beginTime = i.departure
            let endTime = i.arrival
            let duration = (i.duration ?? 0) / 3600
            let date = i.departure
            let title = i.thread?.carrier?.title
            let logo = i.thread?.carrier?.logo
            let code = i.thread?.carrier?.code
            
            let company = CompanyModel(
                companyName: title ?? "Безымянная",
                image: logo ?? "",
                timeToStart: formatDateOrTime(from: beginTime ?? "Нет времени", showTime: true),
                timeToOver: formatDateOrTime(from: endTime ?? "Нет времени", showTime: true),
                allTimePath: formatHours(duration),
                date: formatDateOrTime(from: date ?? "Нет времени", showTime: false),
                needSwapStation: false,
                swapStation: "",
                timeOfDay: from(beginTime ?? ""),
                detailInfo: CompanyInfoModel(
                    bigLogoName: logo ?? "",
                    fullCompanyName: title ?? "Нет картинки",
                    email: email,
                    phone: phone, code: code ?? 0)
            )
            result.append(company)
        }
        return result
    }
    
    private func convertStationsResponse(_ response: NearestStations) -> [SelectStationModel] {
        var result: [SelectStationModel] = []
        
        guard let apiStations = response.stations else { return result }
        
        for apiStation in apiStations {
            
            guard let fullName = apiStation.title, let code = apiStation.code,  let nameOfStation = apiStation.popular_title, nameOfStation != "" else {
                continue
            }
            
            let station = SelectStationModel(
                nameOfStation: nameOfStation,
                fullName: fullName,
                code: code
            )
            
            result.append(station)
        }
        return result
    }
    
    private func checkInternetConnection() async -> Bool {
        do {
            let url = URL(string: "https://www.apple.com")!
            let (_, response) = try await URLSession.shared.data(from: url)
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }
    
    private func formatHours(_ hours: Int) -> String {
        let lastDigit = hours % 10
        let lastTwoDigits = hours % 100
        
        let word: String
        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            word = "часов"
        } else if lastDigit == 1 {
            word = "час"
        } else if lastDigit >= 2 && lastDigit <= 4 {
            word = "часа"
        } else {
            word = "часов"
        }
        
        return "\(hours) \(word)"
    }
    
    
    private func formatDateOrTime(from isoString: String, showTime: Bool) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        guard let date = formatter.date(from: isoString) else { return "" }
        
        if showTime {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "d MMMM"
        }
        
        return formatter.string(from: date)
    }
    
    
    private func from(_ time: String) -> TimeOfDay {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let baseTime = time
            .replacingOccurrences(of: "\\+[0-9]{2}:[0-9]{2}$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "Z$", with: "")
        
        guard let date = formatter.date(from: baseTime) else {
            return .none
        }
        
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 0..<6:
            return .night
        case 6..<12:
            return .morning
        case 12..<18:
            return .day
        case 18..<24:
            return .afternoon
        default:
            return .none
        }
    }
}

