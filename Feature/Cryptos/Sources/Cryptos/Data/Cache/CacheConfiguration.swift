import Foundation

/// Configuration for HTTP cache behavior
public struct CacheConfiguration {
    /// Time interval after which cached data is considered expired
    /// Default: 24 hours (86400 seconds)
    /// For testing: Set to 60 seconds (1 minute)
    public let expirationInterval: TimeInterval

    /// Creates a cache configuration
    /// - Parameter expirationInterval: Duration in seconds before cache expires
    public init(expirationInterval: TimeInterval = 24 * 60 * 60) {
        self.expirationInterval = expirationInterval
    }

    /// Convenience configuration for testing (1 minute expiry)
    public static var testing: CacheConfiguration {
        CacheConfiguration(expirationInterval: 60)
    }

    /// Default configuration (24 hours expiry)
    public static var `default`: CacheConfiguration {
        CacheConfiguration(expirationInterval: 24 * 60 * 60)
    }
}
