import Foundation

/*
4:05 vs 1;40
*/
public func runCI() async {
    let path: String
    switch os {
    case .linux:
        path = ""
    case .macOS:
        path = "/Users/zane/.scribe/Packages/HerbieFP/herbie-fp/herbie"

    }
    FileManager.default.changeCurrentDirectoryPath(path)
    print("running ci")
    let cmds = [
        "racket -y infra/ci.rkt --precision binary64 --seed 0 bench/hamming/machine-decide.fpcore",
        "racket -y infra/ci.rkt --precision binary64 --seed 0 bench/hamming/overflow-underflow.fpcore",
        "racket -y infra/ci.rkt --precision binary64 --seed 0 bench/hamming/quadratic.fpcore",
        "racket -y infra/ci.rkt --precision binary64 --seed 0 bench/hamming/rearrangement.fpcore",
        "racket -y infra/ci.rkt --precision binary64 --seed 0 bench/hamming/series.fpcore",
        "racket -y infra/ci.rkt --precision binary64 --seed 0 bench/hamming/trigonometry.fpcore",
    ]
    await withDiscardingTaskGroup { group in
        for c in cmds {
            group.addTask {
                await shell(c)
            }
        }
    }
}
