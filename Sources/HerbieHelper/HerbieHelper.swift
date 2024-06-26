import FPCore
import Foundation
import Herbie

let homePath = FileManager.default
    .homeDirectoryForCurrentUser
    .path
@main
struct HerbieHelper {

    static let testPath = "reports"

    public static func main() async {
        let packageDir = "\(homePath)/.scribe/Packages/HerbieFP"
        let herbieFPPath: String = "\(packageDir)/herbie-fp"
        if !FileManager.default.fileExists(atPath: herbieFPPath) {
            print("Making directory: \(herbieFPPath)")
            do {
                try FileManager.default.createDirectory(
                    at: URL(fileURLWithPath: herbieFPPath),
                    withIntermediateDirectories: true)
            } catch {
                print(error.localizedDescription)
                print("Error setting up (\(herbieFPPath))")
            }
        }
        let herbieRepo = herbieFPPath + "/herbie"
        if !FileManager.default.fileExists(atPath: herbieRepo)
            && CommandLine.arguments[1] != "setup"
        {
            print("please run setup")
            return
        }
        if CommandLine.arguments.count > 1 {
            /*
            jobs
            FileManager.default.changeCurrentDirectoryPath(herbieRepo)
            print(FileManager.default.currentDirectoryPath)
            print("jobs")
            // let c =
            //     "racket -y src/herbie.rkt --help"
            // await shell(c)
            */
            if CommandLine.arguments[1] == "sample" {
                do {
                    let points = try await Herbie.sample()
                    print(String(describing: points?.points.count))
                } catch {
                    print(error)
                }
            }
            if CommandLine.arguments[1] == "start" {
                do {
                    try await Herbie.improveStart()
                    return
                } catch {
                    print(error.localizedDescription)
                }
            }
            if CommandLine.arguments[1] == "improve" {
                do {
                    try await Herbie.improve()
                    return
                } catch {
                    print(error.localizedDescription)
                }
            }
            if CommandLine.arguments[1] == "alts" {
                do {
                    let _ = try await Herbie.alts()
                    return
                } catch {
                    print(error.localizedDescription)
                }
            }
            if CommandLine.arguments[1] == "alternatives" {
                do {
                    let _ = try await Herbie.alternatives()
                    return
                } catch {
                    print(error.localizedDescription)
                }
            }
            if CommandLine.arguments[1] == "up" {
                do {
                    try await Herbie.up()
                    return
                } catch {
                    print(error.localizedDescription)
                }
            }
            if CommandLine.arguments[1] == "ci" {
                await Herbie.runCI()
                return
            }
            if CommandLine.arguments[1] == "timeline" {
                await parseTimeline()
                return
            }
            if CommandLine.arguments[1] == "results" {
                await parseResults()
                return
            }
            if CommandLine.arguments[1] == "open" {
                // TODO Open firefox to localhost
                await shell(
                    "open /Applications/\"Firefox Developer Edition.app\" --background"
                )
                await shell("code \(packageDir)")
                await shell("code \(herbieRepo)")
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
            if CommandLine.arguments[1] == "math" {
                do {
                    try await _report(
                        path: herbieRepo, .mathematics)
                } catch {
                    print(error.localizedDescription)
                    print("Error relinking files")
                }
            }
            if CommandLine.arguments[1] == "hamming" {
                do {
                    try await _report(
                        path: herbieRepo, .hamming)
                } catch {
                    print(error.localizedDescription)
                    print("Error relinking files")
                }
            }
            if CommandLine.arguments[1] == "fpcore" {
                let str = """
                    (FPCore (x y z)
                     :name "fabs fraction 1"
                     (fabs (- (/ (+ x 4) y) (* (/ x y) z))))
                    """
                if let fpc = try? FPCore(str) {
                    await runFPCore(fpc)
                }
            }
            if CommandLine.arguments[1] == "test" {
                // racket -y src/herbie.rkt report --seed 0 --num-points 10 zane/zane-test.fpcore zane/test
                if CommandLine.arguments.count > 2
                    && CommandLine.arguments[2] == "points"
                {
                    let cmd =
                        "racket -y \(herbieFPPath)/herbie/src/herbie.rkt report --threads \(coreCount) --seed 0 --num-points 10 --timeout 3000 \(herbieFPPath)/herbie/zane/zane-test.fpcore \(herbieFPPath)/herbie/zane/test"
                    print(cmd)
                    try? await shell(cmd)
                } else if CommandLine.arguments.count > 2
                    && CommandLine.arguments[2] == "inters"
                {
                    let cmd =
                        "racket -y \(herbieFPPath)/herbie/src/herbie.rkt report --threads \(coreCount) --seed 0 --num-iters 100 --timeout 3000 \(herbieFPPath)/herbie/zane/zane-test.fpcore \(herbieFPPath)/herbie/zane/test"
                    print(cmd)
                    await shell(cmd)
                } else {
                    // reprots is more usefull to test with because you get the trac back
                    print(
                        "racket -y src/herbie.rkt report --threads \(coreCount) --seed 0 zane/zane-test.fpcore zane/test"
                    )
                    try? await shell(
                        "racket -y \(herbieFPPath)/herbie/src/herbie.rkt report --threads \(coreCount) --seed 0 \(herbieFPPath)/herbie/zane/zane-test.fpcore \(herbieFPPath)/herbie/zane/test"
                    )
                }
            }
            if CommandLine.arguments[1] == "setup" {
                if CommandLine.arguments.count > 2
                    && CommandLine.arguments[2] == "test"
                {
                    let zaneDir = herbieRepo + "/zane"
                    try? FileManager.default.createDirectory(
                        at: URL(fileURLWithPath: zaneDir),
                        withIntermediateDirectories: true)
                    try! write(
                        string: "*", to: zaneDir + "/.gitignore")
                    let testCore = """
                        (FPCore (a b c)
                         :name "quadp (p42, positive)"
                         :herbie-expected 10
                         :herbie-target ; From Racket Math Lib implementation
                         (let ([sqtD
                          (let ([x (* (sqrt (fabs a)) (sqrt (fabs c)))])
                            (if (== (copysign a c) a)
                              (* (sqrt (- (fabs (/ b 2)) x)) (sqrt (+ (fabs (/ b 2)) x)))
                              (hypot (/ b 2) x)))])
                            (if (< b 0) (/ (- sqtD (/ b 2)) a)
                              (/ (- c) (+ (/ b 2) sqtD))))

                         (let ([d (sqrt (- (* b b) (* 4 (* a c))))])
                           (/ (+ (- b) d) (* 2 a))))
                        """
                    try! write(
                        string: testCore,
                        to: zaneDir + "/zane-test.fpcore")
                    print("created: \(zaneDir)")
                    return
                }
                do {
                    try await setupHerbie(at: herbieFPPath)
                } catch {
                    print(error.localizedDescription)
                    print("Error Setting up Herbie")
                }
            }

            if CommandLine.arguments[1] == "merge" {
                var reportNames: [String] = []
                for b in Folder.allCases {
                    guard b != .nightly else { continue }
                    reportNames.append("\"\(b)\"")
                }
                let reportsString = reportNames.joined(separator: " ")
                try? await shell(
                    "racket -y infra/merge.rkt \"reports/\" \(reportsString)"
                )
            }

            if CommandLine.arguments[1] == "http" {
                let home: String
                switch os {
                case .macOS:
                    home = "/Users/zane/"
                case .linux:
                    home = "/home/zane/"
                }
                print(CommandLine.arguments.count)
                if CommandLine.arguments.count >= 3 {
                    if CommandLine.arguments[2] == "hamming" {
                        try? httpServer(
                            "\(home).scribe/Packages/HerbieFP/herbie-fp/herbie/reports/hamming"
                        )
                    }
                    if CommandLine.arguments[2] == "test" {
                        print("test http")
                        try? httpServer(
                            "\(home).scribe/Packages/HerbieFP/herbie-fp/herbie/zane/test"
                        )
                    }
                    if CommandLine.arguments[2] == "main" {
                        print("main http")
                        try? httpServer(
                            "\(home).scribe/Packages/HerbieFP/herbie-fp/herbie/zane/main"
                        )
                    }
                    if CommandLine.arguments[2] == "unsafe" {
                        print("unsafe http")
                        try? httpServer(
                            "\(home).scribe/Packages/HerbieFP/herbie-fp/herbie/zane/unsafe"
                        )
                    }
                } else {
                    try? httpServer(
                        "\(home).scribe/Packages/HerbieFP/herbie-fp/herbie/reports"
                    )
                }
            }
        } else {
            print("please pass a command")
        }
    }

    public static func _report(path: String, _ folder: Folder) async throws {
        // if folder != .nightly {
        //     print("Not finished please fix future Zane")
        //     return
        // }
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
            try FileManager.default.removeItem(atPath: currentPath)
        } catch {
            print(error.localizedDescription)
        }

        // TODO how should we capture logs?
        // TODO Mirror nightly.sh script for herbie
        let reportsString: String
        if folder == .nightly {
            print("running nightly")
            let basePath = "\(path)/\(testPath)"
            print(basePath)
            try FileManager.default.createDirectory(
                at: URL(fileURLWithPath: basePath),
                withIntermediateDirectories: true)
            var reportNames: [String] = []
            for b in Folder.allCases {
                guard b != .nightly else { continue }
                reportNames.append("\"\(b)\"")
                print("running report: \(b)")
                let outputPath: String =
                    "\(basePath)/\(b)"
                try FileManager.default.createDirectory(
                    at: URL(fileURLWithPath: outputPath),
                    withIntermediateDirectories: true)
                let cmd =
                    "racket -y \(path)/src/herbie.rkt report --threads \(coreCount) --seed 0 \(path)/bench/\(b.path) \(path)/\(testPath)/\(b)"
                print(cmd)
                try await shell("cd \(path) && \(cmd)")
            }
            reportsString = reportNames.joined(separator: " ")
            print("Running infra/merge.rkt")

            // can't use absoute path
            try await shell(
                "cd \(path) && racket -y infra/merge.rkt \"reports/\" \(path)/\(reportsString)"
            )
            try await _relink(folder)
        } else {
            print("running \(folder) report")
            let outputPath: String =
                "\(path)/\(testPath)/\(folder)"
            print(outputPath)
            try FileManager.default.createDirectory(
                at: URL(fileURLWithPath: outputPath),
                withIntermediateDirectories: true)
            let cmd =
                "racket -y \(path)/src/herbie.rkt report --threads \(coreCount) --seed 0 \(path)/bench/\(folder.path) \(path)/\(testPath)/\(folder)"
            try await shell("cd \(path) && \(cmd)")
            reportsString = "\(folder.rawValue)"

            let mergeCMD =
                "racket -y \(path)/infra/merge.rkt \"reports/\(folder)\" \(path)/\(folder)/\(reportsString)"
            print("merge")
            print(mergeCMD)
            print("merge")
            try await shell(
                "cd \(path) && \(mergeCMD)"
            )
            // try await _relink(folder)
        }

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
            "\(homePath)/.scribe/Packages/HerbieFP/herbie-fp"
        for file in fileNames {
            do {

                if FileManager.default.fileExists(
                    atPath: "\(herbieFPPath)/herbie/src/web/resources/\(file)")
                {
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
            try FileManager.default.removeItem(atPath: dest)
            try await runProcess(
                binary: "/bin/ln", arguments: [base, dest])
        }
    }
}

public func runFPCore(_ fpCore: FPCore) async {
    let temp = "temp"
    let packageDir = "\(homePath)/.scribe/Packages/HerbieFP"
    let herbieFPPath: String = "\(packageDir)/herbie-fp"
    let herbieRepo = herbieFPPath + "/herbie"
    let zaneDir = herbieRepo + "/zane"
    let tempPath = zaneDir + "/\(temp).fpcore"
    try? write(
        string: fpCore.description,
        to: tempPath)
    let cmd =
        "racket -y \(herbieFPPath)/herbie/src/herbie.rkt report --threads \(coreCount) --seed 0 \(tempPath) \(herbieFPPath)/herbie/zane/\(temp)"
    print(cmd)
    try? await shell(cmd)
    try? FileManager.default.removeItem(atPath: tempPath)

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
