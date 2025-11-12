import XCTest
@testable import Cryptos

final class CryptoConstantsTests: XCTestCase {

    // MARK: - Default Currency Tests

    func testDefaultCurrencyIsUSD() {
        // When
        let defaultCurrency = CryptoConstants.defaultCurrency

        // Then
        XCTAssertEqual(defaultCurrency, "USD")
    }

    func testDefaultCurrencyIsNotEmpty() {
        // When
        let defaultCurrency = CryptoConstants.defaultCurrency

        // Then
        XCTAssertFalse(defaultCurrency.isEmpty)
    }
}
