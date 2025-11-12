import Foundation
import Alamofire
import Networking

/// Factory for creating Alamofire Sessions with Crypto-specific caching
/// This allows the Cryptos feature to own its caching strategy
public enum CryptoSessionFactory {

    /// Creates a Session configured with crypto-specific caching
    /// - Parameters:
    ///   - cacheConfiguration: Cache expiration configuration (24h production, 1min testing)
    ///   - enableLogging: Whether to enable request/response logging
    /// - Returns: Configured Session with CryptoCachedResponseHandler
    public static func createSession(
        cacheConfiguration: CacheConfiguration,
        enableLogging: Bool = true
    ) -> Session {
        // Create crypto-specific cache handler
        let cacheHandler = CryptoCachedResponseHandler(cacheConfiguration: cacheConfiguration)

        // Use core networking factory with crypto's cache handler
        return NetworkSessionFactory.createSession(
            cacheHandler: cacheHandler,
            enableLogging: enableLogging
        )
    }
}
