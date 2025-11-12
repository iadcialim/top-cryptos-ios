import SwiftUI

/// Coordinator responsible for navigation in the Crypto feature
@MainActor
@Observable
public final class CryptoCoordinator {
    /// Navigation path for managing the navigation stack
    public var path: NavigationPath = NavigationPath()

    public init() {}

    // MARK: - Navigation Actions

    /// Navigate to cryptocurrency details
    /// - Parameter crypto: The cryptocurrency to display
    public func showDetails(for crypto: Crypto) {
        path.append(CryptoDestination.details(crypto))
    }

    /// Pop to the previous screen
    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// Pop to root (list view)
    public func popToRoot() {
        path.removeLast(path.count)
    }

    // MARK: - View Factory

    /// Builds the appropriate view for a given destination
    /// - Parameter destination: The destination to navigate to
    /// - Returns: A view for the destination
    @ViewBuilder
    public func view(for destination: CryptoDestination) -> some View {
        switch destination {
        case .details(let crypto):
            CryptoDetailsView(crypto: crypto)
        }
    }
}
