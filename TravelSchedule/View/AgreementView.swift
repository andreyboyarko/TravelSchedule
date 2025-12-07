

import SwiftUI

struct AgreementView:View {
    @Binding var hideTabBar: Bool
    
    var body: some View {
        VStack {
            Text(verbatim: PracticumOfferText.offerTitle)
                .font(.custom("SFPro-Regular", size: 24))
            ScrollView {
                Text(verbatim: PracticumOfferText.documentLink)
                    .font(.custom("SFPro-Regula", size: 17))
                Text("1. ТЕРМИНЫ")
                    .font(.custom("SFPro-Bold", size: 24))
                    .multilineTextAlignment(.leading)
                Text(verbatim: PracticumOfferText.definitions)
                .font(.custom("SFPro-Regula", size: 17))
            }
            .multilineTextAlignment(.leading)
            .padding()
        }
    }
}

