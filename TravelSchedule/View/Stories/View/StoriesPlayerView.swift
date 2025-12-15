import SwiftUI

struct StoriesPlayerView: View {
    
    @Binding var hideTabBar: Bool
    @Binding var navigationPath: NavigationPath
    @Bindable var viewModel: StoriesVM   // 👈 наблюдаемый VM
    
    var body: some View {
        ScrollView(.horizontal) {        // 👈 скролл на верхнем уровне
            lentWithStories
        }
        .frame(maxHeight: 160)
        .scrollIndicators(.hidden)
        .onAppear {
            viewModel.createMainImageLent()
            viewModel.createDetailImageLent()
        }
        .onChange(of: viewModel.isCloseStories) { _, newValue in
            if newValue {
                // безопасно закрываем сторис и сбрасываем флаг
                if !navigationPath.isEmpty {
                    navigationPath.removeLast()
                }
                viewModel.isCloseStories = false
            }
        }
    }
    
    private var lentWithStories: some View {
        LazyHStack(spacing: 10) {
            if let imageArray = viewModel.mainImageViewArray {
                ForEach(imageArray, id: \.self) { imageName in
                    StoryPreviewView(
                        borderStatus: imageName.borderStatus,
                        imageName: imageName.image
                    )
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
