import Foundation
import Alamofire
import Networking

/// API Router for cryptocurrency endpoints using URLRequestConvertible
/// Handles endpoint paths, parameters, and request construction
enum CryptoAPIRouter: URLRequestConvertible {
    case topCryptos(limit: Int, currency: String)
    case cryptoInfo(id: String) // Future: for getting logo, etc.

    // MARK: - Properties

    /// Base URL injected from NetworkConfiguration
    var baseURL: String {
        // Will be set from NetworkConfiguration passed to CryptoAPIService
        // This is a placeholder - actual value comes from dependency injection
        fatalError("baseURL must be set via NetworkConfiguration in CryptoAPIService")
    }

    /// API key injected from NetworkConfiguration
    var apiKey: String {
        // Will be set from NetworkConfiguration passed to CryptoAPIService
        fatalError("apiKey must be set via NetworkConfiguration in CryptoAPIService")
    }

    /// API path for each endpoint
    var path: String {
        switch self {
        case .topCryptos:
            return "/v1/cryptocurrency/listings/latest"
        case .cryptoInfo:
            return "/v2/cryptocurrency/info"
        }
    }

    /// HTTP method for the request
    var method: HTTPMethod {
        switch self {
        case .topCryptos, .cryptoInfo:
            return .get
        }
    }

    /// Query parameters for the request
    var parameters: Parameters? {
        switch self {
        case .topCryptos(let limit, let currency):
            return [
                "limit": limit,
                "convert": currency
            ]
        case .cryptoInfo(let id):
            return ["id": id]
        }
    }

    // MARK: - URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        // This will be called by CryptoAPIRequest which has access to config
        fatalError("Use CryptoAPIRequest instead - it has access to NetworkConfiguration")
    }
}

/// Request wrapper that combines router with configuration
struct CryptoAPIRequest: URLRequestConvertible {
    let router: CryptoAPIRouter
    let configuration: NetworkConfiguration

    func asURLRequest() throws -> URLRequest {
        // Build full URL
        let urlString = configuration.baseURL + router.path
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        // Create request
        var urlRequest = URLRequest(url: url)
        urlRequest.method = router.method

        // Add common headers from configuration
        urlRequest.headers = configuration.commonHeaders

        // Encode parameters
        if let parameters = router.parameters {
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }

        return urlRequest
    }
}
