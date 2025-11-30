
import SwiftUI

/// Горизонтальная лента сторис
struct StoriesFeedView: View {
    
    /// Массив имён картинок для сторис
    let imageViewArray = ["1", "2", "3", "4", "5"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                
                // Отображаем каждую ячейку
                ForEach(imageViewArray, id: \.self) { imageName in
                    StoryCellView(imageName: imageName)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 160)    // Чёткая фиксированная высота
    }
}
