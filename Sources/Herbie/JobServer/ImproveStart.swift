import AsyncHTTPClient
import Foundation
import NIOCore

extension Herbie {

    public static func improveStart() async throws {
        let local = "http://127.0.0.1:8000"
        var request = HTTPClientRequest(url: "\(local)/improve-start")
        request.method = .POST
        let body = HerbieRequest(
            formula: "(FPCore (x) (- (sqrt (+ x 1))))", seed: 5)
        request.body = .bytes(ByteBuffer(string: body.json))

        let response = try await HTTPClient.shared.execute(
            request, timeout: .seconds(30))
        if response.status == .created {
            try? await Task.sleep(for: .seconds(3))
            if let path = response.headers["Location"].first {
                print("\(local + path)")
                var new = HTTPClientRequest(url: local + path)
                new.method = .GET
                let newResp = try await HTTPClient.shared.execute(
                    new, timeout: .seconds(30))
                if newResp.status == .created {
                    let body = try await newResp.body.collect(upTo: 1024 * 1024)  // 1 MB
                    print(newResp.headers)
                    print(String(buffer: body))
                }
            }
        } else {
            print(response.status)
        }
    }
}
