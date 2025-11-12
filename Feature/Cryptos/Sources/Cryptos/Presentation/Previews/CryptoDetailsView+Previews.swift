import SwiftUI

// MARK: - CryptoDetailsView Previews

#Preview("Bitcoin - Positive Change") {
    NavigationStack {
        CryptoDetailsView(crypto: MockCryptoData.bitcoinPositive)
    }
}

#Preview("Ethereum - Negative Change") {
    NavigationStack {
        CryptoDetailsView(crypto: MockCryptoData.ethereumNegative)
    }
}

#Preview("No Logo Crypto") {
    NavigationStack {
        CryptoDetailsView(crypto: MockCryptoData.noLogoCryto)
    }
}
