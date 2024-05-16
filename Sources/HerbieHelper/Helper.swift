import Foundation
import ScribeSystem
import _NIOFileSystem

func shell(_ cmd: String) async {
    let zsh: String
    switch System.os {
    case .macOS:
        zsh = "file:///bin/zsh"
    case .linux:
        zsh = "file:///usr/bin/zsh"
    }
    let url = URL(string: zsh)!
    let process = Process()
    process.executableURL = url
    process.arguments = ["-c"] + [cmd]
    do {
        try process.run()
    } catch {
        print(error)
    }
    print("process started")
    process.waitUntilExit()
    print("process finished")
}

extension String {
    func encodeURIComponent() -> String? {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-_.!~*'()")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet)
    }
}

func writeStringToFile(
    _ str: String,
    _ filePath: String = "/Users/zane/.scribe/Packages/HerbieFP/data.json"
) async throws {
    let fp = FilePath(filePath)
    let fh = try await _NIOFileSystem.FileSystem.shared.openFile(
        forReadingAndWritingAt: fp,
        options: .modifyFile(createIfNecessary: true))
    var writer = fh.bufferedWriter()
    let data = str.data(using: .utf8)!
    try await writer.write(contentsOf: data)
    try await writer.flush()
    try await fh.close()
}
