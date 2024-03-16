import RegexBuilder

/*
https://fpbench.org/spec/fpcore-2.0.html
*/

public struct Token {

    public let offest: Int
    public let type: FPCoreToken

    init(_ offest: Int, _ type: FPCoreToken) {
        self.offest = offest
        self.type = type
    }
}

public enum FPCoreToken {
    case leftParen
    case fpcore
    case symbol(String)
    case string(String)
    case number(Number)
    case whiteSpace(String)
    case colen
    case rightParen
}

public enum Number {
    case rational(String)
    case decieml(String)
}

public enum LexingError: Error {
    case couldNotConsume(String)
}

public func tokens(_ string: String) throws -> [Token] {
    var tokens: [Token] = []
    var index = 0
    while index < string.count {
        let s = next(string, index)
        if let (t, i) = parseWhiteSpace(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = parseLeftParen(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = parseRightParen(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = parseColen(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = parseFPCore(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = parseString(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = parseRational(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = parseDecl(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = parseSymbol(s) {
            tokens.append(Token(index, t))
            index += i
        } else {
            throw
                LexingError
                .couldNotConsume("\(index) : \(string.count)")
        }
    }
    return tokens
}

func parseSymbol(_ str: Substring) -> (FPCoreToken, Int)? {
    let r = #/[a-zA-Z~!@$%^&*_\-+=<>.?/:][a-zA-Z0-9~!@$%^&*_\-+=<>.?/:]*/#
    if let match: Regex<Substring>.Match = str.prefixMatch(of: r) {
        return (
            FPCoreToken.symbol(String(match.output)),
            match.output.count
        )
    }
    return nil
}

func parseDecl(_ str: Substring) -> (FPCoreToken, Int)? {
    let r = #/[-+]?([0-9]+(\.[0-9]+)?|\.[0-9]+)(e[-+]?[0-9]+)?/#
    if let match = str.prefixMatch(of: r) {
        return (
            FPCoreToken.number(.decieml((String(match.output.0)))),
            match.output.0.count
        )
    }
    return nil
}

func parseRational(_ str: Substring) -> (FPCoreToken, Int)? {
    let r = #/[+-]?[0-9]+/[0-9]*[1-9][0-9]*/#
    if let match = str.prefixMatch(of: r) {
        return (
            FPCoreToken.number(.rational((String(match.output)))),
            match.output.count
        )
    }
    return nil
}

func parseString(_ str: Substring) -> (FPCoreToken, Int)? {
    let r = #/"([\x20-\x21\x23-\x5b\x5d-\x7e]|\\["\\])*"/#
    if let match = str.prefixMatch(of: r) {
        return (
            FPCoreToken.string(String(match.output.0)),
            match.output.0.count
        )
    }
    return nil
}

func parseColen(_ str: Substring) -> (FPCoreToken, Int)? {
    if let match: Regex<Substring>.Match = str.prefixMatch(of: ":") {
        return (FPCoreToken.colen, match.output.count)
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

func parseWhiteSpace(_ str: Substring) -> (FPCoreToken, Int)? {
    if let match: Regex<Substring>.Match = str.prefixMatch(of: .whitespace) {
        return (
            FPCoreToken.whiteSpace(String(match.output)), match.output.count
        )
    }
    return nil
}

func next(_ str: String, _ index: Int) -> Substring {
    str.suffix(from: str.index(str.startIndex, offsetBy: index))
}
