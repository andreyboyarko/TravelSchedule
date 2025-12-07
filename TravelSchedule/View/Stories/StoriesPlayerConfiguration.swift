

import Foundation

struct StoriesPlayerConfiguration {
    let timerTickInternal: TimeInterval
    let progressPerTick: CGFloat
    
    init(
        storiesCount: Int,
        secondsPerStory: TimeInterval = 10,
        timerTickInternal: TimeInterval = 0.05
    ) {
        self.timerTickInternal = timerTickInternal
        self.progressPerTick = 1.0 / CGFloat(storiesCount) / secondsPerStory * timerTickInternal
    }
}

