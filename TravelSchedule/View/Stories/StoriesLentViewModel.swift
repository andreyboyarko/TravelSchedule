import SwiftUI
import Combine

@MainActor @Observable final class StoriesLentViewModel {

    // MARK: - Properties

    private let service: StoriesService
    private var cancelLables = Set<AnyCancellable>()
    private var currentStoryGlobalIndex: Int = 0
    private var isReady = false
    private var stories: [[Story]] = []

    var configuration: StoriesPlayerConfiguration?
    var timer: Timer.TimerPublisher?
    var progress: CGFloat = 0
    var cancellable: Cancellable?

    // ✅ ДОБАВИЛИ: удобные флаги
    var hasPrevGroup: Bool { currentStoryGlobalIndex > 0 }
    var hasNextGroup: Bool { currentStoryGlobalIndex < stories.count - 1 }

    // ✅ ДОБАВИЛИ: preview для соседних групп (берём первую сторис группы)
    var prevGroupPreviewStory: Story? {
        guard hasPrevGroup else { return nil }
        return stories[currentStoryGlobalIndex - 1].first
    }

    var nextGroupPreviewStory: Story? {
        guard hasNextGroup else { return nil }
        return stories[currentStoryGlobalIndex + 1].first
    }

    var currentStory: Story {
        guard !stories.isEmpty,
              currentStoryGlobalIndex < stories.count,
              !stories[currentStoryGlobalIndex].isEmpty else {
            return Story(image: "NoInternetError")
        }

        let index = currentStoryIndex
        return stories[currentStoryGlobalIndex][index]
    }

    // ✅ ИСПРАВИЛИ: clamp индекса, чтобы не вылетать при progress == 1
    private var currentStoryIndex: Int {
        guard !stories.isEmpty, currentStoryGlobalIndex < stories.count else { return 0 }
        let count = stories[currentStoryGlobalIndex].count
        guard count > 0 else { return 0 }

        let raw = Int(progress * CGFloat(count))
        return min(max(raw, 0), count - 1)
    }

    var numberOfSections: Int {
        guard !stories.isEmpty, currentStoryGlobalIndex < stories.count else { return 1 }
        return max(stories[currentStoryGlobalIndex].count, 1)
    }

    init(service: StoriesService) {
        self.service = service
        addSubscribing()
    }

