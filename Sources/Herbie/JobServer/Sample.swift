import AsyncHTTPClient
import NIOCore

extension Herbie {
    public static func sample() async throws -> HerbieSampleResponse? {
        let body = HerbieRequest(
            formula: "(FPCore (x) (- (sqrt (+ x 1))))", seed: 5)

        var request = HTTPClientRequest(url: "http://127.0.0.1:8000/api/sample")
        request.method = .POST
        request.body = .bytes(ByteBuffer(string: body.json))

        let response = try await HTTPClient.shared.execute(
            request, timeout: .seconds(30))
        if response.status == .ok {
            let body = try await response.body.collect(upTo: 1024 * 1024)  // 1 MB
            let rspJson = String(buffer: body)
            return HerbieSampleResponse(json: rspJson)
        } else {
            // handle remote error
            return nil
        }
    }
}
