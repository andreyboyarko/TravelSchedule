

import Foundation

struct SelectPlaceModel: Hashable, Identifiable {
    var id = UUID()
    var city: String
    var trainStations: [String]
}

