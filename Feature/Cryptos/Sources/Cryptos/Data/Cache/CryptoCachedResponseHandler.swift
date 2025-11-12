import Foundation
import Alamofire

/// Crypto-specific cached response handler for cryptocurrency API responses
/// Uses URLCache's built-in expiry mechanism with custom Cache-Control headers
///
/// **How it works:**
/// 1. When response is received, modifies Cache-Control header with custom max-age
/// 2. URLCache automatically validates expiry based on Cache-Control headers
/// 3. No manual age checking needed - URLCache does it for you
///
/// **Note:** Other features can implement their own caching strategies
/// by creating their own CachedResponseHandler implementations
public final class CryptoCachedResponseHandler: CachedResponseHandler {
    private let cacheConfiguration: CacheConfiguration

    public init(cacheConfiguration: CacheConfiguration) {
        self.cacheConfiguration = cacheConfiguration
    }

    /// Modifies the cached response to include custom Cache-Control headers
    /// URLCache will automatically respect these headers for expiry validation
    ///
    /// **Key Point:** After this method runs, URLCache automatically handles:
    /// - Checking if cached response is expired based on max-age
    /// - Returning cached data if still valid
    /// - Fetching from network if expired
    public func dataTask(_ task: URLSessionDataTask,
                        willCacheResponse response: CachedURLResponse,
                        completion: @escaping (CachedURLResponse?) -> Void) {

        guard let httpResponse = response.response as? HTTPURLResponse else {
            completion(response)
            return
        }

        // Calculate max-age from configuration
        let maxAgeSeconds = Int(cacheConfiguration.expirationInterval)

        print("[CryptoCachedResponseHandler] max-age=\(maxAgeSeconds)s")

        // Modify headers to include custom max-age
        // URLCache will use this to determine if cache is expired
        var headers = httpResponse.allHeaderFields as? [String: String] ?? [:]
        headers["Cache-Control"] = "public, max-age=\(maxAgeSeconds)"

        // Optional: Add Date header if not present (helps URLCache calculate age)
        if headers["Date"] == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            headers["Date"] = dateFormatter.string(from: Date())
        }

        // Create new HTTP response with modified headers
        guard let url = httpResponse.url,
              let newResponse = HTTPURLResponse(
                url: url,
                statusCode: httpResponse.statusCode,
                httpVersion: "HTTP/1.1",
                headerFields: headers
              ) else {
            completion(response)
            return
        }

        // Create new cached response
        // Note: We don't add custom userInfo since URLCache will handle expiry
        let modifiedCachedResponse = CachedURLResponse(
            response: newResponse,
            data: response.data,
            userInfo: nil,  // No custom metadata needed
            storagePolicy: response.storagePolicy
        )

        completion(modifiedCachedResponse)
    }
}
