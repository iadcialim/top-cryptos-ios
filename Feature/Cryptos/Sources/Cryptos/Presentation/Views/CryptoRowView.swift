import SwiftUI

/// View for displaying a single Crypto row
public struct CryptoRowView: View {
    let crypto: Crypto

    public init(Crypto: Crypto) {
        self.crypto = Crypto
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Crypto logo
                AsyncImage(url: URL(string: crypto.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 40, height: 40)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.gray)
                            .frame(width: 40, height: 40)
                    @unknown default:
                        EmptyView()
                    }
                }

                // Symbol and Name
                VStack(alignment: .leading, spacing: 4) {
                    Text(crypto.symbol)
                        .font(.headline)
                        .fontWeight(.semibold)

                    Text(crypto.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Price and Change
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(crypto.price, specifier: "%.2f")")
                        .font(.headline)
                        .fontWeight(.semibold)

                    HStack(spacing: 4) {
                        Image(systemName: crypto.percentChange24h >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.caption2)

                        Text("\(abs(crypto.percentChange24h), specifier: "%.2f")%")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(crypto.percentChange24h >= 0 ? .green : .red)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)

            // Custom divider that extends full width
            Divider()
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listRowSeparator(.hidden)
    }
}
