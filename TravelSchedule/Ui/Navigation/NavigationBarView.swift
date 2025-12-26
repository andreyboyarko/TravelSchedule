

import SwiftUI

struct NavigationBarView: View {
    let title: String
    let backAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: backAction) {
                HStack {
                    Image("LeftChevron")
                        .padding(.horizontal, -30)
                }
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
            }
            
            Spacer()
            Text(title)
                .font(.custom("SFPro-Bold", size: 17))
            Spacer()
            Rectangle()
                .fill(Color.clear)
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal)
        .frame(height: 44)
        .background(Color.appBackground)
    }
}

