
struct CompanyList {
    let mockCompanies: [Company] = [
        Company(
            companyName: "Скоростной Транзит",
            image: "Aeroflot",
            timeToStart: "01:15",
            timeToOver: "09:00",
            allTimePath: "8 ч",
            date: "14 января",
            needSwapStation: false,
            swapStation: nil,
            timeOfDay: .night
        ),
        Company(
            companyName: "РЖД Экспресс",
            image: "rgd",
            timeToStart: "22:30",
            timeToOver: "08:15",
            allTimePath: "9 ч 45 мин",
            date: "15 января",
            needSwapStation: true,
            swapStation: "Костроме",
            timeOfDay: .night
        ),
        Company(
            companyName: "ТрансКарго",
            image: "TransCargo",
            timeToStart: "12:30",
            timeToOver: "21:00",
            allTimePath: "8 ч 30 мин",
            date: "16 января",
            needSwapStation: false,
            swapStation: nil,
            timeOfDay: .day
        ),
        Company(
            companyName: "АэроФлот Региональный",
            image: "Aeroflot",
            timeToStart: "07:40",
            timeToOver: "11:10",
            allTimePath: "3 ч 30 мин",
            date: "17 января",
            needSwapStation: false,
            swapStation: nil,
            timeOfDay: .morning
        ),
        Company(
            companyName: "Волна-Тур",
            image: "Aeroflot",
            timeToStart: "15:05",
            timeToOver: "19:20",
            allTimePath: "4 ч 15 мин",
            date: "18 января",
            needSwapStation: true,
            swapStation: "Владимире",
            timeOfDay: .day
        ),
        Company(
            companyName: "МежгородАвто",
            image: "TransCargo",
            timeToStart: "09:10",
            timeToOver: "18:40",
            allTimePath: "9 ч 30 мин",
            date: "19 января",
            needSwapStation: false,
            swapStation: nil,
            timeOfDay: .day
        ),
        Company(
            companyName: "Грузовой Альянс",
            image: "rgd",
            timeToStart: "23:45",
            timeToOver: "06:30",
            allTimePath: "6 ч 45 мин",
            date: "20 января",
            needSwapStation: true,
            swapStation: "Твери",
            timeOfDay: .night
        )
    ]
    
    func returnCompany(from: Direction, to: Direction) -> [Company]? {
        guard !mockCompanies.isEmpty else { return nil }
        return mockCompanies
    }
}
