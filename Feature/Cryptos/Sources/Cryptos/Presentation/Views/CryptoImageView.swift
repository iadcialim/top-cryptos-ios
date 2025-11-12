import SwiftUI

/// Shared AsyncImage wrapper for showing crypto logos with consistent styling.
public struct CryptoImageView: View {
    private let imageURL: String
    private let size: CGFloat

    /// - Parameters:
    ///   - imageURL: Remote image URL string.
    ///   - size: Square size for the rendered image.
    public init(imageURL: String, size: CGFloat) {
        self.imageURL = imageURL
        self.size = size
    }

    public var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: size, height: size)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            case .failure:
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.gray)
                    .frame(width: size, height: size)
                    .font(.largeTitle)
            @unknown default:
                EmptyView()
                    .frame(width: size, height: size)
            }
        }
    }
}
