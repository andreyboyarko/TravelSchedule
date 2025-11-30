import SwiftUI

/// Ячейка истории (story) — картинка с рамкой и текстом внизу
struct StoryCellView: View {
    
    let height: CGFloat = 140
    let width: CGFloat = 92
    
    let imageName: String
    let textForImage = "Text Text Text Text Text Text Text Text Text"
    
    var body: some View {
        ZStack {
            // Фоновое изображение
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 4)
                )
            
            // Текст поверх изображения
            VStack {
                Spacer() // Поднимает текст вниз
                
                Text(textForImage)
                    .font(.custom("SFPro-Regular", size: 12))
                    .foregroundColor(.white)
                    .frame(width: width * 0.8, alignment: .bottom)
                    .lineLimit(3)
            }
            .frame(width: width, height: height)
        }
    }
}
