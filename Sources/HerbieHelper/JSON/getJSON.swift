import NIOFileSystem

typealias JSONString = String
func getJsonString(from path: String) async -> JSONString? {
    let path: FilePath =
        "/home/zane/.scribe/Packages/HerbieFP/herbie-fp/herbie/reports/hamming/timeline.json"
    guard let fh = try? await FileSystem.shared.openFile(forReadingAt: path)
    else {
        print("unable to get file handle for \(path)")
        return nil
    }
    guard let info = try? await fh.info() else {
        return nil
    }
    guard
        var buffer = try? await fh.readToEnd(
            maximumSizeAllowed: .bytes(info.size))
    else {
        return nil
    }
    try? await fh.close()
    guard let str = buffer.readString(length: Int(info.size)) else {
        return nil
    }
    return str
}