    func addSubscribing() {
        service.actualStoryPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newStoryArray in
                guard let self else { return }

                if let newStoryArray, !newStoryArray.isEmpty {
                    self.stories = newStoryArray
                    self.currentStoryGlobalIndex = 0
                    self.progress = 0
                    self.isReady = true
                    self.setConfiguration()
                    self.createTimer()
                } else {
                    self.isReady = false
                }
            }
            .store(in: &cancelLables)
    }

    // MARK: - Tap внутри группы

    func nextStory() {
        let storiesCount = stories[currentStoryGlobalIndex].count
        guard storiesCount > 0 else { return }

        let currentIndex = currentStoryIndex
        let nextIndex = currentIndex + 1 < storiesCount ? currentIndex + 1 : 0

        if nextIndex == 0 && currentIndex != 0 && currentStoryGlobalIndex < stories.count - 1 {
            changeStatus(index: currentStoryGlobalIndex)
            currentStoryGlobalIndex += 1
        } else if nextIndex == 0 && currentIndex != 0 && currentStoryGlobalIndex == stories.count - 1 {
            changeStatus(index: currentStoryGlobalIndex)
            closeStories()
        } else if currentStoryGlobalIndex + 1 >= stories.count - 1 && storiesCount == 1 {
            changeStatus(index: currentStoryGlobalIndex)
            closeStories()
        }

        progress = CGFloat(nextIndex) / CGFloat(storiesCount)
    }

    func prevStory() {
        let storiesCount = stories[currentStoryGlobalIndex].count
        guard storiesCount > 0 else { return }

        let currentIndex = currentStoryIndex
        let prevIndex = currentIndex - 1 >= 0 ? currentIndex - 1 : 0

        progress = CGFloat(prevIndex) / CGFloat(storiesCount)

        if currentIndex > 0 {
            return
        } else if currentStoryGlobalIndex > 0 {
            currentStoryGlobalIndex -= 1
            progress = 0
        } else {
            service.needUpdateActualStory(globalNumber: currentStoryGlobalIndex)
        }
    }

    // ✅ ДОБАВИЛИ: свайп между группами
    func goToNextGroup() {
        guard hasNextGroup else { return }
        currentStoryGlobalIndex += 1
        progress = 0
    }

    func goToPrevGroup() {
        guard hasPrevGroup else { return }
        currentStoryGlobalIndex -= 1
        progress = 0
    }

    func closeStories() {
        service.needClose()
    }

    func changeStatus(index: Int) {
        service.changeStatusFor(story: index)
    }

    func resetStories() {
        service.closeStoriesIfNeed()
    }

    func setConfiguration() {
        configuration = StoriesPlayerConfiguration(storiesCount: stories.count)
    }

    func createTimer() {
        guard let configuration else { return }
        timer = Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common)
    }

    func timerTick() {
        guard isReady, let config = configuration else { return }

        var nextProgress = progress + config.progressPerTick

        if nextProgress >= 1 {
            nextProgress = 0
            if currentStoryGlobalIndex < stories.count - 1 {
                changeStatus(index: currentStoryGlobalIndex)
                currentStoryGlobalIndex += 1
            } else {
                changeStatus(index: currentStoryGlobalIndex)
                closeStories()
            }
        }

        withAnimation {
            progress = nextProgress
        }
    }

    func resetTimer() {
        cancellable?.cancel()
        createTimer()
        cancellable = timer?.connect()
    }
}
//
//import SwiftUI
//import Combine
//
//@MainActor @Observable final class StoriesLentViewModel {
//    
//    // MARK: - Properties
//
//    private let service: StoriesService
//    private var cancelLables = Set<AnyCancellable>()
//    private var currentStoryGlobalIndex: Int = 0
//    private(set) var isReady = false
//    var hasStories: Bool {
//        !stories.isEmpty && stories[currentStoryGlobalIndex].isEmpty == false
//    }
//    var actualStory: Story? {
//        guard isReady, hasStories else { return nil }
//        return currentStory
//    }
//    
//    private var stories: [[Story]] = []
//
//    var configuration: StoriesPlayerConfiguration?
//    var timer: Timer.TimerPublisher?
//    var progress: CGFloat = 0
//    var cancellable: Cancellable?
//    
//    var currentStory: Story {
//        guard !stories.isEmpty,
//              currentStoryGlobalIndex < stories.count,
//              !stories[currentStoryGlobalIndex].isEmpty else {
//            return Story(image: "NoInternetError")
//        }
//        let index = currentStoryIndex
//        
//        guard index < stories[currentStoryGlobalIndex].count else {
//            return stories[currentStoryGlobalIndex].first ?? Story(image: "NoInternetError")
//        }
//        
//        return stories[currentStoryGlobalIndex][index]
//    }
//    
//    private var currentStoryIndex: Int {
//        guard !stories.isEmpty, currentStoryGlobalIndex < stories.count else {
//            return 0
//        }
//        let count = stories[currentStoryGlobalIndex].count
//        let calculated = Int(progress * CGFloat(count))
//        return calculated
//    }
//    
//    var numberOfSections: Int {
//        guard !stories.isEmpty, currentStoryGlobalIndex < stories.count else {
//            return 1
//        }
//        let count = stories[currentStoryGlobalIndex].count
//        return count
//    }
//    
//    init(service: StoriesService) {
//        self.service = service
//        addSubscribing()
//    }
//    
//    // MARK: - Methods
//
//    func addSubscribing() {
//        service.actualStoryPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] newStoryArray in
//                if let newStoryArray, !newStoryArray.isEmpty {
//                    self?.stories = newStoryArray
//                    self?.currentStoryGlobalIndex = 0
//                    self?.progress = 0
//                    self?.isReady = true
//                    self?.setConfiguration()
//                    self?.createTimer()
//                } else {
//                    self?.isReady = false
//                }
//            }
//            .store(in: &cancelLables)
//    }
//    
//    func nextStory() {
//        let storiesCount = stories[currentStoryGlobalIndex].count
//        let currentStoryIndex = Int(progress * CGFloat(storiesCount))
//        let nextStoryIndex = currentStoryIndex + 1 < storiesCount ? currentStoryIndex + 1 : 0
//        
//        if nextStoryIndex == 0 && currentStoryIndex != 0 && currentStoryGlobalIndex < stories.count - 1 {
//            changeStatus(index: currentStoryGlobalIndex)
//            currentStoryGlobalIndex += 1
//        } else if nextStoryIndex == 0 && currentStoryIndex != 0 && currentStoryGlobalIndex == stories.count - 1 {
//            changeStatus(index: currentStoryGlobalIndex)
//            closeStories()
//        } else if currentStoryGlobalIndex + 1 >= stories.count - 1 && storiesCount == 1 {
//            changeStatus(index: currentStoryGlobalIndex)
//            closeStories()
//        }
//        progress = CGFloat(nextStoryIndex) / CGFloat(storiesCount)
//    }
//    
//    func prevStory() {
//        let storiesCount = stories[currentStoryGlobalIndex].count
//        let currentStoryIndex = Int(progress * CGFloat(storiesCount))
//        let prevStoryIndex = currentStoryIndex - 1 > 0 ? currentStoryIndex - 1 : 0
//        
//        progress = CGFloat(prevStoryIndex) / CGFloat(storiesCount)
//        
//        if currentStoryIndex > 0 {
//        } else if currentStoryIndex <= 0  && currentStoryGlobalIndex > 0 {
//            currentStoryGlobalIndex -= 1
//        } else if currentStoryIndex == 0 && currentStoryGlobalIndex == 0 {
//            service.needUpdateActualStory(globalNumber: currentStoryGlobalIndex)
//        }
//    }
//    
//    func closeStories() {
//        service.needClose()
//    }
//    
//    func changeStatus(index: Int) {
//        service.changeStatusFor(story: index)
//    }
//    
//    func resetStories() {
//        service.closeStoriesIfNeed()
//    }
//    
//    func setConfiguration() {
//        configuration = StoriesPlayerConfiguration(storiesCount: stories.count)
//    }
//    
//    func createTimer() {
//        if let configuration {
//            timer = Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common)
//        }
//    }
//    
//    func timerTick() {
//        guard isReady else { return }
//        guard let config = configuration else { return }
//        
//        var nextProgress = progress + config.progressPerTick
//        
//        if nextProgress >= 1 {
//            nextProgress = 0
//            if currentStoryGlobalIndex < stories.count - 1 {
//                changeStatus(index: currentStoryGlobalIndex)
//                currentStoryGlobalIndex += 1
//            } else {
//                changeStatus(index: currentStoryGlobalIndex)
//                closeStories()
//            }
//        }
//        withAnimation {
//            progress = nextProgress
//        }
//    }
//    
//    func resetTimer() {
//        cancellable?.cancel()
//        createTimer()
//        cancellable = timer?.connect()
//    }
//}
//
