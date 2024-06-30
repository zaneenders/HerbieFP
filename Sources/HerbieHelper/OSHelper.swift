import Foundation

// Maybe think of this supported Operating Systems?
public enum OS {
    case macOS
    case linux(Linux)
    public enum Linux {
        case ubuntu(String)
        case redhat(String)
        case fedora(String)
        case centos(String)
    }
}

@available(*, deprecated, message: "beta: defaults to macOS")
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

enum SystemShell: String {
    case zsh = "zsh"
    case bash = "bash"
}

func shell(
    _ command: String, _ shell: SystemShell = .zsh,
    _ info: Bool = true
)
    async throws
{
    let shellPath = "/bin/\(shell.rawValue)"
    if info {
        print("\(shellPath), Running(\(command))")
    }
    try await runProcess(
        binary: shellPath, arguments: ["-c", command])
}
func runProcess(binary path: String, arguments: [String])
    async throws
{
    let str = "file://\(path)"
    guard let url = URL(string: str) else {
        throw ProcessError.invalidPath(str)
    }
    let process = Process()
    process.executableURL = url
    process.arguments = arguments
    let start = {
        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    // Maybe we capture std out and stream or return that one day
    await Task(priority: .userInitiated) {
        start()
    }.value
}

enum ProcessError: Error {
    case invalidPath(String)
}

var coreCount: Int {
    ProcessInfo.processInfo.activeProcessorCount
}

var scribePath: String {
    homePath + "/.scribe"
}

func write(string contents: String, to path: String)
    throws
{
    guard let url = URL(string: wrapFilePath(path)) else {
        throw FileSystemError.invalidFilePath(path)
    }
    try contents.write(to: url, atomically: true, encoding: .utf8)
}

func wrapFilePath(_ path: String) -> String {
    "file://" + path
}

enum FileSystemError: Error {
    case invalidFilePath(String)
}
