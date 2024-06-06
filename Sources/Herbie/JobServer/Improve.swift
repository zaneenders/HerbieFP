import AsyncHTTPClient
import Foundation
import NIOCore

extension Herbie {
    public static func improve() async throws {
        var request = HTTPClientRequest(url: "http://127.0.0.1:8000/improve")
        request.url +=
            "?"
            + "formula=\("(FPCore (x) (- (sqrt (+ x 1))))".encodeURIComponent()!)"
        request.method = .GET

        print(request.url)

        let response = try await HTTPClient.shared.execute(
            request, timeout: .seconds(30))
        if response.status == .ok {
            let body = try await response.body.collect(upTo: 1024 * 1024)  // 1 MB
            let rspJson = String(buffer: body)
            print(rspJson.count)  // HTML garbage
        } else {
            print(response.status)
        }
    }
}
