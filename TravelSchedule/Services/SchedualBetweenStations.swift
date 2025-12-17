

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias SchedualBetweenStations = Components.Schemas.Segments

protocol SchedualBetweenStationsProtocol {
    func getSchedualBetweenStations(from: String, to: String) async throws -> SchedualBetweenStations
}

final class SchedualBetweenStationsService: SchedualBetweenStationsProtocol {
    
    var apikey: String
    var client: Client
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getSchedualBetweenStations(from: String, to: String) async throws -> SchedualBetweenStations {
        
        let date = Date()
        let formatter = ISO8601DateFormatter()
        let dateString = String(formatter.string(from: date).prefix(10))
        
        let response = try await client.getSchedualBetweenStations(query: .init(apikey: apikey, from: from, to: to, date: dateString, transport_types: "train", transfers: true))
        return try response.ok.body.json
    }
}

