

import Foundation

extension CompanyModel {
    static let mockCompanies: [CompanyModel] = [
        CompanyModel(
            companyName: "Скоростной Транзит",
            image: "Aeroflot",
            timeToStart: "01:15",
            timeToOver: "09:00",
            allTimePath: "8 ч",
            date: "14 января",
            needSwapStation: false,
            swapStation: "",
            timeOfDay: .night,
            detailInfo: CompanyInfoModel(bigLogoName: "", fullCompanyName: "", email: "", phone: "", code: 0)
        ),
        // …остальные по аналогии
    ]
}
