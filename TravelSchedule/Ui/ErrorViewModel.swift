

import Observation

@MainActor @Observable final class ErrorViewModel {
    
    var actualStatus: ErrorType

    var imageName: String? {
        get {
            switch actualStatus {
            case .NoProblems:
                return nil
            case .ServerError:
                return "ServerError"
            case .NoInternetConnection:
                return  "NoInternetError"
            }
        }
    }
    
    var text: String? {
        get { actualStatus != .NoProblems ? actualStatus.rawValue : nil
        }
    }
    
    init(actualStatus: ErrorType) {
        self.actualStatus = actualStatus
    }
}

