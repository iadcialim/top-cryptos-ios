import XCTest
import Alamofire
@testable import Cryptos

final class CryptoAPIRouterTests: XCTestCase {

    // MARK: - Path Tests

    func testTopCryptosPath() {
        // Given
        let router = CryptoAPIRouter.topCryptos(limit: 10, currency: "USD")

        // Then
        XCTAssertEqual(router.path, "/v1/cryptocurrency/listings/latest")
    }

    func testCryptoMetadataPath() {
        // Given
        let router = CryptoAPIRouter.cryptoMetadata(ids: "1,1027")

        // Then
        XCTAssertEqual(router.path, "/v2/cryptocurrency/info")
    }

    // MARK: - HTTP Method Tests

    func testTopCryptosMethodIsGet() {
        // Given
        let router = CryptoAPIRouter.topCryptos(limit: 10, currency: "USD")

        // Then
        XCTAssertEqual(router.method, .get)
    }

    func testCryptoMetadataMethodIsGet() {
        // Given
        let router = CryptoAPIRouter.cryptoMetadata(ids: "1,1027")

        // Then
        XCTAssertEqual(router.method, .get)
    }

    // MARK: - Parameters Tests

    func testTopCryptosParameters() {
        // Given
        let router = CryptoAPIRouter.topCryptos(limit: 10, currency: "USD")

        // When
        let parameters = router.parameters

        // Then
        XCTAssertNotNil(parameters)
        XCTAssertEqual(parameters?["limit"] as? Int, 10)
        XCTAssertEqual(parameters?["convert"] as? String, "USD")
    }

    func testTopCryptosParametersWithDifferentValues() {
        // Given
        let router = CryptoAPIRouter.topCryptos(limit: 50, currency: "EUR")

        // When
        let parameters = router.parameters

        // Then
        XCTAssertNotNil(parameters)
        XCTAssertEqual(parameters?["limit"] as? Int, 50)
        XCTAssertEqual(parameters?["convert"] as? String, "EUR")
    }

    func testCryptoMetadataParameters() {
        // Given
        let ids = "1,1027,825"
        let router = CryptoAPIRouter.cryptoMetadata(ids: ids)

        // When
        let parameters = router.parameters

        // Then
        XCTAssertNotNil(parameters)
        XCTAssertEqual(parameters?["id"] as? String, ids)
    }

    func testCryptoMetadataParametersWithSingleId() {
        // Given
        let router = CryptoAPIRouter.cryptoMetadata(ids: "1")

        // When
        let parameters = router.parameters

        // Then
        XCTAssertNotNil(parameters)
        XCTAssertEqual(parameters?["id"] as? String, "1")
    }

}
