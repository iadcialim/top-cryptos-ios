import XCTest
@testable import Networking

final class NetworkErrorXCTests: XCTestCase {

    func testInvalidResponseDescription() {
        XCTAssertEqual(
            NetworkError.invalidResponse.errorDescription,
            "Invalid response from server"
        )
    }

    func testHttpErrorDescriptionIncludesStatusCode() {
        XCTAssertEqual(
            NetworkError.httpError(statusCode: 503).errorDescription,
            "HTTP error with status code: 503"
        )
    }

    func testDecodingErrorDescriptionPropagatesMessage() {
        let decodingIssue = NSError(
            domain: "NetworkingTests",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "invalid format"]
        )

        XCTAssertEqual(
            NetworkError.decodingError(decodingIssue).errorDescription,
            "Failed to decode response: invalid format"
        )
    }

    func testNetworkErrorDescriptionMirrorsUnderlyingError() {
        let networkIssue = URLError(.timedOut)

        XCTAssertEqual(
            NetworkError.networkError(networkIssue).errorDescription,
            "Network error: \(networkIssue.localizedDescription)"
        )
    }
}
