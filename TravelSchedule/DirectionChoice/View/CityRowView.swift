

import SwiftUI

import SwiftUI

struct CityRowView: View {
    
    @Binding var navigationPath: NavigationPath
    let place: SelectPlaceModel
    var viewModel: SelectCityViewModel
    
    var body: some View {
        HStack() {
            Text(place.cityName)
            Spacer()
            Button(action: {
                viewModel.setSelectedCity(place)
                navigationPath.append("SelectStation")
            }) {
                Image("NextButton")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .listRowSeparator(.hidden)
    }
}

