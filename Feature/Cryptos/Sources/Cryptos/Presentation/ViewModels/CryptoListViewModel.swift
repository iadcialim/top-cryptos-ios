import Foundation
import SwiftUI

/// ViewModel for the Crypto list view
/// Manages UI state and coordinates with use cases
@MainActor
@Observable
public final class CryptoListViewModel {
    private let getTopCryptosUseCase: GetTopCryptosUseCase

    // MARK: - Published State
    public var cryptocurrencies: [Crypto] = []
    public var isLoading = false
    public var errorMessage: String?
    public var lastUpdated: Date?

    /// Initializes the view model with dependencies
    /// - Parameter getTopCryptocurrenciesUseCase: Use case for fetching cryptocurrencies
    public init(getTopCryptosUseCase: GetTopCryptosUseCase) {
        self.getTopCryptosUseCase = getTopCryptosUseCase
    }

    /// Loads the top cryptocurrencies
    /// - Parameters:
    ///   - limit: Number of cryptocurrencies to fetch (default: 5)
    ///   - currency: Currency code for price conversion (default: defaultCurrency)
    public func loadCryptos(limit: Int = 5, currency: String = CryptoConstants.defaultCurrency) async {
        isLoading = true
        errorMessage = nil

        do {
            cryptocurrencies = try await getTopCryptosUseCase.execute(limit: limit, currency: currency)
            lastUpdated = Date()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    /// Refreshes the cryptos
    public func refresh() async {
        await loadCryptos()
    }
}
