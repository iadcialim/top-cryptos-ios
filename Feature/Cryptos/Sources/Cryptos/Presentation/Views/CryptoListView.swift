import SwiftUI

/// Main view for displaying the list of top cryptocurrencies
public struct CryptoListView: View {
    @State private var viewModel: CryptoListViewModel

    public init(viewModel: CryptoListViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading && viewModel.cryptocurrencies.isEmpty {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)

                        Text("Error")
                            .font(.headline)

                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button("Retry") {
                            Task {
                                await viewModel.loadCryptocurrencies()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    VStack(spacing: 0) {
                        List {
                            ForEach(viewModel.cryptocurrencies) { crypto in
                                CryptoRowView(Crypto: crypto)
                            }
                        }
                        .listStyle(.plain)
                        .refreshable {
                            await viewModel.refresh()
                        }

                        // Last updated timestamp
                        if let lastUpdated = viewModel.lastUpdated {
                            Text("Updated last \(formattedDate(lastUpdated))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("Top Cryptos")
            .task {
                if viewModel.cryptocurrencies.isEmpty {
                    await viewModel.loadCryptocurrencies()
                }
            }
        }
    }

    // MARK: - Helper Methods

    /// Formats the date to "MMM DD, YYYY at HH:MM am/pm" format
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy 'at' hh:mm a"
        return formatter.string(from: date)
    }
}
