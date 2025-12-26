

import SwiftUI

struct ErrorView: View {
    
    let imageHeight: CGFloat = 230
    var viewModel: ErrorViewModel
    
    var body: some View {
        VStack {
            Spacer()
            if let imageName = viewModel.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageHeight, height: imageHeight)
                    .padding()
            }
            if let text = viewModel.text {
                Text(text)
                    .font(.custom("SFPro-Bold", size: 24))
            }
            Spacer()
        }
    }
}
