import Foundation
import Alamofire

/// Factory for creating configured Alamofire Sessions
/// Provides centralized, flexible networking infrastructure
/// Features can provide their own caching strategies via CachedResponseHandler
public enum NetworkSessionFactory {

    /// Creates a configured Alamofire Session with optional caching and logging
    /// - Parameters:
    ///   - cacheHandler: Optional CachedResponseHandler for feature-specific caching
    ///   - enableLogging: Whether to enable network request/response logging
    ///   - urlCache: Optional custom URLCache (defaults to 10MB memory + 50MB disk)
    /// - Returns: Configured Alamofire Session ready to use
    public static func createSession(
        cacheHandler: (any CachedResponseHandler)? = nil,
        enableLogging: Bool = true,
        urlCache: URLCache? = nil
    ) -> Session {
        // Configure URLSession
        let configuration = URLSessionConfiguration.default

        // Use provided cache or create default
        let cache = urlCache ?? URLCache(
            memoryCapacity: 10 * 1024 * 1024, // 10 MB memory cache
            diskCapacity: 50 * 1024 * 1024,   // 50 MB disk cache
            diskPath: nil
        )
        configuration.urlCache = cache
        configuration.requestCachePolicy = .useProtocolCachePolicy

        // Setup event monitors for logging
        let monitors: [EventMonitor] = enableLogging ? [NetworkLogger()] : []

        // Create Session with optional cache handler
        return Session(
            configuration: configuration,
            cachedResponseHandler: cacheHandler,
            eventMonitors: monitors
        )
    }
}
