
import SwiftUI

struct AgreementView:View {
    
    @Binding var hideTabBar: Bool
    var viewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.userAgreement.namesOffer)
                .font(.custom("SFPro-Bold", size: 24))
            ScrollView {
                Text(viewModel.userAgreement.linkOfDocument)
                    .font(.custom("SFPro-Regula", size: 17))
                Text("1. ТЕРМИНЫ")
                    .font(.custom("SFPro-Bold", size: 24))
                    .multilineTextAlignment(.leading)
                Text(verbatim: viewModel.userAgreement.textDocument)
                .font(.custom("SFPro-Regula", size: 17))
            }
            .multilineTextAlignment(.leading)
            .padding()
        }
    }
}


