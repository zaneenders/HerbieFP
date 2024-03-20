import Foundation

func parseTimeline() async {
    print("TODO")
}
protocol Phases: Codable {}

struct TimeLine: Codable {
    /*
    Harder than I wanna do right now
    */
    // https://nightly.cs.washington.edu/reports/herbie/1710844954:nightly:main:0f421560f7/timeline.json
    // var phase: [any Phases]

    public init(json: String) {
        let data = json.data(
            using: .utf8)!
        let decoder = JSONDecoder()
        let msg: Self = try! decoder.decode(
            Self.self, from: data)
        self = msg
    }

    public var json: String {
        let encoder = JSONEncoder()
        // encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(self)
        let jsonString = String(data: data, encoding: .utf8)!
        return jsonString
    }
}
