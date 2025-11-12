import XCTest
@testable import Cryptos

final class CacheConfigurationTests: XCTestCase {

    // MARK: - Initialization Tests

    func testDefaultInitializationSets24HourExpiration() {
        // When
        let config = CacheConfiguration()

        // Then
        XCTAssertEqual(config.expirationInterval, 24 * 60 * 60)
    }

    func testInitializationWithCustomExpiration() {
        // Given
        let customInterval: TimeInterval = 3600

        // When
        let config = CacheConfiguration(expirationInterval: customInterval)

        // Then
        XCTAssertEqual(config.expirationInterval, customInterval)
    }

    // MARK: - Static Configuration Tests

    func testDefaultConfigurationHas24HourExpiration() {
        // When
        let config = CacheConfiguration.default

        // Then
        XCTAssertEqual(config.expirationInterval, 86400) // 24 hours in seconds
    }

    func testTestingConfigurationHas1MinuteExpiration() {
        // When
        let config = CacheConfiguration.testing

        // Then
        XCTAssertEqual(config.expirationInterval, 60) // 1 minute in seconds
    }

    func testDefaultAndTestingConfigurationsAreDifferent() {
        // Given
        let defaultConfig = CacheConfiguration.default
        let testingConfig = CacheConfiguration.testing

        // Then
        XCTAssertNotEqual(defaultConfig.expirationInterval, testingConfig.expirationInterval)
        XCTAssertGreaterThan(defaultConfig.expirationInterval, testingConfig.expirationInterval)
    }

    // MARK: - Edge Case Tests

    func testInitializationWithZeroExpiration() {
        // Given
        let zeroInterval: TimeInterval = 0

        // When
        let config = CacheConfiguration(expirationInterval: zeroInterval)

        // Then
        XCTAssertEqual(config.expirationInterval, 0)
    }

    func testInitializationWithNegativeExpiration() {
        // Given
        let negativeInterval: TimeInterval = -100

        // When
        let config = CacheConfiguration(expirationInterval: negativeInterval)

        // Then
        XCTAssertEqual(config.expirationInterval, -100)
    }

    func testInitializationWithVeryLargeExpiration() {
        // Given
        let largeInterval: TimeInterval = 365 * 24 * 60 * 60 // 1 year

        // When
        let config = CacheConfiguration(expirationInterval: largeInterval)

        // Then
        XCTAssertEqual(config.expirationInterval, largeInterval)
    }
}
