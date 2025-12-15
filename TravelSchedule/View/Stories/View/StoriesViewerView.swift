
import SwiftUI
import Combine

struct StoriesViewerView: View {
    
    private let stories: [[Story]]
    private var viewModel: StoriesVM
    private let configuration: StoriesPlayerConfiguration

    // текущая история в текущей группе
    private var currentStory: Story {
        let g = clamp(currentStoryGlobalIndex, min: 0, max: stories.count - 1)
        let group = stories[g]
        if group.isEmpty { return Story(image: "") } // 👈 так, без title/description
        let idx = clamp(currentStoryIndex, min: 0, max: group.count - 1)
        return group[idx]
    }

    // индекс истории внутри текущей группы
    private var currentStoryIndex: Int {
        let count = stories[currentStoryGlobalIndex].count
        if count == 0 { return 0 }
        let rawIndex = Int(progress * CGFloat(count))
        return clamp(rawIndex, min: 0, max: count - 1)
    }

    @State private var currentStoryGlobalIndex: Int = 0
    @State private var progress: CGFloat = 0
    @State private var timer: Timer.TimerPublisher
    @State private var cancellable: Cancellable?

    // сдвиг всех сторис при свайпе
    @State private var dragOffset: CGFloat = 0

    init(stories: [[Story]], viewModel: StoriesVM) {
        self.stories = stories
        self.viewModel = viewModel
        self.configuration = StoriesPlayerConfiguration(storiesCount: stories.count)
        self.timer = Self.createTimer(configuration: configuration)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topTrailing) {
                Color.black.ignoresSafeArea()

                // --- СТЕК СТОРИС: предыдущая + текущая + следующая ---
                ZStack {
                    // предыдущая группа (слева)
                    if currentStoryGlobalIndex > 0 {
                        let prevIndex = currentStoryGlobalIndex - 1
                        let prevStory = stories[prevIndex].first ?? currentStory
                        StoryView(story: prevStory)
                            .offset(x: -geo.size.width + dragOffset)
                            .zIndex(0)
                    }

                    // текущая группа
                    StoryView(story: currentStory)
                        .offset(x: dragOffset)
                        .zIndex(1)

                    // следующая группа (справа)
                    if currentStoryGlobalIndex < stories.count - 1 {
                        let nextIndex = currentStoryGlobalIndex + 1
                        let nextStory = stories[nextIndex].first ?? currentStory
                        StoryView(story: nextStory)
                            .offset(x: geo.size.width + dragOffset)
                            .zIndex(0)
                    }
                }

                // прогресс
                ProgressBar(
                    numberOfSections: stories[currentStoryGlobalIndex].count,
                    progress: progress
                )
                .padding(.init(top: 28, leading: 12, bottom: 12, trailing: 12))

                // тап-зоны как раньше
                tapZone

                // крестик
                CloseButton(action: {
                    viewModel.needClose()
                })
                .padding(.top, 57)
                .padding(.trailing, 12)
            }
            .contentShape(Rectangle())
            .highPriorityGesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { value in
                        // ограничиваем движение, чтобы не уезжало дальше ширины экрана
                        let width = geo.size.width
                        let raw = value.translation.width
                        dragOffset = max(-width, min(width, raw))
                    }
                    .onEnded { value in
                        let dx = value.translation.width
                        let width = geo.size.width
                        let swipeThreshold: CGFloat = width * 0.25  // примерно четверть экрана

                        // свайп влево → следующая группа
                        if dx < -swipeThreshold,
                           currentStoryGlobalIndex < stories.count - 1 {

                            withAnimation(.easeOut(duration: 0.2)) {
                                dragOffset = -width
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                currentStoryGlobalIndex += 1
                                progress = 0
                                dragOffset = 0
                                resetTimer()
                            }

                        // свайп вправо → предыдущая группа
                        } else if dx > swipeThreshold,
                                  currentStoryGlobalIndex > 0 {

                            withAnimation(.easeOut(duration: 0.2)) {
                                dragOffset = width
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                currentStoryGlobalIndex -= 1
                                progress = 0
                                dragOffset = 0
                                resetTimer()
                            }

                        } else {
                            // не дотянули — просто возвращаемся
                            withAnimation(.easeOut(duration: 0.2)) {
                                dragOffset = 0
                            }
                        }
                    }
            )
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

    // MARK: - ТАП: следующая / предыдущая сторис в группе

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
            // внутри группы
        } else if currentIndex <= 0 && currentStoryGlobalIndex > 0 {
            currentStoryGlobalIndex -= 1
        } else if currentIndex == 0 && currentStoryGlobalIndex == 0 {
            viewModel.needUpdateActualStory(globalNumber: currentStoryGlobalIndex)
        }
    }

    // MARK: - Таймер

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
