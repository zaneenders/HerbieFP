import ScribeSystem

@main
struct HerbieHelper {

    static let testPath = "reports"

    public static func main() async {
        let packageDir = "\(System.homePath)/.scribe/Packages/HerbieFP"
        let herbieFPPath: String = "\(packageDir)/herbie-fp"
        if !FileSystem.fileExists(atPath: "\(herbieFPPath)") {
            print("Making directory: \(herbieFPPath)")
            do {
                try FileSystem.createDirectory(at: herbieFPPath)
            } catch {
                print(error.localizedDescription)
                print("Error setting up (\(herbieFPPath))")
            }
        }
        let herbieRepo = herbieFPPath + "/herbie"
        if !FileSystem.fileExists(atPath: herbieRepo)
            && CommandLine.arguments[1] != "setup"
        {
            print("please run setup")
            return
        }
        if CommandLine.arguments.count > 1 {
            if CommandLine.arguments[1] == "open" {
                // TODO Open firefox to localhost
                do {
                    try await System.shell(
                        "open /Applications/\"Firefox Developer Edition.app\" --background"
                    )
                    try await System.shell("code \(packageDir)")
                    try await System.shell("code \(herbieRepo)")
                } catch {
                    print(error.localizedDescription)
                }
            }
            if CommandLine.arguments[1] == "relink" {
                do {
                    try await _relink(.nightly)
                } catch {
                    print(error.localizedDescription)
                    print("Error relinking files")
                }
            }
            if CommandLine.arguments[1] == "nightly" {
                do {
                    try await _report(
                        path: herbieRepo, .nightly)
                } catch {
                    print(error.localizedDescription)
                    print("Error relinking files")
                }
            }
            if CommandLine.arguments[1] == "test" {
                try? await System.shell(
                    "cd \(herbieFPPath) && racket -y \(herbieFPPath)/herbie/src/herbie.rkt improve --seed 0 \(herbieFPPath)/herbie/zane-test.fpcore -"
                )
            }
            if CommandLine.arguments[1] == "setup" {
                do {
                    try await setupHerbie(at: herbieFPPath)
                } catch {
                    print(error.localizedDescription)
                    print("Error Setting up Herbie")
                }
            }
        } else {
            try? httpServer(
                "/home/zane/.scribe/Packages/HerbieFP/herbie-fp/herbie/reports")
        }
    }

    public static func _report(path: String, _ folder: Folder) async throws {
        print("Are you sure?")
        guard let line = readLine(strippingNewline: true) else {
            print("unable to get response")
            return
        }
        guard line.contains("y") else {
            print("ok good bye")
            return
        }
        do {
            let currentPath: String
            if folder == .nightly {
                currentPath = "\(path)/\(testPath)"
            } else {
                currentPath = "\(path)/\(testPath)/\(folder)"
            }
            print("Removing old report at: \(currentPath)")
            try FileSystem.removeItem(atPath: currentPath)
        } catch {
            print(error.localizedDescription)
        }

        await System.time("Error running report") {
            // TODO how should we capture logs?
            // TODO Mirror nightly.sh script for herbie
            let reportsString: String
            if folder == .nightly {
                print("running nightly")
                let basePath = "\(path)/\(testPath)"
                print(basePath)
                try FileSystem.createDirectory(at: basePath)
                var reportNames: [String] = []
                for b in Folder.allCases {
                    guard b != .nightly else { continue }
                    reportNames.append("\"\(b)\"")
                    print("running report: \(b)")
                    let outputPath: String =
                        "\(basePath)/\(b)"
                    try FileSystem.createDirectory(at: outputPath)
                    let cmd =
                        "racket -y src/herbie.rkt report --threads \(System.coreCount) --seed 0 bench/\(b.path) \(testPath)/\(b)"
                    try await System.shell("cd \(path) && \(cmd)")
                }
                reportsString = reportNames.joined(separator: " ")
            } else {
                print("running \(folder) report")
                let outputPath: String =
                    "\(path)/\(testPath)/\(folder)"
                print(outputPath)
                try FileSystem.createDirectory(at: outputPath)
                let cmd =
                    "racket -y src/herbie.rkt report --threads \(System.coreCount) --seed 0 bench/\(folder.path) \(testPath)/\(folder)"
                try await System.shell("cd \(path) && \(cmd)")
                reportsString = "\(folder.rawValue)"
            }
            print("Running infra/merge.rkt")
            try await System.shell(
                "cd \(path) && racket -y infra/merge.rkt \"reports/\" \(reportsString)"
            )
        }
        try await _relink(folder)
    }

    public static func _relink(_ folder: Folder) async throws {

        let fileNames: [String] = [
            "component.js",
            "bogosity-component.js",
            "graph-components.js",
            "results-components.js",
            "timeline-components.js",
            "timeline-functions.js",
            "report-page.js",
            "report.js",
            "demo.js",
            "main.css",
            "report.css",
        ]
        let herbieFPPath: String =
            "\(System.homePath)/.scribe/Packages/HerbieFP/herbie-fp"
        for file in fileNames {
            do {
                if FileSystem.fileExists(
                    atPath:
                        "\(herbieFPPath)/herbie/src/web/resources/\(file)"
                ) {
                    try await herbieLink(basePath: herbieFPPath, file, folder)
                } else {
                    print("\(file) Not found")
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        func herbieLink(
            basePath: String, _ fileName: String, _ folder: Folder
        )
            async throws
        {
            let base =
                "\(basePath)/herbie/src/web/resources/\(fileName)"
            let dest: String
            if folder == .nightly {
                dest =
                    "\(basePath)/herbie/reports/\(fileName)"
            } else {
                dest =
                    "\(basePath)/herbie/reports/\(folder)/\(fileName)"
            }
            print("sim linking \(base)")
            try? FileSystem.removeItem(atPath: dest)
            try await System.runProcess(
                binary: "/bin/ln", arguments: [base, dest])
        }
    }
}

public enum Folder: String, CaseIterable, CustomStringConvertible {
    case mathematics
    case hamming
    case nightly
    case libraries
    case numerics
    case physics
    case demo
    case haskell
    case pbrt  //https://www.pbrt.org
    case regression
    case tutorial

    public var description: String {
        self.rawValue
    }

    var path: String {
        switch self {
        case .demo, .haskell, .pbrt, .regression, .tutorial:
            return "\(self.rawValue).fpcore"
        case .hamming, .libraries, .mathematics, .numerics, .physics:
            return self.rawValue
        case .nightly:
            return ""
        }
    }
}
