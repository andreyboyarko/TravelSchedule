//import SwiftUI
//import Combine
//
//struct StoriesViewerView: View {
//    
//    // MARK: - Properties
//
//    var viewModel: StoriesLentViewModel
//    @State private var timer: Timer.TimerPublisher?
//    @State private var cancellable: Cancellable?
//    
//    // MARK: - Body
//
//    var body: some View {
//        ZStack(alignment: .topTrailing) {
//            StoryView(story: viewModel.currentStory)
//                .allowsHitTesting(true)
//            
//            ProgressBar(numberOfSections: viewModel.numberOfSections,
//                        progress: viewModel.progress)
//            .padding(.init(top: 28, leading: 12, bottom: 12, trailing: 12))
//            
//            tapZone
//            CloseButton(action: { viewModel.closeStories() })
//                .padding(.top, 57)
//                .padding(.trailing, 12)
//        }
//        .onAppear {
//            viewModel.setConfiguration()
//            viewModel.createTimer()
//            timer = viewModel.timer
//            cancellable = timer?.connect()
//            
//            if timer == nil {
//                timer = Timer.publish(every: 0.1, on: .main, in: .common)
//                cancellable = timer?.connect()
//            }
//        }
//        .onDisappear {
//            cancellable?.cancel()
//            cancellable = nil
//            viewModel.resetStories()
//        }
//        .onReceive(timer?.autoconnect() ?? Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
//            viewModel.timerTick()
//        }
//    }
//    
//    // MARK: - Subviews
//
//    private var tapZone: some View {
//        HStack(spacing: 0) {
//            Rectangle()
//                .fill(Color.clear)
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    viewModel.prevStory()
//                    viewModel.resetTimer()
//                }
//            Rectangle()
//                .fill(Color.clear)
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    viewModel.nextStory()
//                    viewModel.resetTimer()
//                }
//        }
//    }
//}


import SwiftUI
import Combine

struct StoriesViewerView: View {

    // MARK: - Properties

    var viewModel: StoriesLentViewModel

    @State private var timer: Timer.TimerPublisher?
    @State private var cancellable: Cancellable?

    @State private var dragOffset: CGFloat = 0

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topTrailing) {

                Color.black.ignoresSafeArea()

                // ✅ 3 слоя: prev / current / next
                ZStack {
                    if let prev = viewModel.prevGroupPreviewStory {
                        StoryView(story: prev)
                            .offset(x: -geo.size.width + dragOffset)
                    }

                    StoryView(story: viewModel.currentStory)
                        .offset(x: dragOffset)

                    if let next = viewModel.nextGroupPreviewStory {
                        StoryView(story: next)
                            .offset(x: geo.size.width + dragOffset)
                    }
                }

                ProgressBar(
                    numberOfSections: viewModel.numberOfSections,
                    progress: viewModel.progress
                )
                .padding(.init(top: 28, leading: 12, bottom: 12, trailing: 12))

                tapZone // ✅ оставляем тап как раньше

                CloseButton(action: { viewModel.closeStories() })
                    .padding(.top, 57)
                    .padding(.trailing, 12)
            }
            .contentShape(Rectangle())
            .highPriorityGesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { value in
                        let width = geo.size.width
                        let raw = value.translation.width
                        // ограничиваем, чтобы не “улетало”
                        dragOffset = max(-width, min(width, raw))
                    }
                    .onEnded { value in
                        let width = geo.size.width
                        let dx = value.translation.width
                        let threshold = width * 0.2 // ✅ меньше, чтобы “маленьким” свайпом работало

                        // свайп влево → next group
                        if dx < -threshold, viewModel.hasNextGroup {
                            withAnimation(.easeOut(duration: 0.18)) {
                                dragOffset = -width
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                                viewModel.goToNextGroup()
                                viewModel.resetTimer()
                                dragOffset = 0
                            }

                        // свайп вправо → prev group
                        } else if dx > threshold, viewModel.hasPrevGroup {
                            withAnimation(.easeOut(duration: 0.18)) {
                                dragOffset = width
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                                viewModel.goToPrevGroup()
                                viewModel.resetTimer()
                                dragOffset = 0
                            }

                        } else {
                            // не дотянули — вернули назад
                            withAnimation(.easeOut(duration: 0.18)) {
                                dragOffset = 0
                            }
                        }
                    }
            )
        }
        .onAppear {
            viewModel.setConfiguration()
            viewModel.createTimer()
            timer = viewModel.timer
            cancellable = timer?.connect()

            if timer == nil {
                timer = Timer.publish(every: 0.1, on: .main, in: .common)
                cancellable = timer?.connect()
            }
        }
        .onDisappear {
            cancellable?.cancel()
            cancellable = nil
            viewModel.resetStories()
        }
        .onReceive(
            timer?.autoconnect()
            ?? Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        ) { _ in
            viewModel.timerTick()
        }
    }

    // MARK: - Tap Zone

    private var tapZone: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.prevStory()
                    viewModel.resetTimer()
                }

            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.nextStory()
                    viewModel.resetTimer()
                }
        }
    }
}
