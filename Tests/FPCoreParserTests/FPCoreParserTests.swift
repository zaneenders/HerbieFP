import FPCoreParser
import XCTest

final class FPCoreParserTests: XCTestCase {
    func testExample() throws {
        let fpCore: String = """
            (FPCore (x y z)
             :name "fabs fraction 1"
             (fabs (- (/ (+ x 4) y) (* (/ x y) z))))
            """
        let tokens = tokens(fpCore)
        print(tokens)
    }
}
