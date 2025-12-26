

import Foundation

/// Модель, отвечающая за получение списка компаний.
///
/// ⚠️ На текущий момент используется mock-реализация.
/// В будущем должна быть заменена на слой работы с API / репозиторием.
struct CompanyListModel {
    
    /// Моковый список компаний.
    /// Используется для разработки и тестирования UI без реального бэкенда.
    let mockCompanies: [CompanyModel] = CompanyModel.mockCompanies
    
    /// Возвращает список компаний для выбранного направления.
    ///
    /// - Parameters:
    ///   - from: Модель направления отправления
    ///   - to: Модель направления прибытия
    ///
    /// - Returns:
    ///   Массив `CompanyModel`, либо `nil`, если данные недоступны.
    ///
    /// ⚠️ В текущей реализации параметры `from` и `to`
    /// не используются и добавлены для будущей логики фильтрации.
    func returnCompany(
        from: DirectionModel,
        to: DirectionModel
    ) -> [CompanyModel]? {
        guard mockCompanies.isEmpty == false else { return nil }
        return mockCompanies
    }
}
