import Foundation
import _NIOFileSystem

var os: OS {
    let str = ProcessInfo.processInfo.operatingSystemVersionString
    /*
        TODO check for other Operating systems.
        This should be finite and easy ish to check
        idk how I want to do versions yet
        */
    if str.contains("Ubuntu") {
        return .linux(.ubuntu(str))
    } else if str.contains("Red Hat") {
        return .linux(.redhat(str))
    } else if str.contains("Fedora Linux") {
        return .linux(.fedora(str))
    } else {
        return .macOS
    }
}

enum OS {
    case macOS
    case linux(Linux)
    public enum Linux {
        case ubuntu(String)
        case redhat(String)
        case fedora(String)
        case centos(String)
    }
}

public func shell(_ cmd: String) async {
    let zsh: String
    switch os {
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
        // Should we throw?
        print(error)
    }
    print("process started")
    process.waitUntilExit()
    print("process finished")
}

@available(*, deprecated, message: "NOT PUBLIC")
extension String {
    public func encodeURIComponent() -> String? {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-_.!~*'()")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet)
    }
}

@available(*, deprecated, message: "NOT PUBLIC")
public func writeStringToFile(
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
