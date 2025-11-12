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
        // Step 1: Fetch cryptocurrency listings
        let listingsRouter = CryptoAPIRouter.topCryptos(limit: limit, currency: currency)
        let listingsRequest = CryptoAPIRequest(router: listingsRouter, configuration: configuration)

        do {
            let listingsResponse = try await session
                .request(listingsRequest)
                .validate(statusCode: 200..<300)
                .serializingDecodable(CryptoResponseDto.self)
                .value

            // Step 2: Extract IDs and create initial domain models
            let cryptoList = listingsResponse.data
            let ids = cryptoList.map { String($0.id) }.joined(separator: ",")

            // Step 3: Batch-fetch metadata to get crypto logos
            let metadataRouter = CryptoAPIRouter.cryptoMetadata(ids: ids)
            let metadataRequest = CryptoAPIRequest(router: metadataRouter, configuration: configuration)

            let metadataResponse = try await session
                .request(metadataRequest)
                .validate(statusCode: 200..<300)
                .serializingDecodable(CryptoMetadataResponseDto.self)
                .value

            // Step 4: Merge data by ID - map to domain models with logo URLs
            let cryptos = cryptoList.compactMap { cryptoDto -> Crypto? in
                let metadata = metadataResponse.data[String(cryptoDto.id)]
                let imageUrl = metadata?.logo ?? ""
                // Convert to domain model with the logo
                return cryptoDto.toDomain(currency: currency, imageUrl: imageUrl) ?? nil
            }

            return cryptos

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
