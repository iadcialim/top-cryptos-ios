import Foundation
import Alamofire
import Networking

/// Service implementation for interacting with CoinMarketCap API
/// Implements CryptoService protocol from Domain layer
public final class CryptoAPIService: CryptoService {
    private let session: Session
    private let configuration: NetworkConfiguration

    /// Initializes the API service
    /// - Parameters:
    ///   - session: Configured Alamofire session from NetworkSessionFactory
    ///   - configuration: Network configuration with base URL and API key
    public init(session: Session, configuration: NetworkConfiguration) {
        self.session = session
        self.configuration = configuration
    }

    /// Fetches top cryptocurrencies from API
    /// - Parameters:
    ///   - limit: Number of cryptocurrencies to fetch
    ///   - currency: Currency code for price conversion (e.g., defaultCurrency, "EUR")
    /// - Returns: Array of domain cryptocurrencies
    /// - Throws: NetworkError if request fails
    public func getTopCryptos(limit: Int, currency: String) async throws -> [Crypto] {
        // Create request using router
        let router = CryptoAPIRouter.topCryptos(limit: limit, currency: currency)
        let apiRequest = CryptoAPIRequest(router: router, configuration: configuration)

        do {
            // Make request using Alamofire session directly
            let response = try await session
                .request(apiRequest)
                .validate(statusCode: 200..<300)
                .serializingDecodable(CryptoResponseDto.self)
                .value

            return response.data.compactMap { $0.toDomain(currency: currency) }
        } catch let error as AFError {
            throw mapAFError(error)
        } catch {
            throw NetworkError.networkError(error)
        }
    }

    // MARK: - Error Mapping

    /// Maps Alamofire errors to NetworkError
    private func mapAFError(_ error: AFError) -> NetworkError {
        switch error {
        case .responseValidationFailed(let reason):
            if case let .unacceptableStatusCode(code) = reason {
                return NetworkError.httpError(statusCode: code)
            } else {
                return NetworkError.invalidResponse
            }
        case .responseSerializationFailed:
            return NetworkError.decodingError(error)
        default:
            return NetworkError.networkError(error)
        }
    }
}
