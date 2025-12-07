

import SwiftUI

struct StoriesPlayerView: View {
    
    @Binding var hideTabBar: Bool
    @Binding var navigationPath: NavigationPath
    var viewModel: StoriesVM
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(.horizontal) {
                lentWithStories
            }
            .frame(maxHeight: 160)
            .scrollIndicators(.hidden)
            .onAppear {
                viewModel.createMainImageLent()
                viewModel.createDetailImageLent()
            }
            .onChange(of: viewModel.isCloseStories) { oldValue, newValue in
                if newValue {
                    navigationPath.removeLast()
                    viewModel.isCloseStories.toggle()
                }
            }
        }
    }
    
    private var lentWithStories: some View {
        LazyHStack(spacing: 10) {
            
            if let imageArray = viewModel.mainImageViewArray {
                ForEach(imageArray, id: \.self) { imageName in
                    StoryPreviewView( borderStatus: imageName.borderStatus,
                                     imageName: imageName.image)
                    .onTapGesture {
                        viewModel.createStoryArray(number: imageName.image)
                        navigationPath.append("Stories")
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

