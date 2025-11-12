import XCTest
@testable import Cryptos

@MainActor
final class CryptoListViewModelTests: XCTestCase {

    var viewModel: CryptoListViewModel!
    var mockService: MockCryptoServiceForViewModel!
    var useCase: GetTopCryptosUseCase!

    // MARK: - Test Lifecycle

    override func setUp() {
        super.setUp()
        mockService = MockCryptoServiceForViewModel()
        useCase = GetTopCryptosUseCase(service: mockService)
        viewModel = CryptoListViewModel(getTopCryptosUseCase: useCase)
    }

    override func tearDown() {
        viewModel = nil
        useCase = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func testInitialization() {
        // Then
        XCTAssertTrue(viewModel.cryptocurrencies.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.lastUpdated)
    }

    // MARK: - Load Cryptos Tests

    func testLoadCryptosSuccess() async {
        // Given
        let expectedCryptos = createTestCryptos(count: 5)
        mockService.cryptosToReturn = expectedCryptos

        // When
        await viewModel.loadCryptos()

        // Then
        XCTAssertEqual(viewModel.cryptocurrencies.count, 5)
        XCTAssertEqual(viewModel.cryptocurrencies, expectedCryptos)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNotNil(viewModel.lastUpdated)
    }

    func testLoadCryptosWithCustomLimitAndCurrency() async {
        // Given
        let expectedCryptos = createTestCryptos(count: 5)
        mockService.cryptosToReturn = expectedCryptos

        // When
        await viewModel.loadCryptos(limit: 5, currency: "EUR")

        // Then
        XCTAssertEqual(mockService.capturedCurrency, "EUR")
        XCTAssertEqual(viewModel.cryptocurrencies.count, 5)
    }

    func testLoadCryptosSetsIsLoadingTrueWhileLoading() async {
        // Given
        mockService.cryptosToReturn = createTestCryptos(count: 5)
        mockService.delay = 0.1

        // When
        let loadTask = Task {
            await viewModel.loadCryptos()
        }

        // Give it a moment to start
        try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds

        // Then - should be loading
        XCTAssertTrue(viewModel.isLoading)

        // Wait for completion
        await loadTask.value

        // Then - should not be loading anymore
        XCTAssertFalse(viewModel.isLoading)
    }

    func testLoadCryptosUpdatesLastUpdated() async {
        // Given
        let beforeLoad = Date()
        mockService.cryptosToReturn = createTestCryptos(count: 5)

        // When
        await viewModel.loadCryptos()

        // Then
        XCTAssertNotNil(viewModel.lastUpdated)
        XCTAssertGreaterThanOrEqual(viewModel.lastUpdated!, beforeLoad)
    }

    func testLoadCryptosFailureSetsErrorMessage() async {
        // Given
        mockService.errorToThrow = NSError(
            domain: "TestError",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Network error"]
        )

        // When
        await viewModel.loadCryptos()

        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.errorMessage?.contains("Network error") ?? false)
        XCTAssertTrue(viewModel.cryptocurrencies.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.lastUpdated)
    }

    func testLoadCryptosClearsErrorMessageOnSuccess() async {
        // Given - first load fails
        mockService.errorToThrow = NSError(domain: "TestError", code: 500)
        await viewModel.loadCryptos()
        XCTAssertNotNil(viewModel.errorMessage)

        // When - second load succeeds
        mockService.errorToThrow = nil
        mockService.cryptosToReturn = createTestCryptos(count: 5)
        await viewModel.loadCryptos()

        // Then
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.cryptocurrencies.count, 5)
    }

    func testLoadCryptosEmptyArray() async {
        // Given
        mockService.cryptosToReturn = []

        // When
        await viewModel.loadCryptos()

        // Then
        XCTAssertTrue(viewModel.cryptocurrencies.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNotNil(viewModel.lastUpdated)
        XCTAssertFalse(viewModel.isLoading)
    }

    // MARK: - Refresh Tests

    func testRefreshCallsLoadCryptos() async {
        // Given
        mockService.cryptosToReturn = createTestCryptos(count: 5)

        // When
        await viewModel.refresh()

        // Then
        XCTAssertEqual(viewModel.cryptocurrencies.count, 5)
        XCTAssertTrue(mockService.executeCalled)
    }

    func testRefreshUsesDefaultParameters() async {
        // Given
        mockService.cryptosToReturn = createTestCryptos(count: 5)

        // When
        await viewModel.refresh()

        // Then
        XCTAssertEqual(mockService.capturedLimit, 5)
        XCTAssertEqual(mockService.capturedCurrency, "USD")
    }

    // MARK: - Multiple Load Tests

    func testMultipleLoadsUpdateCryptocurrencies() async {
        // Given
        let firstBatch = createTestCryptos(count: 5)
        let secondBatch = createTestCryptos(count: 10)

        // When - first load
        mockService.cryptosToReturn = firstBatch
        await viewModel.loadCryptos()
        XCTAssertEqual(viewModel.cryptocurrencies.count, 5)

        // When - second load
        mockService.cryptosToReturn = secondBatch
        await viewModel.loadCryptos(limit: 10)

        // Then
        XCTAssertEqual(viewModel.cryptocurrencies.count, 10)
        XCTAssertEqual(mockService.executeCallCount, 2)
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

// MARK: - Mock CryptoService for ViewModel

final class MockCryptoServiceForViewModel: CryptoService {
    var executeCalled = false
    var executeCallCount = 0
    var capturedLimit: Int?
    var capturedCurrency: String?
    var cryptosToReturn: [Crypto] = []
    var errorToThrow: Error?
    var delay: TimeInterval = 0

    func getTopCryptos(limit: Int, currency: String) async throws -> [Crypto] {
        executeCalled = true
        executeCallCount += 1
        capturedLimit = limit
        capturedCurrency = currency

        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }

        if let error = errorToThrow {
            throw error
        }

        return cryptosToReturn
    }
}
