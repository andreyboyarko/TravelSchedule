
import SwiftUI

@Observable
final class StoriesVM {
    var mainImageViewArray: [StoryItemModel]?
    var lentDictionary: StoriesBatchModel?
    var isCloseStories: Bool = false

    private let model = StoriesDataProvider()

    var actualStory: [[Story]]?
    var actualNumber: Int?

    init() {}

    // MARK: - Инициализация данных

    func createMainImageLent() {
        if mainImageViewArray == nil {
            mainImageViewArray = model.mainImageViewArray
        }
    }

    func createDetailImageLent() {
        lentDictionary = model.returnImageLent()
    }

    func createStoryArray(number: String) {
        let num = Int(number) ?? 0
        actualStory = model.convertToStory(number: num)
        actualNumber = num
    }

    // MARK: - Управление лентой

    /// Сигнал на закрытие сторис
    func needClose() {
        if !isCloseStories {
            isCloseStories = true
        }
    }

    /// Подгрузить предыдущую «глобальную» историю, если есть, иначе закрыть ленту
    func needUpdateActualStory(globalNumber: Int) {
        guard let num = actualNumber else { return }

        if num - 1 > 0 {
            createStoryArray(number: String(num - 1))
        } else {
            needClose()
        }
    }

    /// Обновить рамку у просмотренной истории
    func changeStatusAFor(story: Int) {
        mainImageViewArray = mainImageViewArray?.map { storyModel in
            storyModel.image == String(story + (actualNumber ?? 0))
                ? StoryItemModel(image: storyModel.image, borderStatus: false)
                : storyModel
        }
    }
}
