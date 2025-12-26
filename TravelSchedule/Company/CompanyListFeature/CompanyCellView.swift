

import SwiftUI

/// Ячейка списка перевозчиков/рейсов.
/// Показывает логотип, название компании, дату, (опционально) информацию о пересадке
/// и нижнюю строку с временем отправления/прибытия и длительностью пути.
struct CompanyCellView: View {

    // MARK: - Properties

    /// Навигационный путь `NavigationStack`.
    /// При тапе на ячейку добавляем маршрут и переходим на экран деталей.
    @Binding var navigationPath: NavigationPath

    /// ViewModel экрана деталей компании.
    /// Сюда сохраняем выбранную компанию перед навигацией.
    let viewModel: CompanyInfoViewModel

    /// Модель компании/рейса, которую отображаем в этой ячейке.
    let companyModel: CompanyModel

    // MARK: - Body

    var body: some View {
        VStack {
            HStack {
                logo
                topLine
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 4)

            downLine
        }
        .background(.lightGray)
        .cornerRadius(24)
        .onTapGesture {
            // 1) Передаём выбранную модель в VM,
            // чтобы экран деталей знал, что показывать.
            viewModel.set(detail: companyModel)

            // 2) Переходим на экран деталей.
            navigationPath.append("CompanyDetail")
        }
    }

    // MARK: - Subviews

    /// Логотип перевозчика.
    /// Загружается асинхронно по URL. В placeholder — белый квадратик.
    private var logo: some View {
        AsyncImage(url: URL(string: companyModel.image)) { image in
            ZStack {
                // Белая подложка под лого (как "карточка")
                Color.white
                    .frame(width: 38, height: 38)
                    .cornerRadius(12)

                // Само изображение логотипа
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
            }
            .frame(width: 38, height: 38)
            .cornerRadius(12)
        } placeholder: {
            // Пока грузится — показываем белую подложку, чтобы верстка не прыгала
            ZStack {
                Color.white
                    .frame(width: 38, height: 38)
                    .cornerRadius(12)
            }
            .frame(width: 38, height: 38)
            .cornerRadius(12)
        }
    }

    /// Верхняя строка карточки:
    /// - слева: название компании
    /// - справа: дата
    /// - ниже: (опционально) пересадка
    private var topLine: some View {
        VStack {
            HStack {
                Text(companyModel.companyName)

                    .font(.custom("SFPro-Regula", size: 17))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(companyModel.date)
                    .font(.custom("SFPro-Regula", size: 12))
            }
            .foregroundColor(.appBlack)

            // Если нужна пересадка и известна станция пересадки — показываем строку
            if companyModel.needSwapStation && companyModel.swapStation != nil {
                Text("C пересадкой в " + (companyModel.swapStation ?? ""))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.red)
                    .font(.custom("SFPro-Regula", size: 12))
            } else {
                // Иначе ничего не рисуем
                EmptyView()
            }
        }
    }

    /// Нижняя строка карточки:
    /// время отправления — линия — длительность пути — линия — время прибытия.
    private var downLine: some View {
        HStack {
            Text(companyModel.timeToStart)
                .font(.custom("SFPro-Regula", size: 17))

            // Разделитель
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)

            Text(companyModel.allTimePath)
                .font(.custom("SFPro-Regula", size: 12))

            // Разделитель
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)

            Text(companyModel.timeToOver)
                .font(.custom("SFPro-Regula", size: 17))
        }
        .foregroundColor(.appBlack)
        .padding(.horizontal)
        .padding(.top, 4)
        .padding(.bottom, 12)
    }
}
