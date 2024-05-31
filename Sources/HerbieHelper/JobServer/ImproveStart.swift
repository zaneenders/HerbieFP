import AsyncHTTPClient
import Foundation
import NIOCore

func improveStart() async throws {
    var request = HTTPClientRequest(url: "http://127.0.0.1:8000/improve-start")
    request.url +=
        "?"
        + "formula=\("(FPCore (x) (- (sqrt (+ x 1))))".encodeURIComponent()!)"
    request.method = .POST

    let response = try await HTTPClient.shared.execute(
        request, timeout: .seconds(30))
    if response.status == .created {
        let body = try await response.body.collect(upTo: 1024 * 1024)  // 1 MB
        // let rspJson = String(buffer: body)
        if let path = response.headers["Location"].first {
            print("here: \(path)")
            var new = HTTPClientRequest(url: path)
            new.method = .GET
            let newResp = try await HTTPClient.shared.execute(
                new, timeout: .seconds(30))
            print(newResp)
        }
    } else {
        print(response.status)
    }
}
