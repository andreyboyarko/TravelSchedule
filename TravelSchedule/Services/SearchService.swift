

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleBetweenStations = Components.Schemas.Segments

protocol SearchServiceProtocol {
    func getScheduleBetweenStations(from: String, to: String, date: String?) async throws -> ScheduleBetweenStations
}

final class SearchService: SearchServiceProtocol {
    var apikey: String
    var client: Client
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getScheduleBetweenStations(from: String, to: String, date: String? = nil) async throws -> ScheduleBetweenStations {
        let response = try await client.getScheduleBetweenStations(
            query: .init(apikey: apikey, from: from, to: to, date: date)
        )
        return try response.ok.body.json
    }
}
