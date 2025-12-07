

import SwiftUI
import Combine

struct StoriesViewerView: View {

    private let stories: [[Story]]
    private var viewModel: StoriesVM
    private let configuration: StoriesPlayerConfiguration

    // выбранная история
    private var currentStory: Story {
        let global = clamp(currentStoryGlobalIndex, min: 0, max: stories.count - 1)
        let count = stories[global].count
        let index = clamp(currentStoryIndex, min: 0, max: count - 1)
        return stories[global][index]
    }

    // номер выбранной истории внутри текущей группы
    private var currentStoryIndex: Int {
        let count = stories[currentStoryGlobalIndex].count
        if count == 0 { return 0 }
        let rawIndex = Int(progress * CGFloat(count))
        return clamp(rawIndex, min: 0, max: count - 1)
    }

    @State private var currentStoryGlobalIndex: Int = 0 // индекс группы историй

    @State private var progress: CGFloat = 0
    @State private var timer: Timer.TimerPublisher
    @State private var cancellable: Cancellable?

    init(stories: [[Story]], viewModel: StoriesVM) {
        self.stories = stories
        self.viewModel = viewModel
        self.configuration = StoriesPlayerConfiguration(storiesCount: stories.count)
        self.timer = Self.createTimer(configuration: configuration)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            StoryView(story: currentStory)
                .allowsHitTesting(true)

            ProgressBar(
                numberOfSections: stories[currentStoryGlobalIndex].count,
                progress: progress
            )
            .padding(.init(top: 28, leading: 12, bottom: 12, trailing: 12))

            tapZone

            CloseButton(action: {
                viewModel.needClose()
            })
            .padding(.top, 57)
            .padding(.trailing, 12)
        }
        .onAppear {
            timer = Self.createTimer(configuration: configuration)
            cancellable = timer.connect()
        }
        .onDisappear {
            cancellable?.cancel()
        }
        .onReceive(timer) { _ in
            timerTick()
        }
    }

    // MARK: - Tap зоны

    private var tapZone: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    prevStory()
                    resetTimer()
                }

            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    nextStory()
                    resetTimer()
                }
        }
    }

    // MARK: - Логика таймера

    private func timerTick() {
        var nextProgress = progress + configuration.progressPerTick

        if nextProgress >= 1 {
            nextProgress = 0

            if currentStoryGlobalIndex < stories.count - 1 {
                viewModel.changeStatusAFor(story: currentStoryGlobalIndex)
                currentStoryGlobalIndex += 1
            } else {
                viewModel.changeStatusAFor(story: currentStoryGlobalIndex)
                viewModel.needClose()
            }
        }

        withAnimation {
            progress = nextProgress
        }
    }

    private func nextStory() {
        let storiesCount = stories[currentStoryGlobalIndex].count
        guard storiesCount > 0 else { return }

        let currentIndex = currentStoryIndex
        let nextIndex = currentIndex + 1 < storiesCount ? currentIndex + 1 : 0

        if nextIndex == 0 && currentIndex != 0 && currentStoryGlobalIndex < stories.count - 1 {
            viewModel.changeStatusAFor(story: currentStoryGlobalIndex)
            currentStoryGlobalIndex += 1
        } else if nextIndex == 0 && currentIndex != 0 && currentStoryGlobalIndex == stories.count - 1 {
            viewModel.changeStatusAFor(story: currentStoryGlobalIndex)
            viewModel.needClose()
        } else if currentStoryGlobalIndex + 1 >= stories.count - 1 && storiesCount == 1 {
            viewModel.changeStatusAFor(story: currentStoryGlobalIndex)
            viewModel.needClose()
        }

        withAnimation {
            progress = CGFloat(nextIndex) / CGFloat(storiesCount)
        }
    }

    private func prevStory() {
        let storiesCount = stories[currentStoryGlobalIndex].count
        guard storiesCount > 0 else { return }

        let currentIndex = currentStoryIndex
        let prevIndex = currentIndex - 1 > 0 ? currentIndex - 1 : 0

        withAnimation {
            progress = CGFloat(prevIndex) / CGFloat(storiesCount)
        }

        if currentIndex > 0 {
            // просто откатываем прогресс назад
        } else if currentIndex <= 0 && currentStoryGlobalIndex > 0 {
            currentStoryGlobalIndex -= 1
        } else if currentIndex == 0 && currentStoryGlobalIndex == 0 {
            viewModel.needUpdateActualStory(globalNumber: currentStoryGlobalIndex)
        }
    }

    private func resetTimer() {
        cancellable?.cancel()
        timer = Self.createTimer(configuration: configuration)
        cancellable = timer.connect()
    }

    private static func createTimer(configuration: StoriesPlayerConfiguration) -> Timer.TimerPublisher {
        Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common)
    }

    // MARK: - Утилита

    private func clamp(_ value: Int, min: Int, max: Int) -> Int {
        Swift.max(min, Swift.min(max, value))
    }
}
