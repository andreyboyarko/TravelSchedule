

import SwiftUI

struct ErrorStateView: View {
    
    let imageHeight: CGFloat = 230
    let imageName: String
    let text: String
    
    var body: some View {
        VStack {
            Spacer()
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: imageHeight, height: imageHeight)
                .padding()
            Text(text)
                .font(.custom("SFPro-Bold", size: 24))
            Spacer()
        }
    }
}

