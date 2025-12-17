
import SwiftUI

struct StationRowView: View {
    @Binding var navigationPath: NavigationPath
    
    let station: SelectStationModel
    var viewModel: SelectStationViewModel
    
    var body: some View {
        HStack() {
            Text(station.nameOfStation)
            Spacer()
            Button(action: {
                viewModel.setStation(with: station)
                viewModel.tryContainsDestination()
                viewModel.tryActiveIfAdds()
                navigationPath = NavigationPath()
            }) {
                Image("NextButton")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
    }
}
