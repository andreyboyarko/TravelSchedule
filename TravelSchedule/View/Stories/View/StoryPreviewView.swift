import SwiftUI

struct StoryPreviewView: View {
    
    let borderStatus: Bool
    let imageName: String
    let textForImage = "Text Text Text Text Text Text Text Text Text"
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: .mainStoriesWidth, height: .mainStoriesHeight)
                .cornerRadius(12)
                .opacity(borderStatus ? 1 : 0.5)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderStatus ? Color.appBlue : Color.clear, lineWidth: 4)
                )
            
            VStack {
                Text(textForImage)
                    .font(.custom("SFPro-Regular", size: 12))
                    .foregroundStyle(.white)
                    .frame(alignment: .bottom)
                    .frame(width: .mainStoriesWidth * 0.8, height: .mainStoriesHeight, alignment: .bottom)
                    .lineLimit(3)
                Spacer()
                Spacer()
            }
            .frame(width: .mainStoriesWidth , height: .mainStoriesHeight)
        }
    }
}

