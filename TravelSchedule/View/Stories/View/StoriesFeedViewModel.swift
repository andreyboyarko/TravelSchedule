//
//import SwiftUI
//import Combine
//
//@MainActor @Observable final class StoriesFeedViewModel {
//    
//    // MARK: - Properties
//    
//    var isCloseStories: Bool = false
//    var mainImageViewArray: [MainStoriesModel]?
//    
//    private var cancelLables = Set<AnyCancellable>()
//    private let service: StoriesService
//    
//    init(service: StoriesService) {
//        self.service = service
//        addSubscribing()
//    }
//    
//    // MARK: -  Methods
//    
//    private func addSubscribing(){
//        service.isCloseStoriesPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] status in
//                self?.isCloseStories = status
//            }
//            .store(in: &cancelLables)
//        
//        service.mainImageViewArrayPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] storiesArray in
//                self?.mainImageViewArray = storiesArray
//            }
//            .store(in: &cancelLables)
//    }
//    
//    func tapOnStories(with num: String) {
//        service.createStoryArray(number: num)
//    }
//}
//
