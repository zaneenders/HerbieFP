import FPCoreParser
import XCTest

final class PrivateDataStructuresTests: XCTestCase {
    func testExample() throws {
        var fpCore: String = """
            (FPCore (x y z)
             :name "fabs fraction 1"
             (fabs (- (/ (+ x 4) y) (* (/ x y) z))))
            """
        let tokens = tokens(fpCore)
        print(tokens.count)
    }
}
