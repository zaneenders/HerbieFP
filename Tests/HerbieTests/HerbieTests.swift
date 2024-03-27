import XCTest

@testable import HerbieHelper

final class ScribeTests: XCTestCase {

    func testRegimes() {
        let points = 10
        let cands = 3
        let top = Double(200)
        let min = Double(60)
        var psums: [[Double]] = []
        var canSplit = Array(repeatElement(true, count: points))

        for _ in 0..<cands {
            var errs: [Double] = []
            for _ in 0..<points {
                errs.append(Double.random(in: min...top))
            }
            psums.append(errs)
        }
        let sums = transpose(psums, canSplit)
        print(psums)
        print(sums)
    }
}

func transpose(_ psums: [[Double]], _ canSplit: [Bool]) -> [Double] {
    let cands = psums.count
    let points = canSplit.count
    guard psums.count > 0 else {
        return []
    }
    var out: [Double] = Array(repeatElement(Double.nan, count: cands * points))
    let sum = cands * points
    for i in 0..<sum {
        let p = i / cands
        let c = i % cands
        out[i] = psums[c][p]
    }
    return out
}
