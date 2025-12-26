

import SwiftUI

struct ChooseDirectionView: View {
    
    // MARK: - Properties

    private let mainViewHeight: CGFloat = 128
    var chooseDirectionViewModel: SelectDirectionViewModel
    
    @Binding var navigationPath: NavigationPath
    
    @State private var topButtonTitle = DirectionType.from.rawValue
    @State private var bottomButtonTitle = DirectionType.to.rawValue
    @State private var isSwapped = false
    
    // MARK: - Body

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
                .background(.white)
                .cornerRadius(20)
                
                swapButton
                Spacer()
            }
            .frame(maxHeight: mainViewHeight)
            .frame(maxWidth: .infinity)
            .background(.blueUniversal)
            .cornerRadius(20)
            .padding()
        }
        .onChange(of:
                    chooseDirectionViewModel.finalDirectionFrom) { _, newValue in
            if let newCity = newValue {
                topButtonTitle = newCity
            } else {
                topButtonTitle = DirectionType.from.rawValue
            }
        }
                    .onChange(of:  chooseDirectionViewModel.finalDirectionTo) { _, newValue in
                        
                        if let newCity = newValue {
                            bottomButtonTitle = newCity
                        } else {
                            bottomButtonTitle = DirectionType.to.rawValue
                        }
                    }
                    .onAppear {
                        if let needClean = chooseDirectionViewModel.needCleanData, needClean == true {
                            chooseDirectionViewModel.needCleanSchedualList()
                        }
                    }
    }
    
    // MARK: - Subviews

    private var swapButton: some View {
        Button(action: {
            chooseDirectionViewModel.needSwapDirection()
            isSwapped.toggle()
        }) {
            Image("ChangeImage")
                .resizable()
                .frame(width: 36, height: 36)
        }
    }
    
    private var originButton: some View {
        Button(action: {
            chooseDirectionViewModel.set(direction: .from)
            navigationPath.append(DirectionType.from)
        }) {
            // Верхняя кнопка всегда показывает FROM направление
            if topButtonTitle == DirectionType.from.rawValue {
                Text("Откуда")
                    .font(.custom("SFPro-Regular", size: 17))
                    .foregroundColor(.grayUniversal)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text(topButtonTitle)
                    .font(.custom("SFPro-Regular", size: 17))
                    .foregroundColor(.appBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.leading, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .contentShape(Rectangle())
    }
    
    private var destinationButton: some View {
        Button(action: {
            chooseDirectionViewModel.set(direction: .to)
            navigationPath.append(DirectionType.to)
        }) {
            // Нижняя кнопка всегда показывает TO направление
            if bottomButtonTitle == DirectionType.to.rawValue {
                Text("Куда")
                    .font(.custom("SFPro-Regular", size: 17))
                    .foregroundColor(.grayUniversal)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text(bottomButtonTitle)
                    .font(.custom("SFPro-Regular", size: 17))
                    .foregroundColor(.appBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.leading, 16)
        .padding(.vertical, 13)
        .background(Color.white)
        .contentShape(Rectangle())
    }
}
