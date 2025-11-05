import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierInfo = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol {
    func getCarrierInfo(code: String) async throws -> CarrierInfo
}

final class CarrierService: CarrierServiceProtocol {
    var apikey: String
    var client: Client
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getCarrierInfo(code: String) async throws -> CarrierInfo {
        let response = try await client.getCarrierInfo(
            query: .init(apikey: apikey, code: code)
        )
        return try response.ok.body.json
    }
}
