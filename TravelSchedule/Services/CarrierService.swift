

import OpenAPIRuntime
import OpenAPIURLSession

typealias Carrier = Components.Schemas.CarrierResponse

protocol CarrierProtocol {
    func getCarrier(code: String, system: String?) async throws -> Carrier
}

final class CarrierService: CarrierProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getCarrier(code: String, system: String?) async throws -> Carrier {
        if let system {
            let response = try await client.getCarrierInfo(query: .init(apikey: apikey, code: code, system: system))
            return try response.ok.body.json
        } else {
            let response = try await client.getCarrierInfo(query: .init(apikey: apikey, code: code))
            return try response.ok.body.json
        }
    }
}



//import Foundation
//import OpenAPIRuntime
//import OpenAPIURLSession
//
//typealias CarrierInfo = Components.Schemas.CarrierResponse
//
//protocol CarrierServiceProtocol {
//    func getCarrierInfo(code: String) async throws -> CarrierInfo
//}
//
//final class CarrierService: CarrierServiceProtocol {
//    var apikey: String
//    var client: Client
//    
//    init(client: Client, apikey: String) {
//        self.client = client
//        self.apikey = apikey
//    }
//    
//    func getCarrierInfo(code: String) async throws -> CarrierInfo {
//        let response = try await client.getCarrierInfo(
//            query: .init(apikey: apikey, code: code)
//        )
//        return try response.ok.body.json
//    }
//}
