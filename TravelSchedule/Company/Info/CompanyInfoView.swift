import SwiftUI

/// Экран с детальной информацией о перевозчике (логотип, название, контакты).
struct CompanyInfoView: View {
    
    // MARK: - Properties
    
    /// ViewModel, которая содержит данные о выбранной компании и ее контактах.
    var viewModel: CompanyInfoViewModel
    
    /// ViewModel списка компаний — используется, чтобы сохранить выбранную компанию
    /// и управлять состояниями ошибок/алертов.
    var companyListViewModel: CompanyListViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Фон экрана
            Color.background.ignoresSafeArea()
            
            // Основное содержимое
            contentView
        }
        .task {
            // При появлении экрана (или при пересчёте body) пробуем сохранить выбранную компанию
            // в CompanyListViewModel, если данные уже есть.
            if let companyModel = viewModel.companyDetail {
                await companyListViewModel.setSelectCompany(detail: companyModel)
            }
        }
    }
    
    // MARK: - Subviews
    
    /// Контент, который показывает либо данные, либо экран ошибки.
    private var contentView: some View {
        VStack {
            // Нормальный сценарий: нет алерта и нет ошибки
            if !companyListViewModel.needToShowAlert && !companyListViewModel.needToShowErrorView {
                VStack {
                    logo
                    companyName
                    contactDetail
                    Spacer()
                }
                
            // Ошибка "нет интернета"
            } else if companyListViewModel.needToShowAlert {
                ErrorView(viewModel: ErrorViewModel(actualStatus: .NoInternetConnection))
                
            // Ошибка "сервер"
            } else {
                ErrorView(viewModel: ErrorViewModel(actualStatus: .ServerError))
            }
        }
    }
    
    /// Блок с большим логотипом компании.
    private var logo: some View {
        VStack {
            if let bigLogo = viewModel.infoCompany?.bigLogoName {
                ZStack {
                    Color.white
                        .frame(height: 100)
                        .cornerRadius(24)
                    
                    // Загрузка логотипа по URL
                    AsyncImage(url: URL(string: bigLogo)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 100, alignment: .trailing)
                    } placeholder: {
                        // Плейсхолдер, пока картинка грузится
                        Color.white
                    }
                }
                .frame(height: 100, alignment: .center)
                .cornerRadius(24)
                .padding(.top)
                .padding(.horizontal)
            }
        }
    }
    
    /// Полное название компании.
    private var companyName: some View {
        VStack(alignment: .leading) {
            if let fullCompanyName = viewModel.infoCompany?.fullCompanyName {
                Text(fullCompanyName)
                    .font(.custom("SFPro-Bold", size: 24))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    /// Контактные данные: email и телефон.
    private var contactDetail: some View {
        VStack(alignment: .leading) {
            
            Text("E-mail")
                .font(.custom("SFPro-Regular", size: 17))
            
            if let email = viewModel.infoCompany?.email {
                VStack {
                    // Если email пустой — показываем заглушку
                    if email.isEmpty {
                        Text("cargo@email.ru")
                    } else {
                        Text(email)
                    }
                }
                .font(.custom("SFPro-Regular", size: 12))
                .foregroundColor(.appBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
            }
            
            Text("Телефон")
                .font(.custom("SFPro-Regular", size: 17))
            
            if let phone = viewModel.infoCompany?.phone {
                Text(phone)
                    .font(.custom("SFPro-Regular", size: 12))
                    .foregroundColor(.appBlue)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}
