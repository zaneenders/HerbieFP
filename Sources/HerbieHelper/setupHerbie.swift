import ScribeSystem

extension HerbieHelper {
    static func setupHerbie(at path: String) async throws {
        var currentPath = path
        do {
            let repoPath = "\(System.scribePath)/.repositories"
            if !FileSystem.fileExists(atPath: repoPath) {
                try FileSystem.createDirectory(at: repoPath)
            }
            // install racket
            let racketPath = "\(repoPath)/racket"
            if !FileSystem.fileExists(atPath: racketPath) {
                try await System.shell(
                    "cd \(repoPath) && git clone git@github.com:racket/racket.git"
                )
            }

            // TODO install rust
            /*
            sudo dnf install rust cargo
            */

            // build racket
            try await System.shell("cd \(racketPath) && git checkout v8.11.1")
            try await System.shell("cd \(racketPath) && make")
            if !FileSystem.fileExists(atPath: "\(currentPath)/herbie") {
                try FileSystem.createDirectory(at: currentPath)
                try await System.shell(
                    "cd \(currentPath) && git clone git@github.com:herbie-fp/herbie.git"
                )
            }
            currentPath += "/herbie"

            // maybe use -y
            try await System.shell(
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
