import Foundation

// MARK: - Mock Data

/// Shared mock cryptocurrency data for SwiftUI previews
enum MockCryptoData {
    static let bitcoinPositive = Crypto(
        id: 1,
        name: "Bitcoin",
        symbol: "BTC",
        price: 103331.63,
        percentChange24h: 2.52,
        marketCap: 2000000000000,
        rank: 1,
        imageUrl: "https://s2.coinmarketcap.com/static/img/coins/64x64/1.png"
    )

    static let ethereumNegative = Crypto(
        id: 1027,
        name: "Ethereum",
        symbol: "ETH",
        price: 3437.82,
        percentChange24h: -3.95,
        marketCap: 400000000000,
        rank: 2,
        imageUrl: "https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png"
    )

    static let tether = Crypto(
        id: 825,
        name: "Tether USD",
        symbol: "USDT",
        price: 1.00,
        percentChange24h: -0.01,
        marketCap: 120000000000,
        rank: 3,
        imageUrl: "https://s2.coinmarketcap.com/static/img/coins/64x64/825.png"
    )

    static let xrp = Crypto(
        id: 52,
        name: "XRP",
        symbol: "XRP",
        price: 2.40,
        percentChange24h: 4.86,
        marketCap: 130000000000,
        rank: 4,
        imageUrl: "https://s2.coinmarketcap.com/static/img/coins/64x64/52.png"
    )

    static let bnb = Crypto(
        id: 1839,
        name: "BNB",
        symbol: "BNB",
        price: 963.85,
        percentChange24h: -3.51,
        marketCap: 140000000000,
        rank: 5,
        imageUrl: "https://s2.coinmarketcap.com/static/img/coins/64x64/1839.png"
    )
    
    static let noLogoCryto = Crypto(
        id: 1839,
        name: "BNB",
        symbol: "BNB",
        price: 963.85,
        percentChange24h: -3.51,
        marketCap: 140000000000,
        rank: 5,
        imageUrl: "nil"
    )


    /// All mock cryptos as an array
    static let all: [Crypto] = [
        bitcoinPositive,
        ethereumNegative,
        tether,
        xrp,
        bnb
    ]
}

// MARK: - Mock Service

/// Mock implementation of CryptoService for SwiftUI previews
final class MockCryptoService: CryptoService {
    private let shouldSucceed: Bool
    private let delay: TimeInterval

    init(shouldSucceed: Bool, delay: TimeInterval = 0) {
        self.shouldSucceed = shouldSucceed
        self.delay = delay
    }

    func getTopCryptos(limit: Int, currency: String) async throws -> [Crypto] {
        // Simulate network delay
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }

        if shouldSucceed {
            return MockCryptoData.all
        } else {
            throw NSError(domain: "PreviewError", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Failed to fetch cryptocurrencies.\nPlease check your connection and try again."
            ])
        }
    }
}
