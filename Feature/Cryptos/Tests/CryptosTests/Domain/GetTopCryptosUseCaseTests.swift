import XCTest
@testable import Cryptos

final class GetTopCryptosUseCaseTests: XCTestCase {

    // MARK: - Subject Under Test

    var sut: GetTopCryptosUseCase!
    var mockService: MockCryptoService!

    // MARK: - Test Lifecycle

    override func setUp() {
        super.setUp()
        mockService = MockCryptoService()
        sut = GetTopCryptosUseCase(service: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Execute Tests

    func testExecuteCallsServiceWithDefaultParameters() async throws {
        // Given
        let expectedCryptos = createTestCryptos(count: 5)
        mockService.cryptosToReturn = expectedCryptos

        // When
        let result = try await sut.execute()

        // Then
        XCTAssertTrue(mockService.getTopCryptosCalled)
        XCTAssertEqual(mockService.capturedLimit, 5)
        XCTAssertEqual(mockService.capturedCurrency, "USD")
        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result, expectedCryptos)
    }

    func testExecuteCallsServiceWithCustomLimit() async throws {
        // Given
        let expectedCryptos = createTestCryptos(count: 10)
        mockService.cryptosToReturn = expectedCryptos

        // When
        let result = try await sut.execute(limit: 10)

        // Then
        XCTAssertTrue(mockService.getTopCryptosCalled)
        XCTAssertEqual(mockService.capturedLimit, 10)
        XCTAssertEqual(mockService.capturedCurrency, "USD")
        XCTAssertEqual(result.count, 10)
    }

    func testExecuteCallsServiceWithCustomCurrency() async throws {
        // Given
        let expectedCryptos = createTestCryptos(count: 5)
        mockService.cryptosToReturn = expectedCryptos

        // When
        let result = try await sut.execute(limit: 5, currency: "EUR")

        // Then
        XCTAssertTrue(mockService.getTopCryptosCalled)
        XCTAssertEqual(mockService.capturedLimit, 5)
        XCTAssertEqual(mockService.capturedCurrency, "EUR")
        XCTAssertEqual(result.count, 5)
    }

    func testExecuteCallsServiceWithCustomParameters() async throws {
        // Given
        let expectedCryptos = createTestCryptos(count: 20)
        mockService.cryptosToReturn = expectedCryptos

        // When
        let result = try await sut.execute(limit: 20, currency: "GBP")

        // Then
        XCTAssertTrue(mockService.getTopCryptosCalled)
        XCTAssertEqual(mockService.capturedLimit, 20)
        XCTAssertEqual(mockService.capturedCurrency, "GBP")
        XCTAssertEqual(result.count, 20)
    }

    func testExecuteReturnsEmptyArrayWhenServiceReturnsEmpty() async throws {
        // Given
        mockService.cryptosToReturn = []

        // When
        let result = try await sut.execute()

        // Then
        XCTAssertTrue(mockService.getTopCryptosCalled)
        XCTAssertTrue(result.isEmpty)
    }

    func testExecuteThrowsErrorWhenServiceFails() async {
        // Given
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockService.errorToThrow = expectedError

        // When & Then
        do {
            _ = try await sut.execute()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(mockService.getTopCryptosCalled)
            XCTAssertEqual(error as NSError, expectedError)
        }
    }

    // MARK: - Helper Methods

    private func createTestCrypto(
        id: Int,
        name: String,
        symbol: String = "TEST",
        price: Double = 100.0,
        percentChange24h: Double = 0.0,
        marketCap: Double = 1_000_000.0,
        rank: Int = 1,
        imageUrl: String = "https://example.com/test.png"
    ) -> Crypto {
        return Crypto(
            id: id,
            name: name,
            symbol: symbol,
            price: price,
            percentChange24h: percentChange24h,
            marketCap: marketCap,
            rank: rank,
            imageUrl: imageUrl
        )
    }

    private func createTestCryptos(count: Int) -> [Crypto] {
        return (1...count).map { index in
            createTestCrypto(
                id: index,
                name: "Crypto \(index)",
                symbol: "CRY\(index)",
                rank: index
            )
        }
    }
}

// MARK: - Mock CryptoService

final class MockCryptoService: CryptoService {
    var getTopCryptosCalled = false
    var getTopCryptosCallCount = 0
    var capturedLimit: Int?
    var capturedCurrency: String?
    var cryptosToReturn: [Crypto] = []
    var errorToThrow: Error?

    func getTopCryptos(limit: Int, currency: String) async throws -> [Crypto] {
        getTopCryptosCalled = true
        getTopCryptosCallCount += 1
        capturedLimit = limit
        capturedCurrency = currency

        if let error = errorToThrow {
            throw error
        }

        return cryptosToReturn
    }
}
