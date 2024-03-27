import Foundation

/*
4:05 vs 1;40
*/
func runCI() async {
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
                print(c)
                let str = "file:///usr/bin/zsh"
                let url = URL(string: str)!
                let process = Process()
                process.executableURL = url
                process.arguments = ["-c"] + [c]
                try? process.run()
                process.waitUntilExit()
            }
        }
    }
}
