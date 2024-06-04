import Foundation

public struct HerbieSampleResponse: Codable {

    public let points: [Point]

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
    public struct Point: Codable {
        let a: [Double]
        let b: Double

        public init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            self.a = try container.decode([Double].self)
            self.b = try container.decode(Double.self)
        }
    }
}
