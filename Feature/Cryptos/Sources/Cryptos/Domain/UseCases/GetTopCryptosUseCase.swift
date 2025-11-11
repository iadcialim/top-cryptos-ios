import Foundation

/// Use case for fetching top cryptocurrencies
public final class GetTopCryptosUseCase {
    private let service: any CryptoService

    /// Initializes the use case with a service
    /// - Parameter service: Service for Crypto data
    public init(service: any CryptoService) {
        self.service = service
    }

    /// Executes the use case to fetch top cryptocurrencies
    /// - Parameters:
    ///   - limit: Number of cryptocurrencies to fetch (default: 5)
    ///   - currency: Currency code for price conversion (default: USD)
    /// - Returns: Array of cryptocurrencies
    /// - Throws: Error if fetching fails
    public func execute(limit: Int = 5, currency: String = CryptoConstants.defaultCurrency) async throws -> [Crypto] {
        return try await service.getTopCryptos(limit: limit, currency: currency)
    }
}
