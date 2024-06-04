import Foundation

struct HerbieAltsRequest: Codable {
    let formula: String
    let seed: Int
    // Encoding this correctly will be a pain
    let sample: [Double]

    public var json: String {
        let encoder = JSONEncoder()
        // encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(self)
        let jsonString = String(data: data, encoding: .utf8)!
        return jsonString
    }
}
