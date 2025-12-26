
enum ErrorType: String, Error, Sendable {
    case ServerError = "Ошибка сервера"
    case NoInternetConnection = "Нет интернета"
    case NoProblems
}

