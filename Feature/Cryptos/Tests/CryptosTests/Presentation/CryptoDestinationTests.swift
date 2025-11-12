import XCTest
@testable import Cryptos

final class CryptoDestinationTests: XCTestCase {

    // MARK: - Hashable Tests

    func testDetailsDestinationWithSameCryptoAreEqual() {
        // Given
        let crypto1 = createTestCrypto(id: 1, name: "Bitcoin")
        let crypto2 = createTestCrypto(id: 1, name: "Bitcoin")

        // When
        let destination1 = CryptoDestination.details(crypto1)
        let destination2 = CryptoDestination.details(crypto2)

        // Then
        XCTAssertEqual(destination1, destination2)
    }

    func testDetailsDestinationWithDifferentCryptoAreNotEqual() {
        // Given
        let bitcoin = createTestCrypto(id: 1, name: "Bitcoin")
        let ethereum = createTestCrypto(id: 2, name: "Ethereum")

        // When
        let destination1 = CryptoDestination.details(bitcoin)
        let destination2 = CryptoDestination.details(ethereum)

        // Then
        XCTAssertNotEqual(destination1, destination2)
    }

    func testDetailsDestinationHashValue() {
        // Given
        let crypto1 = createTestCrypto(id: 1, name: "Bitcoin")
        let crypto2 = createTestCrypto(id: 1, name: "Bitcoin")

        // When
        let destination1 = CryptoDestination.details(crypto1)
        let destination2 = CryptoDestination.details(crypto2)

        // Then
        XCTAssertEqual(destination1.hashValue, destination2.hashValue)
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
}
