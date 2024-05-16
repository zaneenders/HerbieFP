import AsyncHTTPClient
import Foundation
import NIOCore
import _NIOFileSystem

struct HerbieRequest: Codable {
    let formula: String
    let seed: Int

    public var json: String {
        let encoder = JSONEncoder()
        // encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(self)
        let jsonString = String(data: data, encoding: .utf8)!
        return jsonString
    }
}

struct HerbieSampleResponse: Codable {

    let points: [Point]

    enum CodingKeys: String, CodingKey {
        case points = "points"
    }

    public init?(json: String) {
        guard
            let data = json.data(
                using: .utf8)
        else {
            return nil
        }
        let decoder = JSONDecoder()
        guard
            let msg: Self = try? decoder.decode(
                Self.self, from: data)
        else {
            return nil
        }
        self = msg
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let p = try values.decode([Point].self, forKey: .points)
        self.points = p
    }
}

extension HerbieSampleResponse {
    struct Point: Codable {
        let a: [Double]
        let b: Double

        init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            self.a = try container.decode([Double].self)
            self.b = try container.decode(Double.self)
        }
    }
}

func sample() async throws -> HerbieSampleResponse? {
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
