import Foundation

/// Response DTO for /v2/cryptocurrency/info endpoint
struct CryptoMetadataResponseDto: Decodable {
    let data: [String: CryptoMetadataDto]
}

/// Metadata DTO containing cryptocurrency information including logo
struct CryptoMetadataDto: Decodable {
    let id: Int
    let name: String
    let symbol: String
    let logo: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case logo
    }
}
