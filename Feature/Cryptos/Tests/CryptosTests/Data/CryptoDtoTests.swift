import XCTest
@testable import Cryptos

final class CryptoDtoTests: XCTestCase {

    // MARK: - JSON Decoding Tests

    func testDecodeCryptoDtoWithMultipleCurrencies() throws {
        // Given
        let json = """
        {
            "id": 1,
            "name": "Bitcoin",
            "symbol": "BTC",
            "cmc_rank": 1,
            "quote": {
                "USD": {
                    "price": 45000.50,
                    "percent_change_24h": 2.5,
                    "last_updated": "2023-01-01T00:00:00.000Z"
                },
                "EUR": {
                    "price": 42000.00,
                    "percent_change_24h": 2.3,
                    "last_updated": "2023-01-01T00:00:00.000Z"
                }
            }
        }
        """
        let jsonData = json.data(using: .utf8)!

        // When
        let cryptoDto = try JSONDecoder().decode(CryptoDto.self, from: jsonData)

        // Then
        XCTAssertEqual(cryptoDto.quote.count, 2)
        XCTAssertNotNil(cryptoDto.quote["USD"])
        XCTAssertNotNil(cryptoDto.quote["EUR"])
        XCTAssertEqual(cryptoDto.quote["USD"]?.price, 45000.50)
        XCTAssertEqual(cryptoDto.quote["EUR"]?.price, 42000.00)
    }

    // MARK: - Domain Mapping Tests

    func testToDomainWithValidCurrency() throws {
        // Given
        let json = """
        {
            "id": 1,
            "name": "Bitcoin",
            "symbol": "BTC",
            "cmc_rank": 1,
            "quote": {
                "USD": {
                    "price": 45000.50,
                    "percent_change_24h": 2.5,
                    "last_updated": "2023-01-01T00:00:00.000Z"
                }
            }
        }
        """
        let jsonData = json.data(using: .utf8)!
        let cryptoDto = try JSONDecoder().decode(CryptoDto.self, from: jsonData)

        // When
        let crypto = cryptoDto.toDomain(currency: "USD", imageUrl: "https://example.com/btc.png")

        // Then
        XCTAssertNotNil(crypto)
        XCTAssertEqual(crypto?.id, 1)
        XCTAssertEqual(crypto?.name, "Bitcoin")
        XCTAssertEqual(crypto?.symbol, "BTC")
        XCTAssertEqual(crypto?.price, 45000.50)
        XCTAssertEqual(crypto?.percentChange24h, 2.5)
        XCTAssertEqual(crypto?.rank, 1)
        XCTAssertEqual(crypto?.imageUrl, "https://example.com/btc.png")
    }

    func testToDomainWithInvalidCurrencyReturnsNil() throws {
        // Given
        let json = """
        {
            "id": 1,
            "name": "Bitcoin",
            "symbol": "BTC",
            "cmc_rank": 1,
            "quote": {
                "USD": {
                    "price": 45000.50,
                    "percent_change_24h": 2.5,
                    "last_updated": "2023-01-01T00:00:00.000Z"
                }
            }
        }
        """
        let jsonData = json.data(using: .utf8)!
        let cryptoDto = try JSONDecoder().decode(CryptoDto.self, from: jsonData)

        // When
        let crypto = cryptoDto.toDomain(currency: "EUR", imageUrl: "https://example.com/btc.png")

        // Then
        XCTAssertNil(crypto)
    }

    func testToDomainWithEmptyImageUrl() throws {
        // Given
        let json = """
        {
            "id": 1,
            "name": "Bitcoin",
            "symbol": "BTC",
            "cmc_rank": 1,
            "quote": {
                "USD": {
                    "price": 45000.50,
                    "percent_change_24h": 2.5,
                    "last_updated": "2023-01-01T00:00:00.000Z"
                }
            }
        }
        """
        let jsonData = json.data(using: .utf8)!
        let cryptoDto = try JSONDecoder().decode(CryptoDto.self, from: jsonData)

        // When
        let crypto = cryptoDto.toDomain(currency: "USD", imageUrl: "")

        // Then
        XCTAssertNotNil(crypto)
        XCTAssertEqual(crypto?.imageUrl, "")
    }

}
