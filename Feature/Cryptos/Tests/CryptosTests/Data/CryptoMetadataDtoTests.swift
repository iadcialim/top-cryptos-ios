import XCTest
@testable import Cryptos

final class CryptoMetadataDtoTests: XCTestCase {

    // MARK: - JSON Decoding Tests

    func testDecodeCryptoMetadataResponseDto() throws {
        // Given
        let json = """
        {
            "data": {
                "1": {
                    "id": 1,
                    "name": "Bitcoin",
                    "symbol": "BTC",
                    "logo": "https://s2.coinmarketcap.com/static/img/coins/64x64/1.png"
                },
                "1027": {
                    "id": 1027,
                    "name": "Ethereum",
                    "symbol": "ETH",
                    "logo": "https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png"
                }
            }
        }
        """
        let jsonData = json.data(using: .utf8)!

        // When
        let response = try JSONDecoder().decode(CryptoMetadataResponseDto.self, from: jsonData)

        // Then
        XCTAssertEqual(response.data.count, 2)
        XCTAssertNotNil(response.data["1"])
        XCTAssertNotNil(response.data["1027"])
    }

    func testDecodeMultipleCryptoMetadata() throws {
        // Given
        let json = """
        {
            "data": {
                "1": {
                    "id": 1,
                    "name": "Bitcoin",
                    "symbol": "BTC",
                    "logo": "https://example.com/btc.png"
                },
                "1027": {
                    "id": 1027,
                    "name": "Ethereum",
                    "symbol": "ETH",
                    "logo": "https://example.com/eth.png"
                },
                "825": {
                    "id": 825,
                    "name": "Tether",
                    "symbol": "USDT",
                    "logo": "https://example.com/usdt.png"
                }
            }
        }
        """
        let jsonData = json.data(using: .utf8)!

        // When
        let response = try JSONDecoder().decode(CryptoMetadataResponseDto.self, from: jsonData)

        // Then
        XCTAssertEqual(response.data.count, 3)

        let bitcoin = response.data["1"]
        XCTAssertNotNil(bitcoin)
        XCTAssertEqual(bitcoin?.name, "Bitcoin")
        XCTAssertEqual(bitcoin?.symbol, "BTC")

        let ethereum = response.data["1027"]
        XCTAssertNotNil(ethereum)
        XCTAssertEqual(ethereum?.name, "Ethereum")
        XCTAssertEqual(ethereum?.symbol, "ETH")

        let tether = response.data["825"]
        XCTAssertNotNil(tether)
        XCTAssertEqual(tether?.name, "Tether")
        XCTAssertEqual(tether?.symbol, "USDT")
    }

    // MARK: - Property Tests

    func testAccessNonExistentMetadataReturnsNil() throws {
        // Given
        let json = """
        {
            "data": {
                "1": {
                    "id": 1,
                    "name": "Bitcoin",
                    "symbol": "BTC",
                    "logo": "https://example.com/btc.png"
                }
            }
        }
        """
        let jsonData = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(CryptoMetadataResponseDto.self, from: jsonData)

        // When
        let nonExistent = response.data["999"]

        // Then
        XCTAssertNil(nonExistent)
    }
}
