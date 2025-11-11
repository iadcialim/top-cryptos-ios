import Foundation

/// Service protocol for Crypto operations
/// Defines the contract for fetching Crypto data
public protocol CryptoService: Sendable {
    /// Fetches the top cryptocurrencies by market cap
    /// - Parameters:
    ///   - limit: Number of cryptocurrencies to fetch
    ///   - currency: Currency code for price conversion
    /// - Returns: Array of cryptocurrencies
    /// - Throws: Error if fetching fails
    func getTopCryptos(limit: Int, currency: String) async throws -> [Crypto]
}
