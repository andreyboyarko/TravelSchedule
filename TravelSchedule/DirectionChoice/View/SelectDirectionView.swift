import SwiftUI

struct SelectDirectionView: View {
    
    private let mainViewHeight: CGFloat = 128
    
    var viewModel: SelectCityViewModel
    
    @Binding var navigationPath: NavigationPath
    @Binding var activeDirection: DirectionType?
    
    @State private var topButtonTitle   = "Откуда"
    @State private var bottomButtonTitle = "Куда"
    
    var body: some View {
        ZStack {
            HStack(spacing: 22) {
                Spacer()
                
                VStack(spacing: 0) {
                    originButton
                    destinationButton
                }
                .frame(height: mainViewHeight * 0.8)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                
                // Кнопка смены направлений
                Button {
                    viewModel.swapDirections()
                } label: {
                    Image("ChangeImage")
                        .resizable()
                        .frame(width: 36, height: 36)
                }
                
                Spacer()
            }
            .frame(maxHeight: mainViewHeight)
            .frame(maxWidth: .infinity)
            .background(Color.blueUniversal)
            .cornerRadius(20)
            .padding()
        }
        .onChange(of: viewModel.finalDirectionFrom) { _, newValue in
            topButtonTitle = newValue ?? "Откуда"
        }
        .onChange(of: viewModel.finalDirectionTo) { _, newValue in
            bottomButtonTitle = newValue ?? "Куда"
        }
    }
    
    // MARK: - Кнопки
    
    private var originButton: some View {
        Button {
            viewModel.needCityArray()
            activeDirection = .from
            navigationPath.append(DirectionType.from)
        } label: {
            let isPlaceholder = (topButtonTitle == "Откуда")
            
            Text(isPlaceholder ? "Откуда" : topButtonTitle)
                .font(.custom("SFPro-Regular", size: 17))
                .foregroundColor(isPlaceholder ? .grayUniversal : .appBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.leading, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .contentShape(Rectangle())
    }
    
    private var destinationButton: some View {
        Button {
            viewModel.needCityArray()
            activeDirection = .to
            navigationPath.append(DirectionType.to)
        } label: {
            let isPlaceholder = (bottomButtonTitle == "Куда")
            
            Text(isPlaceholder ? "Куда" : bottomButtonTitle)
                .font(.custom("SFPro-Regular", size: 17))
                .foregroundColor(isPlaceholder ? .grayUniversal : .appBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.leading, 16)
        .padding(.vertical, 13)
        .background(Color.white)
        .contentShape(Rectangle())
    }
}
