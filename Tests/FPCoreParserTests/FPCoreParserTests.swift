import FPCoreParser
import XCTest

final class FPCoreParserTests: XCTestCase {
    func testExample() throws {
        let fpCore: String = """
            (FPCore (x y z)
             :name "fabs fraction 1"
             (fabs (- (/ (+ x 4) y) (* (/ x y) z))))
            """
        do {
            let tokens = try tokens(fpCore)
            XCTAssertEqual(tokens.count, 54)
        } catch LexingError.couldNotConsume(let str) {
            XCTFail(str)
        }
    }
}
