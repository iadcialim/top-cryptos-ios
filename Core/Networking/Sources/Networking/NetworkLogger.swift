import Foundation
import Alamofire

/// Logs outgoing requests and incoming responses for debugging.
public final class NetworkLogger: EventMonitor {
    public let queue = DispatchQueue(label: "com.iadcialimguno.topcryptos.networklogger")

    public init() {}

    public func requestDidResume(_ request: Request) {
        guard let httpRequest = request.request else { return }

        print("--------------------------------------------------------------------------------")
        print("Request: \(httpRequest.httpMethod ?? "UNKNOWN") \(httpRequest.url?.absoluteString ?? "")")

        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            print("Headers:")
            headers.forEach { key, value in
                print("  \(key): \(value)")
            }
        }

        if let body = httpRequest.httpBody,
           let bodyString = String(data: body, encoding: .utf8),
           !bodyString.isEmpty {
            print("Body:")
            print(bodyString)
        }
        print("") // Empty line for separation
    }

    public func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        let statusCode = response.response?.statusCode ?? -1
        let url = request.request?.url?.absoluteString ?? ""

        print("Response: \(statusCode) \(url)")

        switch response.result {
        case .success:
            if let data = response.data,
               let bodyString = String(data: data, encoding: .utf8),
               !bodyString.isEmpty {
                print("Body:")
                // Pretty print JSON if possible
                if let jsonData = bodyString.data(using: .utf8),
                   let jsonObject = try? JSONSerialization.jsonObject(with: jsonData),
                   let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys]),
                   let prettyString = String(data: prettyData, encoding: .utf8) {
                    print(prettyString)
                } else {
                    print(bodyString)
                }
            }
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
            if let data = response.data,
               let errorBody = String(data: data, encoding: .utf8) {
                print("Error Body:")
                print(errorBody)
            }
        }
        print("") // Empty line for separation
    }
}
