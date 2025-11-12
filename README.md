# Top Cryptos iOS

An iOS application that displays the top cryptocurrencies by market cap with real-time pricing data and caching capabilities.

## Features

- Display top cryptocurrencies ranked by market cap
- View detailed information for each cryptocurrency
- Real-time price updates and 24-hour price change percentages
- HTTP caching for improved performance and offline support
- Cryptocurrency logos and branding

## Architecture

The application follows MVVM + Clean Architecture principles with a modular package structure:

### Core Modules
- **Networking**: Generic networking layer built on Alamofire with configurable caching and error handling

### Feature Modules
- **Cryptos**: Main feature module with three layers:
  - **Domain**: Business logic, entities (Crypto), use cases (GetTopCryptosUseCase), and service protocols
  - **Data**: API integration, DTOs, caching logic, and service implementations
  - **Presentation**: SwiftUI views, view models, and navigation coordinators

### Design Patterns
- Clean Architecture (Domain/Data/Presentation layers)
- MVVM for presentation layer
- Coordinator pattern for navigation
- Manual dependency injection
- Protocol-oriented design

## Requirements

- iOS 17.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

## Running the App

### Using Xcode

1. Open the project:
   ```bash
   open TopCryptos.xcodeproj
   ```

2. Select a simulator (iPhone 15, iPhone 14 Pro, etc.)

3. Build and run: `Cmd + R`

## Running Unit Tests

### Test Networking Module (CLI)

Navigate to the Networking module and run tests:

```bash
cd Core/Networking
swift test
```

This will execute all Networking module tests including:
- NetworkConfiguration tests
- NetworkSessionFactory tests
- NetworkError tests

### Test Cryptos Module (CLI)

Navigate to the Cryptos module and run tests using xcodebuild:

```bash
cd Feature/Cryptos
xcodebuild test -scheme Cryptos -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.0'
```

## Testing Cache Logic

### Manual Testing

1. Launch the app with network connectivity
2. View the cryptocurrency list (data is cached with 24-hour TTL)
3. Enable Airplane Mode
4. Force quit and relaunch the app
5. The cached data should still display

### Quick Testing

You can lower down the TTL value to 1 minute for easy testing.

1. Open the file `TopCryptosApp` and find the line
    ```
    let cacheConfig = CacheConfiguration.default
    ```
    Then you can change to 
    ```
    let cacheConfig = CacheConfiguration.testing
    ```

2. You can run the app again to initially load the cryptocurrency list.
Wait for 1 minute and pull to refresh. You should see in the console it a new response is returned.

## API Integration

The app uses the CoinMarketCap API for cryptocurrency data:
- Base URL: https://pro-api.coinmarketcap.com
- Endpoints: `/v1/cryptocurrency/listings/latest`, `/v2/cryptocurrency/info`
- Authentication: API key required (configured in NetworkConfiguration)

    You can use your own key by updating this line in `TopCryptosApp`.
    ```
    private func createCryptoListView() -> CryptoListView {
      // Configure base URL and API key
      let apiKey = "xxxx"
    ```

## Project Structure

```
top-cryptos-ios/
├── Core/
│   └── Networking/           # Generic networking module
├── Feature/
│   └── Cryptos/              # Cryptocurrency feature module
├── TopCryptos/               # Main app target
├── TopCryptosTests/          # App-level tests
└── TopCryptosUITests/        # UI tests
```

## Dependencies

- **Alamofire** (5.10.2): HTTP networking library
