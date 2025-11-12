import Foundation

/// Data Transfer Object for Crypto API response
/// Maps to CoinMarketCap API response structure
struct CryptoResponseDto: Decodable {
    let data: [CryptoDto]
}

/// Quote data for a specific currency
/// Represents price information in a particular currency (e.g., USD, EUR)
struct QuoteData: Decodable {
    let price: Double
    let percent_change_24h: Double?
    let last_updated: String

    enum CodingKeys: String, CodingKey {
        case price
        case percent_change_24h
        case last_updated
    }
}

struct CryptoDto: Decodable {
    let id: Int
    let name: String
    let symbol: String
    let cmc_rank: Int
    let quote: [String: QuoteData]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case cmc_rank
        case quote
    }

    /// Maps DTO to domain entity using specified currency
    /// - Parameter currency: Currency code to extract from quote (default: defaultCurrency)
    /// - Returns: Crypto domain entity
    func toDomain(currency: String, imageUrl: String) -> Crypto? {
        guard let quoteData = quote[currency] else {
            return nil
        }

        return Crypto(
            id: id,
            name: name,
            symbol: symbol,
            price: quoteData.price,
            percentChange24h: quoteData.percent_change_24h ?? 0.0,
            marketCap: 0.0,
            rank: cmc_rank,
            imageUrl: imageUrl
        )
    }
}
