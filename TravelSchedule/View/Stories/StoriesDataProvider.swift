

import SwiftUI

struct StoriesDataProvider {
    
    // MARK: - Properties

    let mainImageViewArray = StoriesDataProvider.mainImageViewArray
    let mocksLentDictionary = StoriesDataProvider.mocksLentDictionary
    
    // MARK: - Methods

    func returnImageLent() -> StoriesBatchModel {
        StoriesBatchModel(imageArray: mocksLentDictionary)
    }
    
    func convertToStory(number: Int) -> [[Story]] {
        var storyArray = [[Story]]()
        var stringMassive = [[String]]()
        
        let sortedMocksDictionary = mocksLentDictionary.sorted(by: { $1.key > $0.key })
        
        for i in sortedMocksDictionary {
            if i.key >= number {
                stringMassive.append(i.value)
            }
        }
        
        for j in stringMassive {
            storyArray.append(j.map { Story(image: $0)})
        }
        
        return storyArray
    }
}
