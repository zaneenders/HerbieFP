import RegexBuilder

/*
https://fpbench.org/spec/fpcore-1.2.html#g:decnum
*/

public enum FPCoreToken {
    case leftParen
    case fpcore
    case symbol(String)
    case rightParen
}

public func tokens(_ string: String) -> [FPCoreToken] {
    var tokens: [FPCoreToken] = []
    var index = parseWhiteSpace(string.suffix(from: string.startIndex))
    while index < string.count {
        let s = next(string, index)
        let i = parseWhiteSpace(s)
        if i > 0 {
            index += i
            continue
        }
        if let (t, i) = parseLeftParen(s) {
            tokens.append(t)
            index += i
        } else if let (t, i) = parseFPCore(s) {
            tokens.append(t)
            index += i
        } else if let (t, i) = parseSymbol(s) {
            tokens.append(t)
            index += i
        } else {
            break
        }
    }
    return tokens
}

func parseSymbol(_ str: Substring) -> (FPCoreToken, Int)? {
    let r = #/[a-zA-Z~!@$%^&*_\-+=<>.?:][a-zA-Z0-9~!@$%^&*_\-+=<>.?:]*/#
    if let match: Regex<Substring>.Match = str.prefixMatch(of: r) {
        return (
            FPCoreToken.symbol(
                String(match.output)), match.output.count
        )
    }
    return nil
}

func parseFPCore(_ str: Substring) -> (FPCoreToken, Int)? {
    if let match: Regex<Substring>.Match = str.prefixMatch(of: "FPCore") {
        return (FPCoreToken.fpcore, match.output.count)
    }
    return nil
}

func parseLeftParen(_ str: Substring) -> (FPCoreToken, Int)? {
    if let match: Regex<Substring>.Match = str.prefixMatch(of: "(") {
        return (FPCoreToken.leftParen, match.output.count)
    }
    return nil
}

func parseRightParen(_ str: Substring) -> (FPCoreToken, Int)? {
    if let match: Regex<Substring>.Match = str.prefixMatch(of: ")") {
        return (FPCoreToken.rightParen, match.output.count)
    }
    return nil
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
