import XCTest
import Alamofire
import Networking
@testable import Cryptos

final class CryptoAPIRequestTests: XCTestCase {

    var testConfiguration: NetworkConfiguration!

    // MARK: - Test Lifecycle

    override func setUp() {
        super.setUp()
        testConfiguration = NetworkConfiguration.coinMarketCap(apiKey: "test-api-key-12345")
    }

    override func tearDown() {
        testConfiguration = nil
        super.tearDown()
    }

    // MARK: - URL Construction Tests

    func testTopCryptosRequestCreatesCorrectURL() throws {
        // Given
        let router = CryptoAPIRouter.topCryptos(limit: 10, currency: "USD")
        let request = CryptoAPIRequest(router: router, configuration: testConfiguration)

        // When
        let urlRequest = try request.asURLRequest()

        // Then
        XCTAssertNotNil(urlRequest.url)
        XCTAssertTrue(urlRequest.url?.absoluteString.contains("pro-api.coinmarketcap.com") ?? false)
        XCTAssertTrue(urlRequest.url?.absoluteString.contains("/v1/cryptocurrency/listings/latest") ?? false)
    }

    func testCryptoMetadataRequestCreatesCorrectURL() throws {
        // Given
        let router = CryptoAPIRouter.cryptoMetadata(ids: "1,1027")
        let request = CryptoAPIRequest(router: router, configuration: testConfiguration)

        // When
        let urlRequest = try request.asURLRequest()

        // Then
        XCTAssertNotNil(urlRequest.url)
        XCTAssertTrue(urlRequest.url?.absoluteString.contains("pro-api.coinmarketcap.com") ?? false)
        XCTAssertTrue(urlRequest.url?.absoluteString.contains("/v2/cryptocurrency/info") ?? false)
    }

    // MARK: - HTTP Method Tests

    func testTopCryptosRequestHasGetMethod() throws {
        // Given
        let router = CryptoAPIRouter.topCryptos(limit: 10, currency: "USD")
        let request = CryptoAPIRequest(router: router, configuration: testConfiguration)

        // When
        let urlRequest = try request.asURLRequest()

        // Then
        XCTAssertEqual(urlRequest.method, .get)
    }

    func testCryptoMetadataRequestHasGetMethod() throws {
        // Given
        let router = CryptoAPIRouter.cryptoMetadata(ids: "1,1027")
        let request = CryptoAPIRequest(router: router, configuration: testConfiguration)

        // When
        let urlRequest = try request.asURLRequest()

        // Then
        XCTAssertEqual(urlRequest.method, .get)
    }

    // MARK: - Headers Tests

    func testRequestIncludesCommonHeaders() throws {
        // Given
        let router = CryptoAPIRouter.topCryptos(limit: 10, currency: "USD")
        let request = CryptoAPIRequest(router: router, configuration: testConfiguration)

        // When
        let urlRequest = try request.asURLRequest()

        // Then
        XCTAssertNotNil(urlRequest.headers)
        XCTAssertEqual(urlRequest.headers["X-CMC_PRO_API_KEY"], "test-api-key-12345")
        XCTAssertEqual(urlRequest.headers["Accept"], "application/json")
    }

    // MARK: - Query Parameters Tests

    func testTopCryptosRequestIncludesQueryParameters() throws {
        // Given
        let router = CryptoAPIRouter.topCryptos(limit: 10, currency: "USD")
        let request = CryptoAPIRequest(router: router, configuration: testConfiguration)

        // When
        let urlRequest = try request.asURLRequest()

        // Then
        let urlString = urlRequest.url?.absoluteString ?? ""
        XCTAssertTrue(urlString.contains("limit=10"))
        XCTAssertTrue(urlString.contains("convert=USD"))
    }

    func testCryptoMetadataRequestIncludesQueryParameters() throws {
        // Given
        let router = CryptoAPIRouter.cryptoMetadata(ids: "1,1027,825")
        let request = CryptoAPIRequest(router: router, configuration: testConfiguration)

        // When
        let urlRequest = try request.asURLRequest()

        // Then
        let urlString = urlRequest.url?.absoluteString ?? ""
        XCTAssertTrue(urlString.contains("id=1"))
    }

}
