import XCTest
@testable import Networking

final class NetworkConfigurationTests: XCTestCase {
    func testCoinMarketCapConfigurationSetsExpectedValues() {
        let apiKey = "test-key"
        let configuration = NetworkConfiguration.coinMarketCap(apiKey: apiKey)

        XCTAssertEqual(configuration.baseURL, "https://pro-api.coinmarketcap.com")
        XCTAssertEqual(configuration.apiKey, apiKey)
        XCTAssertEqual(configuration.commonHeaders["X-CMC_PRO_API_KEY"], apiKey)
        XCTAssertEqual(configuration.commonHeaders["Accept"], "application/json")
    }
}
