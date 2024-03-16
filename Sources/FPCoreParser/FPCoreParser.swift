import RegexBuilder

/*
https://fpbench.org/spec/fpcore-1.2.html#g:decnum
*/

public enum FPCoreToken {
    case leftParen
    case rightParen
}

public func tokens(_ string: String) -> [FPCoreToken] {
    var tokens: [FPCoreToken] = []
    var index = parseWhiteSpace(string.suffix(from: string.startIndex))
    print(index)
    while index < string.count {
        let s = next(string, index)
        print(s)
        if let r = parseLeftParen(s) {
            print(r)
        }
        break
    }
    return tokens
}

func next(_ str: String, _ index: Int) -> Substring {
    str.suffix(from: str.index(str.startIndex, offsetBy: index))
}

func parseWhiteSpace(_ str: Substring) -> Int {
    if let match: Regex<Substring>.Match = str.prefixMatch(of: .whitespace) {
        return match.output.count
    }
    return 0
}

func parseLeftParen(_ str: Substring) -> (FPCoreToken, Int)? {
    print(str)
    if let match: Regex<Substring>.Match = str.prefixMatch(of: "(") {
        return (FPCoreToken.leftParen, match.output.count)
    }
    return nil
}
