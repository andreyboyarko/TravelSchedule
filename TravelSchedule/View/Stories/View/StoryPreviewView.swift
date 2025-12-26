import SwiftUI

struct StoryPreviewView: View {
    
    // MARK: - Properties
    
    let storiesType: StoryItemModel
    let textForImage = "Text Text Text Text Text Text Text Text Text"
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            image
            text
        }
    }
    
    // MARK: - Subviews

    private var text: some View {
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
    
    private var image: some View {
        Image(storiesType.image)
            .resizable()
            .scaledToFill()
            .frame(width: .mainStoriesWidth, height: .mainStoriesHeight)
            .cornerRadius(12)
            .opacity(storiesType.borderStatus ? 1 : 0.5)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(storiesType.borderStatus ? Color.appBlue : Color.clear, lineWidth: 4)
            )
    }
}
