

import Foundation

struct Company: Identifiable {
    var id = UUID()
    var companyName: String
    var image: String // image(systemImage: "top")
    var timeToStart: String // 22:30
    var timeToOver: String // 11:49
    var allTimePath: String // 8 часов
    var date: String // 14 января
    var needSwapStation: Bool // true
    var swapStation: String? // If needSwapStation == true swapStation = Кострома
    var timeOfDay: TimeOfDay
}
