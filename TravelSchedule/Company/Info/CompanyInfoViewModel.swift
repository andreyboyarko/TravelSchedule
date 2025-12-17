import Observation
import Combine
import Foundation

/// ViewModel экрана CompanyInfoView.
/// Получает детали перевозчика из DirectionsService и отдает их во View.
@MainActor
@Observable
final class CompanyInfoViewModel {

    // MARK: - Published (Observable) state

    /// Данные для отображения на экране (логотип, имя, почта, телефон, код).
    var infoCompany: CompanyInfoModel?

    /// Модель выбранной компании (передается из CompanyListViewModel / списка).
    var companyDetail: CompanyModel?

    // MARK: - Private

    /// Сервис, который публикует подробности перевозчика.
    private let service: DirectionsService

    /// Хранилище подписок Combine.
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(service: DirectionsService) {
        self.service = service
        setupSubscriptions()
    }

    // MARK: - Subscriptions

    /// Подписываемся на обновления деталей компании из сервиса.
    private func setupSubscriptions() {
        service.companyDetailPublisher
            .sink { [weak self] newState in
                // Если сервис прислал nil — не перетираем уже отображаемые данные.
                guard let newState else { return }
                self?.infoCompany = newState
            }
            .store(in: &cancellables)
    }

    // MARK: - Public API

    /// Сохраняем выбранную компанию, чтобы потом запросить по ней детали (если нужно).
    func set(detail: CompanyModel) {
        companyDetail = detail
    }
}
