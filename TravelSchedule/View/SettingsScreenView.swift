

import SwiftUI

struct SettingsScreenView: View {
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
//            Text("Экран настроек")
//                .font(.custom("SFPro-Bold", size: 17))
            ErrorStateView(imageName: "NoInternetError", text: "Нет интернета")
//            ErrorStateView(imageName: "ServerError", text: "Ошибка сервера")
        }
    }
}

