import XCTest
@testable import Networking

final class NetworkSessionFactoryTests: XCTestCase {

    func testUsesProvidedURLCacheAndPolicy() {
        let customCache = URLCache(memoryCapacity: 1024, diskCapacity: 2048, diskPath: nil)

        let session = NetworkSessionFactory.createSession(
            enableLogging: false,
            urlCache: customCache
        )

        let configuration = session.sessionConfiguration
        XCTAssertEqual(configuration.requestCachePolicy, URLRequest.CachePolicy.useProtocolCachePolicy)
        XCTAssertTrue(configuration.urlCache === customCache)
    }

    func testCreatesDefaultCacheWhenNil() {
        let session = NetworkSessionFactory.createSession(enableLogging: false, urlCache: nil)
        let configuration = session.sessionConfiguration

        XCTAssertNotNil(configuration.urlCache)
        XCTAssertEqual(configuration.urlCache?.memoryCapacity, 10 * 1024 * 1024)
        XCTAssertEqual(configuration.urlCache?.diskCapacity, 50 * 1024 * 1024)
    }

}
