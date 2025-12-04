

import SwiftUI

struct CompanyCellView : View {
    
    @Binding var navigationPath: NavigationPath
    
    let image: String
    let nameOfCompany: String
    let needSwapStation: Bool
    let swapStation: String?
    let date: String
    let allTimePath: String
    let timeToStart: String
    let timeToOver: String
    
    var body: some View {
        VStack {
            HStack {
                Image(image)
                    .frame(width:38, height: 38)
                VStack {
                    HStack {
                        Text(nameOfCompany)
                            .font(.custom("SFPro-Regula", size: 17))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(date)
                            .font(.custom("SFPro-Regula", size: 12))
                    }
                    .foregroundColor(.appBlack)
                    
                    if needSwapStation && swapStation != nil {
                        Text("C пересадкой в " + (swapStation ?? ""))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.red)
                            .font(.custom("SFPro-Regula", size: 12))
                    } else {
                        EmptyView()
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 4)
            HStack {
                Text(timeToStart)
                    .font(.custom("SFPro-Regula", size: 17))
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                Text(allTimePath)
                    .font(.custom("SFPro-Regula", size: 12))
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                Text(timeToOver)
                    .font(.custom("SFPro-Regula", size: 17))
            }
            .foregroundColor(.appBlack)
            .padding(.horizontal)
            .padding(.top, 4)
            .padding(.bottom, 12)
        }
        .background(Color.lightGray)
        .cornerRadius(24)
        .onTapGesture {
            navigationPath.append("CompanyDetail")
        }
    }
}
