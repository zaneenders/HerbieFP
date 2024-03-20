import Foundation

func parseResults() async {
    let path =
        "/home/zane/.scribe/Packages/HerbieFP/herbie-fp/herbie/reports/hamming/results.json"
    guard let json = await getJsonString(from: path) else {
        print("failed to get json")
        return
    }
    print(json.count)
    do {
        let results = try Results(json: json)
        print(results)
    } catch {
        print(error)
    }
}

extension Results {
    init(from decoder: Decoder) throws {
        // let values = try decoder.container(keyedBy: CodingKeys.self)
        // TODO come back to this
        // https://blog.logrocket.com/simplify-json-parsing-swift-using-codable/#complex-example
    }
}

struct Results {
    enum CodingKeys: String, CodingKey {
        case branch, commit, date, flags, hostname, interations, note, points,
            seed, tests
        // Map the JSON key "url" to the Swift property name "htmlLink"
        //case merged_cost_accuracy = "merged-cost-accuracy"
    }
    let branch: String
    let commit: String
    let date: Int
    let flags: [String]
    let hostname: String
    let interations: Int
    // let merged_cost_accuracy: [[Point]]
    let note: String
    let points: Int
    let seed: String
    let tests: [Test]
}

struct Point: Codable {
    let a: Double
    let b: Double
}

struct Test: Codable {
    let bits: Int
    let conversion: [String]
    //let cost_accuracy: [[Point]]
    let end: Double
    let end_est: Double
    let identifer: String
    let input: String
    let link: String
    let name: String
    let output: String
    let pre: String
    let prec: String
    let preprocess: String
    let spec: String
    let start: Double
    let start_est: Double
    let status: String
    let target: String
    let target_prog: String
    let time: String
    let vars: [String]
}

extension Results: Codable {
    public init?(json: String) throws {
        guard
            let data = json.data(
                using: .utf8)
        else {
            return nil
        }
        let decoder = JSONDecoder()
        let msg: Self = try decoder.decode(
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
