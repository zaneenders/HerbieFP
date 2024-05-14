import Foundation
import ScribeSystem

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
