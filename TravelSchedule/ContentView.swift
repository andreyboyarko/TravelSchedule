import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
    private let apikey = "ВСТАВЬ_СВОЙ_API_KEY"

    var body: some View {
        Text("TravelSchedule network demo")
            .padding()
            .onAppear {
                testNearestStations()
                testScheduleByStation()
                testSearchBetweenStations()
                testThread()
                testNearestCity()
                testCarrier()
                testAllStations()
                testCopyright()
            }
    }

    // 1. /v3.0/nearest_stations/
    private func testNearestStations() {
        Task {
            do {
                let client = makeClient()
                let service = NearestStationsService(client: client, apikey: apikey)
                let result = try await service.getNearestStations(lat: 55.75, lng: 37.61, distance: 10)
                print("Nearest stations OK:", result.stations?.count ?? 0)
            } catch { print("Nearest stations ERROR:", error) }
        }
    }

    // 2. /v3.0/schedule/
    private func testScheduleByStation() {
        Task {
            do {
                let client = makeClient()
                let service = ScheduleService(client: client, apikey: apikey)
                let result = try await service.getStationSchedule(station: "s9600213")
                print("Schedule by station OK:", result.date ?? "no date")
            } catch { print("Schedule by station ERROR:", error) }
        }
    }

    // 3. /v3.0/search/
    private func testSearchBetweenStations() {
        Task {
            do {
                let client = makeClient()
                let service = SearchService(client: client, apikey: apikey)
                let result = try await service.getScheduleBetweenStations(from: "s2000001", to: "s9602494", date: nil)
                print("Search between stations OK:", result.segments?.count ?? 0)
            } catch { print("Search between stations ERROR:", error) }
        }
    }

    // 4. /v3.0/thread/
    private func testThread() {
        Task {
            do {
                let client = makeClient()
                let service = ThreadService(client: client, apikey: apikey)
                let result = try await service.getRouteStations(uid: "078S_9_2")
                print("Thread OK:", result.title ?? "no title")
            } catch { print("Thread ERROR:", error) }
        }
    }

    // 5. /v3.0/nearest_settlement/
    private func testNearestCity() {
        Task {
            do {
                let client = makeClient()
                let service = NearestCityService(client: client, apikey: apikey)
                let result = try await service.getNearestCity(lat: 55.75, lng: 37.61)
                print("Nearest city OK:", result.title ?? "no title")
            } catch { print("Nearest city ERROR:", error) }
        }
    }

    // 6. /v3.0/carrier/
    private func testCarrier() {
        Task {
            do {
                let client = makeClient()
                let service = CarrierService(client: client, apikey: apikey)
                let result = try await service.getCarrierInfo(code: "680")
                print("Carrier OK:", result.carrier?.title ?? "no carrier")
            } catch { print("Carrier ERROR:", error) }
        }
    }

    // 7. /v3.0/stations_list/
    private func testAllStations() {
        Task {
            do {
                let client = makeClient()
                let service = AllStationsService(client: client, apikey: apikey)
                let result = try await service.getAllStations()
                print("All stations OK, countries:", result.countries?.count ?? 0)
            } catch { print("All stations ERROR:", error) }
        }
    }

    // 8. /v3.0/copyright/
    private func testCopyright() {
        Task {
            do {
                let client = makeClient()
                let service = CopyrightService(client: client, apikey: apikey)
                let result = try await service.getCopyright()
                print("Copyright OK:", result.copyright?.text ?? "no text")
            } catch { print("Copyright ERROR:", error) }
        }
    }

    // MARK: - helper
    private func makeClient() -> Client {
        try! Client(
            serverURL: Servers.Server1.url(),
            transport: URLSessionTransport()
        )
    }
}

#Preview {
    ContentView()
}
