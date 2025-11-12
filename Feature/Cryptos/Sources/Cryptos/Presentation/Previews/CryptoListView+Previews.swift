import SwiftUI

// MARK: - CryptoListView Previews

#Preview("Loading State") {
    @Previewable @State var viewModel = CryptoListViewPreviewHelper.loadingViewModel()
    @Previewable @State var coordinator = CryptoCoordinator()
    return CryptoListView(viewModel: viewModel, coordinator: coordinator)
}

#Preview("Success State") {
    @Previewable @State var viewModel = CryptoListViewPreviewHelper.successViewModel()
    @Previewable @State var coordinator = CryptoCoordinator()
    return CryptoListView(viewModel: viewModel, coordinator: coordinator)
}

#Preview("Error State") {
    @Previewable @State var viewModel = CryptoListViewPreviewHelper.errorViewModel()
    @Previewable @State var coordinator = CryptoCoordinator()
    return CryptoListView(viewModel: viewModel, coordinator: coordinator)
}

// MARK: - Preview Helper

/// Helper for creating CryptoListViewModel instances with different states for previews
enum CryptoListViewPreviewHelper {
    @MainActor
    static func loadingViewModel() -> CryptoListViewModel {
        let mockService = MockCryptoService(shouldSucceed: true, delay: 100)
        let useCase = GetTopCryptosUseCase(service: mockService)
        return CryptoListViewModel(getTopCryptosUseCase: useCase)
    }

    @MainActor
    static func successViewModel() -> CryptoListViewModel {
        let mockService = MockCryptoService(shouldSucceed: true, delay: 0)
        let useCase = GetTopCryptosUseCase(service: mockService)
        let viewModel = CryptoListViewModel(getTopCryptosUseCase: useCase)

        // Pre-populate with mock data for preview
        viewModel.cryptocurrencies = MockCryptoData.all
        viewModel.lastUpdated = Date()

        return viewModel
    }

    @MainActor
    static func errorViewModel() -> CryptoListViewModel {
        let mockService = MockCryptoService(shouldSucceed: false, delay: 0)
        let useCase = GetTopCryptosUseCase(service: mockService)
        let viewModel = CryptoListViewModel(getTopCryptosUseCase: useCase)

        // Pre-populate with error for preview
        viewModel.errorMessage = "Failed to fetch cryptocurrencies. Please check your connection and try again."

        return viewModel
    }
}
