import SwiftUI

// MARK: - CryptoRowView Previews

#Preview("Bitcoin - Positive Change") {
    CryptoRowView(Crypto: MockCryptoData.bitcoinPositive)
        .previewLayout(.sizeThatFits)
}

#Preview("Ethereum - Negative Change") {
    CryptoRowView(Crypto: MockCryptoData.ethereumNegative)
        .previewLayout(.sizeThatFits)
}

#Preview("No logo crypto") {
    CryptoRowView(Crypto: MockCryptoData.noLogoCryto)
        .previewLayout(.sizeThatFits)
}

#Preview("Row in List") {
    List {
        CryptoRowView(Crypto: MockCryptoData.bitcoinPositive)
        CryptoRowView(Crypto: MockCryptoData.ethereumNegative)
        CryptoRowView(Crypto: MockCryptoData.tether)
    }
    .listStyle(.plain)
}
