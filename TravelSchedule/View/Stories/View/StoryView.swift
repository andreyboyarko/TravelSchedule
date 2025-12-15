

import SwiftUI

struct StoryView: View {
    let story: Story
    
    var body: some View {
        ZStack {
            Color.appBlack
                .ignoresSafeArea()
            Image(story.image)
                .resizable()
                .cornerRadius(40)
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    Text(story.title)
                        .font(.custom("SFPro-Bold", size: 34))
                        .foregroundColor(.white)
                    Text(story.description)
                        .font(.custom("SFPro-Regular", size: 20))
                        .lineLimit(3)
                        .foregroundColor(.white)
                }
            }
            .padding(.init(top: 0, leading: 16, bottom: 40, trailing: 16))
        }
    }
}

