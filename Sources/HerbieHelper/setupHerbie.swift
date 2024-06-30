import Foundation

extension HerbieHelper {

    static func setupHerbie(at path: String) async throws {
        var currentPath = path
        do {
            switch os {
            case .macOS:
                ()
            case .linux:
                let repoPath = "\(scribePath)/.repositories"
                if !FileManager.default.fileExists(atPath: repoPath) {
                    try FileManager.default.createDirectory(
                        at: URL(fileURLWithPath: repoPath),
                        withIntermediateDirectories: true)
                }
                // install racket
                let racketPath = "\(repoPath)/racket"
                if !FileManager.default.fileExists(atPath: racketPath) {
                    try await shell(
                        "cd \(repoPath) && git clone git@github.com:racket/racket.git"
                    )
                }
                // TODO install rust
                /*
                sudo dnf install rust cargo
                */
                // build racket
                // TODO check if already running
                if false {
                    try await shell(
                        "cd \(racketPath) && git checkout v8.11.1")
                    try await shell("cd \(racketPath) && make")
                }
            }

            // setup Herbie

            if !FileManager.default.fileExists(atPath: "\(currentPath)/herbie")
            {

                try FileManager.default.createDirectory(
                    at: URL(fileURLWithPath: currentPath),
                    withIntermediateDirectories: true)
                try await shell(
                    "cd \(currentPath) && git clone git@github.com:herbie-fp/herbie.git"
                )
            }
            currentPath += "/herbie"

            // maybe use -y
            try await shell(
                "cd \(currentPath) && make install"
            )
            print("Herbie installed at:")
            print(currentPath)
        } catch {
            print("failed to setup Herbie")
            print(error.localizedDescription)
        }
    }
}
