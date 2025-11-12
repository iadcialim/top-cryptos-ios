//
//  TopCryptosApp.swift
//  TopCryptos
//
//  Created by Macaroon Guno on 11/11/2025.
//

import SwiftUI
import Cryptos
import Networking

/// Main application entry point
/// Handles dependency injection and app initialization
@main
struct TopCryptosApp: App {
    var body: some Scene {
        WindowGroup {
            createCryptoListView()
        }
    }

    /// Creates the main view with all dependencies wired up
    /// This is where explicit dependency injection happens
    /// - Returns: Configured CryptoListView with all dependencies
    private func createCryptoListView() -> CryptoListView {
        // Configure base URL and API key
        let apiKey = "f631eea54fc842efa1d829b2cc1b7a71"
        let networkConfig = NetworkConfiguration.coinMarketCap(apiKey: apiKey)

        // Session creation
        let cacheConfig = CacheConfiguration.testing // change for different expiry
        let session = CryptoSessionFactory.createSession(
            cacheConfiguration: cacheConfig,
            enableLogging: true
        )

        // Service layer
        // Feature modules use the session + configuration to build their own APIs
        let service = CryptoAPIService(
            session: session,
            configuration: networkConfig
        )

        // Usecase layer
        let useCase = GetTopCryptosUseCase(service: service)

        // ViewModel layer
        let viewModel = CryptoListViewModel(getTopCryptosUseCase: useCase)

        // View layer
        return CryptoListView(viewModel: viewModel)
    }
}
