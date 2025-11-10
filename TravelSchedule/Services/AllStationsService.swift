import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias AllStations = Components.Schemas.AllStationsResponse

protocol AllStationsServiceProtocol {
    func getAllStations() async throws -> AllStations
}

final class AllStationsService: AllStationsServiceProtocol {

    private let client: Client
    private let apikey: String
    private let jsonDecoder = JSONDecoder()

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getAllStations() async throws -> AllStations {
        // 1. делаем запрос
        let response = try await client.getAllStations(
            query: .init(apikey: apikey)
        )

        // 2. берём именно то поле, которое сгенерировал OpenAPI
        let bodyStream = try response.ok.body.text_html_charset_utf_hyphen_8

        // 3. стрим
        let limit = 50 * 1024 * 1024 // 50 MB — запас, можно меньше
        let data = try await Data(collecting: bodyStream, upTo: limit)

        // 4. декодим как обычный JSON в наш сгенерированный тип
        let result = try jsonDecoder.decode(AllStations.self, from: data)

        // опционально: глянуть, что пришло
        // print(String(data: data.prefix(1000), encoding: .utf8) ?? "")

        return result
    }
}
