import Foundation
import _NIOFileSystem

func parseResults() async {
    let path =
        "/home/zane/.scribe/Packages/HerbieFP/herbie-fp/herbie/reports/hamming/results.json"
    guard let json = await getJsonString(from: path) else {
        print("failed to get json")
        return
    }
    print(json.count)
    guard
        let data = json.data(
            using: .utf8)
    else {
        fatalError("data")
    }
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    do {

        let data = try encoder.encode(Results(branch: "idk"))
        let jsonString = String(data: data, encoding: .utf8)!
        let file = FilePath("idk.json")
        let fh = try await FileSystem.shared.openFile(
            forReadingAndWritingAt: file,
            options: OpenOptions.Write.newFile(replaceExisting: true))
        var buffer = fh.bufferedWriter()
        try await buffer.write(contentsOf: jsonString.utf8)
        try await buffer.flush()
        try await fh.close()

        let msg: Results = try decoder.decode(
            Results.self, from: data)

    } catch {
        print(error)
    }
}

struct Results: Codable {
    let branch: String
}
