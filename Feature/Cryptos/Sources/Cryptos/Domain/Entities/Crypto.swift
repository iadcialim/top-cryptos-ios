import Foundation

/// Represents a cryptocurrency in the market
public struct Crypto: Identifiable {
    public let id: Int
    public let name: String
    public let symbol: String
    public let price: Double
    public let percentChange24h: Double
    public let marketCap: Double
    public let rank: Int

    public init(
        id: Int,
        name: String,
        symbol: String,
        price: Double,
        percentChange24h: Double,
        marketCap: Double,
        rank: Int
    ) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.price = price
        self.percentChange24h = percentChange24h
        self.marketCap = marketCap
        self.rank = rank
    }
}
