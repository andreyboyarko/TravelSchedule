

import SwiftUI
import Combine

@Observable final class StoriesService {
    
    // MARK: - Properties

    private let model: StoriesDataProvider
    private let mainImageViewArraySubject = CurrentValueSubject<[StoryItemModel]?, Never>(nil)
    private let isCloseStoriesSubject = CurrentValueSubject<Bool, Never>(false)
    private let actualStorySubject = CurrentValueSubject<[[Story]]?, Never>(nil)
    private var mainImageViewArray: [StoryItemModel]? {
        mainImageViewArraySubject.value
    }
    private var actualNumber: Int?
    
    var isCloseStoriesPublisher: AnyPublisher<Bool, Never> {
        isCloseStoriesSubject.eraseToAnyPublisher()
    }
    var mainImageViewArrayPublisher:AnyPublisher<[StoryItemModel]?, Never> {
        mainImageViewArraySubject.eraseToAnyPublisher()
    }
    var actualStoryPublisher: AnyPublisher<[[Story]]?, Never> {
        actualStorySubject.eraseToAnyPublisher()
    }
    
    init(model: StoriesDataProvider) {
        self.model = model
        loadStories()
    }
    
    // MARK: - Subviews

    func closeStoriesIfNeed() {
        isCloseStoriesSubject.send(false)
    }
    
    func loadStories() {
        mainImageViewArraySubject.send(model.mainImageViewArray)
    }
    
    func needClose() {
        isCloseStoriesSubject.send(true)
    }
    
    func createStoryArray(number: String) {
        let newStoryArray = model.convertToStory(number: Int(number) ?? 0)
        actualStorySubject.send(newStoryArray)
        actualNumber = Int(number) ?? 0
    }
    
    func needUpdateActualStory(globalNumber: Int) {
        guard let num = actualNumber else { return }
        if num - 1 > 0 {
            createStoryArray(number: String(num-1) )
        } else {
            needClose()
        }
    }
    
    func changeStatusFor(story: Int) {
        var actualArray = mainImageViewArray
        
        let newArray = actualArray?.map { storyModel in
            storyModel.image == String(story + (actualNumber ?? 0))
            ? StoryItemModel(image: storyModel.image, borderStatus: false)
            : storyModel
        }
        mainImageViewArraySubject.send(newArray)
    }
}
