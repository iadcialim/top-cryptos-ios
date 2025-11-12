import XCTest
import SwiftUI
@testable import Cryptos

@MainActor
final class CryptoCoordinatorTests: XCTestCase {

    var coordinator: CryptoCoordinator!

    // MARK: - Test Lifecycle

    override func setUp() {
        super.setUp()
        coordinator = CryptoCoordinator()
    }

    override func tearDown() {
        coordinator = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func testInitializationCreatesEmptyPath() {
        // When
        let newCoordinator = CryptoCoordinator()

        // Then
        XCTAssertTrue(newCoordinator.path.isEmpty)
    }

    // MARK: - Navigation Tests

    func testShowDetailsAppendsToPath() {
        // Given
        let crypto = createTestCrypto(id: 1, name: "Bitcoin")
        XCTAssertTrue(coordinator.path.isEmpty)

        // When
        coordinator.showDetails(for: crypto)

        // Then
        XCTAssertEqual(coordinator.path.count, 1)
    }

    func testShowDetailsMultipleTimes() {
        // Given
        let bitcoin = createTestCrypto(id: 1, name: "Bitcoin")
        let ethereum = createTestCrypto(id: 2, name: "Ethereum")
        let cardano = createTestCrypto(id: 3, name: "Cardano")

        // When
        coordinator.showDetails(for: bitcoin)
        coordinator.showDetails(for: ethereum)
        coordinator.showDetails(for: cardano)

        // Then
        XCTAssertEqual(coordinator.path.count, 3)
    }

    func testPopRemovesLastFromPath() {
        // Given
        let crypto1 = createTestCrypto(id: 1, name: "Bitcoin")
        let crypto2 = createTestCrypto(id: 2, name: "Ethereum")
        coordinator.showDetails(for: crypto1)
        coordinator.showDetails(for: crypto2)
        XCTAssertEqual(coordinator.path.count, 2)

        // When
        coordinator.pop()

        // Then
        XCTAssertEqual(coordinator.path.count, 1)
    }

    func testPopOnEmptyPathDoesNothing() {
        // Given
        XCTAssertTrue(coordinator.path.isEmpty)

        // When
        coordinator.pop()

        // Then
        XCTAssertTrue(coordinator.path.isEmpty)
    }

    func testPopMultipleTimes() {
        // Given
        coordinator.showDetails(for: createTestCrypto(id: 1, name: "Bitcoin"))
        coordinator.showDetails(for: createTestCrypto(id: 2, name: "Ethereum"))
        coordinator.showDetails(for: createTestCrypto(id: 3, name: "Cardano"))
        XCTAssertEqual(coordinator.path.count, 3)

        // When
        coordinator.pop()
        coordinator.pop()

        // Then
        XCTAssertEqual(coordinator.path.count, 1)
    }

    func testPopToRootClearsEntirePath() {
        // Given
        coordinator.showDetails(for: createTestCrypto(id: 1, name: "Bitcoin"))
        coordinator.showDetails(for: createTestCrypto(id: 2, name: "Ethereum"))
        coordinator.showDetails(for: createTestCrypto(id: 3, name: "Cardano"))
        XCTAssertEqual(coordinator.path.count, 3)

        // When
        coordinator.popToRoot()

        // Then
        XCTAssertTrue(coordinator.path.isEmpty)
    }

    // MARK: - Navigation Flow Tests

    func testNavigationFlowShowAndPop() {
        // Given
        let bitcoin = createTestCrypto(id: 1, name: "Bitcoin")
        let ethereum = createTestCrypto(id: 2, name: "Ethereum")

        // When & Then
        coordinator.showDetails(for: bitcoin)
        XCTAssertEqual(coordinator.path.count, 1)

        coordinator.showDetails(for: ethereum)
        XCTAssertEqual(coordinator.path.count, 2)

        coordinator.pop()
        XCTAssertEqual(coordinator.path.count, 1)

        coordinator.pop()
        XCTAssertTrue(coordinator.path.isEmpty)
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
