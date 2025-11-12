import SwiftUI

/// Detail view for displaying cryptocurrency information
public struct CryptoDetailsView: View {
    let crypto: Crypto

    public init(crypto: Crypto) {
        self.crypto = crypto
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Logo and Name Section
                VStack(spacing: 12) {
                    CryptoImageView(
                        imageURL: crypto.imageUrl,
                        size: 80
                    )

                    Text(crypto.name)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(crypto.symbol)
                        .font(.body)
                        .foregroundColor(.secondary)

                    // Rank Badge
                    Text("Rank #\(crypto.rank)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.1))
                        )
                }
                .padding(.top, 24)

                Divider()
                    .padding(.horizontal)

                // Price Information Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Price Information")
                        .font(.title3)
                        .fontWeight(.semibold)

                    // Current Price
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current Price")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("$\(formatPrice(crypto.price))")
                            .font(.title)
                            .fontWeight(.semibold)
                    }

                    // 24h Change
                    VStack(alignment: .leading, spacing: 4) {
                        Text("24h Change")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        HStack(spacing: 6) {
                            Image(systemName: crypto.percentChange24h >= 0 ? "arrow.up.right" : "arrow.down.right")
                                .font(.caption)

                            Text("\(formatPercentage(crypto.percentChange24h))%")
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(crypto.percentChange24h >= 0 ? .green : .red)
                    }

                    // Last Updated
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Last Updated")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text(formattedDate(Date()))
                            .font(.body)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helper Methods

    /// Formats price with proper decimal places
    private func formatPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: price)) ?? String(format: "%.2f", price)
    }

    /// Formats percentage to 2 decimal places
    private func formatPercentage(_ percentage: Double) -> String {
        return String(format: "%.2f", abs(percentage))
    }

    /// Formats the date to "MMM DD, YYYY at HH:MM am/pm" format
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy 'at' hh:mm a"
        return formatter.string(from: date)
    }
}
