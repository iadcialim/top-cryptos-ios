import Foundation
import Alamofire

/// Configuration for network settings shared across the app
public struct NetworkConfiguration: Sendable {
    /// Base URL for the API
    public let baseURL: String

    /// API key for authentication
    public let apiKey: String

    /// Common headers to include in every request
    public let commonHeaders: HTTPHeaders

    /// Creates a network configuration
    /// - Parameters:
    ///   - baseURL: Base URL for the API
    ///   - apiKey: API key for authentication
    ///   - commonHeaders: Headers to include in every request
    public init(baseURL: String, apiKey: String, commonHeaders: HTTPHeaders) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.commonHeaders = commonHeaders
    }

    /// Default configuration for CoinMarketCap API
    /// - Parameter apiKey: API key for authentication
    /// - Returns: Configuration with CoinMarketCap base URL and headers
    public static func coinMarketCap(apiKey: String) -> NetworkConfiguration {
        let headers: HTTPHeaders = [
            "X-CMC_PRO_API_KEY": apiKey,
            "Accept": "application/json"
        ]

        return NetworkConfiguration(
            baseURL: "https://pro-api.coinmarketcap.com",
            apiKey: apiKey,
            commonHeaders: headers
        )
    }
}
